Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756062Ab1KQUcg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 15:32:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:60567 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754871Ab1KQUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 15:32:35 -0500
Date: Thu, 17 Nov 2011 21:32:02 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: hdoyu@nvidia.com
Cc: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Hiro Sugawara <hsugawara@nvidia.com>,
        Krishna Reddy <vdumpa@nvidia.com>
Subject: Re: [PATCH 1/3] ARM: iommu: tegra/common: Initial support for IOVMM
 driver
Message-ID: <20111117203202.GB20889@avionic-0098.mockup.avionic-design.de>
References: <1321527667-12923-1-git-send-email-hdoyu@nvidia.com>
 <1321527667-12923-2-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <1321527667-12923-2-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:c7J3uxd7uboAHtWyyF3oOCgPeobssk5TnQPv8MnC0fv
 jIL7bFcslLrVjBubTHa4wEJp+QwmfdxHDCICHKFo4YTUOPYGWV
 dHYScYFUyBC9otywJa1v63CrpF5E8QKaiaiXeemaJoYFMqm0lP
 AQvbqJlo5x3ck7l2eSr/n1XJXjya3byr6gkrI0x4PkkyDMawPp
 upaWo0kEyQgxIfud/m0TNorLLyJ7WPwDicvVvxm3HogQKweZSm
 0B6MGYx2VSuj9iktAdXTHJxC3MJPe8/+Cp8loRfOfdzx5Mbud2
 wu1QhcHKASytBkfLKkAL8TvE7EKcQHnAu4+wGcfX/4gbmEjCiz
 oR6ysuKVnSVrkczIr2075FeIJw0v3WwKIV61By1UEu2Fl7dTpK
 6o0iDSOyezFdKmEmY3/xrpcGI/+NmPh6fUv4SrdsjwK5nJ76wH
 VkmrT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm not very knowledgeable about IOMMUs in general, so my comments are more
about general style.

* hdoyu@nvidia.com wrote:
> From: Hiroshi DOYU <hdoyu@nvidia.com>
>=20
> This is the tegra specific IOMMU framework, independent of H/W. H/W

You should keep the spelling of "Tegra" consistent.

> dependent modules are to be registered to this framework so that this
> can support different IOMMU H/Ws among Tegra generations, Tegra2/GART,
> and Tegra3/SMMU H/Ws.
>=20
> Most of this part could be replaced with a generic IOMMU
> framework. This is expected to ease finding similarities with
> different platforms, with the intention of solving problems once in a
> generic framework which everyone can use.
>=20
> Signed-off-by: Hiroshi DOYU <hdoyu@nvidia.com>
> Cc: Hiro Sugawara <hsugawara@nvidia.com>
> Cc: Krishna Reddy <vdumpa@nvidia.com>
> ---
>  arch/arm/mach-tegra/include/mach/iovmm.h |  283 +++++++++
>  drivers/iommu/Kconfig                    |    6 +
>  drivers/iommu/Makefile                   |    1 +
>  drivers/iommu/tegra-iovmm.c              |  936 ++++++++++++++++++++++++=
++++++
>  4 files changed, 1226 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-tegra/include/mach/iovmm.h
>  create mode 100644 drivers/iommu/tegra-iovmm.c
>=20
> diff --git a/arch/arm/mach-tegra/include/mach/iovmm.h b/arch/arm/mach-teg=
ra/include/mach/iovmm.h
> new file mode 100644
> index 0000000..6fd0bb6
> --- /dev/null
> +++ b/arch/arm/mach-tegra/include/mach/iovmm.h
> @@ -0,0 +1,283 @@
> +/*
> + * Copyright (c) 2010-2011, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed i the hope that it will be useful, but WI=
THOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, write to the Free Software Foundation, Inc=
=2E,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +#include <linux/list.h>
> +#include <linux/platform_device.h>
> +#include <linux/miscdevice.h>
> +#include <linux/rbtree.h>
> +#include <linux/rwsem.h>
> +#include <linux/spinlock.h>
> +#include <linux/types.h>
> +
> +#ifndef _MACH_TEGRA_IOVMM_H_
> +#define _MACH_TEGRA_IOVMM_H_
> +
> +typedef u32 tegra_iovmm_addr_t;
> +
> +struct tegra_iovmm_device_ops;
> +
> +/* each I/O virtual memory manager unit should register a device with
> + * the iovmm system
> + */

Generally, multi-line comments have the starting /* and ending */ on separa=
te
lines. Also since this API is public it may be better to document it using
kerneldoc.

