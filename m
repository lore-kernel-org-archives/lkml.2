Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1CYGwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 02:52:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:36434 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754203Ab1CYGwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 02:52:08 -0400
Subject: ALSA: vmalloc buffers should use normal mmap
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 17:51:54 +1100
Message-ID: <1301035914.2402.472.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
CC: Takashi Iwai <tiwai@suse.de>
---
 include/sound/pcm.h     |    4 +---
 sound/core/pcm_native.c |    9 ---------
 2 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/include/sound/pcm.h b/include/sound/pcm.h
index 430a9cc..e1bad11 100644
--- a/include/sound/pcm.h
+++ b/include/sound/pcm.h
@@ -1031,9 +1031,7 @@ int snd_pcm_lib_mmap_iomem(struct snd_pcm_substream *substream, struct vm_area_s
 #define snd_pcm_lib_mmap_iomem	NULL
 #endif
 
-int snd_pcm_lib_mmap_noncached(struct snd_pcm_substream *substream,
-			       struct vm_area_struct *area);
-#define snd_pcm_lib_mmap_vmalloc	snd_pcm_lib_mmap_noncached
+#define snd_pcm_lib_mmap_vmalloc NULL
 
 static inline void snd_pcm_limit_isa_dma_size(int dma, size_t *max)
 {
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 2d99c37..7639407 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3194,15 +3194,6 @@ int snd_pcm_lib_mmap_iomem(struct snd_pcm_substream *substream,
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


