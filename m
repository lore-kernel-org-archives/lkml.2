Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1033068Ab2I1VSY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:18:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54647 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759304Ab2I1Uie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:34 -0400
X-Sasl-enc: oRtCKhlhrekAeM0YHEjZ5ePOWzqc+kQ+FpqA2eJTXvaR 1348864713
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Richard Genoud <richard.genoud@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 205/218] UBI: fix a horrible memory deallocation bug
Date: Fri, 28 Sep 2012 13:17:02 -0700
Message-Id: <20120928201525.114777793@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

commit 78b495c39add820ab66ab897af9bd77a5f2e91f6 upstream

UBI was mistakingly using 'kfree()' instead of 'kmem_cache_free()' when
freeing "attach eraseblock" structures in vtbl.c. Thankfully, this happened
only when we were doing auto-format, so many systems were unaffected. However,
there are still many users affected.

It is strange, but the system did not crash and nothing bad happened when
the SLUB memory allocator was used. However, in case of SLOB we observed an
crash right away.

This problem was introduced in 2.6.39 by commit
"6c1e875 UBI: add slab cache for ubi_scan_leb objects"

Reported-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/ubi/vtbl.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/mtd/ubi/vtbl.c
+++ b/drivers/mtd/ubi/vtbl.c
@@ -346,7 +346,7 @@ retry:
 	 */
 	err = ubi_scan_add_used(ubi, si, new_seb->pnum, new_seb->ec,
 				vid_hdr, 0);
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
 
@@ -359,7 +359,7 @@ write_error:
 		list_add(&new_seb->u.list, &si->erase);
 		goto retry;
 	}
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;


