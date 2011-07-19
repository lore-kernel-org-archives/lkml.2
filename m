Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071Ab1GSP41 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 11:56:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58088 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab1GSP40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 11:56:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [RFC][PATCH] Anonymous shared memory (ashmem) subsystem
Date: Tue, 19 Jul 2011 17:55:50 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Robert Love <rlove@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Eric Anholt <eric@anholt.net>, Jesse Barnes <jbarnes@virtuousgeek.org>
References: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1311015274-28650-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107191755.50749.arnd@arndb.de>
X-Provags-ID: V02:K0:17yKrkyY6p0lEhZ0Gow/doEg7Xs3i37oyVYguChO9yj
 ejN6GCHXaUNSNKJr0dLkGZLkczJGgmQ5ToM5w2dQTSbzlxIRTP
 M82MoLizS5X31Z+MmW46fwAPFLlIcq+FBJrrcecAq4zenMFVXi
 sziRbuNoGBoYRW9r41P0sANHbHlgOP5BvZD4E6+UcI+DGb7rhh
 wx8onmhdxrpHBwdlGOWZg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 July 2011, John Stultz wrote:

> +
> +#define ASHMEM_NAME_DEF		"dev/ashmem"
> +
> +/* Return values from ASHMEM_PIN: Was the mapping purged while unpinned? */
> +#define ASHMEM_NOT_PURGED	0
> +#define ASHMEM_WAS_PURGED	1
> +
> +/* Return values from ASHMEM_GET_PIN_STATUS: Is the mapping pinned? */
> +#define ASHMEM_IS_UNPINNED	0
> +#define ASHMEM_IS_PINNED	1
> +
> +struct ashmem_pin {
> +	__u32 offset;	/* offset into region, in bytes, page-aligned */
> +	__u32 len;	/* length forward from offset, in bytes, page-aligned */
> +};
> +
> +#define __ASHMEMIOC		0x77
> +
> +#define ASHMEM_SET_NAME		_IOW(__ASHMEMIOC, 1, char[ASHMEM_NAME_LEN])
> +#define ASHMEM_GET_NAME		_IOR(__ASHMEMIOC, 2, char[ASHMEM_NAME_LEN])

Having a name for an 'anonymous shared memory' segment is rather
counter-intuitive ;-)

> +#define ASHMEM_SET_SIZE		_IOW(__ASHMEMIOC, 3, size_t)
> +#define ASHMEM_GET_SIZE		_IO(__ASHMEMIOC, 4)
> +#define ASHMEM_SET_PROT_MASK	_IOW(__ASHMEMIOC, 5, unsigned long)
> +#define ASHMEM_GET_PROT_MASK	_IO(__ASHMEMIOC, 6)

size_t and unsigned long arguments in ioctl commands are harmful,
because they require a compat_ioctl function. It's often better to just
make these either __u32 or __u64.

> diff --git a/mm/Makefile b/mm/Makefile
> index 836e416..cd41f09 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -30,6 +30,7 @@ obj-$(CONFIG_HUGETLBFS)	+= hugetlb.o
>  obj-$(CONFIG_NUMA) 	+= mempolicy.o
>  obj-$(CONFIG_SPARSEMEM)	+= sparse.o
>  obj-$(CONFIG_SPARSEMEM_VMEMMAP) += sparse-vmemmap.o
> +obj-$(CONFIG_ASHMEM)	+= ashmem.o
>  obj-$(CONFIG_SLOB) += slob.o
>  obj-$(CONFIG_COMPACTION) += compaction.o
>  obj-$(CONFIG_MMU_NOTIFIER) += mmu_notifier.o

Wouldn't this better live in drivers/char, next to mem.c or even
merged into that file?

> +static const struct file_operations ashmem_fops = {
> +	.owner = THIS_MODULE,
> +	.open = ashmem_open,
> +	.release = ashmem_release,
> +	.read = ashmem_read,
> +	.llseek = ashmem_llseek,
> +	.mmap = ashmem_mmap,
> +	.unlocked_ioctl = ashmem_ioctl,
> +	.compat_ioctl = ashmem_ioctl,
> +};

The compat_ioctl is wrong here, as described above.

	Arnd
