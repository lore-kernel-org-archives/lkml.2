Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761747Ab0J2Tpg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:45:36 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12678 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab0J2Tpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:45:35 -0400
Date: Fri, 29 Oct 2010 21:35:25 +0200 (CEST)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: support@audioscience.com, alsa-devel@alsa-project.org,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH] AudioScience HPI driver: Unsafe memory management when
 allocating control cache
Message-ID: <alpine.LNX.2.00.1010292124180.24561@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed that sound/pci/asihpi/hpicmn.c::hpi_alloc_control_cache() does 
not check the return value from kmalloc(), which may fail.
If kmalloc() fails we'll dereference a null pointer and things will go bad 
fast.
There are two memory allocations in that function and there's also the 
problem that the first may succeed and the second may fail and nothing is 
done about that either which will also go wrong down the line.

I tried to fix that up in the patch below, but since I don't know this 
code at all nor have the hardware to test anything the patch is based 
entirely on 30 minutes of investigation of the source and then compile 
tested only, so it may be the completely wrong way to fix the issues. Thus 
I am not suggesting that this patch be merged as-is unless someone else 
who know this code says it looks correct (in which case, by all means 
merge it), I'm mainly trying to bring the issue to the attention of the 
relevant people and providing an attempted fix seemed like the best way to 
do that.

Btw; please keep me on Cc if you reply.


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 hpi6000.c |    2 ++
 hpi6205.c |    2 ++
 hpicmn.c  |   12 +++++++++---
 3 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/sound/pci/asihpi/hpi6000.c b/sound/pci/asihpi/hpi6000.c
index f7e374e..1b9bf93 100644
--- a/sound/pci/asihpi/hpi6000.c
+++ b/sound/pci/asihpi/hpi6000.c
@@ -625,6 +625,8 @@ static short create_adapter_obj(struct hpi_adapter_obj *pao,
 			control_cache_size, (struct hpi_control_cache_info *)
 			&phw->control_cache[0]
 			);
+		if (!phw->p_cache)
+			pao->has_control_cache = 0;
 	} else
 		pao->has_control_cache = 0;
 
diff --git a/sound/pci/asihpi/hpi6205.c b/sound/pci/asihpi/hpi6205.c
index 22c5fc6..2672f65 100644
--- a/sound/pci/asihpi/hpi6205.c
+++ b/sound/pci/asihpi/hpi6205.c
@@ -644,6 +644,8 @@ static u16 create_adapter_obj(struct hpi_adapter_obj *pao,
 				interface->control_cache.size_in_bytes,
 				(struct hpi_control_cache_info *)
 				p_control_cache_virtual);
+			if (!phw->p_cache)
+				err = HPI_ERROR_MEMORY_ALLOC;
 		}
 		if (!err) {
 			err = hpios_locked_mem_get_phys_addr(&phw->
diff --git a/sound/pci/asihpi/hpicmn.c b/sound/pci/asihpi/hpicmn.c
index dda4f1c..d67f4d3 100644
--- a/sound/pci/asihpi/hpicmn.c
+++ b/sound/pci/asihpi/hpicmn.c
@@ -571,14 +571,20 @@ struct hpi_control_cache *hpi_alloc_control_cache(const u32
 {
 	struct hpi_control_cache *p_cache =
 		kmalloc(sizeof(*p_cache), GFP_KERNEL);
+	if (!p_cache)
+		return NULL;
+	p_cache->p_info =
+		kmalloc(sizeof(*p_cache->p_info) * number_of_controls,
+			GFP_KERNEL);
+	if (!p_cache->p_info) {
+		kfree(p_cache);
+		return NULL;
+	}
 	p_cache->cache_size_in_bytes = size_in_bytes;
 	p_cache->control_count = number_of_controls;
 	p_cache->p_cache =
 		(struct hpi_control_cache_single *)pDSP_control_buffer;
 	p_cache->init = 0;
-	p_cache->p_info =
-		kmalloc(sizeof(*p_cache->p_info) * p_cache->control_count,
-		GFP_KERNEL);
 	return p_cache;
 }
 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

