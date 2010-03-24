Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756795Ab0CXTmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:42:44 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:36798 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756087Ab0CXTmm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <20100323210616.GB19572@n2100.arm.linux.org.uk>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
	 <1269219965-23923-3-git-send-email-christofferdall@christofferdall.dk>
	 <20100323210616.GB19572@n2100.arm.linux.org.uk>
Date: Wed, 24 Mar 2010 20:42:41 +0100
Message-ID: <7d08b87d1003241242k62cd125ex4b0fa0e24879fddb@mail.gmail.com>
Subject: Re: [C/R ARM][PATCH 2/3] ARM: Add the eclone system call
From: Christoffer Dall <christofferdall@christofferdall.dk>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       libc-ports <libc-ports@sourceware.org>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:06 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Sun, Mar 21, 2010 at 09:06:04PM -0400, Christoffer Dall wrote:
>> In addition to doing everything that clone() system call does, the
>> eclone() system call:
>
> Some comments...
>
>> +sys_eclone_wrapper:
>> +             add     ip, sp, #S_OFF
>> +             str     ip, [sp, #0]
>> +             b       sys_eclone
>> +ENDPROC(sys_eclone_wrapper)
>
> I'm curious why, if you want the entire set of registers, you don't just
> do:
>                add     r0, sp, #S_OFF
>                b       sys_eclone
>
> and load the syscall arguments out of regs->ARM_foo.  This avoids the need
> for additional stores.
>

I simply copied the code from sys_clone. Do you prefer that I change
it in both places?

>> +
>>  sys_sigreturn_wrapper:
>>               add     r0, sp, #S_OFF
>>               b       sys_sigreturn
>> diff --git a/arch/arm/kernel/sys_arm.c b/arch/arm/kernel/sys_arm.c
>> index ae4027b..fd8199d 100644
>> --- a/arch/arm/kernel/sys_arm.c
>> +++ b/arch/arm/kernel/sys_arm.c
>> @@ -183,6 +183,45 @@ asmlinkage int sys_clone(unsigned long clone_flags, unsigned long newsp,
>>       return do_fork(clone_flags, newsp, regs, 0, parent_tidptr, child_tidptr);
>>  }
>>
>> +asmlinkage int sys_eclone(unsigned flags_low, struct clone_args __user *uca,
>> +                       int args_size, pid_t __user *pids,
>> +                       struct pt_regs *regs)
>> +{
>> +     int rc;
>> +     struct clone_args kca;
>> +     unsigned long flags;
>> +     int __user *parent_tidp;
>> +     int __user *child_tidp;
>> +     unsigned long __user stack;
>
> __user on an integer type doesn't make any sense; integer types do not
> have address spaces.
>

thanks, will follow Sukadev's changes...

>> +     unsigned long stack_size;
>> +
>> +     rc = fetch_clone_args_from_user(uca, args_size, &kca);
>> +     if (rc)
>> +             return rc;
>> +
>> +     /*
>> +      * TODO: Convert 'clone-flags' to 64-bits on all architectures.
>> +      * TODO: When ->clone_flags_high is non-zero, copy it in to the
>> +      *       higher word(s) of 'flags':
>> +      *
>> +      *              flags = (kca.clone_flags_high << 32) | flags_low;
>> +      */
>> +     flags = flags_low;
>> +     parent_tidp = (int *)(unsigned long)kca.parent_tid_ptr;
>> +     child_tidp = (int *)(unsigned long)kca.child_tid_ptr;
>
> This will produce sparse errors.  Is there a reason why 'clone_args'
> tid pointers aren't already pointers marked with __user ?
>
>> +
>> +     stack_size = (unsigned long)kca.child_stack_size;
>
> Shouldn't this already be of integer type?
>
>> +     if (stack_size)
>> +             return -EINVAL;
>
> So the stack must have a zero size?  Is this missing a '!' ?
>
>> +
>> +     stack = (unsigned long)kca.child_stack;
>> +     if (!stack)
>> +             stack = regs->ARM_sp;
>> +
>> +     return do_fork_with_pids(flags, stack, regs, stack_size, parent_tidp,
>> +                             child_tidp, kca.nr_pids, pids);
>
> Hmm, so let me get this syscall interface right.  We have some arguments
> passed in registers and others via a (variable sized?) structure.  It seems
> really weird to have, eg, a pointer to the pids and the number of pids
> passed in two separate ways.
>
> The grouping between what's passed in registers and via this clone_args
> structure seems to be random.  Can it be sanitized?
>

Thanks for you feedback. I will let the people behind eclone deal with
the eclone specifics.
