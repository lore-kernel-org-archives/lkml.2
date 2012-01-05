Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757943Ab2AESZc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 13:25:32 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:33502 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755489Ab2AESZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 13:25:29 -0500
Date: Thu, 5 Jan 2012 13:29:30 -0500
From: Jerome Glisse <j.glisse@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, thellstrom@vmware.co, airlied@linux.ie
Subject: Re: [PATCH 3/3] Revert "drm/ttm: callback move_notify any time bo
 placement change v4"
Message-ID: <20120105182930.GB2799@homer.localdomain>
References: <1325712916-27962-1-git-send-email-konrad.wilk@oracle.com>
 <1325712916-27962-4-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325712916-27962-4-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 04:35:16PM -0500, Konrad Rzeszutek Wilk wrote:
> This reverts commit 5c2680ddbe14b24771d24841dd66881f90d3d740 otherwise
> when we unbind the device we get this:
> sh-4.1# echo "0000:00:0d.0" > unbind
>  BUG: unable to handle kernel NULL pointer dereference at           (null)
>  IP: [<ffffffffa011ab1
>  CPU 1
>  Modules linked in: iscsi_boot_sysfs iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi libcrc32c crc32c radeon sg sd_mod nouveau fbcon tileblit ttm font sata_nv bitblit softcursor drm_kms_helper mxm_wmi ata_generic wmi libata video e1000 scsi_mod skge
> 
>  Pid: 3070, comm: sh Not tainted 3.2.0-rc7-00108-gf8eb6d6 #1 BIOSTAR Group N61PB-M2S/N61PB-M2S
>  RIP: 0010:[<ffffffffa011ab1d>]  [<ffffffffa011ab1d>] nouveau_bo_move_ntfy+0x1d/0xc0 [nouveau]
>  RSP: 0018:ffff88012deb7be8  EFLAGS: 00010296
>  RAX: ffffffffa011ab00 RBX: ffff8801292ec210 RCX: ffff880132480498
>  RDX: ffff880132480498 RSI: 0000000000000000 RDI: ffff8801292ec000
>  RBP: ffff88012deb7c18 R08: 0000000000000000 R09: ffff88012e654df8
>  R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000001
>  R13: ffff880132480728 R14: ffff880132480320 R15: ffff88012e654df8
>  FS:  00007f191ca6a700(0000) GS:ffff88013fc80000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 0000000000000000 CR3: 000000012de89000 CR4: 00000000000006e0
>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>  Process sh (pid: 3070, threadinfo ffff88012deb6000, task ffff8801295f9e30)
>  Stack:
>   ffff88012deb7c08 ffff8801292ec000 0000000000000001 ffff880132480728
>   ffff880132480320 ffff88012e654df8 ffff88012deb7c38 ffffffffa00eabe6
>   ffff88012deb7c38 ffff8801292ec000 ffff88012deb7ca8 ffffffffa00edcd1
>  Call Trace:
>   [<ffffffffa00eabe6>] ttm_bo_cleanup_memtype_use+0x26/0x80 [ttm]
>   [<ffffffffa00edcd1>] ttm_bo_release+0x251/0x270 [ttm]
>   [<ffffffff8108ede1>] ? get_parent_ip+0x11/0x50
>   [<ffffffffa00eda80>] ? ttm_bo_create+0x110/0x110 [ttm]
>   [<ffffffff812f0997>] kref_put+0x37/0x70
>   [<ffffffffa00eb572>] ttm_bo_unref+0x42/0x60 [ttm]
>   [<ffffffff813d5cb0>] ? drm_gem_object_handle_free+0x90/0x90
>   [<ffffffffa011e9bf>] nouveau_gem_object_del+0x3f/0x70 [nouveau]
>   [<ffffffff813d5cda>] drm_gem_object_free+0x2a/0x40
>   [<ffffffff812f0997>] kref_put+0x37/0x70
>   [<ffffffffa013bd16>] nouveau_fbcon_fini+0xb6/0x130 [nouveau]
>   [<ffffffffa0111f3d>] nouveau_unload+0x1bd/0x230 [nouveau]
>   [<ffffffff813d4132>] ? drm_lastclose+0x2c2/0x310
>   [<ffffffff813da403>] drm_put_dev+0x73/0x240
>   [<ffffffffa011101d>] nouveau_pci_remove+0x1d/0x20 [nouveau]
>   [<ffffffff813199a7>] pci_device_remove+0x37/0x70
>   [<ffffffff813f3a76>] __device_release_driver+0x66/0xc0
>   [<ffffffff813f3bcd>] device_release_driver+0x2d/0x40
>   [<ffffffff813f3011>] driver_unbind+0xa1/0xc0
>   [<ffffffff813f244c>] drv_attr_store+0x2c/0x30
>   [<ffffffff81213189>] sysfs_write_file+0xf9/0x180
>   [<ffffffff8119f778>] vfs_write+0xc8/0x190
>   [<ffffffff8119f941>] sys_write+0x51/0x90
>   [<ffffffff81644c82>] system_call_fastpath+0x16/0x1b
>  Code: 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 48 8b 9f 10 02 00 00 <4c> 8b 3e 4c 8d af 10 02 00 00 49 89 fe 49 89 f4 4c 39 eb 75 16
>  RIP  [<ffffffffa011ab1d>] nouveau_bo_move_ntfy+0x1d/0xc0 [nouveau]
>   RSP <ffff88012deb7be8>
>  CR2: 0000000000000000
>  ---[ end trace b57ad98adec9841d ]---
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

NAK proper fix on its way.

Cheers,
Jerome

> ---
>  drivers/gpu/drm/nouveau/nouveau_bo.c |    4 ++--
>  drivers/gpu/drm/ttm/ttm_bo.c         |    9 +++------
>  2 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
> index aa91f7b..47d0b05 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_bo.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
> @@ -815,10 +815,10 @@ nouveau_bo_move_ntfy(struct ttm_buffer_object *bo, struct ttm_mem_reg *new_mem)
>  	struct nouveau_vma *vma;
>  
>  	list_for_each_entry(vma, &nvbo->vma_list, head) {
> -		if (new_mem && new_mem->mem_type == TTM_PL_VRAM) {
> +		if (new_mem->mem_type == TTM_PL_VRAM) {
>  			nouveau_vm_map(vma, new_mem->mm_node);
>  		} else
> -		if (new_mem && new_mem->mem_type == TTM_PL_TT &&
> +		if (new_mem->mem_type == TTM_PL_TT &&
>  		    nvbo->page_shift == vma->vm->spg_shift) {
>  			nouveau_vm_map_sg(vma, 0, new_mem->
>  					  num_pages << PAGE_SHIFT,
> diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
> index 2f0eab6..483cded 100644
> --- a/drivers/gpu/drm/ttm/ttm_bo.c
> +++ b/drivers/gpu/drm/ttm/ttm_bo.c
> @@ -404,6 +404,9 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
>  		}
>  	}
>  
> +	if (bdev->driver->move_notify)
> +		bdev->driver->move_notify(bo, mem);
> +
>  	if (!(old_man->flags & TTM_MEMTYPE_FLAG_FIXED) &&
>  	    !(new_man->flags & TTM_MEMTYPE_FLAG_FIXED))
>  		ret = ttm_bo_move_ttm(bo, evict, no_wait_reserve, no_wait_gpu, mem);
> @@ -416,9 +419,6 @@ static int ttm_bo_handle_move_mem(struct ttm_buffer_object *bo,
>  	if (ret)
>  		goto out_err;
>  
> -	if (bdev->driver->move_notify)
> -		bdev->driver->move_notify(bo, mem);
> -
>  moved:
>  	if (bo->evicted) {
>  		ret = bdev->driver->invalidate_caches(bdev, bo->mem.placement);
> @@ -457,9 +457,6 @@ out_err:
>  
>  static void ttm_bo_cleanup_memtype_use(struct ttm_buffer_object *bo)
>  {
> -	if (bo->bdev->driver->move_notify)
> -		bo->bdev->driver->move_notify(bo, NULL);
> -
>  	if (bo->ttm) {
>  		ttm_tt_unbind(bo->ttm);
>  		ttm_tt_destroy(bo->ttm);
> -- 
> 1.7.7.4
> 
