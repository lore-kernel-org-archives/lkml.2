Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1HVQqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 12:46:38 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:7052 "EHLO
	VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1HVQqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 12:46:36 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz98dK4015Lzz1202hzz15d4R8275bhz32i668h839h944h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LQC99H-01-9HK-02
X-M-MSG: 
Date: Mon, 22 Aug 2011 18:46:26 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Neil Horman <nhorman@tuxdriver.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry (v2)
Message-ID: <20110822164626.GI2079@amd.com>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110808191354.GA22117@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110808191354.GA22117@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

I applied your patch and did some minor changes and fixed one problem I
have seen. Find the edited version appended, when this is fine for you I
push it.

Thanks,
	Joerg

On Mon, Aug 08, 2011 at 03:13:54PM -0400, Neil Horman wrote:
> +		range += (1 << HASH_FN_SHIFT);
> +		put_hash_bucket(*bucket, flags);
> +		index.dev_addr -= HASH_FN_SHIFT;

This should be index.dev_addr -= (1 << HASH_FN_SHIFT), right?

Here is the changed version:

commit 30172f1a71871acbbbbe7325a4264762211f4824
Author: Neil Horman <nhorman@tuxdriver.com>
Date:   Mon Aug 8 15:13:54 2011 -0400

    dma-debug: hash_bucket_find needs to allow for offsets within an entry
    
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
    
    (some edits by Joerg Roedel)
    
    Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
    Reported-by: Jay Fenalson <fenlason@redhat.com>
    CC: Divy LeRay <divy@chelsio.com>
    CC: Stanislaw Gruszka <sgruszka@redhat.com>
    CC: Joerg Roedel <joerg.roedel@amd.com>
    CC: Arnd Bergmann <arnd@arndb.de>
    Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>

diff --git a/lib/dma-debug.c b/lib/dma-debug.c
index db07bfd..79700fa 100644
--- a/lib/dma-debug.c
+++ b/lib/dma-debug.c
@@ -62,6 +62,8 @@ struct dma_debug_entry {
 #endif
 };
 
+typedef bool (*match_fn)(struct dma_debug_entry *, struct dma_debug_entry *);
+
 struct hash_bucket {
 	struct list_head list;
 	spinlock_t lock;
@@ -240,18 +242,37 @@ static void put_hash_bucket(struct hash_bucket *bucket,
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
-static struct dma_debug_entry *hash_bucket_find(struct hash_bucket *bucket,
-						struct dma_debug_entry *ref)
+static struct dma_debug_entry *__hash_bucket_find(struct hash_bucket *bucket,
+						  struct dma_debug_entry *ref,
+						  match_fn match)
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
 
+static struct dma_debug_entry *bucket_find_exact(struct hash_bucket *bucket,
+						 struct dma_debug_entry *ref)
+{
+	return __hash_bucket_find(bucket, ref, exact_match);
+}
+
+static struct dma_debug_entry *bucket_find_contain(struct hash_bucket **bucket,
+						   struct dma_debug_entry *ref,
+						   unsigned long *flags)
+{
+
+	unsigned int max_range = dma_get_max_seg_size(ref->dev);
+	struct dma_debug_entry *entry, index = *ref;
+	unsigned int range = 0;
+
+	while (range <= max_range) {
+		entry = __hash_bucket_find(*bucket, &index, containing_match);
+
+		if (entry)
+			return entry;
+
+		/*
+		 * Nothing found, go back a hash bucket
+		 */
+		put_hash_bucket(*bucket, flags);
+		range          += (1 << HASH_FN_SHIFT);
+		index.dev_addr -= (1 << HASH_FN_SHIFT);
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
+	entry = bucket_find_exact(bucket, ref);
 
 	if (!entry) {
 		err_printk(ref->dev, NULL, "DMA-API: device driver tries "
@@ -902,7 +956,7 @@ static void check_sync(struct device *dev,
 
 	bucket = get_hash_bucket(ref, &flags);
 
-	entry = hash_bucket_find(bucket, ref);
+	entry = bucket_find_contain(&bucket, ref, &flags);
 
 	if (!entry) {
 		err_printk(dev, NULL, "DMA-API: device driver tries "
@@ -1060,7 +1114,7 @@ static int get_nr_mapped_entries(struct device *dev,
 	int mapped_ents;
 
 	bucket       = get_hash_bucket(ref, &flags);
-	entry        = hash_bucket_find(bucket, ref);
+	entry        = bucket_find_exact(bucket, ref);
 	mapped_ents  = 0;
 
 	if (entry)

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

