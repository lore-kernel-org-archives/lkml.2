Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312Ab2I1VGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:06:07 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51788 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423174Ab2I1VFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 17:05:53 -0400
X-Sasl-enc: wCA4uddDzpvGyOxCmidBezXd3ehNxcHMSaYL5QJX2lS1 1348866352
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Richard Genoud <richard.genoud@gmail.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Subject: [ 122/127] UBI: fix a horrible memory deallocation bug
Date: Fri, 28 Sep 2012 13:34:55 -0700
Message-Id: <20120928203100.163585961@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -356,7 +356,7 @@ retry:
 	 */
 	err = ubi_scan_add_used(ubi, si, new_seb->pnum, new_seb->ec,
 				vid_hdr, 0);
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;
 
@@ -369,7 +369,7 @@ write_error:
 		list_add(&new_seb->u.list, &si->erase);
 		goto retry;
 	}
-	kfree(new_seb);
+	kmem_cache_free(si->scan_leb_slab, new_seb);
 out_free:
 	ubi_free_vid_hdr(ubi, vid_hdr);
 	return err;


