Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965785Ab0COU2E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:28:04 -0400
Received: from gate.crashing.org ([63.228.1.57]:49959 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936710Ab0COU2A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:28:00 -0400
Subject: Re: 64-syscall args on 32-bit vs syscall()
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com, drepper@redhat.com,
       torvalds@linux-foundation.org, munroesj@linux.vnet.ibm.com
In-Reply-To: <20100315134449.GB1653@linux-mips.org>
References: <1268628493.2355.2.camel@pasglop>
	 <20100314.220646.190065794.davem@davemloft.net>
	 <1268630313.2335.2.camel@pasglop>  <20100315134449.GB1653@linux-mips.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 07:27:09 +1100
Message-ID: <1268684829.2335.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 14:44 +0100, Ralf Baechle wrote:
> Syscall is most often used for new syscalls that have no syscall stub in
> glibc yet, so the user of syscall() encodes this ABI knowledge.  If at a
> later stage syscall() is changed to have this sort of knowledge we break
> the API.  This is something only the kernel can get right. 

Well, no. The change I propose would not break the ABI on powerpc and
would auto-magically fix thoses cases :-) But again, you don't have to
do the same thing on MIPS or sparc, it's definitely arch specific.

IE. What you are saying is that a syscall defined in the kernel as:

	sys_foo(u64 arg);

To be called from userspace would require something like:

	u64 arg = 0x123456789abcdef01;

#if defined(__powerpc__) && WORDSIZE == 32
	syscall(SYS_foo, (u32)(arg >> 32), (u32)arg);
#ese
	syscall(SYS_foo, arg);

While with the trick of making syscall a macro wrapping an underlying
__syscall that has an added dummy argument, the register alignment is
"corrected" and thus -both- forms above suddenly work for me. That might
actually work for you too.

Cheers,
Ben.


