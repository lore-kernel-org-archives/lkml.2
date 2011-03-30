Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab1C3Vrc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:47:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:23361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933499Ab1C3VHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237141"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: khorenko@parallels.com, khorenko@openvz.org, bfields@redhat.com,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [110/275] NFSD: memory corruption due to writing beyond the stat array
Message-Id: <20110330210549.78C6E3E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Konstantin Khorenko <khorenko@parallels.com>

commit 3aa6e0aa8ab3e64bbfba092c64d42fd1d006b124 upstream.

If nfsd fails to find an exported via NFS file in the readahead cache, it
should increment corresponding nfsdstats counter (ra_depth[10]), but due to a
bug it may instead write to ra_depth[11], corrupting the following field.

In a kernel with NFSDv4 compiled in the corruption takes the form of an
increment of a counter of the number of NFSv4 operation 0's received; since
there is no operation 0, this is harmless.

In a kernel with NFSDv4 disabled it corrupts whatever happens to be in the
memory beyond nfsdstats.

Signed-off-by: Konstantin Khorenko <khorenko@openvz.org>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/nfsd/vfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/nfsd/vfs.c
===================================================================
--- linux-2.6.35.y.orig/fs/nfsd/vfs.c	2011-03-29 22:51:24.834087726 -0700
+++ linux-2.6.35.y/fs/nfsd/vfs.c	2011-03-29 23:03:00.482287829 -0700
@@ -819,7 +819,7 @@
 		if (ra->p_count == 0)
 			frap = rap;
 	}
-	depth = nfsdstats.ra_size*11/10;
+	depth = nfsdstats.ra_size;
 	if (!frap) {	
 		spin_unlock(&rab->pb_lock);
 		return NULL;
