Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab0JWCLi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 22:11:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38511 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753028Ab0JWCLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 22:11:37 -0400
MIME-Version: 1.0
In-Reply-To: <tip-fd35fbcdd1b2579a6e00a1545f7124e4005d0474@git.kernel.org>
References: <AANLkTi=RKyHLNTq6iomZOXkc6Zw1j9iAgsq8388XmzwN@mail.gmail.com> <tip-fd35fbcdd1b2579a6e00a1545f7124e4005d0474@git.kernel.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 22 Oct 2010 19:11:09 -0700
Message-ID: <AANLkTi=KRVMrNh6MyDh5v-ZGB18iEKkqsW+6Eqp27M5X@mail.gmail.com>
Subject: Re: [tip:x86/fpu] x86-64, asm: Use fxsaveq/fxrestorq in more places
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 6:20 PM, tip-bot for H. Peter Anvin
<hpa@zytor.com> wrote:
>
> Checkin d7acb92fea932ad2e7846480aeacddc2c03c8485 made use of fxsaveq
> in fpu_fxsave() if the assembler supports it; this adds
> fxsaveq/fxrstorq to fxrstor_checking() and fxsave_user() as well.

Hmm. I really think you should be able to do something like this

  #ifdef CONFIG_AS_FXSAVEQ
    #define FXSAVEQ_INSN "fxsaveq %[fx]"
    #define FXRSTORQ_INSN "fxrstorq %[fx]"
    #define FX_EXTRA(ptr)
  #else
    #define FXSAVEQ_INSN "rex64/fxsave (%[fxr])"
    #define FXRSTORQ_INSN "rex64/fxrstor (%[fxr])"
    #define FX_EXTRA(ptr)  [fxr] "R" (ptr)
  #endif

and then you should be able to write the actual code something like

   asm volatile(FXSAVEQ_INSN
      :[fx] "=m" (memory)
      :FX_EXTRA(&memory))

and

  #define __COMMA_CONCAT(x) ,##x
  #define COMMA_CONCAT(x) __COMMA_CONCAT(x)
  asm volatile(FXRSTRORQ_INSN
      : :[fx] "m" (memory) COMMA_CONCAT(FX_EXTRA(&memory)));

or something like that (obviously you'll need the exception stuff too there).

With no #ifdef's in the actual code. Hmm?

                                      Linus
