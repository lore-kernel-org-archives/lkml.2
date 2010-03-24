Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012Ab0CXUs6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:48:58 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:59906 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932998Ab0CXUsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:48:47 -0400
MIME-Version: 1.0
In-Reply-To: <20100323211843.GC19572@n2100.arm.linux.org.uk>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
	 <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk>
	 <20100323211843.GC19572@n2100.arm.linux.org.uk>
Date: Wed, 24 Mar 2010 21:48:45 +0100
Message-ID: <7d08b87d1003241348g347f092k1142318490e0bdcc@mail.gmail.com>
Subject: Re: [C/R ARM][PATCH 3/3] c/r: ARM implementation of 
	checkpoint/restart
From: Christoffer Dall <christofferdall@christofferdall.dk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:18 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Mar 21, 2010 at 09:06:05PM -0400, Christoffer Dall wrote:
>> The ISA version (given by __LINUX_ARM_ARCH__) is checkpointed and verified
>> against the machine architecture on restart.
>
> I think you misunderstand what __LINUX_ARM_ARCH__ signifies.  It is the
> build architecture for the kernel, and it indicates the lowest
> architecture version that the kernel will run on.

Yes, clearly I didn't understand this fully. So is it in fact possible
to compile the kernel with __LINUX_ARM_ARCH=6 and have
CONFIG_CPU_32v7? Or is it a matter of running a v6 kernel with
CONFIG_CPU_32v6 on a newer architecture?

What I would like to accomplish is the best way to make sure that the
restarted process will in fact be able to run. What is the best way to
ensure this with regards to the architecture version?

>
> That doesn't indicate what ISA version the system is running on, or even
> if the ABI is compatible (we have two ABIs - OABI and EABI).

That's why I checkpointed CONFIG_OABI_COMPAT, but I realize that it's
not sufficient.

How about checkpointing CONFIG_AEABI and CONFIG_OABI_COMPAT and making
sure that we either restore to the same setting of the two or restore
to CONFIG_OABI_COMPAT=y?

>
> There's also the matter of FP implementation - whether it is VFP or FPA,
> and whether iwMMXt is available or not.  (iwMMXt precludes the use of
> FPA.)

I had a feeling this would be an issue, but I never dove into the
workings of FP on ARM. Can you give me some concrete pointers as what
to checkpoint and restart / check on restart for a process using FP to
be able to be restarted?

>
>> Regarding ThumbEE, the thumbee_state field on the thread_info is stored
>> in checkpoints when CONFIG_ARM_THUMBEE and 0 is stored otherwise. If
>> a value different than 0 is checkpointed and CONFIG_ARM_THUMBEE is not
>> set on the restore system, the restore is aborted. Feedback on this
>> implementation is very welcome.
>
> I don't recognise this configuration symbol; it doesn't exist in mainline.
>

I encountered it when looking at struct thread_info in
arch/arm/include/asm/thread_info.h, and have not seen et before. After
looking into it a little more, it's included it 2.6.33 and defined in
arch/arm/mm/Kconfig.

>> We checkpoint whether the system is running with CONFIG_MMU or not and
>> require the same configuration for the system on which we restore the
>> process. It might be possible to allow something more fine-grained,
>> if it's worth the energy. Input on this item is also very welcome,
>> specifically from someone who knows the exact meaning of the end_brk
>> field.
>
> Processes which run on MMU and non-MMU CPUs are unlikely to be
> interchangable - the run time environments are quite different.  I
> think this is a sane check.
>
thanks.

>> +/* dump the thread_struct of a given task */
>> +int checkpoint_thread(struct ckpt_ctx *ctx, struct task_struct *t)
>> +{
>> +     int ret;
>> +     struct ckpt_hdr_thread *h;
>> +     struct thread_info *ti = task_thread_info(t);
>> +
>> +     h = ckpt_hdr_get_type(ctx, sizeof(*h), CKPT_HDR_THREAD);
>> +     if (!h)
>> +             return -ENOMEM;
>> +
>> +     /*
>> +      * Store the syscall information about the checkpointed process
>> +      * as we need to know if the process was doing a syscall (and which)
>> +      * during restart.
>> +      */
>> +     h->syscall = ti->syscall;
>> +
>> +     /*
>> +      * Store remaining thread-specific info.
>> +      */
>> +     h->tp_value = ti->tp_value;
>
> How do you safely obtain consistent information from a thread?  Do you
> temporarily stop it?
>
