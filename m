Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1FXVw0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 17:52:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39791 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785Ab1FXVwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 17:52:25 -0400
Message-ID: <4E050704.3070409@zytor.com>
Date: Fri, 24 Jun 2011 14:52:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/8] x86/ticketlock: Use C for __ticket_spin_unlock
References: <cover.1308259496.git.jeremy.fitzhardinge@citrix.com> <aa0d82c6e7a1c22a941da0df3c4ba58fea375074.1308878118.git.jeremy.fitzhardinge@citrix.com>
In-Reply-To: <aa0d82c6e7a1c22a941da0df3c4ba58fea375074.1308878118.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 06:19 PM, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> If we don't need to use a locked inc for unlock, then implement it in C.
> 
> Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> ---
>  arch/x86/include/asm/spinlock.h |   33 ++++++++++++++++++---------------
>  1 files changed, 18 insertions(+), 15 deletions(-)
> 
> diff --git a/arch/x86/include/asm/spinlock.h b/arch/x86/include/asm/spinlock.h
> index f48a6e3..704b0c3 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -33,9 +33,21 @@
>   * On PPro SMP or if we are using OOSTORE, we use a locked operation to unlock
>   * (PPro errata 66, 92)
>   */
> -# define UNLOCK_LOCK_PREFIX LOCK_PREFIX
> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
> +{
> +	if (sizeof(lock->tickets.head) == sizeof(u8))
> +		asm (LOCK_PREFIX "incb %0"
> +		     : "+m" (lock->tickets.head) : : "memory");
> +	else
> +		asm (LOCK_PREFIX "incw %0"
> +		     : "+m" (lock->tickets.head) : : "memory");
> +

These should be asm volatile, I believe.

	-hpa
