Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965917Ab2EOQjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:39:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:52791 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965809Ab2EOQjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:39:12 -0400
Date: Tue, 15 May 2012 18:38:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Message-ID: <20120515163855.GE27806@aftab.osrc.amd.com>
References: <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
 <4FAC6FF8.3050608@redhat.com>
 <20120511102527.GI8913@aftab.osrc.amd.com>
 <4FAD081C.5000704@redhat.com>
 <20120511172430.GB17299@aftab.osrc.amd.com>
 <4FAD5CAD.90508@redhat.com>
 <20120514133404.GE4231@aftab.osrc.amd.com>
 <4FB1163D.3010302@redhat.com>
 <20120515150957.GC27806@aftab.osrc.amd.com>
 <4FB27EDC.8040001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FB27EDC.8040001@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 01:05:48PM -0300, Mauro Carvalho Chehab wrote:
> > Here's what an error looks like on my system here:
> > 
> >        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )
> > 
> > There's still this trailing " " at the end of the error line which
> > shouldn't be there and also two spaces between "channel" and "page".
> 
> If you take a look at the trace printk:
> 
> + TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
> +           (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
> +                 ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
> +                 "Fatal" : "Uncorrected"),
> +           __get_str(msg),
> +           __get_str(label),
> +           __entry->mc_index,
> +           __get_str(location),
> +           __get_str(detail),
> +           __get_str(driver_detail))
> 
> There are not extra spaces there. The first extra space is probably because
> there is an extra space at the label string. This should be easy to fix.
> 
> The other extra space at the end is because amd64 currently doesn't provide
> driver_detail information.

Remind me again why do we need two strings: detail and driver_detail?

Because they could very well be lumped together with a single "%s"
format - "(mc:%d %s)" - and be printed.

And detail will always contain something which is not the empty string,
so problem solved.

> > Also, according to the output above "amd64_edac" is supposed to be
> > [error msg] which is strange.
> > 
> > I believe this comes from this call in f1x_map_sysaddr_to_csrow():
> > 
> > 	        edac_mc_handle_error(HW_EVENT_ERR_CORRECTED, mci,
> >                              page, offset, syndrome,
> >                              csrow, chan, -1,
> >                              EDAC_MOD_STR, "", NULL);
> > 
> > I guess you want to do the following instead:
> > 
> >        mcegen.py-2868  [007] .N..   178.261607: mc_event: amd64_edac: corrected error on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed)
> > 
> > maybe concatenate EDAC_MOD_STR with the proper string it reports, i.e.
> > corrected/uncorrected error?
> 
> The issue here is because amd64_edac (just like a few other drivers) use
> its driver name (EDAC_MOD_STR) as the error message, instead of using 
> something meaningful, like "read error" or "ECC error".

No, the issue is here that edac_mc_handle_ce() used to say "CE..."
and edac_mc_handle_ue() used to say "UE.. " and yours don't say that
anymore. In other words, you need to add the "CE/UE" thing to the string
based on the HW_EVENT_ERR_* flag or something to that effect.

[ … ]

> >>     Of course, any userspace tools meant to handle errors should not parse
> >>     the above data. They should, instead, use the binary fields provided by
> >>     the tracepoint, mapping them directly into their MIBs.
> > 
> > What is a MIB?
> 
> Management Information Base. This is how anyone that works with Element
> Management calls the model of information that represents each management
> property. It is generally written using ITU-T ASN.1 syntax. Almost all
> management software use that.
> 
> [1] http://en.wikipedia.org/wiki/Management_information_base

That looks like an ACPI or some other idiotic spec speak, pls remove it.

[ … ]

> >> + * edac_mc_handle_error - reports a memory event to userspace
> >> + *
> >> + * @type:		severity of the error (CE/UE/Fatal)
> >> + * @mci:		a struct mem_ctl_info pointer
> >> + * @page_frame_number:	mem page where the error occurred
> >> + * @offset_in_page:	offset of the error inside the page
> >> + * @syndrome:		ECC syndrome
> >> + * @layer0:		Memory layer0 position
> >> + * @layer1:		Memory layer2 position
> >> + * @layer2:		Memory layer3 position
> >> + * @msg:		Message meaningful to the end users that
> >> + *			explains the event
> >> + * @other_detail:	Technical details about the event that
> >> + *			may help hardware manufacturers and
> >> + *			EDAC developers to analyse the event
> > 
> > 					analyze it.
> 
> Analyse is the same as analyze [2].

I know that. What I meant is

s/EDAC developers to analyse the event/EDAC developers to analyse it/

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
