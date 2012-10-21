Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2JUMIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:08:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36837 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab2JUMIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:08:41 -0400
Date: Sun, 21 Oct 2012 14:09:01 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>
Cc: Heinz Diehl <htd@fritha.org>, Martin Peres <martin.peres@labri.fr>,
        Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121021120901.GA22587@joi.lan>
References: <1724445.dN2yMEzN6d@localhost>
 <20121020212036.GA1698@fritha.org>
 <20121020221948.GE5826@joi.lan>
 <2155889.FOmdXlva7q@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2155889.FOmdXlva7q@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 08:58:07AM +0200, Paweł Sikora wrote:
> On Sunday 21 of October 2012 00:19:48 Marcin Slusarz wrote:
> > On Sat, Oct 20, 2012 at 11:20:36PM +0200, Heinz Diehl wrote:
> > > On 20.10.2012, Marcin Slusarz wrote: 
> > > 
> > > > Try this one.
> > > 
> > > It works, now I can boot again. However, nouveau seems to be dead now.
> > > The dmesg output with your patch on top of 3.7-rc1 is:
> > > 
> > > [    3.685909] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
> > > [    3.687784] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a8800b1
> > > [    3.689960] nouveau  [  DEVICE][0000:01:00.0] Chipset: GT218 (NVA8)
> > > [    3.692471] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
> > > [    3.695716] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
> > > [    3.697087] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > > [    3.698471] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
> > > [    3.699838] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > > [    3.701223] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
> > > [    3.702684] ACPI Error: Field [ROMI] Base+Offset+Width 0+24+1 is beyond end of region [VROM] (length 24) (20120913/exfldio-210)
> > > [    3.704139] ACPI Error: Method parse/execution failed[\_SB_.PCI0.PEG1.GFX0._ROM] (Node ffff880142e85cf8), AE_AML_REGION_LIMIT (20120913/psparse-536)
> > > [    3.716183] failed to evaluate ROM got AE_AML_REGION_LIMIT
> > > [    3.718776] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > > [    3.721349] nouveau  [   VBIOS][0000:01:00.0] checking PCIROM for image...
> > > [    3.724111] nouveau 0000:01:00.0: Invalid ROM contents
> > > [    3.726663] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
> > > [    3.729159] nouveau E[   VBIOS][0000:01:00.0] unable to locate usable image
> > > [    3.731677] nouveau E[  DEVICE][0000:01:00.0] failed to create 0x10000001, -22
> > > [    3.734231] nouveau E[     DRM] failed to create 0x80000080, -22
> > > [    3.736097] nouveau: probe of 0000:01:00.0 failed with error -22
> > > [    3.740523] dracut: Starting plymouth daemon
> > 
> > Hmm, maybe we can't fetch 3 bytes only...
> > 
> > Let's check this:
> > 
> > ---
> > diff --git a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> > index 824eea0..8bd71aa 100644
> > --- a/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> > +++ b/drivers/gpu/drm/nouveau/core/subdev/bios/base.c
> > @@ -192,14 +192,16 @@ nouveau_bios_shadow_acpi(struct nouveau_bios *bios)
> >  {
> >  	struct pci_dev *pdev = nv_device(bios)->pdev;
> >  	int ret, cnt, i;
> > -	u8  data[3];
> > +	u8  *data;
> >  
> >  	if (!nouveau_acpi_rom_supported(pdev))
> >  		return;
> >  
> >  	bios->size = 0;
> > -	if (nouveau_acpi_get_bios_chunk(data, 0, 3) == 3)
> > +	data = kmalloc(4096, GFP_KERNEL);
> > +	if (data && nouveau_acpi_get_bios_chunk(data, 0, 4096) >= 3)
> >  		bios->size = data[2] * 512;
> > +	kfree(data);
> >  	if (!bios->size)
> >  		return;
> 
> with these both patches applied my laptop boots and gui works fine.
> here's dmesg:
> 
> (...)
> [    8.751795] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
> [    8.751798] nouveau  [   VBIOS][0000:01:00.0] using image from ACPI
> [    8.751895] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
> [    8.751898] nouveau  [   VBIOS][0000:01:00.0] version 70.08.45.00
> [    8.752366] nouveau  [ DEVINIT][0000:01:00.0] adaptor not initialised
> [    8.752368] nouveau  [   VBIOS][0000:01:00.0] running init tables
> [    8.867660] nouveau  [     MXM][0000:01:00.0] no VBIOS data, nothing to do
> [    8.867690] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
> [    8.867692] nouveau  [     PFB][0000:01:00.0] RAM size: 512 MiB
> [    8.901523] vga_switcheroo: enabled
> [    8.901979] [TTM] Zone  kernel: Available graphics memory: 6104282 kiB
> [    8.901980] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
> [    8.901982] [TTM] Initializing pool allocator
> [    8.902014] [TTM] Initializing DMA pool allocator
> [    8.902180] mtrr: type mismatch for c0000000,10000000 old: write-back new: write-combining
> [    8.902184] nouveau  [     DRM] VRAM: 512 MiB
> [    8.902185] nouveau  [     DRM] GART: 512 MiB
> [    8.902188] nouveau  [     DRM] BIT BIOS found
> [    8.902190] nouveau  [     DRM] Bios version 70.08.45.00
> [    8.902192] nouveau  [     DRM] TMDS table version 2.0
> [    8.902194] nouveau  [     DRM] DCB version 4.0
> [    8.902196] nouveau  [     DRM] DCB outp 00: 02011300 00000000
> [    8.902198] nouveau  [     DRM] DCB conn 01: 00000100
> [    8.903540] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
> [    8.903541] [drm] No driver support for vblank timestamp query.
> [    8.903545] nouveau  [     DRM] ACPI backlight interface available, not registering our own
> [    8.903938] nouveau  [     DRM] 3 available performance level(s)
> [    8.903941] nouveau  [     DRM] 0: core 50MHz shader 101MHz memory 135MHz voltage 830mV
> [    8.903943] nouveau  [     DRM] 1: core 202MHz shader 405MHz memory 324MHz voltage 830mV
> [    8.903946] nouveau  [     DRM] 3: core 672MHz shader 1344MHz memory 900MHz voltage 980mV
> [    8.903948] nouveau  [     DRM] c: core 202MHz shader 405MHz memory 324MHz voltage 980mV
> [    8.908895] nouveau  [     DRM] MM: using COPY1 for buffer copies
> [    8.988695] nouveau  [     DRM] allocated 1024x768 fb: 0x60000, bo ffff88033b5f1800
> [    8.988955] fb1: nouveaufb frame buffer device
> [    8.988959] [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 1
> (...)
> 
> > Please attach acpidump output.
> 
> http://pluto.agmk.net/nv/acpidump.txt
> 

This looks like ACPI bug...

Nouveau calls this method:
Method (_ROM, 2, NotSerialized)// _ROM: Read-Only Memory
{
  Add (Arg0, RBUF, Local0)
  ShiftLeft (Arg1, 0x03, Local1)
  Name (VBUF, Buffer (Arg1) {})
  OperationRegion (VROM, SystemMemory, Local0, Local1)
  Field (VROM, ByteAcc, NoLock, Preserve)
  {
    ROMI, 65536
  }

  Store (ROMI, VBUF)
  Return (VBUF)
}

with Arg0 == 0, Arg1 == 3 and gets:

ACPI Error: Field [ROMI] Base+Offset+Width 0+24+1 is beyond end of region [VROM] (length 24) (20120913/exfldio-210)
ACPI Error: Method parse/execution failed [\_SB_.PCI0.PEGR.GFX0._ROM] (Node ffff88033e47fe88), AE_AML_REGION_LIMIT (20120913/psparse-536)

We can workaround it by aligning Arg1 to 4096 (I'm wondering what is the minimal
value), but do we really have to?

Marcin
