Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431Ab1DLPAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 11:00:53 -0400
Received: from kroah.org ([198.145.64.141]:57340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756699Ab1DLOh2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 10:37:28 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 12 07:35:48 2011
Message-Id: <20110412143548.347694176@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 12 Apr 2011 07:33:53 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Takashi Iwai <tiwai@suse.de>
Subject: [004/105] ALSA: vmalloc buffers should use normal mmap
In-Reply-To: <20110412143613.GA19478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

commit 3674f19dabd15f9541079a588149a370d888f4e6 upstream.

It's a big no-no to use pgprot_noncached() when mmap'ing such buffers
into userspace since they are mapped cachable in kernel space.

This can cause all sort of interesting things ranging from to garbled
sound to lockups on various architectures. I've observed that usb-audio
is broken on powerpc 4xx for example because of that.

Also remove the now unused snd_pcm_lib_mmap_noncached(). It's
an arch business to know when to use uncached mappings, there's
already hacks for MIPS inside snd_pcm_default_mmap() and other
archs are supposed to use dma_mmap_coherent().

(See my separate patch that adds dma_mmap_coherent() to powerpc)

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/sound/pcm.h     |    4 +---
 sound/core/pcm_native.c |    9 ---------
 2 files changed, 1 insertion(+), 12 deletions(-)

--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1030,9 +1030,7 @@ int snd_pcm_lib_mmap_iomem(struct snd_pc
 #define snd_pcm_lib_mmap_iomem	NULL
 #endif
 
-int snd_pcm_lib_mmap_noncached(struct snd_pcm_substream *substream,
-			       struct vm_area_struct *area);
-#define snd_pcm_lib_mmap_vmalloc	snd_pcm_lib_mmap_noncached
+#define snd_pcm_lib_mmap_vmalloc NULL
 
 static inline void snd_pcm_limit_isa_dma_size(int dma, size_t *max)
 {
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3201,15 +3201,6 @@ int snd_pcm_lib_mmap_iomem(struct snd_pc
 EXPORT_SYMBOL(snd_pcm_lib_mmap_iomem);
 #endif /* SNDRV_PCM_INFO_MMAP */
 
-/* mmap callback with pgprot_noncached */
-int snd_pcm_lib_mmap_noncached(struct snd_pcm_substream *substream,
-			       struct vm_area_struct *area)
-{
-	area->vm_page_prot = pgprot_noncached(area->vm_page_prot);
-	return snd_pcm_default_mmap(substream, area);
-}
-EXPORT_SYMBOL(snd_pcm_lib_mmap_noncached);
-
 /*
  * mmap DMA buffer
  */


