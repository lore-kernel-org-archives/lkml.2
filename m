Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759944Ab2CTNm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 09:42:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15012 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229Ab2CTNmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 09:42:54 -0400
X-Authority-Analysis: v=2.0 cv=Wf+OmjdX c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=bg8cI4lvms4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=ru3RulGpUh-yXPnA3CYA:9 a=_nWhroSRGTl89_XFJy8A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1332250970.23924.10.camel@gandalf.stny.rr.com>
Subject: Re: Suspend-to-ram not working when ftrace is enabled, again!
From: Steven Rostedt <rostedt@goodmis.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "mingo@elte.hu" <mingo@elte.hu>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 20 Mar 2012 09:42:50 -0400
In-Reply-To: <4F6754DA.6090401@linux.vnet.ibm.com>
References: <4F6754DA.6090401@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-03-19 at 21:16 +0530, Srivatsa S. Bhat wrote:
> Hi,
> 
> If tracing is enabled and we are tracing low-level suspend-to-ram related
> functions like restore_processor_state() etc (which are included by default
> in the list of traced functions), and we try suspending the machine, the
> machine doesn't resume. It reboots instead.
> (If we trace some unrelated functions like kzalloc() for example, there is
> no problem with suspend/resume).

Yeah, this is a know issue. I need to look at the suspend code and add
notrace annotations, or keep entire files from being traced.

The problem is that on resume, there's functions that are called that do
not have all kernel setup initialized. For example, smp_processor_id()
uses the %gs register to access the per_cpu data which also contains the
cpu id. On resume, the %gs register is not yet set up, and calling the
function tracer, which uses smp_processor_id() to find out what buffer
to write to causes a page fault. Then the page fault handling also calls
the function tracer which it too will page fault, and we end up with a
triple fault and the machine reboots.


> 
> Looking at https://lkml.org/lkml/2008/8/27/177, it appears that this
> is an old problem and also had a workaround (disabling tracing around
> suspend). The above patch corresponds to commit id: f42ac38c59 (ftrace:
> disable tracing for suspend to ram), which went in around 2.6.27 I think.
> But then commit cbe2f5a6e84 (tracing: allow tracing of suspend/resume &
> hibernation code again) reverted that commit.
> 
> And from https://lkml.org/lkml/2008/8/21/349, it looks like 2.6.28 and
> further was supposed to be problem-free. But unfortunately this problem has
> resurfaced.
> 
> I tested kernel 2.6.32.54 and I observed that the machine reboots during
> resume, which looks exactly like the problem discussed in the link above.
> 
> In another machine, I tested 3.3-rc6 and it doesn't seem to respond to
> resume events (like button press, lid open) at all. It just seems to remain
> suspended forever.
> 
> Should we resort to disabling ftrace around suspend again? Or do we have a
> better solution this time around?
> 

No the real solution is to find the functions that break and fix them.
Probably requires more notrace annotations.

Thanks,

-- Steve




