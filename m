Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756007Ab0EXDYN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 23:24:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46720 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab0EXDYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 23:24:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:x-mailer:mime-version:content-type
         :content-transfer-encoding;
        b=CL8UKkQ4Dg+Vh12zULdSdYY7n+Qv5VA+hyESUCb8v13zTM0UA1UFOiEEXUwUqFLRf2
         WEpCnCO2hMrUJDcBJtjHVyoTJnXqR0PCbqdIf3gnrQasqDDWPh4g7K3vAmTxPcfG43BZ
         czoARC03YLjLxIeaxSHyzcaTIivgjr/9/t9QE=
Date: Mon, 24 May 2010 11:23:55 +0800
From: Ming Lei <tom.leiming@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-embedded@vger.kernel.org,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH] ARM: fix 'unannotated irqs-on' lockdep warning
Message-ID: <20100524112355.18424622@tom-lei>
In-Reply-To: <20100523194746.GE950@n2100.arm.linux.org.uk>
References: <1274615328-27953-1-git-send-email-tom.leiming@gmail.com>
	<20100523123801.GC950@n2100.arm.linux.org.uk>
	<AANLkTikRp0EHxshKYq39p18ymoRNAtyHrNm3yq6A49-r@mail.gmail.com>
	<20100523141300.GD950@n2100.arm.linux.org.uk>
	<AANLkTinV9Na9zxYMIfTr893Ynnc0YOk2B6uPKEa9s4R1@mail.gmail.com>
	<20100523194746.GE950@n2100.arm.linux.org.uk>
Organization: private
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 23 May 2010 20:47:46 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Let me explain again.  We have this series of actions:
> 
> - in userspace
> - exception happens
> - cpu disables interrupts itself
> - save state
> - enable interrupts, and tell lockdep that IRQs are unmasked
> - we process the exception, and ultimately call ret_fast_syscall or
>   ret_slow_syscall
> 
> Now, what was happening in existing kernels is:
> 
> POINT A.
> - disable interrupts, and tell lockdep that IRQs are masked
> - check for any work pending
>   - if work pending, call function - with IRQs still masked
>   - go back to point A.
> - restore state
> - resume userspace, which implicitly re-enables IRQs
> 
> This results in a balanced and afaics correct setup.  Lockdep doesn't
> care about the state of userspace - it only cares about state (and its
> code only ever runs) when we're in kernel mode.
> 
> With your change above, what's happening is the above is replaced by:
> 
> POINT A.
> - disable interrupts, but don't tell lockdep that IRQs are masked
> - check for any work pending
>   - if work pending, call function - with IRQs still masked
> 	*but* lockdep believes IRQs are enabled.  Therefore, I believe
> 	false warnings are probable from things like the scheduler,
> 	signal handling paths, etc.
>   - go back to point A.
> - restore state
> - resume userspace, which implicitly re-enables IRQs
> 
> So can you now see why I believe the above change I've quoted is
> wrong?

Yes, you are right, so we can fix it by the two ways below:

	-keep disable_irq in ret_slow_syscall, also add a extra 
	trace_ret_hardirqs_on before resume userspace.
or 
	-replace disable_irq with disable_irq_notrace in ret_slow_syscall
	and ret_fast_syscall, also add a extra trace_ret_hardirqs_off if
	there are works pending

seems the 2nd way is more efficient.

> 
> Moreover, I put to you that it's utterly pointless - and a waste of
> CPU time - telling lockdep about the IRQ masking when an exception

Yes, the patch still tries to remove the pointless trace of IRQ masking,
such as: replace disable_irq with disable_irq_notrace.

> occurs, and it's also pointless telling lockdep about the IRQ
> unmasking when we resume userspace.

Even it is pointless, but if lockdep doesn't see the IRQ unmasking, the 
warning "unannotated irqs-on" will be triggered and lockdep doe not work
any longer, so we have to remove the warning to make lockdep workable on
ARM, could you agree on it?  It is the main purpose of the patch.

The warning was reported before and still exists in 2.6.34 and -next tree:

        http://marc.info/?l=linux-arm-kernel&m=126047420005553&w=2


Thanks,
Ming Lei

