Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932651Ab1ESXCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:02:10 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:47602 "EHLO duck.linux-mips.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755179Ab1ESXCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:02:07 -0400
Date: Fri, 20 May 2011 00:02:02 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MIPS: Define dummy MAX_DMA_CHANNELS to fix build failure
Message-ID: <20110519230202.GA10628@linux-mips.org>
References: <1287673079-15065-1-git-send-email-namhyung@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1287673079-15065-1-git-send-email-namhyung@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 11:57:59PM +0900, Namhyung Kim wrote:
> Date:   Thu, 21 Oct 2010 23:57:59 +0900
> From: Namhyung Kim <namhyung@gmail.com>
> To: Ralf Baechle <ralf@linux-mips.org>
> Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
> Subject: [PATCH] MIPS: Define dummy MAX_DMA_CHANNELS to fix build failure
> 
> allmodconfig build failes like following:
> 
>   CC [M]  sound/oss/soundcard.o
> sound/oss/soundcard.c:68: error: 'MAX_DMA_CHANNELS' undeclared here (not in a function)
> make[3]: *** [sound/oss/soundcard.o] Error 1
> make[2]: *** [sound/oss] Error 2
> make[1]: *** [sub-make] Error 2
> make: *** [all] Error 2

With your patch applied I get this:

  CC      kernel/dma.o
kernel/dma.c:61:2: error: array index in initializer exceeds array bounds
kernel/dma.c:61:2: error: (near initialization for ‘dma_chan_busy’)
kernel/dma.c:61:2: warning: excess elements in array initializer [enabled by default]
kernel/dma.c:61:2: warning: (near initialization for ‘dma_chan_busy’) [enabled by default]
make[1]: *** [kernel/dma.o] Error 1
make: *** [kernel] Error 2

MAX_DMA_CHANNELS is left undefined so kernel/dma.c builds only the dummy
versions but sound/oss/soundcard.c doesn't support the same thing except
with a rather crude patch following what kernel/dma.c already does such
as below.  It gets everything to build for the affected systems but I
doubt much (if anything) will be working.

At this stage I just wanna get rid of OSS for MIPS entirely; it has very
little life if any left.

  Ralf

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

 sound/oss/soundcard.c |   14 ++++++++++++++
 1 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index 7c7793a..78ef95a 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -66,7 +66,9 @@ int             sound_dmap_flag = 1;
 int             sound_dmap_flag = 0;
 #endif
 
+#ifdef MAX_DMA_CHANNELS
 static char     dma_alloc_map[MAX_DMA_CHANNELS];
+#endif
 
 #define DMA_MAP_UNAVAIL		0
 #define DMA_MAP_FREE		1
@@ -594,11 +596,13 @@ static void __exit oss_cleanup(void)
 
 	sequencer_unload();
 
+#ifdef MAX_DMA_CHANNELS
 	for (i = 0; i < MAX_DMA_CHANNELS; i++)
 		if (dma_alloc_map[i] != DMA_MAP_UNAVAIL) {
 			printk(KERN_ERR "Sound: Hmm, DMA%d was left allocated - fixed\n", i);
 			sound_free_dma(i);
 		}
+#endif
 
 	for (i = 0; i < sound_nblocks; i++)
 		vfree(sound_mem_blocks[i]);
@@ -619,7 +623,9 @@ int sound_alloc_dma(int chn, char *deviceID)
 	if ((err = request_dma(chn, deviceID)) != 0)
 		return err;
 
+#ifdef MAX_DMA_CHANNELS
 	dma_alloc_map[chn] = DMA_MAP_FREE;
+#endif
 
 	return 0;
 }
@@ -627,6 +633,7 @@ EXPORT_SYMBOL(sound_alloc_dma);
 
 int sound_open_dma(int chn, char *deviceID)
 {
+#ifdef MAX_DMA_CHANNELS
 	if (!valid_dma(chn)) {
 		printk(KERN_ERR "sound_open_dma: Invalid DMA channel %d\n", chn);
 		return 1;
@@ -638,27 +645,34 @@ int sound_open_dma(int chn, char *deviceID)
 	}
 	dma_alloc_map[chn] = DMA_MAP_BUSY;
 	return 0;
+#else
+	return 1;	/* No ISA DMA supported  */
+#endif
 }
 EXPORT_SYMBOL(sound_open_dma);
 
 void sound_free_dma(int chn)
 {
+#ifdef MAX_DMA_CHANNELS
 	if (dma_alloc_map[chn] == DMA_MAP_UNAVAIL) {
 		/* printk( "sound_free_dma: Bad access to DMA channel %d\n",  chn); */
 		return;
 	}
 	free_dma(chn);
 	dma_alloc_map[chn] = DMA_MAP_UNAVAIL;
+#endif
 }
 EXPORT_SYMBOL(sound_free_dma);
 
 void sound_close_dma(int chn)
 {
+#ifdef MAX_DMA_CHANNELS
 	if (dma_alloc_map[chn] != DMA_MAP_BUSY) {
 		printk(KERN_ERR "sound_close_dma: Bad access to DMA channel %d\n", chn);
 		return;
 	}
 	dma_alloc_map[chn] = DMA_MAP_FREE;
+#endif
 }
 EXPORT_SYMBOL(sound_close_dma);
 
