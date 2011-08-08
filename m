Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006Ab1HHTOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 15:14:10 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39355 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab1HHTOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 15:14:07 -0400
Date: Mon, 8 Aug 2011 15:13:54 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: linux-kernel@vger.kernel.org
Cc: Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Joerg Roedel <joerg.roedel@amd.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry (v2)
Message-ID: <20110808191354.GA22117@hmsreliant.think-freely.org>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: 0.2 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dma-debug: hash_bucket_find needs to allow for offsets within an entry (v2)

Summary:
Users of the pci_dma_sync_single_* api allow users to sync address ranges within
the range of a mapped entry (i.e. you can dma map address X to dma_addr_t A and
then pci_dma_sync_single on dma_addr_t A+1.  The dma-debug library however
assume dma syncs will always occur using the base address of a mapped region,
and uses that assumption to find entries in its hash table.  Since thats often
(but not always the case), the dma debug library can give us false errors about
missing entries, which are reported as syncing of memory not allocated by the
driver.  This was noted in the cxgb3 driver as this error:

WARNING: at lib/dma-debug.c:902 check_sync+0xdd/0x48c()
Hardware name: To be filled by O.E.M.
cxgb3 0000:01:00.0: DMA-API: device driver tries to sync DMA memory it has not
allocated [device address=0x00000000fff97800] [size=1984 bytes]
Modules linked in: autofs4 sunrpc cpufreq_ondemand acpi_cpufreq freq_table
mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter ip6_tables ipv6 uinput
snd_hda_codec_intelhdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer e1000e snd soundcore r8169
cxgb3 iTCO_wdt snd_page_alloc mii shpchp i2c_i801 iTCO_vendor_support mdio
microcode firewire_ohci firewire_core crc_itu_t ata_generic pata_acpi i915
drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded:
scsi_wait_scan]
Pid: 1818, comm: ifconfig Not tainted 2.6.35-0.23.rc3.git6.fc14.x86_64 #1
Call Trace:
[<ffffffff81050f71>] warn_slowpath_common+0x85/0x9d
[<ffffffff8105102c>] warn_slowpath_fmt+0x46/0x48
[<ffffffff8124658e>] ? check_sync+0x39/0x48c
[<ffffffff8107c470>] ? trace_hardirqs_on+0xd/0xf
[<ffffffff81246632>] check_sync+0xdd/0x48c
[<ffffffff81246ca6>] debug_dma_sync_single_for_device+0x3f/0x41
[<ffffffffa011615c>] ? pci_map_page+0x84/0x97 [cxgb3]
[<ffffffffa0117bc3>] pci_dma_sync_single_for_device.clone.0+0x65/0x6e [cxgb3]
[<ffffffffa0117ed1>] refill_fl+0x305/0x30a [cxgb3]
[<ffffffffa011857d>] t3_sge_alloc_qset+0x6a7/0x821 [cxgb3]
[<ffffffffa010a07b>] cxgb_up+0x4d0/0xe62 [cxgb3]
[<ffffffff81086037>] ? __module_text_address+0x12/0x58
[<ffffffffa010aa4c>] cxgb_open+0x3f/0x309 [cxgb3]
[<ffffffff813e9f6c>] __dev_open+0x8e/0xbc
[<ffffffff813e7ca5>] __dev_change_flags+0xbe/0x142
[<ffffffff813e9ea8>] dev_change_flags+0x21/0x57
[<ffffffff81445937>] devinet_ioctl+0x29a/0x54b
[<ffffffff811f9a87>] ? inode_has_perm+0xaa/0xce
[<ffffffff81446ed2>] inet_ioctl+0x8f/0xa7
[<ffffffff813d683a>] sock_do_ioctl+0x29/0x48
[<ffffffff813d6c83>] sock_ioctl+0x213/0x222
[<ffffffff81137f78>] vfs_ioctl+0x32/0xa6
[<ffffffff811384e2>] do_vfs_ioctl+0x47a/0x4b3
[<ffffffff81138571>] sys_ioctl+0x56/0x79
[<ffffffff81009c32>] system_call_fastpath+0x16/0x1b
---[ end trace 69a4d4cc77b58004 ]---

Version 1 of this simply attempted to relax the search in hash_bucket_find to
allow for entries to be supersets of the requested address and range.  That
turned out to be to simplistic as it didn't account for the possibility that the
'base' entry might have hashed to a previous bucket, meaning several
(potentially time consuming) searches needed to be done.  The consensus was to
break a large entry up into several smaller entries, and hash them all
independently, but this turned out to hold its own issues.  Namely that some
devices have rather large dma operations, and consume many hundreds of entries
in a single map/unmap, making that approach detrimental as well.

