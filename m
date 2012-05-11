Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab2EKKZn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 06:25:43 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:32936 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758328Ab2EKKZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 06:25:41 -0400
Date: Fri, 11 May 2012 12:25:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
Message-ID: <20120511102527.GI8913@aftab.osrc.amd.com>
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com>
 <20120510204042.GA4598@aftab.osrc.amd.com>
 <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com>
 <4FAC3C35.70101@redhat.com>
 <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
 <4FAC6FF8.3050608@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC6FF8.3050608@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 10:48:40PM -0300, Mauro Carvalho Chehab wrote:
> Em 10-05-2012 19:37, Luck, Tony escreveu:
> >      kworker/u:6-201   [007] .N..   186.197280: mc_error: [Hardware Error]: mem_ctl#0: Corrected error memory read error on memory stick "DIMM_A1" (channel:0 slot:1  page:0x2f1eb3 offset:0x446 grain:32 syndrome:0x0 1 error(s): Unknown: Err=0001:0090 socket=0 channel=0/mask=1 rank=5)
> >      
> > The word "error" appears *five* times on this line (once with a capital E).
> > I feel beaten, bruised and ready to give up on this machine with just one
> > actual error reported :-)
> 
> :)
> 
> Several of them come from the driver-provided details.
> 
> The edac-mc core contributes with "mc_error", "[Hardware Error]" and "Corrected error".
> The sb-edac driver contributes with "memory read error" and "1 error(s)".
> 
> We can get easily get rid of "[Hardware Error]" by removing HW_ERR from:
> 
> 	TP_printk(HW_ERR "mem_ctl#%d: %s error %s on memory stick \"%s\" (%s %s %s)",
> 
> replacing mc_error by something else is not hard, but this is the name of the trace call:
> 
> TRACE_EVENT(mc_error,
> ...
> 
> Maybe the better is to do s/mc_error/mc_event/g.

HW_ERR is the "official" prefix used by the MCE code in the kernel.
Maybe we can shorten it but it is needed to raise attention when staring
at dmesg output.

Now, since this tracepoint is not dmesg, we don't need it there at all
since we know that trace_mc_error reports memory errors.

"mc_error" is also not needed.

> The error count msg ("1 error(s)") could be replaced by "count:1".

Is there even a possibility to report more than one error when invoking
trace_mc_error once? If not, simply drop the count completely.

> > We could get rid of one by:
> >  s/Corrected error memory read error/Corrected memory read error/
> 
> This is the hardest possible solution ;) Changing it will cause weird messages
> all over EDAC drivers ;)

I agree with Tony here - repeating error a gazillion times on one report
only is a "naaah!"

Here's how it should look:

kworker/u:6-201   [007] .N..   161.136624: [Hardware Error]: memory read on memory stick "DIMM_A1" (type: corrected socket:0 mc:0 channel:0 slot:0 rank:1 page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 channel_mask:1)

* count is gone
* MC-drivers shouldn't say "error" when reporting an error
* UE/CE moves into the brackets
* socket moves earlier in the brackets, and keep the whole deal hierarchical.
* drop "err_code" what is that?
* drop second "socket"
* drop "area" Area "DRAM" - are there other?
* what is "channel_mask"?
* move "rank" to earlier

Now this is an output format I can get on board with.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
