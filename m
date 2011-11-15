Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab1KOPNr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 10:13:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59741 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753914Ab1KOPNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 10:13:44 -0500
Message-ID: <1321370020.2856.16.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Subject: Re: [PATCH 1/4] Routine for generating an safe ID for kernel pointer
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Date: Tue, 15 Nov 2011 16:13:40 +0100
In-Reply-To: <4EC24EC1.7060203@parallels.com>
References: <4EC24E9E.8040502@parallels.com>
	 <4EC24EC1.7060203@parallels.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 15 novembre 2011 à 15:36 +0400, Pavel Emelyanov a écrit :
> The routine XORs the given pointer with a random value thus producing
> an ID (32 or 64 bit, depending on the arch) which can be shown even to
> unprivileged user space processes without risking of leaking kernel
> information.
> 
> It implies that it gets called when the random pool is ready for providing
> a random long value.
> 
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> 
> ---
>  include/linux/gen_object_ids.h |   12 ++++++++++++
>  mm/Kconfig                     |    7 +++++++
>  mm/Makefile                    |    1 +
>  mm/gen_object_ids.c            |   21 +++++++++++++++++++++
>  4 files changed, 41 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/gen_object_ids.h
>  create mode 100644 mm/gen_object_ids.c
> 
> diff --git a/include/linux/gen_object_ids.h b/include/linux/gen_object_ids.h
> new file mode 100644
> index 0000000..17981ae
> --- /dev/null
> +++ b/include/linux/gen_object_ids.h
> @@ -0,0 +1,12 @@
> +#ifndef __GEN_OBJECT_IDS_H__
> +#define __GEN_OBJECT_IDS_H__
> +
> +#ifdef CONFIG_GENERIC_OBJECT_IDS
> +unsigned long gen_object_id(void *ptr);
> +#else
> +static inline unsigned long gen_object_id(void *ptr)
> +{
> +	return 0;
> +}
> +#endif
> +#endif
> diff --git a/mm/Kconfig b/mm/Kconfig
> index f2f1ca1..1480cbf 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -370,3 +370,10 @@ config CLEANCACHE
>  	  in a negligible performance hit.
>  
>  	  If unsure, say Y to enable cleancache
> +
> +config GENERIC_OBJECT_IDS
> +	bool "Enable generic object ids infrastructure"
> +	default n
> +	help
> +	  Turn on the (quite simple) funtionality that can generate IDs for
> +	  kernel objects which is safe to export to the userspace.
> diff --git a/mm/Makefile b/mm/Makefile
> index 836e416..155797a 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -50,3 +50,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
>  obj-$(CONFIG_CLEANCACHE) += cleancache.o
> +obj-$(CONFIG_GENERIC_OBJECT_IDS) += gen_object_ids.o
> diff --git a/mm/gen_object_ids.c b/mm/gen_object_ids.c
> new file mode 100644
> index 0000000..a75119b
> --- /dev/null
> +++ b/mm/gen_object_ids.c
> @@ -0,0 +1,21 @@
> +#include <linux/gen_object_ids.h>
> +#include <linux/spinlock.h>
> +#include <linux/random.h>
> +
> +static unsigned long ptr_poison __read_mostly;
> +static DEFINE_SPINLOCK(ptr_poison_lock);
> +
> +unsigned long gen_object_id(void *ptr)
> +{
> +	if (!ptr)
> +		return 0;
> +
> +	if (unlikely(!ptr_poison)) {
> +		spin_lock(&ptr_poison_lock);
> +		if (!ptr_poison)
> +			get_random_bytes(&ptr_poison, sizeof(ptr_poison));
> +		spin_unlock(&ptr_poison_lock);
> +	}
> +
> +	return ((unsigned long)ptr) ^ ptr_poison;
> +}

It can not be called from irq context then...

I suggest using following code instead (no lock needed)

if (!ptr_poison) {
	unsigned long rnd;

	do {
		get_random_bytes(&rnd, sizeof(rnd));
	} while (rnd == 0);
	cmpxchg(&ptr_poison, 0, rnd);
}
return ((unsigned long)ptr) ^ ptr_poison;



