Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab2ALWkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 17:40:15 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:50223 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630Ab2ALWkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 17:40:11 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Venkatesh Pallipadi <venki@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kexec reboot and stale/inconsistent system state
References: <1326405521-2736-1-git-send-email-venki@google.com>
Date: Thu, 12 Jan 2012 14:42:26 -0800
In-Reply-To: <1326405521-2736-1-git-send-email-venki@google.com> (Venkatesh
	Pallipadi's message of "Thu, 12 Jan 2012 13:58:41 -0800")
Message-ID: <m14nw0wnjh.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+aKRIaQjxBZLl2ILYG/BRe9fB+P8XhbAo=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatesh Pallipadi <venki@google.com> writes:

> Of course, kexec reboots has a lot of advantantages. There is one
> blind spot though, in the way we handle shutdown of the old kernel in kexec.
> The problem: there are drivers in the kernel that change
> system state either during init or during normal operation. During a
> hardware reboot these system states would get reset to default.
> But, with kexec reboot this system state can stay persistent with the
> new kernel and can lead to some inconsistencies.
>
> More concrete x86 example:
> * Kernel_v0 has a driver which sets a particular MSR.
> * Kernel_v1 has a different version of the driver which does not touch the
> MSR and assumes it to be at BIOS init state.
> * Now we have a kexec reboot from Kernel_v0 to Kernel_v1 and the MSR will
> stay set leading to potential inconsistent state.
>
> One such driver I was looking at is drivers/idle/intel_idle.c, which sets
> the MSR during init and forgets about it. There are other drivers which can
> potentially have similar problems - like MTRR, etc. There can be other
> state in the system like chipset state and device state etc, though
> I expect most of it won't be a problem based on the way drivers init.
>
> Seemingly simple solution is to do the needed cleanup in driver's module_exit
> code path. That is not enough as module_exit for all builtin drivers are
> all discarded.
>
> What if we retain all the module_exits in CONFIG_KEXEC case and do a
> cleanup before launching a new kernel. This should work, but most of the
> module_exit code assumes that they will be only called when corresponding
> init is successful. I couldn't find a clean and easy way of associating
> module's init function with its exit function and to save the result of
> init.
>
> Alternate quick solution is to create a new module interface to register
> kexec cleanup function as in the patch below. But, this is not generic enough
> yet and does not handle the case where we have done the cleanup and kexec
> fails after that and we have to do some setup again to run with old
> kernel.
>
> Before spending more time on this, just wanted to run this RFC along to see:
> * How big/serious this problem really is?
> * Has this been looked at before and any other potential solution for
> this?

Use the drivers shutdown method.  The shutdown method is called
at reboot and at normal kexec.  If you care about the kexec on panic
case you need to write a paranoid driver initialization routine.

Hmm.  Looking a little closer the intel idle driver is a weird thing.
I am not seeing any operations structures.  There are kobjects so
the intel idle driver might be properly hooked into the device tree.
If the intel idle driver isn't properly hooked into the device
tree you should be able to hook into the reboot notifier instead
of implementing a device shutdown method.  Although for a lot
of reasons implementing the standard device shutdown method is
preferred.

Eric
