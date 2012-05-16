Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933371Ab2EPMsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 08:48:16 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4950 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab2EPMsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 08:48:14 -0400
X-Authority-Analysis: v=2.0 cv=ae7jbGUt c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=g_LhDMiRcOYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=MXh8i3YQ1hvvQgUc4BgA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1337172492.6724.36.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Date: Wed, 16 May 2012 08:48:12 -0400
In-Reply-To: <20120515163855.GE27806@aftab.osrc.amd.com>
References: <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
	 <4FAC6FF8.3050608@redhat.com> <20120511102527.GI8913@aftab.osrc.amd.com>
	 <4FAD081C.5000704@redhat.com> <20120511172430.GB17299@aftab.osrc.amd.com>
	 <4FAD5CAD.90508@redhat.com> <20120514133404.GE4231@aftab.osrc.amd.com>
	 <4FB1163D.3010302@redhat.com> <20120515150957.GC27806@aftab.osrc.amd.com>
	 <4FB27EDC.8040001@redhat.com> <20120515163855.GE27806@aftab.osrc.amd.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-15 at 18:38 +0200, Borislav Petkov wrote:
> On Tue, May 15, 2012 at 01:05:48PM -0300, Mauro Carvalho Chehab wrote:
> > > Here's what an error looks like on my system here:
> > > 
> > >        mcegen.py-2868  [007] .N..   178.261607: mc_event: Corrected error:amd64_edac on memory stick "unknown memory" (mc:0 csrow:3 channel:1  page:0x5bac7 offset:0x388 grain:0 syndrome:0x34ed )
> > > 
> > > There's still this trailing " " at the end of the error line which
> > > shouldn't be there and also two spaces between "channel" and "page".
> > 
> > If you take a look at the trace printk:
> > 
> > + TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
> > +           (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
> > +                 ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
> > +
> > +           __get_str(msg),
> > +           __get_str(label),
> > +           __entry->mc_index,
> > +           __get_str(location),
> > +           __get_str(detail),
> > +           __get_str(driver_detail))
> > 
> > There are not extra spaces there. The first extra space is probably because
> > there is an extra space at the label string. This should be easy to fix.
> > 
> > The other extra space at the end is because amd64 currently doesn't provide
> > driver_detail information.
> 
> Remind me again why do we need two strings: detail and driver_detail?
> 
> Because they could very well be lumped together with a single "%s"
> format - "(mc:%d %s)" - and be printed.
> 
> And detail will always contain something which is not the empty string,
> so problem solved.

Here's another trick if you want to get rid of the space and keep both
fields:

TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s%s%s)",
           (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
                 ((__entry->err_type == HW_EVENT_ERR_FATAL) ?
                 "Fatal" : "Uncorrected"),

           __get_str(msg),
           __get_str(label),
           __entry->mc_index,
           __get_str(location),
           __get_str(detail),
	   strlen(__get_str(detail)) &&
	    strlen(__get_str(driver_detail) ? " ": "",
           __get_str(driver_detail))

-- Steve