So I came up with this idea.  Its closer to the first approach, but adds the
recursive search through the hash table, if the initial serach fails (i.e. a
slow path should the normal fast lookup fail).  I limit that search however to
the max_segment_size of the device, which tells us how big a given dma mapping
for that dev can be.  This lets us avoid having to traverse the hash table,
potentially many times over, looking for a match.  I've been testing this on my
system here, and it seems to be working well.

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
Reported-by: Jay Fenalson <fenlason@redhat.com>
CC: Divy LeRay <divy@chelsio.com>
CC: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Joerg Roedel <joerg.roedel@amd.com>
CC: Arnd Bergmann <arnd@arndb.de>

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index db07bfd..7f36be0 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -240,18 +240,39 @@ static void put_hash_bucket(struct hash_bucket *bucket,
 	spin_unlock_irqrestore(&bucket->lock, __flags);
 }
 
+static bool exact_match(struct dma_debug_entry *a, struct dma_debug_entry *b)
+{
+	return ((a->dev_addr == a->dev_addr) &&
+		(a->dev == b->dev)) ? true : false;
+}
+
+static bool containing_match(struct dma_debug_entry *a,
+			     struct dma_debug_entry *b)
+{
+	if (a->dev != b->dev)
+		return false;
+
+	if ((b->dev_addr <= a->dev_addr) &&
+	    ((b->dev_addr + b->size) >= (a->dev_addr + a->size)))
+		return true;
+
+	return false;
+}
+
 /*
  * Search a given entry in the hash bucket list
  */
 static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
-						struct dma_debug_entry *ref)
+						struct dma_debug_entry *ref,
+						bool (*match)(
+						     struct dma_debug_entry *a,
+						     struct dma_debug_entry *b))
 {
 	struct dma_debug_entry *entry, *ret = NULL;
 	int matches = 0, match_lvl, last_lvl = 0;
 
 	list_for_each_entry(entry, &bucket->list, list) {
-		if ((entry->dev_addr != ref->dev_addr) ||
-		    (entry->dev != ref->dev))
+		if (!match(ref, entry))
 			continue;
 
 		/*
@@ -293,6 +314,39 @@ static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
 	return ret;
 }
 
+static struct dma_debug_entry *hash_bucket_find_recursive(
+				  struct hash_bucket **bucket,
+				  struct dma_debug_entry *ref,
+				  unsigned long *flags)
+{
+
+	struct dma_debug_entry *entry, index;
+	unsigned int range = 0;
+	unsigned int max_range = dma_get_max_seg_size(ref->dev);
+
+	memcpy(&index, ref, sizeof(struct dma_debug_entry));
+	/*
+	 * Normalize the reference to start on a page boundary
+	 */
+
+	while (range <= max_range) {
+		entry = hash_bucket_find(*bucket, &index, containing_match);
+
+		if (entry)
+			return entry;
+
+		/*
+		 * Nothing found, go back a page
+		 */
+		range += (1 << HASH_FN_SHIFT);
+		put_hash_bucket(*bucket, flags);
+		index.dev_addr -= HASH_FN_SHIFT;
+		*bucket = get_hash_bucket(&index, flags);
+	}
+
+	return NULL;
+}
+
 /*
  * Add an entry to a hash bucket
  */
@@ -802,7 +856,7 @@ static void check_unmap(struct dma_debug_entry *ref)
 	}
 
 	bucket = get_hash_bucket(ref, &flags);
-	entry = hash_bucket_find(bucket, ref);
+	entry = hash_bucket_find(bucket, ref, exact_match);
 
 	if (!entry) {
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
@@ -902,7 +956,7 @@ static void check_sync(struct device *dev,
 
 	bucket = get_hash_bucket(ref, &flags);
 
-	entry = hash_bucket_find(bucket, ref);
+	entry = hash_bucket_find_recursive(&bucket, ref, &flags);
 
 	if (!entry) {
 		err_printk(dev, NULL, "DMA-API: device driver tries "
@@ -1060,7 +1114,7 @@ static int get_nr_mapped_entries(struct device *dev,
 	int mapped_ents;
 
 	bucket       = get_hash_bucket(ref, &flags);
-	entry        = hash_bucket_find(bucket, ref);
+	entry        = hash_bucket_find(bucket, ref, exact_match);
 	mapped_ents  = 0;
 
 	if (entry)
