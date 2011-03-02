Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab1CBIXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:23:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:55227 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755774Ab1CBIXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:23:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Saravana Kannan <skannan@codeaurora.org>
Subject: Re: CONFIG_ARM_DMA_MEM_BUFFERABLE and readl/writel weirdness
Date: Wed, 2 Mar 2011 09:23:36 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc6+; KDE/4.5.1; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "linux-arm-kernel" <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4D6D9C03.2080906@codeaurora.org>
In-Reply-To: <4D6D9C03.2080906@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103020923.36796.arnd@arndb.de>
X-Provags-ID: V02:K0:0PIDxaVGDmYvjcVYV0wfHjwk4DZ35y/7hy2SY66qaVS
 15Gq8U8BeenvUJZ+uAATNeQvi/Wz4BIrvhAc8tNvcwk+2qFf3K
 8sOb29XVZHNTgpM2yCNkEXkFVikUcPoBjcY9xxkzBTUbdC9ass
 WTv8Ausq2RWUsY4cHIxuk0HIf4QrWbbrp4vzTEhQLphYqmUPei
 fQ+GcfdT+j3FI8nfjGuPQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 March 2011 02:23:15 Saravana Kannan wrote:
> There are so many other drivers that don't use or care about DMA and 
> might still want to ensure some ordering constraints between their 
> readl(s)/writel(s). They can't depend on readl/writel taking care of it 
> for them since their code could be used in a kernel configuration that 
> doesn't enable this config.

What exactly are the ordering constraints, do you need the full
dmb() for readl() and dsb() for writel(), or just a compiler barrier?

I think we need the barrier() even for the relaxed variant, but 
that is fairly lightweight. What would be a reason to have more?

> Firstly, I don't know how many people noticed this and realize they 
> can't depend on readl/writel to take care of the mb()s for them. Seems 
> like an unnecessary encouragement to make mistakes when it didn't need 
> to be so.
> 
> Secondly, even if they realize they have to take care of it, they will 
> have to continue using mb()s in to force ordering between their 
> reads/writes. So, are we depending on the compiler to optimize these 
> extra mb() out in the case where the config is enabled? I'm not sure it 
> will be able to optimize out the extra mb()s in all cases.

The compiler certainly won't merge multiple inline assembly statements,
but multiple barrier() statements don't make it worse than just one.
barrier() just forces accessing variables from memory that could otherwise
be kept in registers.

The other problems we still need to fix are the complete absence of
barriers in inb()/outb() style accessors, which are meant to be stricter
than readl()/writel(), and the fact that we rely on undefined behavior
in gcc regarding the atomicity of multi-byte accesses, as we recently
found out when a new gcc turned a readl into byte accesses.

	Arnd
