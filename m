Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756477Ab0CXTrA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:47:00 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:45922 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab0CXTq5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:46:57 -0400
MIME-Version: 1.0
In-Reply-To: <20100323160933.GA4465@us.ibm.com>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk>
	 <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk>
	 <20100323160933.GA4465@us.ibm.com>
Date: Wed, 24 Mar 2010 20:46:55 +0100
Message-ID: <7d08b87d1003241246i39c9163ch6426d2184de628b0@mail.gmail.com>
Subject: Re: [C/R ARM][PATCH 3/3] c/r: ARM implementation of 
	checkpoint/restart
From: Christoffer Dall <christofferdall@christofferdall.dk>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: containers <containers@lists.linux-foundation.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, rmk@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 5:09 PM, Serge E. Hallyn <serue@us.ibm.com> wrote:
> Quoting Christoffer Dall (christofferdall@christofferdall.dk):
>> Implements architecture specific requirements for checkpoint/restart on
>> ARM. The changes touch almost only c/r related code. Most of the work is
>> done in arch/arm/checkpoint.c, which implements checkpointing of the CPU
>> and necessary fields on the thread_info struct.
>>
>> The ISA version (given by __LINUX_ARM_ARCH__) is checkpointed and verified
>> against the machine architecture on restart. If they differ, an error is
>> raised and restart aborted. It should be possible to restart on newer
>> architectures, but further investigation is warranted.
>>
>> Regarding ThumbEE, the thumbee_state field on the thread_info is stored
>> in checkpoints when CONFIG_ARM_THUMBEE and 0 is stored otherwise. If
>> a value different than 0 is checkpointed and CONFIG_ARM_THUMBEE is not
>> set on the restore system, the restore is aborted. Feedback on this
>> implementation is very welcome.
>>
>> We checkpoint whether the system is running with CONFIG_MMU or not and
>> require the same configuration for the system on which we restore the
>> process. It might be possible to allow something more fine-grained,
>> if it's worth the energy. Input on this item is also very welcome,
>> specifically from someone who knows the exact meaning of the end_brk
>> field.
>>
>> Added support for syscall sys_checkpoint and sys_restart for ARM:
>> __NR_checkpoint         367
>> __NR_restart            368
>>
>>
>> Cc: rmk@arm.linux.org.uk
>> Signed-off-by: Christoffer Dall <christofferdall@christofferdall.dk>
>> Acked-by: Oren Laadan <orenl@cs.columbia.edu>
>
> In terms of the cr api I don't see any problems.  Two nits below,
> but in any case
>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
>
> thanks, this is really cool, especially how minimal it is :)
> -serge
thanks
>
> ...
>
>> +static int load_cpu_regs(struct ckpt_hdr_cpu *h, struct task_struct *t)
>> +{
>> +     int i;
>> +     struct pt_regs *regs = task_pt_regs(t);
>> +
>> +     memcpy(regs, &h->uregs, sizeof(struct pt_regs));
>> +
>> +     for (i = 0; i < 16; i++)
>> +             regs->uregs[i] = h->uregs[i];
>> +
>> +     /*
>> +      * Restore only user-writable bits on the CPSR
>> +      */
>> +     regs->ARM_cpsr = regs->ARM_cpsr |
>> +                      (h->ARM_cpsr & (PSR_N_BIT | PSR_Z_BIT |
>> +                                      PSR_C_BIT | PSR_V_BIT |
>> +                                      PSR_V_BIT | PSR_Q_BIT |
>> +                                      PSR_E_BIT | PSR_GE_BITS));
>> +     regs->ARM_ORIG_r0 = h->ARM_ORIG_r0;
>> +
>> +     return 0;
>> +}
>> +
>> +/* read the cpu state and registers for the current task */
>> +int restore_cpu(struct ckpt_ctx *ctx)
>> +{
>> +     struct ckpt_hdr_cpu *h;
>> +     struct task_struct *t = current;
>> +     int ret;
>> +
>> +     h = ckpt_read_obj_type(ctx, sizeof(*h), CKPT_HDR_CPU);
>> +     if (IS_ERR(h))
>> +             return PTR_ERR(h);
>> +
>> +     ret = load_cpu_regs(h, t);
>
> will load_cpu_regs() ever be changed to return anything but 0?  If
> not both fns can be simplified.
>

you're right. I will put load_cpu_regs() inline in restore_cpu.
> ...
>
>> +int restore_mm_context(struct ckpt_ctx *ctx, struct mm_struct *mm)
>> +{
>> +     struct ckpt_hdr_mm_context *h;
>> +     int ret = 0;
>> +
>> +     h = ckpt_read_obj_type(ctx, sizeof(*h), CKPT_HDR_MM_CONTEXT);
>> +     if (IS_ERR(h))
>> +             return PTR_ERR(h);
>> +
>> +#if !CONFIG_MMU
>> +     mm->context.end_brk = h->end_brk;
>> +#endif
>> +
>> +     ckpt_hdr_put(ctx, h);
>> +     return ret;
>
> Again ret doesn't seem needed here.
indeed it doesn't.

-Christoffer
