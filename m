Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778Ab2GZVcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:32:14 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58435 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab2GZVcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:32:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Subject: [ 36/40] mm: vmscan: convert global reclaim to per-memcg LRU lists
Date: Thu, 26 Jul 2012 14:29:54 -0700
Message-Id: <20120726211414.464540343@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Weiner <jweiner@redhat.com>

commit b95a2f2d486d0d768a92879c023a03757b9c7e58 upstream - WARNING: this is a substitute patch.

Stable note: Not tracked in Bugzilla. This is a partial backport of an
	upstream commit addressing a completely different issue
	that accidentally contained an important fix. The workload
	this patch helps was memcached when IO is started in the
	background. memcached should stay resident but without this patch
	it gets swapped. Sometimes this manifests as a drop in throughput
	but mostly it was observed through /proc/vmstat.

Commit [246e87a9: memcg: fix get_scan_count() for small targets] was meant
to fix a problem whereby small scan targets on memcg were ignored causing
priority to raise too sharply. It forced scanning to take place if the
target was small, memcg or kswapd.

>From the time it was introduced it caused excessive reclaim by kswapd
with workloads being pushed to swap that previously would have stayed
resident. This was accidentally fixed in commit [b95a2f2d: mm: vmscan:
convert global reclaim to per-memcg LRU lists] by making it harder for
kswapd to force scan small targets but that patchset is not suitable for
backporting. This was later changed again by commit [90126375: mm/vmscan:
push lruvec pointer into get_scan_count()] into a format that looks
like it would be a straight-forward backport but there is a subtle
difference due to the use of lruvecs.

The impact of the accidental fix is to make it harder for kswapd to force
scan small targets by taking zone->all_unreclaimable into account. This
patch is the closest equivalent available based on what is backported.

---
 mm/vmscan.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1850,7 +1850,8 @@ static void get_scan_count(struct zone *
 	unsigned long nr_force_scan[2];
 
 	/* kswapd does zone balancing and needs to scan this zone */
-	if (scanning_global_lru(sc) && current_is_kswapd())
+	if (scanning_global_lru(sc) && current_is_kswapd() &&
+	    zone->all_unreclaimable)
 		force_scan = true;
 	/* memcg may have small limit and need to avoid priority drop */
 	if (!scanning_global_lru(sc))


