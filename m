Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab1KOLix (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 06:38:53 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50350 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab1KOLiw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 06:38:52 -0500
MIME-Version: 1.0
In-Reply-To: <4EC24EC1.7060203@parallels.com>
References: <4EC24E9E.8040502@parallels.com>
	<4EC24EC1.7060203@parallels.com>
Date: Tue, 15 Nov 2011 13:38:51 +0200
X-Google-Sender-Auth: SUbKx2w5jGq8mW7C1ojaOIF6AIw
Message-ID: <CAOJsxLECV5yr+A_mSooS674CKgGoNxgrbhOs0CCu0Pa0=KPkPw@mail.gmail.com>
Subject: Re: [PATCH 1/4] Routine for generating an safe ID for kernel pointer
From: Pekka Enberg <penberg@kernel.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 1:36 PM, Pavel Emelyanov <xemul@parallels.com> wrote:
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
>  include/linux/gen_object_ids.h |   12 ++++++++++++
>  mm/Kconfig                     |    7 +++++++
>  mm/Makefile                    |    1 +
>  mm/gen_object_ids.c            |   21 +++++++++++++++++++++
>  4 files changed, 41 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/gen_object_ids.h
>  create mode 100644 mm/gen_object_ids.c
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
> +       return 0;
> +}
> +#endif
> +#endif
> diff --git a/mm/Kconfig b/mm/Kconfig
> index f2f1ca1..1480cbf 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -370,3 +370,10 @@ config CLEANCACHE
>          in a negligible performance hit.
>
>          If unsure, say Y to enable cleancache
> +
> +config GENERIC_OBJECT_IDS
> +       bool "Enable generic object ids infrastructure"
> +       default n
> +       help
> +         Turn on the (quite simple) funtionality that can generate IDs for
> +         kernel objects which is safe to export to the userspace.
> diff --git a/mm/Makefile b/mm/Makefile
> index 836e416..155797a 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -50,3 +50,4 @@ obj-$(CONFIG_HWPOISON_INJECT) += hwpoison-inject.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK) += kmemleak.o
>  obj-$(CONFIG_DEBUG_KMEMLEAK_TEST) += kmemleak-test.o
>  obj-$(CONFIG_CLEANCACHE) += cleancache.o
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
> +       if (!ptr)
> +               return 0;
> +
> +       if (unlikely(!ptr_poison)) {
> +               spin_lock(&ptr_poison_lock);
> +               if (!ptr_poison)
> +                       get_random_bytes(&ptr_poison, sizeof(ptr_poison));
> +               spin_unlock(&ptr_poison_lock);
> +       }
> +
> +       return ((unsigned long)ptr) ^ ptr_poison;
> +}

You could put this in mm/util.c. Wouldn't it make sense to separate
the initialization and use late_initcall() to call it?

                        Pekka