> +struct tegra_iovmm_device {
> +	struct tegra_iovmm_device_ops	*ops;
> +	const char			*name;
> +	struct list_head		list;
> +	int				pgsize_bits;
> +};
> +
> +/* tegra_iovmm_domain serves a purpose analagous to mm_struct as defined=
 in
> + * <linux/mm_types.h> - it defines a virtual address space within which
> + * tegra_iovmm_areas can be created.
> + */
> +struct tegra_iovmm_domain {
> +	atomic_t		clients;
> +	atomic_t		locks;
> +	spinlock_t		block_lock;
> +	unsigned long		flags;
> +	wait_queue_head_t	delay_lock;  /* when lock_client fails */
> +	struct rw_semaphore	map_lock;
> +	struct rb_root		all_blocks;  /* ordered by address */
> +	struct rb_root		free_blocks; /* ordered by size */
> +	struct tegra_iovmm_device *dev;
> +};
> +
> +/* tegra_iovmm_client is analagous to an individual task in the task gro=
up
> + * which owns an mm_struct.
> + */
> +
> +struct iovmm_share_group;
> +
> +struct tegra_iovmm_client {
> +	const char			*name;
> +	unsigned long			flags;
> +	struct iovmm_share_group	*group;
> +	struct tegra_iovmm_domain	*domain;
> +	struct miscdevice		*misc_dev;
> +	struct list_head		list;
> +};
> +
> +/* tegra_iovmm_area serves a purpose analagous to vm_area_struct as defi=
ned
> + * in <linux/mm_types.h> - it defines a virtual memory area which can be
> + * mapped to physical memory by a client-provided mapping function. */
> +
> +struct tegra_iovmm_area {
> +	struct tegra_iovmm_domain	*domain;
> +	tegra_iovmm_addr_t		iovm_start;
> +	size_t				iovm_length;
> +	pgprot_t			pgprot;
> +	struct tegra_iovmm_area_ops	*ops;
> +};
> +
> +struct tegra_iovmm_device_ops {
> +	/* maps a VMA using the page residency functions provided by the VMA */
> +	int (*map)(struct tegra_iovmm_domain *domain,
> +		struct tegra_iovmm_area *io_vma);
> +	/* marks all PTEs in a VMA as invalid; decommits the virtual addres
> +	 * space (potentially freeing PDEs when decommit is true.) */
> +	void (*unmap)(struct tegra_iovmm_domain *domain,
> +		struct tegra_iovmm_area *io_vma, bool decommit);
> +	void (*map_pfn)(struct tegra_iovmm_domain *domain,
> +		struct tegra_iovmm_area *io_vma,
> +		tegra_iovmm_addr_t offs, unsigned long pfn);
> +	/* ensures that a domain is resident in the hardware's mapping region
> +	 * so that it may be used by a client */
> +	int (*lock_domain)(struct tegra_iovmm_domain *domain,
> +		struct tegra_iovmm_client *client);
> +	void (*unlock_domain)(struct tegra_iovmm_domain *domain,
> +		struct tegra_iovmm_client *client);
> +	/* allocates a vmm_domain for the specified client; may return the same
> +	 * domain for multiple clients */
> +	struct tegra_iovmm_domain* (*alloc_domain)(
> +		struct tegra_iovmm_device *dev,
> +		struct tegra_iovmm_client *client);
> +	void (*free_domain)(struct tegra_iovmm_domain *domain,
> +		struct tegra_iovmm_client *client);
> +	int (*suspend)(struct tegra_iovmm_device *dev);
> +	void (*resume)(struct tegra_iovmm_device *dev);
> +};
> +
> +struct tegra_iovmm_area_ops {
> +	/* ensures that the page of data starting at the specified offset
> +	 * from the start of the iovma is resident and pinned for use by
> +	 * DMA, returns the system pfn, or an invalid pfn if the
> +	 * operation fails. */
> +	unsigned long (*lock_makeresident)(struct tegra_iovmm_area *area,
> +		tegra_iovmm_addr_t offs);
> +	/* called when the page is unmapped from the I/O VMA */
> +	void (*release)(struct tegra_iovmm_area *area, tegra_iovmm_addr_t offs);
> +};
> +
> +#ifdef CONFIG_TEGRA_IOVMM
> +/* called by clients to allocate an I/O VMM client mapping context which
> + * will be shared by all clients in the same share_group */
> +struct tegra_iovmm_client *tegra_iovmm_alloc_client(const char *name,
> +	const char *share_group, struct miscdevice *misc_dev);
> +
> +size_t tegra_iovmm_get_vm_size(struct tegra_iovmm_client *client);
> +
> +void tegra_iovmm_free_client(struct tegra_iovmm_client *client);
> +
> +/* called by clients to ensure that their mapping context is resident
> + * before performing any DMA operations addressing I/O VMM regions.
> + * client_lock may return -EINTR. */
> +int tegra_iovmm_client_lock(struct tegra_iovmm_client *client);
> +int tegra_iovmm_client_trylock(struct tegra_iovmm_client *client);
> +
> +/* called by clients after DMA operations are complete */
> +void tegra_iovmm_client_unlock(struct tegra_iovmm_client *client);
> +
> +/* called by clients to allocate a new iovmm_area and reserve I/O virtual
> + * address space for it. if ops is NULL, clients should subsequently call
> + * tegra_iovmm_vm_map_pages and/or tegra_iovmm_vm_insert_pfn to explicit=
ly
> + * map the I/O virtual address to an OS-allocated page or physical addre=
ss,
> + * respectively. VM operations may be called before this call returns */
> +struct tegra_iovmm_area *tegra_iovmm_create_vm(
> +	struct tegra_iovmm_client *client, struct tegra_iovmm_area_ops *ops,
> +	size_t size, size_t align, pgprot_t pgprot, unsigned long iovm_start);
> +
> +/* called by clients to "zap" an iovmm_area, and replace all mappings
> + * in it with invalid ones, without freeing the virtual address range */
> +void tegra_iovmm_zap_vm(struct tegra_iovmm_area *vm);
> +
> +/* after zapping a demand-loaded iovmm_area, the client should unzap it
> + * to allow the VMM device to remap the page range. */
> +void tegra_iovmm_unzap_vm(struct tegra_iovmm_area *vm);
> +
> +/* called by clients to return an iovmm_area to the free pool for the do=
main */
> +void tegra_iovmm_free_vm(struct tegra_iovmm_area *vm);
> +
> +/* returns size of largest free iovm block */
> +size_t tegra_iovmm_get_max_free(struct tegra_iovmm_client *client);
> +
> +/* called by client software to map the page-aligned I/O address vaddr to
> + * a specific physical address pfn. I/O VMA should have been created with
> + * a NULL tegra_iovmm_area_ops structure. */
> +void tegra_iovmm_vm_insert_pfn(struct tegra_iovmm_area *area,
> +	tegra_iovmm_addr_t vaddr, unsigned long pfn);
> +
> +/* called by clients to return the iovmm_area containing addr, or NULL if
> + * addr has not been allocated. caller should call tegra_iovmm_put_area =
when
> + * finished using the returned pointer */
> +struct tegra_iovmm_area *tegra_iovmm_find_area_get(
> +	struct tegra_iovmm_client *client, tegra_iovmm_addr_t addr);

The comment mentions tegra_iovmm_put_area() but the function declared below
is called tegra_iovmm_area_put().

> +
> +struct tegra_iovmm_area *tegra_iovmm_area_get(struct tegra_iovmm_area *v=
m);
> +void tegra_iovmm_area_put(struct tegra_iovmm_area *vm);
> +
> +/* called by drivers to initialize a tegra_iovmm_domain structure */
> +int tegra_iovmm_domain_init(struct tegra_iovmm_domain *domain,
> +	struct tegra_iovmm_device *dev, tegra_iovmm_addr_t start,
> +	tegra_iovmm_addr_t end);
> +
> +/* called by drivers to register an I/O VMM device with the system */
> +int tegra_iovmm_register(struct tegra_iovmm_device *dev);
> +
> +/* called by drivers to remove an I/O VMM device from the system */
> +int tegra_iovmm_unregister(struct tegra_iovmm_device *dev);
> +
> +#else /* CONFIG_TEGRA_IOVMM */
> +
> +static inline struct tegra_iovmm_client *tegra_iovmm_alloc_client(
> +	const char *name, const char *share_group, struct miscdevice *misc_dev)
> +{
> +	return NULL;
> +}
> +
> +static inline size_t tegra_iovmm_get_vm_size(struct tegra_iovmm_client *=
client)
> +{
> +	return 0;
> +}
> +
> +static inline void tegra_iovmm_free_client(struct tegra_iovmm_client *cl=
ient)
> +{}

For readability, the braces should probably go on separate lines.

