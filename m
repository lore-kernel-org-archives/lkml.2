Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2K2KER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 05:04:17 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:55217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab2K2KEN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 05:04:13 -0500
Date: Thu, 29 Nov 2012 11:04:05 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: linux-tegra@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 3/8] video: tegra: host: Add channel and client support
Message-ID: <20121129100405.GB28781@avionic-0098.adnet.avionic-design.de>
References: <1353935954-13763-1-git-send-email-tbergstrom@nvidia.com>
 <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+pHx0qQiF2pBVqBT"
Content-Disposition: inline
In-Reply-To: <1353935954-13763-4-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:MqnZpOHszdmahHsxj7sWcZ3IR8cgGQ8a/ivv0mDcsgW
 9Q40HaiTp/R3/9DT73LWdQZTXpVtEK1GsneZJVIE54n0XTh+U7
 lcG9uunsQDiJDbQR2l+zJLCQgH6aXfzu05p+lXkqY3HPKys3po
 4Rk0iYBzJBntQiOrtosSvy+N8e6BAMzjR/Kjr6DJr/GIDvv8Jp
 dyLcqBiIQ2CmzNFWK7ILTkclT3cpDz9cts4mdpveKj5LbSTBOy
 UaYFusvTMxKIe4GCPzGt1hjk/md4i4KegZ9FLknl28v8Ua+qr/
 wNTMY0JTLVyP3nb5TWZkNQtPSIgmuoI/aJFSHzCEhillmjJbaX
 1DgC1lVl7chQI9R6TW+Fl2lbzGk9tkbrJHvLS7Ordzvz9Hc6M7
 UI4vO7kZMVK9ASaE/Tk1OcDkqgsHbWMHes=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+pHx0qQiF2pBVqBT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 26, 2012 at 03:19:09PM +0200, Terje Bergstrom wrote:

I've skipped a lot of code here that I need more time to review.

