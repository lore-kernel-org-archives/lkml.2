Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab2GZVcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:32:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40055 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2GZVcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:32:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Pekka Enberg <penberg@kernel.org>, Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>,
        Mel Gorman <mel@csn.ul.ie>, Shaohua Li <shaohua.li@intel.com>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>
Subject: [ 33/40] vmscan: activate executable pages after first usage
Date: Thu, 26 Jul 2012 14:29:51 -0700
Message-Id: <20120726211414.141121812@linuxfoundation.org>
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

From: Konstantin Khlebnikov <khlebnikov@openvz.org>

commit c909e99364c8b6ca07864d752950b6b4ecf6bef4 upstream.

Stable note: Not tracked in Bugzilla. There were reports of shared
	mapped pages being unfairly reclaimed in comparison to older kernels.
	This is being addressed over time.

Logic added in commit 8cab4754d24a0 ("vmscan: make mapped executable pages
the first class citizen") was noticeably weakened in commit
645747462435d84 ("vmscan: detect mapped file pages used only once").

Currently these pages can become "first class citizens" only after second
usage.  After this patch page_check_references() will activate they after
first usage, and executable code gets yet better chance to stay in memory.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Minchan Kim <minchan.kim@gmail.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nick Piggin <npiggin@kernel.dk>
Cc: Mel Gorman <mel@csn.ul.ie>
Cc: Shaohua Li <shaohua.li@intel.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Mel Gorman <mgorman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/vmscan.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -726,6 +726,12 @@ static enum page_references page_check_r
 		if (referenced_page || referenced_ptes > 1)
 			return PAGEREF_ACTIVATE;
 
+		/*
+		 * Activate file-backed executable pages after first usage.
+		 */
+		if (vm_flags & VM_EXEC)
+			return PAGEREF_ACTIVATE;
+
 		return PAGEREF_KEEP;
 	}
 