> +
> +static inline int tegra_iovmm_client_lock(struct tegra_iovmm_client *cli=
ent)
> +{
> +	return 0;
> +}
> +
> +static inline int tegra_iovmm_client_trylock(struct tegra_iovmm_client *=
client)
> +{
> +	return 0;
> +}
> +
> +static inline void tegra_iovmm_client_unlock(struct tegra_iovmm_client *=
client)
> +{}
> +

Here as well.

> +static inline struct tegra_iovmm_area *tegra_iovmm_create_vm(
> +	struct tegra_iovmm_client *client, struct tegra_iovmm_area_ops *ops,
> +	size_t size, size_t align, pgprot_t pgprot, unsigned long iovm_start)
> +{
> +	return NULL;
> +}
> +
> +static inline void tegra_iovmm_zap_vm(struct tegra_iovmm_area *vm) { }
> +
> +static inline void tegra_iovmm_unzap_vm(struct tegra_iovmm_area *vm) { }
> +
> +static inline void tegra_iovmm_free_vm(struct tegra_iovmm_area *vm) { }

And here.

> +static inline size_t tegra_iovmm_get_max_free(struct tegra_iovmm_client =
*client)
> +{
> +	return 0;
> +}
> +
> +static inline void tegra_iovmm_vm_insert_pfn(struct tegra_iovmm_area *ar=
ea,
> +	tegra_iovmm_addr_t vaddr, unsigned long pfn) { }
> +

Here.

> +static inline struct tegra_iovmm_area *tegra_iovmm_find_area_get(
> +	struct tegra_iovmm_client *client, tegra_iovmm_addr_t addr)
> +{
> +	return NULL;
> +}
> +
> +static inline struct tegra_iovmm_area *tegra_iovmm_area_get(
> +	struct tegra_iovmm_area *vm)
> +{
> +	return NULL;
> +}
> +
> +static inline void tegra_iovmm_area_put(struct tegra_iovmm_area *vm) { }
> +

Here.

> +static inline int tegra_iovmm_domain_init(struct tegra_iovmm_domain *dom=
ain,
> +	struct tegra_iovmm_device *dev, tegra_iovmm_addr_t start,
> +	tegra_iovmm_addr_t end)
> +{
> +	return 0;
> +}
> +
> +static inline int tegra_iovmm_register(struct tegra_iovmm_device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline int tegra_iovmm_unregister(struct tegra_iovmm_device *dev)
> +{
> +	return 0;
> +}
> +
> +static inline int tegra_iovmm_suspend(void)
> +{
> +	return 0;
> +}
> +
> +static inline void tegra_iovmm_resume(void) { }
> +#endif /* CONFIG_TEGRA_IOVMM */

And here. Preferably with a blank line between the closing } and the #endif.

> +
> +

One of these is gratuitous.

> +#endif
> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 5414253..487d1ee 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -131,4 +131,10 @@ config OMAP_IOMMU_DEBUG
> =20
>           Say N unless you know you need this.
> =20
> +

This one also.

> +# Tegra IOMMU support
> +
> +config TEGRA_IOVMM
> +	bool
> +
>  endif # IOMMU_SUPPORT
> diff --git a/drivers/iommu/Makefile b/drivers/iommu/Makefile
> index 2f44487..365eefb 100644
> --- a/drivers/iommu/Makefile
> +++ b/drivers/iommu/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_IRQ_REMAP) +=3D intr_remapping.o
>  obj-$(CONFIG_OMAP_IOMMU) +=3D omap-iommu.o
>  obj-$(CONFIG_OMAP_IOVMM) +=3D omap-iovmm.o
>  obj-$(CONFIG_OMAP_IOMMU_DEBUG) +=3D omap-iommu-debug.o
> +obj-$(CONFIG_TEGRA_IOVMM) +=3D tegra-iovmm.o
> diff --git a/drivers/iommu/tegra-iovmm.c b/drivers/iommu/tegra-iovmm.c
> new file mode 100644
> index 0000000..0f2d996
> --- /dev/null
> +++ b/drivers/iommu/tegra-iovmm.c
> @@ -0,0 +1,936 @@
> +/*
> + * Tegra I/O VM manager
> + *
> + * Copyright (c) 2010-2011, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful, but W=
ITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License alo=
ng
> + * with this program; if not, write to the Free Software Foundation, Inc=
=2E,
> + * 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/spinlock.h>
> +#include <linux/proc_fs.h>
> +#include <linux/sched.h>
> +#include <linux/string.h>
> +#include <linux/slab.h>
> +#include <linux/syscore_ops.h>
> +
> +#include <mach/iovmm.h>
> +
> +/*
> + * after the best-fit block is located, the remaining pages not needed
> + * for the allocation will be split into a new free block if the
> + * number of remaining pages is >=3D MIN_SPLIT_PAGE.
> + */
> +#define MIN_SPLIT_PAGE		4
> +#define MIN_SPLIT_BYTES(_d)	(MIN_SPLIT_PAGE << (_d)->dev->pgsize_bits)
> +#define NO_SPLIT(m)		((m) < MIN_SPLIT_BYTES(domain))
> +#define DO_SPLIT(m)		((m) >=3D MIN_SPLIT_BYTES(domain))
> +
> +#define iovmm_start(_b)		((_b)->vm_area.iovm_start)
> +#define iovmm_length(_b)	((_b)->vm_area.iovm_length)
> +#define iovmm_end(_b)		(iovmm_start(_b) + iovmm_length(_b))
> +
> +/* flags for the block */
> +#define BK_free		0 /* indicates free mappings */
> +#define BK_map_dirty	1 /* used by demand-loaded mappings */
> +
> +/* flags for the client */
> +#define CL_locked	0
> +
> +/* flags for the domain */
> +#define DM_map_dirty	0

These flags should be all uppercase.