[...]
> diff --git a/drivers/video/tegra/host/nvhost_intr.c b/drivers/video/tegra=
/host/nvhost_intr.c
[...]
> +static void action_submit_complete(struct nvhost_waitlist *waiter)
> +{
> +	struct nvhost_channel *channel =3D waiter->data;
> +	int nr_completed =3D waiter->count;
> +
> +	nvhost_cdma_update(&channel->cdma);
> +	nvhost_module_idle_mult(channel->dev, nr_completed);
> +}
> =20
>  static void action_wakeup(struct nvhost_waitlist *waiter)
>  {
> @@ -125,6 +145,7 @@ static void action_wakeup_interruptible(struct nvhost=
_waitlist *waiter)
>  typedef void (*action_handler)(struct nvhost_waitlist *waiter);
> =20
>  static action_handler action_handlers[NVHOST_INTR_ACTION_COUNT] =3D {
> +	action_submit_complete,
>  	action_wakeup,
>  	action_wakeup_interruptible,
>  };
[...]
> diff --git a/drivers/video/tegra/host/nvhost_intr.h b/drivers/video/tegra=
/host/nvhost_intr.h
[...]
>  enum nvhost_intr_action {
>  	/**
> +	 * Perform cleanup after a submit has completed.
> +	 * 'data' points to a channel
> +	 */
> +	NVHOST_INTR_ACTION_SUBMIT_COMPLETE =3D 0,
> +
> +	/**
>  	 * Wake up a  task.
>  	 * 'data' points to a wait_queue_head_t
>  	 */

Looking some more at how this is used, I'm starting to think that it
might be easier to export the various handlers and allow them to be
passed to the nvhost_intr_add_action() explicitly.

> diff --git a/drivers/video/tegra/host/nvhost_job.c b/drivers/video/tegra/=
host/nvhost_job.c
[...]
> +/* Magic to use to fill freed handle slots */
> +#define BAD_MAGIC 0xdeadbeef

This isn't currently used.

> +static size_t job_size(u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
> +{
> +	u32 num_unpins =3D num_cmdbufs + num_relocs;
> +	s64 total;
> +
> +	if (num_relocs < 0 || num_waitchks < 0 || num_cmdbufs < 0)
> +		return 0;
> +
> +	total =3D sizeof(struct nvhost_job)
> +			+ num_relocs * sizeof(struct nvhost_reloc)
> +			+ num_unpins * sizeof(struct nvhost_job_unpin_data)
> +			+ num_waitchks * sizeof(struct nvhost_waitchk)
> +			+ num_cmdbufs * sizeof(struct nvhost_job_gather);
> +
> +	if (total > ULONG_MAX)
> +		return 0;
> +	return (size_t)total;
> +}
> +
> +
> +static void init_fields(struct nvhost_job *job,
> +		u32 num_cmdbufs, u32 num_relocs, u32 num_waitchks)
> +{
> +	u32 num_unpins =3D num_cmdbufs + num_relocs;
> +	void *mem =3D job;
> +
> +	/* First init state to zero */
> +
> +	/*
> +	 * Redistribute memory to the structs.
> +	 * Overflows and negative conditions have
> +	 * already been checked in job_alloc().
> +	 */
> +	mem +=3D sizeof(struct nvhost_job);
> +	job->relocarray =3D num_relocs ? mem : NULL;
> +	mem +=3D num_relocs * sizeof(struct nvhost_reloc);
> +	job->unpins =3D num_unpins ? mem : NULL;
> +	mem +=3D num_unpins * sizeof(struct nvhost_job_unpin_data);
> +	job->waitchk =3D num_waitchks ? mem : NULL;
> +	mem +=3D num_waitchks * sizeof(struct nvhost_waitchk);
> +	job->gathers =3D num_cmdbufs ? mem : NULL;
> +	mem +=3D num_cmdbufs * sizeof(struct nvhost_job_gather);
> +	job->addr_phys =3D (num_cmdbufs || num_relocs) ? mem : NULL;
> +
> +	job->reloc_addr_phys =3D job->addr_phys;
> +	job->gather_addr_phys =3D &job->addr_phys[num_relocs];
> +}

I wouldn't bother splitting out the above two functions.

> +
> +struct nvhost_job *nvhost_job_alloc(struct nvhost_channel *ch,
> +		int num_cmdbufs, int num_relocs, int num_waitchks)
> +{
> +	struct nvhost_job *job =3D NULL;
> +	size_t size =3D job_size(num_cmdbufs, num_relocs, num_waitchks);
> +
> +	if (!size)
> +		return NULL;
> +	job =3D vzalloc(size);

Why vzalloc()?

> +void nvhost_job_add_gather(struct nvhost_job *job,
> +		u32 mem_id, u32 words, u32 offset)
> +{
> +	struct nvhost_job_gather *cur_gather =3D
> +			&job->gathers[job->num_gathers];
> +
> +	cur_gather->words =3D words;
> +	cur_gather->mem_id =3D mem_id;
> +	cur_gather->offset =3D offset;
> +	job->num_gathers +=3D 1;

job->num_gathers++

> +static int pin_job_mem(struct nvhost_job *job)
> +{
> +	int i;
> +	int count =3D 0;
> +	int result;
> +	long unsigned *ids =3D
> +			kmalloc(sizeof(u32 *) *
> +				(job->num_relocs + job->num_gathers),
> +				GFP_KERNEL);

Maybe this should be allocated along with the nvhost_job and the other
fields to avoid having to allocate, and potentially fail, here?

> +static int do_relocs(struct nvhost_job *job,
> +		u32 cmdbuf_mem, struct mem_handle *h)
> +{
> +	int i =3D 0;
> +	int last_page =3D -1;
> +	void *cmdbuf_page_addr =3D NULL;
> +
> +	/* pin & patch the relocs for one gather */
> +	while (i < job->num_relocs) {
> +		struct nvhost_reloc *reloc =3D &job->relocarray[i];
> +
> +		/* skip all other gathers */
> +		if (cmdbuf_mem !=3D reloc->cmdbuf_mem) {
> +			i++;
> +			continue;
> +		}
> +
> +		if (last_page !=3D reloc->cmdbuf_offset >> PAGE_SHIFT) {
> +			if (cmdbuf_page_addr)
> +				nvhost_memmgr_kunmap(h, last_page, cmdbuf_page_addr);
> +
> +			cmdbuf_page_addr =3D nvhost_memmgr_kmap(h,
> +					reloc->cmdbuf_offset >> PAGE_SHIFT);
> +			last_page =3D reloc->cmdbuf_offset >> PAGE_SHIFT;
> +
> +			if (unlikely(!cmdbuf_page_addr)) {
> +				pr_err("Couldn't map cmdbuf for relocation\n");
> +				return -ENOMEM;
> +			}
> +		}
> +
> +		__raw_writel(
> +			(job->reloc_addr_phys[i] +
> +				reloc->target_offset) >> reloc->shift,
> +			(cmdbuf_page_addr +
> +				(reloc->cmdbuf_offset & ~PAGE_MASK)));

You're not writing to I/O memory, so you shouldn't be using
__raw_writel() here.

> +int nvhost_job_pin(struct nvhost_job *job, struct platform_device *pdev)
> +{
> +	int err =3D 0, i =3D 0, j =3D 0;
> +	struct nvhost_syncpt *sp =3D &nvhost_get_host(pdev)->syncpt;
> +	unsigned long waitchk_mask[nvhost_syncpt_nb_pts(sp) / BITS_PER_LONG];

You should use a bitmap instead. See DECLARE_BITMAP in linux/types.h...

> +
> +	memset(&waitchk_mask[0], 0, sizeof(waitchk_mask));

and run bitmap_zero() here...

> +	for (i =3D 0; i < job->num_waitchk; i++) {
> +		u32 syncpt_id =3D job->waitchk[i].syncpt_id;
> +		if (syncpt_id < nvhost_syncpt_nb_pts(sp))
> +			waitchk_mask[BIT_WORD(syncpt_id)] |=3D
> +				BIT_MASK(syncpt_id);

and use _set_bit here.

> +	}
> +
> +	/* get current syncpt values for waitchk */
> +	for_each_set_bit(i, &waitchk_mask[0], sizeof(waitchk_mask))
> +		nvhost_syncpt_update_min(sp, i);

Or since you only use the mask here, why not move the
nvhost_syncpt_update_min() into the above loop?

> +	/* patch gathers */
> +	for (i =3D 0; i < job->num_gathers; i++) {
> +		struct nvhost_job_gather *g =3D &job->gathers[i];
> +
> +		/* process each gather mem only once */
> +		if (!g->ref) {
> +			g->ref =3D nvhost_memmgr_get(g->mem_id, job->ch->dev);
> +			if (IS_ERR(g->ref)) {
> +				err =3D PTR_ERR(g->ref);
> +				g->ref =3D NULL;
> +				break;
> +			}
> +
> +			g->mem_base =3D job->gather_addr_phys[i];
> +
> +			for (j =3D 0; j < job->num_gathers; j++) {
> +				struct nvhost_job_gather *tmp =3D
> +					&job->gathers[j];
> +				if (!tmp->ref && tmp->mem_id =3D=3D g->mem_id) {
> +					tmp->ref =3D g->ref;
> +					tmp->mem_base =3D g->mem_base;
> +				}
> +			}
> +			err =3D do_relocs(job, g->mem_id,  g->ref);
> +			if (!err)
> +				err =3D do_waitchks(job, sp,
> +						g->mem_id, g->ref);
> +			nvhost_memmgr_put(g->ref);
> +			if (err)
> +				break;
> +		}
> +	}
> +fail:
> +	wmb();

What do you need this write barrier for?

> diff --git a/drivers/video/tegra/host/nvhost_memmgr.c b/drivers/video/teg=
ra/host/nvhost_memmgr.c
> new file mode 100644
> index 0000000..bdceb74
> --- /dev/null
> +++ b/drivers/video/tegra/host/nvhost_memmgr.c
> @@ -0,0 +1,160 @@
> +/*
> + * drivers/video/tegra/host/nvhost_memmgr.c
> + *
> + * Tegra host1x Memory Management Abstraction
> + *
> + * Copyright (c) 2012, NVIDIA Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify =
it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License=
 for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/kernel.h>
> +#include <linux/err.h>
> +
> +#include "nvhost_memmgr.h"
> +#include "dmabuf.h"
> +#include "chip_support.h"
> +
> +struct mem_handle *nvhost_memmgr_alloc(size_t size, size_t align, int fl=
ags)
> +{
> +	struct mem_handle *h =3D NULL;
> +	h =3D nvhost_dmabuf_alloc(size, align, flags);
> +
> +	return h;
> +}
> +
> +struct mem_handle *nvhost_memmgr_get(u32 id, struct platform_device *dev)
> +{
> +	struct mem_handle *h =3D NULL;
> +
> +	switch (nvhost_memmgr_type(id)) {
> +	case mem_mgr_type_dmabuf:
> +		h =3D (struct mem_handle *) nvhost_dmabuf_get(id, dev);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return h;
> +}

Heh, this would actually be a case where I'd argue in favour of an ops
structure. But Lucas already mentioned that we may want to revise how
the memory manager works and ideally we'd only have a single type of
buffers anyway so this would largely become obsolete anyway.

> diff --git a/include/linux/nvhost.h b/include/linux/nvhost.h
[...]
> +#define NVSYNCPT_2D_0		(18)
> +#define NVSYNCPT_2D_1		(19)
> +#define NVSYNCPT_VBLANK0	(26)
> +#define NVSYNCPT_VBLANK1	(27)
>=20
> +/* sync points that are wholly managed by the client */
> +#define NVSYNCPTS_CLIENT_MANAGED (\
> +	BIT(NVSYNCPT_VBLANK0) | \
> +	BIT(NVSYNCPT_VBLANK1) | \
> +	BIT(NVSYNCPT_2D_1))
> +
> +#define NVWAITBASE_2D_0 (1)
> +#define NVWAITBASE_2D_1 (2)

I think we already agreed that we want to do dynamic allocation of
syncpoints so these definitions can go away.

>  enum nvhost_power_sysfs_attributes {
>  	NVHOST_POWER_SYSFS_ATTRIB_CLOCKGATE_DELAY =3D 0,
>  	NVHOST_POWER_SYSFS_ATTRIB_POWERGATE_DELAY,
> @@ -142,4 +157,138 @@ void host1x_syncpt_incr(u32 id);
>  u32 host1x_syncpt_read(u32 id);
>  int host1x_syncpt_wait(u32 id, u32 thresh, u32 timeout, u32 *value);
> =20
> +/* Register device */
> +int nvhost_client_device_init(struct platform_device *dev);

Again, I think this should be made easier on the clients. Ideally
there'd be a single call to register a client with host1x which would
already initialize the appropriate fields. There can be other, separate
functions for resource allocations such as syncpoints and channels,
though.

> +int nvhost_client_device_suspend(struct platform_device *dev);

Again, I think this should be handled via runtime PM.

> +struct nvhost_channel *nvhost_getchannel(struct nvhost_channel *ch);
> +void nvhost_putchannel(struct nvhost_channel *ch);

These are oddly named. Better names would be nvhost_channel_get() or
nvhost_channel_put().

> +int nvhost_channel_submit(struct nvhost_job *job);
> +
> +enum host1x_class {
> +	NV_HOST1X_CLASS_ID		=3D 0x1,
> +	NV_GRAPHICS_2D_CLASS_ID		=3D 0x51,
> +};

Maybe this enumeration should be made more consistent, somewhat along
the lines of:

	enum host1x_class {
		HOST1X_CLASS_HOST1X =3D 0x01,
		HOST1X_CLASS_2D =3D 0x51,
	};

Again, I'll need more time to go over the rest of the code but the good
news is that I'm starting to form a better picture of how things work.

Thierry

--+pHx0qQiF2pBVqBT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQtzMVAAoJEN0jrNd/PrOhA9wP/iYLJp+LVdpz4g56ahu5adfz
ckdaxdoJ9UGIxBL4zUkxiF652pXbuuSncCJjOnfzrTJwu7eIePGJWAE0CHbYmUga
ZsSbJSEfvIK0ZMut57K3KDoXNVRl5ad861To1YrJrGaW6NG2kJ3N/0lH6eCdmsY4
CjvqLKgeneTSjg1p9GW/rAVBm+o1rt/GTnjlvbaVrMtAMstIfVsbRvGZkqjVMWn6
yNUKFLhfAF0aeLYAnrZAl9siKxu1VU19gUjdJohaufyxXdW8MXAmc2nb9gKJNMAB
oCFX8dHpyfIfSoF0Hd94BhLMDyifnlyj/fBImX/1boR552g2SS6ovgxz6+iSGQmF
JROzp+2S6rksqjQdioHyO2DsGGLvcaZKDi0LukE8t1wnczqdrWoxkZVGtthqe2HH
tdq50ndbBCM1sr5n55Q/TDb2pe0U3Tyg22euRvuaFIs8PpyBvS2Kh6AB39LraOg9
R9cQ5zY7cie0XNGZjPbaR5abvR+Vs03IgybSccUblsuU0YYqUYNCLHwz5VQe8jHN
ENwcpXuazXVfN0bTZYG9cwzCGbWw4B+XZS7xAHEY3+JTxYsHeNNGiYqX5iYIbtli
VVtYI0nVDV9j/c2xOnz1jxLqhvdPBLowSL4z5lJo4NufioGJlPgCFxqCFgqLzYNw
vo9yVOlhKmy2iEqlkzcS
=IWBL
-----END PGP SIGNATURE-----

--+pHx0qQiF2pBVqBT--
