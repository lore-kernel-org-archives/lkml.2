Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab0KJT3B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 14:29:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45571 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab0KJT27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 14:28:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=msz01eIe+F+Dqd55KMeMk4laa80/PN1TfgX1wr8DCaNO+3sACnWjNrgV+oSAny0pkl
         BYP2zSNpi4vUElXJD8MoWLn9QdP+BhEcf9SfyI/0Hv0UtYN8MlfFvTor4r0tvHtjqnu6
         1PzHNyqoHkGOLgTc2uRkZswpwlp/ufY0LR/v8=
MIME-Version: 1.0
From: Andrew Lutomirski <andy@luto.us>
Date: Wed, 10 Nov 2010 14:28:37 -0500
X-Google-Sender-Auth: hqoq3S8C19oTGUVFqQXDLtO0u68
Message-ID: <AANLkTi=sQ1_HD7JFBPC0LGZ_GNZTSrdkT_jSC36wG3kQ@mail.gmail.com>
Subject: Severe reproducible nouveau breakage in 2.6.36 (and maybe .35)
To: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all-

Somewhere between 2.6.34-fedora-whatever and 2.6.36, Nouveau became
extremely broken on my hardware.  It appears to be triggered by a bug
in my monitor (HP LP2475w), which causes the monitor to disappear from
DVI when it goes to sleep.  Every time the console blanks (in X or
otherwise AFAICT) the system crashes oddly but unrecoverably.  This is
100% reproducible by Ctrl-Alt-F2 followed by 'echo 1
>/sys/class/graphics/fb0/blank' *from SSH* and waiting a few seconds
for the monitor to go to sleep, but it also happens if I just walk
away from the computer long enough for it to blank itself.  This is
present on F14's kernel and on 2.6.36 from kernel.org.  This may or
may not be related to the unreproducible crashes that I used to get
rarely on 2.6.34.

The symptoms are:

 - netconsole becomes very unreliable.  (This makes it rather hard to
get any good debugging info because I don't have a real serial port.)
 - system doesn't answer pings.  userspace seems dead as well.
 - capslock will work intermittently
 - the lockup detector doesn't say anything.
 - After a few seconds, the system thinks that the tsc is massively
unstable and switches clocksources.  (I think this is because the
clocksource watchdog fails to schedule for awhile and then somehow
ends up running and thinking it detected a clocksource failure.)
 - SysRq-c will give me my console back and spew (useless?) garbage.
Usually it also causes a panic and I get nothing else out of the
system.

The most recent time I triggered this, I got an amazing amount of
console spew about unexpected NMIs.  None of it made it to serial
console, and the part left on the screen was so far down as to be
pretty much useless.  lockdep shows nothing interesting (or at least
nothing interesting that stays on the screen long enough for me to
read).

The best hint I have is from this patch (sorry for whitespace damage):

diff --git a/drivers/gpu/drm/nouveau/nv50_display.c
b/drivers/gpu/drm/nouveau/nv50_display.c
index 612fa6d..6823a4d 100644
--- a/drivers/gpu/drm/nouveau/nv50_display.c
+++ b/drivers/gpu/drm/nouveau/nv50_display.c
@@ -1014,6 +1014,8 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
        uint32_t unplug_mask, plug_mask, change_mask;
        uint32_t hpd0, hpd1 = 0;

+       printk(KERN_ERR "in nv50_display_irq_hotplug_bh\n");
+
        hpd0 = nv_rd32(dev, 0xe054) & nv_rd32(dev, 0xe050);
        if (dev_priv->chipset >= 0x90)
                hpd1 = nv_rd32(dev, 0xe074) & nv_rd32(dev, 0xe070);
@@ -1062,6 +1064,7 @@ nv50_display_irq_hotplug_bh(struct work_struct *work)
        if (dev_priv->chipset >= 0x90)
                nv_wr32(dev, 0xe074, nv_rd32(dev, 0xe074));

+       printk(KERN_ERR "about to drm_helper_hpd_irq_event\n");
        drm_helper_hpd_irq_event(dev);
 }