> +
> +struct tegra_iovmm_block {
> +	struct tegra_iovmm_area vm_area;
> +	tegra_iovmm_addr_t	start;
> +	size_t			length;
> +	atomic_t		ref;
> +	unsigned long		flags;
> +	unsigned long		poison;
> +	struct rb_node		free_node;
> +	struct rb_node		all_node;
> +};
> +
> +struct iovmm_share_group {
> +	const char			*name;
> +	struct tegra_iovmm_domain	*domain;
> +	struct list_head		client_list;
> +	struct list_head		group_list;
> +	spinlock_t			lock; /* for client_list */
> +};
> +
> +static LIST_HEAD(iovmm_devices);
> +static LIST_HEAD(iovmm_groups);
> +static DEFINE_MUTEX(iovmm_group_list_lock);
> +static struct kmem_cache *iovmm_cache;
> +
> +#define SIMALIGN(b, a)	(((b)->start % (a)) ? ((a) - ((b)->start % (a))) =
: 0)
> +
> +size_t tegra_iovmm_get_max_free(struct tegra_iovmm_client *client)
> +{
> +	struct rb_node *n;
> +	struct tegra_iovmm_block *b;
> +	struct tegra_iovmm_domain *domain =3D client->domain;
> +	tegra_iovmm_addr_t max_free =3D 0;
> +
> +	spin_lock(&domain->block_lock);
> +	n =3D rb_first(&domain->all_blocks);
> +	while (n) {
> +		b =3D rb_entry(n, struct tegra_iovmm_block, all_node);
> +		n =3D rb_next(n);
> +		if (test_bit(BK_free, &b->flags)) {
> +			max_free =3D max_t(tegra_iovmm_addr_t,
> +				max_free, iovmm_length(b));
> +		}
> +	}
> +	spin_unlock(&domain->block_lock);
> +	return max_free;
> +}
> +
> +
> +static void tegra_iovmm_block_stats(struct tegra_iovmm_domain *domain,
> +	unsigned int *num_blocks, unsigned int *num_free,
> +	tegra_iovmm_addr_t *total, size_t *total_free, size_t *max_free)
> +{
> +	struct rb_node *n;
> +	struct tegra_iovmm_block *b;
> +
> +	*num_blocks =3D 0;
> +	*num_free =3D 0;
> +	*total =3D 0;
> +	*total_free =3D 0;
> +	*max_free =3D 0;
> +
> +	spin_lock(&domain->block_lock);
> +	n =3D rb_first(&domain->all_blocks);
> +	while (n) {
> +		b =3D rb_entry(n, struct tegra_iovmm_block, all_node);
> +		n =3D rb_next(n);
> +		(*num_blocks)++;
> +		*total +=3D b->length;
> +		if (test_bit(BK_free, &b->flags)) {
> +			(*num_free)++;
> +			*total_free +=3D b->length;
> +			*max_free =3D max_t(size_t, *max_free, b->length);
> +		}
> +	}
> +	spin_unlock(&domain->block_lock);
> +}
> +
> +static int tegra_iovmm_read_proc(char *page, char **start, off_t off,
> +	int count, int *eof, void *data)
> +{
> +	struct iovmm_share_group *grp;
> +	size_t max_free, total_free, total;
> +	unsigned int num, num_free;
> +
> +	int len =3D 0;
> +
> +	mutex_lock(&iovmm_group_list_lock);
> +	len +=3D snprintf(page + len, count - len, "\ngroups\n");
> +	if (list_empty(&iovmm_groups))
> +		len +=3D snprintf(page + len, count - len, "\t<empty>\n");
> +	else {
> +		list_for_each_entry(grp, &iovmm_groups, group_list) {
> +			len +=3D snprintf(page + len, count - len,
> +					"\t%s (device: %s)\n",
> +				(grp->name) ? grp->name : "<unnamed>",
> +				grp->domain->dev->name);
> +			tegra_iovmm_block_stats(grp->domain, &num,
> +				&num_free, &total, &total_free, &max_free);
> +			total >>=3D 10;
> +			total_free >>=3D 10;
> +			max_free >>=3D 10;
> +			len +=3D snprintf(page + len, count - len,
> +				"\t\tsize: %uKiB free: %uKiB "
> +				"largest: %uKiB (%u free / %u total blocks)\n",
> +				total, total_free, max_free, num_free, num);
> +		}
> +	}
> +	mutex_unlock(&iovmm_group_list_lock);
> +
> +	*eof =3D 1;
> +	return len;
> +}
> +
> +static void iovmm_block_put(struct tegra_iovmm_block *b)
> +{
> +	BUG_ON(b->poison);
> +	BUG_ON(atomic_read(&b->ref) =3D=3D 0);
> +	if (!atomic_dec_return(&b->ref)) {
> +		b->poison =3D 0xa5a5a5a5;
> +		kmem_cache_free(iovmm_cache, b);
> +	}
> +}
> +
> +static void iovmm_free_block(struct tegra_iovmm_domain *domain,
> +	struct tegra_iovmm_block *block)
> +{
> +	struct tegra_iovmm_block *pred =3D NULL; /* address-order predecessor */
> +	struct tegra_iovmm_block *succ =3D NULL; /* address-order successor */
> +	struct rb_node **p;
> +	struct rb_node *parent =3D NULL, *temp;
> +	int pred_free =3D 0, succ_free =3D 0;
> +
> +	iovmm_block_put(block);
> +
> +	spin_lock(&domain->block_lock);
> +	temp =3D rb_prev(&block->all_node);
> +	if (temp)
> +		pred =3D rb_entry(temp, struct tegra_iovmm_block, all_node);
> +	temp =3D rb_next(&block->all_node);
> +	if (temp)
> +		succ =3D rb_entry(temp, struct tegra_iovmm_block, all_node);
> +
> +	if (pred)
> +		pred_free =3D test_bit(BK_free, &pred->flags);
> +	if (succ)
> +		succ_free =3D test_bit(BK_free, &succ->flags);
> +
> +	if (pred_free && succ_free) {
> +		pred->length +=3D block->length;
> +		pred->length +=3D succ->length;
> +		rb_erase(&block->all_node, &domain->all_blocks);
> +		rb_erase(&succ->all_node, &domain->all_blocks);
> +		rb_erase(&succ->free_node, &domain->free_blocks);
> +		rb_erase(&pred->free_node, &domain->free_blocks);
> +		iovmm_block_put(block);
> +		iovmm_block_put(succ);
> +		block =3D pred;
> +	} else if (pred_free) {
> +		pred->length +=3D block->length;
> +		rb_erase(&block->all_node, &domain->all_blocks);
> +		rb_erase(&pred->free_node, &domain->free_blocks);
> +		iovmm_block_put(block);
> +		block =3D pred;
> +	} else if (succ_free) {
> +		block->length +=3D succ->length;
> +		rb_erase(&succ->all_node, &domain->all_blocks);
> +		rb_erase(&succ->free_node, &domain->free_blocks);
> +		iovmm_block_put(succ);
> +	}
> +
> +	p =3D &domain->free_blocks.rb_node;
> +	while (*p) {
> +		struct tegra_iovmm_block *b;
> +		parent =3D *p;
> +		b =3D rb_entry(parent, struct tegra_iovmm_block, free_node);
> +		if (block->length >=3D b->length)
> +			p =3D &parent->rb_right;
> +		else
> +			p =3D &parent->rb_left;
> +	}
> +	rb_link_node(&block->free_node, parent, p);
> +	rb_insert_color(&block->free_node, &domain->free_blocks);
> +	set_bit(BK_free, &block->flags);
> +	spin_unlock(&domain->block_lock);
> +}
> +
> +/* if the best-fit block is larger than the requested size, a remainder
> + * block will be created and inserted into the free list in its place.
> + * since all free blocks are stored in two trees the new block needs to =
be
> + * linked into both. */
> +static struct tegra_iovmm_block *iovmm_split_free_block(
> +	struct tegra_iovmm_domain *domain,
> +	struct tegra_iovmm_block *block, unsigned long size)
> +{
> +	struct rb_node **p;
> +	struct rb_node *parent =3D NULL;
> +	struct tegra_iovmm_block *rem;
> +	struct tegra_iovmm_block *b;
> +
> +	rem =3D kmem_cache_zalloc(iovmm_cache, GFP_KERNEL);
> +	if (!rem)
> +		return NULL;
> +
> +	spin_lock(&domain->block_lock);
> +	p =3D &domain->free_blocks.rb_node;
> +
> +	rem->start  =3D block->start + size;
> +	rem->length =3D block->length - size;
> +	atomic_set(&rem->ref, 1);
> +	block->length =3D size;
> +
> +	while (*p) {
> +		parent =3D *p;
> +		b =3D rb_entry(parent, struct tegra_iovmm_block, free_node);
> +		if (rem->length >=3D b->length)
> +			p =3D &parent->rb_right;
> +		else
> +			p =3D &parent->rb_left;
> +	}
> +	set_bit(BK_free, &rem->flags);
> +	rb_link_node(&rem->free_node, parent, p);
> +	rb_insert_color(&rem->free_node, &domain->free_blocks);
> +
> +	p =3D &domain->all_blocks.rb_node;
> +	parent =3D NULL;
> +	while (*p) {
> +		parent =3D *p;
> +		b =3D rb_entry(parent, struct tegra_iovmm_block, all_node);
> +		if (rem->start >=3D b->start)
> +			p =3D &parent->rb_right;
> +		else
> +			p =3D &parent->rb_left;
> +	}
> +	rb_link_node(&rem->all_node, parent, p);
> +	rb_insert_color(&rem->all_node, &domain->all_blocks);
> +
> +	return rem;
> +}
> +
> +static int iovmm_block_splitting;

