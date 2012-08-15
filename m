Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755321Ab2HOAyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 20:54:25 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:56016 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab2HOAyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 20:54:23 -0400
Date: Tue, 14 Aug 2012 17:49:14 -0700
From: Olof Johansson <olof@lixom.net>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v2 15/31] arm64: SMP support
Message-ID: <20120815004914.GH19607@quad.lixom.net>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <1344966752-16102-16-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344966752-16102-16-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Aug 14, 2012 at 06:52:16PM +0100, Catalin Marinas wrote:
> This patch adds SMP initialisation and spinlocks implementation for
> AArch64. The spinlock support uses the new load-acquire/store-release
> instructions to avoid explicit barriers. The architecture also specifies
> that an event is automatically generated when clearing the exclusive
> monitor state to wake up processors in WFE, so there is no need for an
> explicit DSB/SEV instruction sequence. The SEVL instruction is used to
> set the exclusive monitor locally as there is no conditional WFE and a
> branch is more expensive.
> 
> For the SMP booting protocol, see Documentation/arm64/booting.txt.
> 
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> ---

> diff --git a/arch/arm64/include/asm/spinlock.h b/arch/arm64/include/asm/spinlock.h
> new file mode 100644
> index 0000000..34a37fb
> --- /dev/null
> +++ b/arch/arm64/include/asm/spinlock.h
> @@ -0,0 +1,199 @@
> +/*
> + * Copyright (C) 2012 ARM Ltd.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +#ifndef __ASM_SPINLOCK_H
> +#define __ASM_SPINLOCK_H
> +
> +#include <asm/spinlock_types.h>
> +#include <asm/processor.h>
> +
> +/*
> + * AArch64 Spin-locking.
> + *
> + * We exclusively read the old value.  If it is zero, we may have
> + * won the lock, so we try exclusively storing it.  A memory barrier
> + * is required after we get a lock, and before we release it, because
> + * V6 CPUs are assumed to have weakly ordered memory.

This comment should be updated, to mention the implicit locking and remove the
reference to V6?

Also, ignore previous questions on another reply about need for barriers,
obviously not needed given the load-acquire/store-release semantics.



-Olof