@@ -1072,6 +1075,7 @@ nv50_display_irq_handler(struct drm_device *dev)
        uint32_t delayed = 0;

        if (nv_rd32(dev, NV50_PMC_INTR_0) & NV50_PMC_INTR_0_HOTPLUG) {
+               printk(KERN_ERR "nv50 got hpd irq\n");
                if (!work_pending(&dev_priv->hpd_work))
                        queue_work(dev_priv->wq, &dev_priv->hpd_work);
        }

which spews "nv50 got hpd irq" once the display blanks.

Nouveau startup says:

[   15.646535] nouveau 0000:04:00.0: PCI INT A -> GSI 24 (level, low) -> IRQ 24
[   15.646540] nouveau 0000:04:00.0: setting latency timer to 64
[   15.650606] [drm] nouveau 0000:04:00.0: Detected an NV50 generation
card (0x086f00a2)
[   15.657126] [drm] nouveau 0000:04:00.0: Attempting to load BIOS
image from PRAMIN
[   15.714410] [drm] nouveau 0000:04:00.0: ... appears to be valid
[   15.714413] [drm] nouveau 0000:04:00.0: BIT BIOS found
[   15.714415] [drm] nouveau 0000:04:00.0: Bios version 60.86.5b.00
[   15.714418] [drm] nouveau 0000:04:00.0: TMDS table version 2.0
[   15.714420] [drm] nouveau 0000:04:00.0: Found Display Configuration
Block version 4.0
[   15.714423] [drm] nouveau 0000:04:00.0: Raw DCB entry 0: 02011300 00000028
[   15.714425] [drm] nouveau 0000:04:00.0: Raw DCB entry 1: 01011302 00000010
[   15.714427] [drm] nouveau 0000:04:00.0: Raw DCB entry 2: 01000310 00000028
[   15.714429] [drm] nouveau 0000:04:00.0: Raw DCB entry 3: 02000312 00000010
[   15.714430] [drm] nouveau 0000:04:00.0: Raw DCB entry 4: 0000000e 00000000
[   15.714433] [drm] nouveau 0000:04:00.0: DCB connector table: VHER 0x40 5 14 2
[   15.714435] [drm] nouveau 0000:04:00.0:   0: 0x00002030: type 0x30
idx 0 tag 0x08
[   15.714438] [drm] nouveau 0000:04:00.0:   1: 0x00001130: type 0x30
idx 1 tag 0x07
[   15.714441] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 0
at offset 0xC34B
[   15.740011] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 1
at offset 0xC6B5
[   15.758892] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 2
at offset 0xD2F6
[   15.758903] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 3
at offset 0xD3E8
[   15.760960] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table 4
at offset 0xD5E2
[   15.760965] [drm] nouveau 0000:04:00.0: Parsing VBIOS init table at
offset 0xD647
[   15.781884] [drm] nouveau 0000:04:00.0: 0xD647: Condition still not
met after 20ms, skipping following opcodes
[   15.781953] [drm] nouveau 0000:04:00.0: Detected 256MiB VRAM
[   15.873252] [TTM] Zone  kernel: Available graphics memory: 3055420 kiB.
[   15.873256] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   15.873259] [TTM] Initializing pool allocator.
[   15.948218] [drm] nouveau 0000:04:00.0: 512 MiB GART (aperture)
[   15.983208] [drm] nouveau 0000:04:00.0: Allocating FIFO number 1
[   15.998872] [drm] nouveau 0000:04:00.0: nouveau_channel_alloc:
initialised FIFO 1
[   16.158101] [drm] nouveau 0000:04:00.0: allocated 1920x1200 fb:
0x40230000, bo ffff8801b48a5000
[   16.158315] fbcon: nouveaufb (fb0) is primary device
[   16.165464] Console: switching to colour frame buffer device 240x75
[   16.168574] fb0: nouveaufb frame buffer device
[   16.168576] drm: registered panic notifier
[   16.168601] [drm] Initialized nouveau 0.0.16 20090420 for
0000:04:00.0 on minor 0