Could this be moved into the tegra_iovmm_domain structure?

> +static struct tegra_iovmm_block *iovmm_alloc_block(
> +	struct tegra_iovmm_domain *domain, size_t size, size_t align)
> +{
> +	struct rb_node *n;
> +	struct tegra_iovmm_block *b, *best;
> +	size_t simalign;
> +	unsigned long page_size =3D 1 << domain->dev->pgsize_bits;
> +
> +	BUG_ON(!size);
> +
> +	size =3D round_up(size, page_size);
> +	align =3D round_up(align, page_size);
> +	for (;;) {
> +		spin_lock(&domain->block_lock);
> +		if (!iovmm_block_splitting)
> +			break;
> +		spin_unlock(&domain->block_lock);
> +		schedule();
> +	}
> +	n =3D domain->free_blocks.rb_node;
> +	best =3D NULL;
> +	while (n) {
> +		tegra_iovmm_addr_t aligned_start, block_ceil;
> +
> +		b =3D rb_entry(n, struct tegra_iovmm_block, free_node);
> +		simalign =3D SIMALIGN(b, align);
> +		aligned_start =3D b->start + simalign;
> +		block_ceil =3D b->start + b->length;
> +
> +		if (block_ceil >=3D aligned_start + size) {
> +			/* Block has enough size */
> +			best =3D b;
> +			if (NO_SPLIT(simalign) &&
> +				NO_SPLIT(block_ceil - (aligned_start + size)))
> +				break;
> +			n =3D n->rb_left;
> +		} else {
> +			n =3D n->rb_right;
> +		}
> +	}
> +	if (!best) {
> +		spin_unlock(&domain->block_lock);
> +		return NULL;
> +	}
> +
> +	simalign =3D SIMALIGN(best, align);
> +	if (DO_SPLIT(simalign)) {
> +		iovmm_block_splitting =3D 1;
> +		spin_unlock(&domain->block_lock);
> +
> +		/* Split off misalignment */
> +		b =3D best;
> +		best =3D iovmm_split_free_block(domain, b, simalign);
> +		if (best)
> +			simalign =3D 0;
> +		else
> +			best =3D b;
> +	}
> +
> +	/* Unfree designed block */
> +	rb_erase(&best->free_node, &domain->free_blocks);
> +	clear_bit(BK_free, &best->flags);
> +	atomic_inc(&best->ref);
> +
> +	iovmm_start(best) =3D best->start + simalign;
> +	iovmm_length(best) =3D size;
> +
> +	if (DO_SPLIT((best->start + best->length) - iovmm_end(best))) {
> +		iovmm_block_splitting =3D 1;
> +		spin_unlock(&domain->block_lock);
> +
> +		/* Split off excess */
> +		(void)iovmm_split_free_block(domain, best, size + simalign);
> +	}
> +
> +	iovmm_block_splitting =3D 0;
> +	spin_unlock(&domain->block_lock);
> +
> +	return best;
> +}
> +
> +static struct tegra_iovmm_block *iovmm_allocate_vm(
> +	struct tegra_iovmm_domain *domain, size_t size,
> +	size_t align, unsigned long iovm_start)
> +{
> +	struct rb_node *n;
> +	struct tegra_iovmm_block *b, *best;
> +	unsigned long page_size =3D 1 << domain->dev->pgsize_bits;
> +
> +	BUG_ON(iovm_start % align);
> +	BUG_ON(!size);
> +
> +	size =3D round_up(size, page_size);
> +	for (;;) {
> +		spin_lock(&domain->block_lock);
> +		if (!iovmm_block_splitting)
> +			break;
> +		spin_unlock(&domain->block_lock);
> +		schedule();
> +	}
> +
> +	n =3D rb_first(&domain->free_blocks);
> +	best =3D NULL;
> +	while (n) {
> +		b =3D rb_entry(n, struct tegra_iovmm_block, free_node);
> +		if ((b->start <=3D iovm_start) &&
> +		     (b->start + b->length) >=3D (iovm_start + size)) {
> +			best =3D b;
> +			break;
> +		}
> +		n =3D rb_next(n);
> +	}
> +
> +	if (!best)
> +		goto fail;
> +
> +	/* split the mem before iovm_start. */
> +	if (DO_SPLIT(iovm_start - best->start)) {
> +		iovmm_block_splitting =3D 1;
> +		spin_unlock(&domain->block_lock);
> +		best =3D iovmm_split_free_block(domain, best,
> +			(iovm_start - best->start));
> +	}
> +	if (!best)
> +		goto fail;
> +
> +	/* remove the desired block from free list. */
> +	rb_erase(&best->free_node, &domain->free_blocks);
> +	clear_bit(BK_free, &best->flags);
> +	atomic_inc(&best->ref);
> +
> +	iovmm_start(best) =3D iovm_start;
> +	iovmm_length(best) =3D size;
> +
> +	BUG_ON(best->start > iovmm_start(best));
> +	BUG_ON((best->start + best->length) < iovmm_end(best));
> +	/* split the mem after iovm_start+size. */
> +	if (DO_SPLIT(best->start + best->length - iovmm_end(best))) {
> +		iovmm_block_splitting =3D 1;
> +		spin_unlock(&domain->block_lock);
> +		(void)iovmm_split_free_block(domain, best,
> +			(iovmm_start(best) - best->start + size));
> +	}
> +fail:
> +	iovmm_block_splitting =3D 0;
> +	spin_unlock(&domain->block_lock);
> +	return best;
> +}
> +
> +int tegra_iovmm_domain_init(struct tegra_iovmm_domain *domain,
> +	struct tegra_iovmm_device *dev, tegra_iovmm_addr_t start,
> +	tegra_iovmm_addr_t end)
> +{
> +	struct tegra_iovmm_block *b;
> +	unsigned long page_size =3D 1 << dev->pgsize_bits;
> +
> +	b =3D kmem_cache_zalloc(iovmm_cache, GFP_KERNEL);
> +	if (!b)
> +		return -ENOMEM;
> +
> +	domain->dev =3D dev;
> +
> +	atomic_set(&domain->clients, 0);
> +	atomic_set(&domain->locks, 0);
> +	atomic_set(&b->ref, 1);
> +	spin_lock_init(&domain->block_lock);
> +	init_rwsem(&domain->map_lock);
> +	init_waitqueue_head(&domain->delay_lock);
> +
> +	b->start  =3D round_up(start, page_size);
> +	b->length =3D round_down(end, page_size) - b->start;
> +
> +	set_bit(BK_free, &b->flags);
> +	rb_link_node(&b->free_node, NULL, &domain->free_blocks.rb_node);
> +	rb_insert_color(&b->free_node, &domain->free_blocks);
> +	rb_link_node(&b->all_node, NULL, &domain->all_blocks.rb_node);
> +	rb_insert_color(&b->all_node, &domain->all_blocks);
> +
> +	return 0;
> +}
> +
> +/* If iovm_start !=3D 0, tries to allocate specified iova block if it is=
 free.
> + * if it is not free, it fails.
> + */
> +struct tegra_iovmm_area *tegra_iovmm_create_vm(
> +	struct tegra_iovmm_client *client, struct tegra_iovmm_area_ops *ops,
> +	size_t size, size_t align, pgprot_t pgprot, unsigned long iovm_start)
> +{
> +	struct tegra_iovmm_block *b;
> +	struct tegra_iovmm_domain *domain;
> +
> +	if (!client)
> +		return NULL;
> +
> +	domain =3D client->domain;
> +
> +	if (iovm_start)
> +		b =3D iovmm_allocate_vm(domain, size, align, iovm_start);
> +	else
> +		b =3D iovmm_alloc_block(domain, size, align);
> +	if (!b)
> +		return NULL;
> +
> +	b->vm_area.domain =3D domain;
> +	b->vm_area.pgprot =3D pgprot;
> +	b->vm_area.ops =3D ops;
> +
> +	down_read(&b->vm_area.domain->map_lock);
> +	if (ops && !test_bit(CL_locked, &client->flags)) {
> +		set_bit(BK_map_dirty, &b->flags);
> +		set_bit(DM_map_dirty, &client->domain->flags);
> +	} else if (ops) {
> +		if (domain->dev->ops->map(domain, &b->vm_area))
> +			pr_err("%s failed to map locked domain\n", __func__);
> +	}
> +	up_read(&b->vm_area.domain->map_lock);
> +
> +	return &b->vm_area;
> +}
> +
> +void tegra_iovmm_vm_insert_pfn(struct tegra_iovmm_area *vm,
> +	tegra_iovmm_addr_t vaddr, unsigned long pfn)
> +{
> +	struct tegra_iovmm_domain *domain =3D vm->domain;

Does this need a check for !vm?

> +	BUG_ON(vaddr & ((1<<domain->dev->pgsize_bits)-1));
> +	BUG_ON(vaddr >=3D vm->iovm_start + vm->iovm_length);
> +	BUG_ON(vaddr < vm->iovm_start);
> +	BUG_ON(vm->ops);
> +
> +	domain->dev->ops->map_pfn(domain, vm, vaddr, pfn);
> +}
> +
> +void tegra_iovmm_zap_vm(struct tegra_iovmm_area *vm)
> +{
> +	struct tegra_iovmm_block *b;
> +	struct tegra_iovmm_domain *domain;
> +
> +	b =3D container_of(vm, struct tegra_iovmm_block, vm_area);
> +	domain =3D vm->domain;

Same.

> +	/*
> +	 * if the vm area mapping was deferred, don't unmap it since
> +	 * the memory for the page tables it uses may not be allocated
> +	 */
> +	down_read(&domain->map_lock);
> +	if (!test_and_clear_bit(BK_map_dirty, &b->flags))
> +		domain->dev->ops->unmap(domain, vm, false);
> +	up_read(&domain->map_lock);
> +}
> +
> +void tegra_iovmm_unzap_vm(struct tegra_iovmm_area *vm)
> +{
> +	struct tegra_iovmm_block *b;
> +	struct tegra_iovmm_domain *domain;
> +
> +	b =3D container_of(vm, struct tegra_iovmm_block, vm_area);
> +	domain =3D vm->domain;

Same.

> +	if (!vm->ops)
> +		return;
> +
> +	down_read(&domain->map_lock);
> +	if (vm->ops) {
> +		if (atomic_read(&domain->locks))
> +			domain->dev->ops->map(domain, vm);
> +		else {
> +			set_bit(BK_map_dirty, &b->flags);
> +			set_bit(DM_map_dirty, &domain->flags);
> +		}
> +	}
> +	up_read(&domain->map_lock);
> +}
> +
> +void tegra_iovmm_free_vm(struct tegra_iovmm_area *vm)
> +{
> +	struct tegra_iovmm_block *b;
> +	struct tegra_iovmm_domain *domain;
> +
> +	if (!vm)
> +		return;
> +
> +	b =3D container_of(vm, struct tegra_iovmm_block, vm_area);
> +	domain =3D vm->domain;
> +	down_read(&domain->map_lock);
> +	if (!test_and_clear_bit(BK_map_dirty, &b->flags))
> +		domain->dev->ops->unmap(domain, vm, true);
> +	iovmm_free_block(domain, b);
> +	up_read(&domain->map_lock);
> +}

