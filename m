Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2JVAJC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 20:09:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab2JVAJA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 20:09:00 -0400
Message-ID: <1350864479.3404.2.camel@turiel>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Heinz Diehl <htd@fritha.org>, Martin Peres <martin.peres@labri.fr>,
        Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        =?UTF-8?Q?Pawe=C5=82?= Sikora <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Date: Mon, 22 Oct 2012 10:07:59 +1000
In-Reply-To: <20121020221948.GE5826@joi.lan>
References: <1724445.dN2yMEzN6d@localhost>
	 <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
	 <20121020092647.GA3186@fancy-poultry.org> <50827174.7070109@labri.fr>
	 <20121020104238.GA1539@fritha.org> <20121020202846.GA5826@joi.lan>
	 <20121020212036.GA1698@fritha.org> <20121020221948.GE5826@joi.lan>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-10-21 at 00:19 +0200, Marcin Slusarz wrote:
> On Sat, Oct 20, 2012 at 11:20:36PM +0200, Heinz Diehl wrote:
> > On 20.10.2012, Marcin Slusarz wrote: 
> > 
> > > Try this one.
> > 
> > It works, now I can boot again. However, nouveau seems to be dead now.
> > The dmesg output with your patch on top of 3.7-rc1 is:
> > 
> > [    3.685909] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> > [    3.687784] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a8800b1
> > [    3.689960] nouveau  [  DEVICE][0000:01:00.0] Chipset: GT218 (NVA8)
> > [    3.692471] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
> > [    3.695716] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
> > [    3.697087] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > [    3.698471] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
> > [    3.699838] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > [    3.701223] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
> > [    3.702684] ACPI Error: Field [ROMI] Base+Offset+Width 0+24+1 is beyond end of region [VROM] (length 24) (20120913/exfldio-210)
> > [    3.704139] ACPI Error: Method parse/execution failed[\_SB_.PCI0.PEG1.GFX0._ROM] (Node ffff880142e85cf8), AE_AML_REGION_LIMIT (20120913/psparse-536)
> > [    3.716183] failed to evaluate ROM got AE_AML_REGION_LIMIT
> > [    3.718776] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > [    3.721349] nouveau  [   VBIOS][0000:01:00.0] checking PCIROM for image...
> > [    3.724111] nouveau 0000:01:00.0: Invalid ROM contents
> > [    3.726663] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > [    3.729159] nouveau E[   VBIOS][0000:01:00.0] unable to locate usable image
> > [    3.731677] nouveau E[  DEVICE][0000:01:00.0] failed to create 0x10000001, -22
> > [    3.734231] nouveau E[     DRM] failed to create 0x80000080, -22
> > [    3.736097] nouveau: probe of 0000:01:00.0 failed with error -22
> > [    3.740523] dracut: Starting plymouth daemon
> 
> Hmm, maybe we can't fetch 3 bytes only...
Yeah, I noticed this issue myself on a machine here while backporting
the patch to another (older) kernel.  I assumed (wrongly, apparently)
that there was just a bug in the older kernel's ACPI implementation that
had been fixed upstream already (I didn't see it on the same machine
with the current kernel)...  So, I didn't send the patch.

I'll queue it up with a -fixes batch later today.

Sorry about the trouble,
Ben.

> 
> Let's check this:
> 
> ---
> diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> index 824eea0..8bd71aa 100644
> --- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> +++ b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> @@ -192,14 +192,16 @@ nouveau_bios_shadow_acpi(struct nouveau_bios *bios)
>  {
>  	struct pci_dev *pdev = nv_device(bios)->pdev;
>  	int ret, cnt, i;
> -	u8  data[3];
> +	u8  *data;
>  
>  	if (!nouveau_acpi_rom_supported(pdev))
>  		return;
>  
>  	bios->size = 0;
> -	if (nouveau_acpi_get_bios_chunk(data, 0, 3) == 3)
> +	data = kmalloc(4096, GFP_KERNEL);
> +	if (data && nouveau_acpi_get_bios_chunk(data, 0, 4096) >= 3)
>  		bios->size = data[2] * 512;
> +	kfree(data);
>  	if (!bios->size)
>  		return;
>  
> ---
> 
> Please attach acpidump output.


