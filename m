Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043Ab0J2VE6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 17:04:58 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13816 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755739Ab0J2VEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 17:04:55 -0400
Date: Fri, 29 Oct 2010 22:54:45 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: Benny Sjostrand <benny@hostmobility.com>
cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org
Subject: [PATCH] cs46xx memory management fixes for cs46xx_dsp_spos_create()
 - make sure we free and don't do pointless work.
Message-ID: <alpine.LNX.2.00.1010292242080.24561@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

When reading through sound/pci/cs46xx/dsp_spos.c I noticed a couple of 
things in cs46xx_dsp_spos_create().

It seems to me that we don't always free the various memory buffers we 
allocate and we also do some work (structure member assignment) early, 
that is completely pointless if some of the memory allocations fail and 
we end up just aborting the whole thing.

I don't have hardware to test, so the patch below is compile tested only, 
but it makes the following changes:

- Make sure we always free all allocated memory on failures.
- Don't do pointless work assigning to structure members before we know 
  all memory allocations, that may abort progress, have completed 
  successfully.
- Remove some trailing whitespace.

If it looks ok, please merge, otherwise I'd be interested in knowing 
what's wrong so I can improve it.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 dsp_spos.c |   33 +++++++++++----------------------
 1 file changed, 11 insertions(+), 22 deletions(-)

diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index 3e5ca8f..e377287 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -225,39 +225,25 @@ struct dsp_spos_instance *cs46xx_dsp_spos_create (struct snd_cs46xx * chip)
 {
 	struct dsp_spos_instance * ins = kzalloc(sizeof(struct dsp_spos_instance), GFP_KERNEL);
 
-	if (ins == NULL) 
+	if (ins == NULL)
 		return NULL;
 
 	/* better to use vmalloc for this big table */
-	ins->symbol_table.nsymbols = 0;
 	ins->symbol_table.symbols = vmalloc(sizeof(struct dsp_symbol_entry) *
 					    DSP_MAX_SYMBOLS);
-	ins->symbol_table.highest_frag_index = 0;
-
-	if (ins->symbol_table.symbols == NULL) {
+	ins->code.data = kmalloc(DSP_CODE_BYTE_SIZE, GFP_KERNEL);
+	ins->modules = kmalloc(sizeof(struct dsp_module_desc) * DSP_MAX_MODULES, GFP_KERNEL);
+	if (!ins->symbol_table.symbols || !ins->code.data || !ins->modules) {
 		cs46xx_dsp_spos_destroy(chip);
 		goto error;
 	}
-
+	ins->symbol_table.nsymbols = 0;
+	ins->symbol_table.highest_frag_index = 0;
 	ins->code.offset = 0;
 	ins->code.size = 0;
-	ins->code.data = kmalloc(DSP_CODE_BYTE_SIZE, GFP_KERNEL);
-
-	if (ins->code.data == NULL) {
-		cs46xx_dsp_spos_destroy(chip);
-		goto error;
-	}
-
 	ins->nscb = 0;
 	ins->ntask = 0;
-
 	ins->nmodules = 0;
-	ins->modules = kmalloc(sizeof(struct dsp_module_desc) * DSP_MAX_MODULES, GFP_KERNEL);
-
-	if (ins->modules == NULL) {
-		cs46xx_dsp_spos_destroy(chip);
-		goto error;
-	}
 
 	/* default SPDIF input sample rate
 	   to 48000 khz */
@@ -271,8 +257,8 @@ struct dsp_spos_instance *cs46xx_dsp_spos_create (struct snd_cs46xx * chip)
 
 	/* set left and right validity bits and
 	   default channel status */
-	ins->spdif_csuv_default = 
-		ins->spdif_csuv_stream =  
+	ins->spdif_csuv_default =
+		ins->spdif_csuv_stream =
 	 /* byte 0 */  ((unsigned int)_wrap_all_bits(  (SNDRV_PCM_DEFAULT_CON_SPDIF        & 0xff)) << 24) |
 	 /* byte 1 */  ((unsigned int)_wrap_all_bits( ((SNDRV_PCM_DEFAULT_CON_SPDIF >> 8) & 0xff)) << 16) |
 	 /* byte 3 */   (unsigned int)_wrap_all_bits(  (SNDRV_PCM_DEFAULT_CON_SPDIF >> 24) & 0xff) |
@@ -281,6 +267,9 @@ struct dsp_spos_instance *cs46xx_dsp_spos_create (struct snd_cs46xx * chip)
 	return ins;
 
 error:
+	kfree(ins->modules);
+	kfree(ins->code.data);
+	vfree(ins->symbol_table.symbols);
 	kfree(ins);
 	return NULL;
 }


-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

