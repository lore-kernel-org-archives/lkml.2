Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2BNDaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 22:30:09 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41731 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758927Ab2BNDaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 22:30:06 -0500
MIME-Version: 1.0
In-Reply-To: <20120213172311.GB12117@google.com>
References: <1329131018-19107-1-git-send-email-tom.leiming@gmail.com>
	<20120213172311.GB12117@google.com>
Date: Tue, 14 Feb 2012 11:30:06 +0800
Message-ID: <CACVXFVMyihmG3NexXOqTUoJb8UJFa7dJqYGOr6oC_y5heFSo1A@mail.gmail.com>
Subject: Re: [PATCH] percpu: use raw_local_irq_* in _this_cpu op
From: Ming Lei <tom.leiming@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Feb 14, 2012 at 1:23 AM, Tejun Heo <tj@kernel.org> wrote:
> On Mon, Feb 13, 2012 at 07:03:38PM +0800, Ming Lei wrote:
>> It doesn't make sense to trace irq off or do irq flags
>> lock proving inside 'this_cpu' operations, so replace local_irq_*
>> with raw_local_irq_* in 'this_cpu' op.
>>
>> Also the patch fixes one lockdep warning[1], which is caused
>> by the added local_irq_save/restore(flags) in this_cpu_inc
>> called by __debug_atomic_inc: kernel/lockdep.c
>
> I think this isn't gonna hurt anything but I don't understand why the
> lockdep warning is triggering when using traced version.  Can you
> please explain that in a bit more detail in the patch description?

In trace_hardirqs_on_caller:kernel/lockdep.c, __debug_atomic_inc
will be called to add on 'this_cpu' variable, so may introduce recursive
trace_hardirqs_on|off_caller called.

For the lockdep warning, I reproduced it on ARM, see the path below:

kernel_thread_helper	/*irq disabled*/
	->entry: trace_hardirqs_on_caller	/*hardirqs_enabled was set*/
		->trace_hardirqs_off_caller /*hardirqs_enabled cleared*/
			__this_cpu_add(redundant_hardirqs_on)
		->trace_hardirqs_off_caller	/*irq disabled, so call here*/

so the 'unannotated irqs-on' warning will be triggered somewhere
because irq will be enabled just after the irq trace inside
kernel_thread_helper.
You can refer to log of commit  ac78884e6d89714d18b32b5b7d574116ecfb7c88
(ARM: lockdep: fix unannotated irqs-on) about irq trace inside
kernel_thread_helper.


thanks,
-- 
Ming Lei
