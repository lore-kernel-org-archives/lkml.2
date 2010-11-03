Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755403Ab0KCPNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 11:13:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44993 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab0KCPNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 11:13:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=VOOdcVD4+0thgk9udZyXhE97ZqtAXGRKZNBGI+ON8r2Palp3q2nFq2Utqe9jaT+KKI
         mQFrTwJ6Af940SiB+SBBJzPLC2p0CWz8uVMJb8/f6zVf4Iux2cIGc1VLkQD4lsEcKCCy
         BdTK81KeLiyVK3axKLDgxgP+KVTD21Kg6+pIM=
Subject: Re: [PATCH 03/20] x86/ticketlock: Use C for __ticket_spin_unlock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@suse.de>, Jan Beulich <JBeulich@novell.com>,
        Avi Kivity <avi@redhat.com>, Xen-devel <xen-devel@lists.xensource.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
In-Reply-To: <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1288794124.git.jeremy.fitzhardinge@citrix.com>
	 <20092775a9df07a5a75820ac250194b535279d51.1288794124.git.jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 16:13:38 +0100
Message-ID: <1288797218.2511.143.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 03 novembre 2010 à 10:59 -0400, Jeremy Fitzhardinge a
écrit :
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
> index 6711d36..082990a 100644
> --- a/arch/x86/include/asm/spinlock.h
> +++ b/arch/x86/include/asm/spinlock.h
> @@ -33,9 +33,23 @@
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
> +}
>  #else
> -# define UNLOCK_LOCK_PREFIX
> +static __always_inline void __ticket_unlock_release(struct arch_spinlock *lock)
> +{
> +	barrier();

technically speaking, it should be : smp_wmb()

> +	lock->tickets.head++;
> +	barrier();

Not sure you need this one.

> +}
>  #endif
>  

