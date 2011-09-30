Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab1I3VG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 17:06:29 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:53741 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1I3VG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 17:06:27 -0400
Date: Fri, 30 Sep 2011 14:06:25 -0700
From: Andrew Morton <akpm00@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <htejun@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH RFC] stop_machine: make stop_machine safe and efficient
 to call early
Message-Id: <20110930140625.c7faad28.akpm00@gmail.com>
In-Reply-To: <4E85F596.4050704@goop.org>
References: <4E85EE1F.7050508@goop.org>
	<1317400496.4588.54.camel@gandalf.stny.rr.com>
	<4E85F596.4050704@goop.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Sep 2011 10:00:06 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> On 09/30/2011 09:34 AM, Steven Rostedt wrote:
> > Doesn't interrupts need to be disabled here too? As stop machine
> > functions also guarantee that they will not be interrupted by
> > interrupts. -- Steve
> 
> Good point.
> 
>     J
> 
> Make stop_machine() safe to call early in boot, before SMP has been
> set up, by simply calling the callback function directly if there's
> only one CPU online.

Being a trusting soul, I shall assume that you presently have or soon
will have some code which requires this change?

>
> ...
>
> --- a/kernel/stop_machine.c
> +++ b/kernel/stop_machine.c
> @@ -485,6 +485,17 @@ int __stop_machine(int (*fn)(void *), void *data, const struct cpumask *cpus)
>  					    .num_threads = num_online_cpus(),
>  					    .active_cpus = cpus };
>  
> +	if (smdata.num_threads == 1) {
> +		unsigned long flags;
> +		int ret;
> +
> +		local_save_flags(flags);
> +		ret = (*fn)(data);
> +		local_irq_restore(flags);
> +
> +		return ret;
> +	}

It is quite unobvious to readers why this code exists.  Therefore, we
should tell them.

Also, bug.  local_save_flags() is used to read the irq flags - it does
not actually disable interrupts.  We want local_irq_save() here.  None
of these interfaces are documented and their naming system is crappy. 
Cause, effect.


--- a/kernel/stop_machine.c~stop_machine-make-stop_machine-safe-and-efficient-to-call-early-fix
+++ a/kernel/stop_machine.c
@@ -486,10 +486,14 @@ int __stop_machine(int (*fn)(void *), vo
 					    .active_cpus = cpus };
 
 	if (smdata.num_threads == 1) {
+		/*
+		 * Handle the case where stop_machine() is called early in boot
+		 * before SMP startup.
+		 */
 		unsigned long flags;
 		int ret;
 
-		local_save_flags(flags);
+		local_irq_save(flags);
 		ret = (*fn)(data);
 		local_irq_restore(flags);
 
_