I believe it is more common to initialize b to container_of(...) in the same
line as the declaration. Since container_of() doesn't actually do any
dereferencing, it is safe to check for !vm later.

> +
> +struct tegra_iovmm_area *tegra_iovmm_area_get(struct tegra_iovmm_area *v=
m)
> +{
> +	struct tegra_iovmm_block *b;
> +
> +	BUG_ON(!vm);
> +	b =3D container_of(vm, struct tegra_iovmm_block, vm_area);
> +
> +	atomic_inc(&b->ref);
> +	return &b->vm_area;
> +}
> +
> +void tegra_iovmm_area_put(struct tegra_iovmm_area *vm)
> +{
> +	struct tegra_iovmm_block *b;
> +	BUG_ON(!vm);
> +	b =3D container_of(vm, struct tegra_iovmm_block, vm_area);
> +	iovmm_block_put(b);
> +}
> +
> +struct tegra_iovmm_area *tegra_iovmm_find_area_get(
> +	struct tegra_iovmm_client *client, tegra_iovmm_addr_t addr)
> +{
> +	struct rb_node *n;
> +	struct tegra_iovmm_block *b =3D NULL;
> +
> +	if (!client)
> +		return NULL;
> +
> +	spin_lock(&client->domain->block_lock);
> +	n =3D client->domain->all_blocks.rb_node;
> +
> +	while (n) {
> +		b =3D rb_entry(n, struct tegra_iovmm_block, all_node);
> +		if (iovmm_start(b) <=3D addr && addr <=3D iovmm_end(b)) {
> +			if (test_bit(BK_free, &b->flags))
> +				b =3D NULL;
> +			break;
> +		}
> +		if (addr > iovmm_start(b))
> +			n =3D n->rb_right;
> +		else
> +			n =3D n->rb_left;
> +		b =3D NULL;
> +	}
> +	if (b)
> +		atomic_inc(&b->ref);
> +	spin_unlock(&client->domain->block_lock);
> +	if (!b)
> +		return NULL;
> +	return &b->vm_area;
> +}
> +
> +static int _iovmm_client_lock(struct tegra_iovmm_client *client)
> +{
> +	struct tegra_iovmm_device *dev;
> +	struct tegra_iovmm_domain *domain;
> +	int v;
> +
> +	if (unlikely(!client))
> +		return -ENODEV;
> +
> +	if (unlikely(test_bit(CL_locked, &client->flags))) {
> +		pr_err("attempting to relock client %s\n", client->name);
> +		return 0;
> +	}
> +
> +	domain =3D client->domain;
> +	dev =3D domain->dev;
> +	down_write(&domain->map_lock);
> +	v =3D atomic_inc_return(&domain->locks);
> +	/* if the device doesn't export the lock_domain function, the device
> +	 * must guarantee that any valid domain will be locked. */
> +	if (v =3D=3D 1 && dev->ops->lock_domain) {
> +		if (dev->ops->lock_domain(domain, client)) {
> +			atomic_dec(&domain->locks);
> +			up_write(&domain->map_lock);
> +			return -EAGAIN;
> +		}
> +	}
> +	if (test_and_clear_bit(DM_map_dirty, &domain->flags)) {
> +		struct rb_node *n;
> +		struct tegra_iovmm_block *b;
> +
> +		spin_lock(&domain->block_lock);
> +		n =3D rb_first(&domain->all_blocks);
> +		while (n) {
> +			b =3D rb_entry(n, struct tegra_iovmm_block, all_node);
> +			n =3D rb_next(n);
> +			if (test_bit(BK_free, &b->flags))
> +				continue;
> +
> +			if (test_and_clear_bit(BK_map_dirty, &b->flags)) {
> +				if (!b->vm_area.ops) {
> +					pr_err("%s: "
> +					       "vm_area ops must exist for lazy maps\n",
> +					       __func__);
> +					continue;
> +				}
> +				dev->ops->map(domain, &b->vm_area);
> +			}
> +		}
> +	}
> +	set_bit(CL_locked, &client->flags);
> +	up_write(&domain->map_lock);
> +	return 0;
> +}
> +
> +int tegra_iovmm_client_trylock(struct tegra_iovmm_client *client)
> +{
> +	return _iovmm_client_lock(client);
> +}
> +
> +int tegra_iovmm_client_lock(struct tegra_iovmm_client *client)
> +{
> +	int ret;
> +
> +	if (!client)
> +		return -ENODEV;
> +
> +	ret =3D wait_event_interruptible(client->domain->delay_lock,
> +		_iovmm_client_lock(client) !=3D -EAGAIN);
> +
> +	if (ret =3D=3D -ERESTARTSYS)
> +		return -EINTR;
> +
> +	return ret;
> +}
> +
> +void tegra_iovmm_client_unlock(struct tegra_iovmm_client *client)
> +{
> +	struct tegra_iovmm_device *dev;
> +	struct tegra_iovmm_domain *domain;
> +	int do_wake =3D 0;
> +
> +	if (!client)
> +		return;
> +
> +	if (!test_and_clear_bit(CL_locked, &client->flags)) {
> +		pr_err("unlocking unlocked client %s\n", client->name);
> +		return;
> +	}
> +
> +	domain =3D client->domain;
> +	dev =3D domain->dev;
> +	down_write(&domain->map_lock);
> +	if (!atomic_dec_return(&domain->locks)) {
> +		if (dev->ops->unlock_domain)
> +			dev->ops->unlock_domain(domain, client);
> +		do_wake =3D 1;
> +	}
> +	up_write(&domain->map_lock);
> +	if (do_wake)
> +		wake_up(&domain->delay_lock);
> +}
> +
> +size_t tegra_iovmm_get_vm_size(struct tegra_iovmm_client *client)
> +{
> +	struct tegra_iovmm_domain *domain;
> +	struct rb_node *n;
> +	struct tegra_iovmm_block *b;
> +	size_t size =3D 0;
> +
> +	if (!client)
> +		return 0;
> +
> +	domain =3D client->domain;
> +
> +	spin_lock(&domain->block_lock);
> +	n =3D rb_first(&domain->all_blocks);
> +	while (n) {
> +		b =3D rb_entry(n, struct tegra_iovmm_block, all_node);
> +		n =3D rb_next(n);
> +		size +=3D b->length;
> +	}
> +	spin_unlock(&domain->block_lock);
> +
> +	return size;
> +}
> +
> +void tegra_iovmm_free_client(struct tegra_iovmm_client *client)
> +{
> +	struct tegra_iovmm_device *dev;
> +	struct tegra_iovmm_domain *domain;
> +
> +	if (!client)
> +		return;
> +
> +	BUG_ON(!client->domain || !client->domain->dev);
> +
> +	domain =3D client->domain;
> +	dev =3D domain->dev;
> +
> +	if (test_and_clear_bit(CL_locked, &client->flags)) {
> +		pr_err("freeing locked client %s\n", client->name);
> +		if (!atomic_dec_return(&domain->locks)) {
> +			down_write(&domain->map_lock);
> +			if (dev->ops->unlock_domain)
> +				dev->ops->unlock_domain(domain, client);
> +			up_write(&domain->map_lock);
> +			wake_up(&domain->delay_lock);
> +		}
> +	}
> +	mutex_lock(&iovmm_group_list_lock);
> +	if (!atomic_dec_return(&domain->clients))
> +		if (dev->ops->free_domain)
> +			dev->ops->free_domain(domain, client);
> +	list_del(&client->list);
> +	if (list_empty(&client->group->client_list)) {
> +		list_del(&client->group->group_list);
> +		kfree(client->group->name);
> +		kfree(client->group);
> +	}
> +	kfree(client->name);
> +	kfree(client);
> +	mutex_unlock(&iovmm_group_list_lock);
> +}
> +
> +struct tegra_iovmm_client *tegra_iovmm_alloc_client(const char *name,
> +	const char *share_group, struct miscdevice *misc_dev)
> +{
> +	struct tegra_iovmm_client *c =3D kzalloc(sizeof(*c), GFP_KERNEL);
> +	struct iovmm_share_group *grp =3D NULL;
> +	struct tegra_iovmm_device *dev;
> +
> +	if (!c)
> +		return NULL;
> +	c->name =3D kstrdup(name, GFP_KERNEL);
> +	if (!c->name)
> +		goto fail;
> +	c->misc_dev =3D misc_dev;
> +
> +	mutex_lock(&iovmm_group_list_lock);
> +	if (share_group) {
> +		list_for_each_entry(grp, &iovmm_groups, group_list) {
> +			if (grp->name && !strcmp(grp->name, share_group))
> +				break;
> +		}
> +	}
> +	if (!grp || strcmp(grp->name, share_group)) {
> +		grp =3D kzalloc(sizeof(*grp), GFP_KERNEL);
> +		if (!grp)
> +			goto fail_lock;
> +		grp->name =3D
> +			(share_group) ? kstrdup(share_group, GFP_KERNEL) : NULL;

Parens are not required around "share_group".

> +		if (share_group && !grp->name) {
> +			kfree(grp);
> +			goto fail_lock;
> +		}
> +		list_for_each_entry(dev, &iovmm_devices, list) {
> +			grp->domain =3D dev->ops->alloc_domain(dev, c);
> +			if (grp->domain)
> +				break;
> +		}
> +		if (!grp->domain) {
> +			pr_err("%s: alloc_domain failed for %s\n",
> +				__func__, c->name);
> +			dump_stack();
> +			kfree(grp->name);
> +			kfree(grp);
> +			grp =3D NULL;
> +			goto fail_lock;
> +		}
> +		spin_lock_init(&grp->lock);
> +		INIT_LIST_HEAD(&grp->client_list);
> +		list_add_tail(&grp->group_list, &iovmm_groups);
> +	}
> +
> +	atomic_inc(&grp->domain->clients);
> +	c->group =3D grp;
> +	c->domain =3D grp->domain;
> +	spin_lock(&grp->lock);
> +	list_add_tail(&c->list, &grp->client_list);
> +	spin_unlock(&grp->lock);
> +	mutex_unlock(&iovmm_group_list_lock);
> +	return c;
> +
> +fail_lock:
> +	mutex_unlock(&iovmm_group_list_lock);
> +fail:
> +	if (c)
> +		kfree(c->name);
> +	kfree(c);
> +	return NULL;
> +}
> +
> +int tegra_iovmm_register(struct tegra_iovmm_device *dev)
> +{
> +	BUG_ON(!dev);
> +	mutex_lock(&iovmm_group_list_lock);
> +	if (list_empty(&iovmm_devices)) {
> +		iovmm_cache =3D KMEM_CACHE(tegra_iovmm_block, 0);
> +		if (!iovmm_cache) {
> +			pr_err("%s: failed to make kmem cache\n", __func__);
> +			mutex_unlock(&iovmm_group_list_lock);
> +			return -ENOMEM;
> +		}
> +		create_proc_read_entry("iovmminfo", S_IRUGO, NULL,
> +			tegra_iovmm_read_proc, NULL);
> +	}
> +	list_add_tail(&dev->list, &iovmm_devices);
> +	mutex_unlock(&iovmm_group_list_lock);
> +	pr_info("%s: added %s\n", __func__, dev->name);
> +	return 0;
> +}
> +
> +int tegra_iovmm_unregister(struct tegra_iovmm_device *dev)
> +{
> +	mutex_lock(&iovmm_group_list_lock);
> +	list_del(&dev->list);
> +	mutex_unlock(&iovmm_group_list_lock);
> +	return 0;
> +}
> +
> +static int tegra_iovmm_suspend(void)
> +{
> +	int rc =3D 0;
> +	struct tegra_iovmm_device *dev;
> +
> +	list_for_each_entry(dev, &iovmm_devices, list) {
> +

Gratuitous newline.

> +		if (!dev->ops->suspend)
> +			continue;
> +
> +		rc =3D dev->ops->suspend(dev);
> +		if (rc) {
> +			pr_err("%s: %s suspend returned %d\n",
> +			       __func__, dev->name, rc);
> +			return rc;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static void tegra_iovmm_resume(void)
> +{
> +	struct tegra_iovmm_device *dev;
> +
> +	list_for_each_entry(dev, &iovmm_devices, list) {
> +		if (dev->ops->resume)
> +			dev->ops->resume(dev);
> +	}
> +}
> +
> +static struct syscore_ops tegra_iovmm_syscore_ops =3D {
> +	.suspend =3D tegra_iovmm_suspend,
> +	.resume =3D tegra_iovmm_resume,
> +};
> +
> +static __init int tegra_iovmm_syscore_init(void)
> +{
> +	register_syscore_ops(&tegra_iovmm_syscore_ops);
> +	return 0;
> +}
> +subsys_initcall(tegra_iovmm_syscore_init);
> --=20
> 1.7.0.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-tegra" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
>=20

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7Fb0IACgkQZ+BJyKLjJp+sUQCdGx9jwMgiJVp/AU+sU8IOeOvR
1i4An2nZa0fdWOrUzktz6jG8+3A8jW4y
=4oor
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
