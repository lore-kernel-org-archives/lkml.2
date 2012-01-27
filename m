Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038Ab2A0GUT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:20:19 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58349 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab2A0GUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:20:17 -0500
Message-ID: <4F22421A.5020501@gmail.com>
Date: Fri, 27 Jan 2012 17:20:10 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, Jiri Kosina <trivial@kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next V2] drivers: Use NULL not zero pointer assignments
References: <20120126061330.GA15856@elgon.mountain>	 <1327559803.28707.6.camel@joe2Laptop> <1327642391.4846.36.camel@joe2Laptop>
In-Reply-To: <1327642391.4846.36.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/12 16:33, Joe Perches wrote:

> Using NULL pointer assignments is more kernel-style standard.
> 
> Uncompiled, untested.
> 
> Done via cocinelle script:
> 
> @@
> type T;
> T *pointer;
> @@
> -pointer = 0
> +pointer = NULL
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---

Hi Joe,

I think you can drop a lot of the initialisations completely rather than
convert them. I've pointed some out below. I'm just scanning through for
likely candidates and I didn't bother looking at the staging drivers, so
this list is not comprehensive.

~Ryan

<snip>

> diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
> index f8f41e0..8df54cf 100644
> --- a/drivers/atm/ambassador.c
> +++ b/drivers/atm/ambassador.c
> @@ -1922,7 +1922,7 @@ static int __devinit ucode_init (loader_block * lb, amb_dev * dev) {
>    const struct firmware *fw;
>    unsigned long start_address;
>    const struct ihex_binrec *rec;
> -  const char *errmsg = 0;
> +  const char *errmsg = NULL;


This one looks like the assignment can just be dropped. errmsg is only
used on the fail: exit path and errmsg gets assigned on all paths which
goto there. Assuming gcc is smart enough to get this right, the
initialisation here is not required.

Unrelated: What happened to the indentation in that file. How did it
ever get passed review?


> diff --git a/drivers/gpu/drm/gma500/framebuffer.c b/drivers/gpu/drm/gma500/framebuffer.c
> index 791c0ef..1db1845 100644
> --- a/drivers/gpu/drm/gma500/framebuffer.c
> +++ b/drivers/gpu/drm/gma500/framebuffer.c
> @@ -113,7 +113,7 @@ static int psbfb_pan(struct fb_var_screeninfo *var, struct fb_info *info)
>  
>  void psbfb_suspend(struct drm_device *dev)
>  {
> -	struct drm_framebuffer *fb = 0;
> +	struct drm_framebuffer *fb = NULL;

>  	struct psb_framebuffer *psbfb = to_psb_fb(fb);

This code looks broken? to_psb_fb is defined as:

  container_of(x, struct psb_framebuffer, base)

So passing a NULL fb is not useful. I think it can be fixed by not
initialising either fb or psbfb, and then doing:

  list_for_each_entry(fb, &dev->mode_config.fb_list, head) {
  	psbfb = to_psb_fb(fb);
  	...

>  
>  	console_lock();
> @@ -129,7 +129,7 @@ void psbfb_suspend(struct drm_device *dev)
>  
>  void psbfb_resume(struct drm_device *dev)
>  {
> -	struct drm_framebuffer *fb = 0;
> +	struct drm_framebuffer *fb = NULL;
>  	struct psb_framebuffer *psbfb = to_psb_fb(fb);


Code looks broken in the same way as the psbfb_suspend function.

> diff --git a/drivers/gpu/drm/nouveau/nv50_instmem.c b/drivers/gpu/drm/nouveau/nv50_instmem.c
> index a7c12c9..b2f89ef 100644
> --- a/drivers/gpu/drm/nouveau/nv50_instmem.c
> +++ b/drivers/gpu/drm/nouveau/nv50_instmem.c
> @@ -253,7 +253,7 @@ nv50_instmem_takedown(struct drm_device *dev)
>  	nouveau_gpuobj_ref(NULL, &priv->bar1_dmaobj);
>  
>  	nouveau_vm_ref(NULL, &dev_priv->bar1_vm, chan->vm_pd);
> -	dev_priv->channels.ptr[127] = 0;
> +	dev_priv->channels.ptr[127] = NULL;
>  	nv50_channel_del(&dev_priv->channels.ptr[0]);
>  
>  	nouveau_gpuobj_ref(NULL, &dev_priv->bar3_vm->pgt[0].obj[0]);
> diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> index 0af6ebd..15531c5 100644
> --- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> @@ -378,7 +378,7 @@ int vmw_framebuffer_create_handle(struct drm_framebuffer *fb,
>  				  unsigned int *handle)
>  {
>  	if (handle)
> -		handle = 0;
> +		handle = NULL;


This doesn't do anything useful. I think maybe it is meant to be:

  if (handle)
  	*handle = 0;

Otherwise the whole function should just get removed.

>  
>  	return 0;
>  }



> diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
> index bdea288..c727cf6 100644
> --- a/drivers/iommu/amd_iommu_init.c
> +++ b/drivers/iommu/amd_iommu_init.c
> @@ -1210,7 +1210,7 @@ static int __init init_exclusion_range(struct ivmd_header *m)
>  /* called for unity map ACPI definition */
>  static int __init init_unity_map_range(struct ivmd_header *m)
>  {
> -	struct unity_map_entry *e = 0;
> +	struct unity_map_entry *e = NULL;


This initialisation can be removed. e is immediately kzalloc'ed just below.

>  	char *s;
>  
>  	e = kzalloc(sizeof(*e), GFP_KERNEL);

> diff --git a/drivers/media/video/hdpvr/hdpvr-core.c b/drivers/media/video/hdpvr/hdpvr-core.c
> index e5eb56a..90db4f3 100644
> --- a/drivers/media/video/hdpvr/hdpvr-core.c
> +++ b/drivers/media/video/hdpvr/hdpvr-core.c
> @@ -295,7 +295,7 @@ static int hdpvr_probe(struct usb_interface *interface,
>  		goto error;
>  	}
>  
> -	dev->workqueue = 0;
> +	dev->workqueue = NULL;


This line can be removed. dev was kzalloc'ed just above so
dev->workqueue is already NULL.

> diff --git a/drivers/net/fddi/skfp/hwmtm.c b/drivers/net/fddi/skfp/hwmtm.c
> index e26398b..41fd280 100644
> --- a/drivers/net/fddi/skfp/hwmtm.c
> +++ b/drivers/net/fddi/skfp/hwmtm.c
> @@ -46,8 +46,8 @@ static char const ID_sccs[] = "@(#)hwmtm.c	1.40 99/05/31 (C) SK" ;
>  	-------------------------------------------------------------
>  */
>  #ifdef COMMON_MB_POOL
> -static	SMbuf *mb_start = 0 ;
> -static	SMbuf *mb_free = 0 ;
> +static	SMbuf *mb_start = NULL;
> +static	SMbuf *mb_free = NULL;


Drop the assignments here. These are globals, so already initialised to
NULL.

> diff --git a/drivers/scsi/be2iscsi/be_cmds.c b/drivers/scsi/be2iscsi/be_cmds.c
> index cdb1536..ef67f9c 100644
> --- a/drivers/scsi/be2iscsi/be_cmds.c
> +++ b/drivers/scsi/be2iscsi/be_cmds.c
> @@ -22,9 +22,9 @@
>  int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
>  {
>  	u32 sreset;
> -	u8 *pci_reset_offset = 0;
> -	u8 *pci_online0_offset = 0;
> -	u8 *pci_online1_offset = 0;
> +	u8 *pci_reset_offset = NULL;
> +	u8 *pci_online0_offset = NULL;
> +	u8 *pci_online1_offset = NULL;


Drop all of these. They all get re-assigned immediately below.

>  	u32 pconline0 = 0;
>  	u32 pconline1 = 0;
>  	u32 i;
> @@ -74,7 +74,7 @@ int beiscsi_pci_soft_reset(struct beiscsi_hba *phba)
>  int be_chk_reset_complete(struct beiscsi_hba *phba)
>  {
>  	unsigned int num_loop;
> -	u8 *mpu_sem = 0;
> +	u8 *mpu_sem = NULL;


Same here. It gets assigned again unconditionally about 3 lines down.

>  	u32 status;
>  
>  	num_loop = 1000;
> diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
> index 375756f..a53e797 100644
> --- a/drivers/scsi/be2iscsi/be_main.c
> +++ b/drivers/scsi/be2iscsi/be_main.c
> @@ -4132,7 +4132,7 @@ static void beiscsi_quiesce(struct beiscsi_hba *phba)
>  	struct hwi_context_memory *phwi_context;
>  	struct be_eq_obj *pbe_eq;
>  	unsigned int i, msix_vec;
> -	u8 *real_offset = 0;
> +	u8 *real_offset = NULL;


This initialisation isn't needed. It gets assigned unconditionally in
the code below before anything attempts to use it.

>  	u32 value = 0;
>  
>  	phwi_ctrlr = phba->phwi_ctrlr;
> @@ -4229,7 +4229,7 @@ static int __devinit beiscsi_dev_probe(struct pci_dev *pcidev,
>  	struct hwi_context_memory *phwi_context;
>  	struct be_eq_obj *pbe_eq;
>  	int ret, num_cpus, i;
> -	u8 *real_offset = 0;
> +	u8 *real_offset = NULL;


Same here. Just remove the initialisation.

>  	u32 value = 0;
>  
>  	ret = beiscsi_enable_pci(pcidev);
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index 23a2759..7daba92 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -15898,7 +15898,7 @@ lpfc_drain_txq(struct lpfc_hba *phba)
>  {
>  	LIST_HEAD(completions);
>  	struct lpfc_sli_ring *pring = &phba->sli.ring[LPFC_ELS_RING];
> -	struct lpfc_iocbq *piocbq = 0;
> +	struct lpfc_iocbq *piocbq = NULL;


Initialisation doesn't appear to be necessary.

>  	unsigned long iflags = 0;
>  	char *fail_msg = NULL;
>  	struct lpfc_sglq *sglq;


~Ryan

