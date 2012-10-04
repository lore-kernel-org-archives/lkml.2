Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933713Ab2JDVUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:20:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:57562 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933607Ab2JDVUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:20:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: [ 05/58] dm verity: fix overflow check
Date: Thu,  4 Oct 2012 14:19:12 -0700
Message-Id: <20121004210636.115714807@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004210635.449598766@linuxfoundation.org>
References: <20121004210635.449598766@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 1d55f6bcc0331d744cd5b56c4ee79e3809438161 upstream.

This patch fixes sector_t overflow checking in dm-verity.

Without this patch, the code checks for overflow only if sector_t is
smaller than long long, not if sector_t and long long have the same size.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-verity.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -718,8 +718,8 @@ static int verity_ctr(struct dm_target *
 	v->hash_dev_block_bits = ffs(num) - 1;
 
 	if (sscanf(argv[5], "%llu%c", &num_ll, &dummy) != 1 ||
-	    num_ll << (v->data_dev_block_bits - SECTOR_SHIFT) !=
-	    (sector_t)num_ll << (v->data_dev_block_bits - SECTOR_SHIFT)) {
+	    (sector_t)(num_ll << (v->data_dev_block_bits - SECTOR_SHIFT))
+	    >> (v->data_dev_block_bits - SECTOR_SHIFT) != num_ll) {
 		ti->error = "Invalid data blocks";
 		r = -EINVAL;
 		goto bad;
@@ -733,8 +733,8 @@ static int verity_ctr(struct dm_target *
 	}
 
 	if (sscanf(argv[6], "%llu%c", &num_ll, &dummy) != 1 ||
-	    num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT) !=
-	    (sector_t)num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT)) {
+	    (sector_t)(num_ll << (v->hash_dev_block_bits - SECTOR_SHIFT))
+	    >> (v->hash_dev_block_bits - SECTOR_SHIFT) != num_ll) {
 		ti->error = "Invalid hash start";
 		r = -EINVAL;
 		goto bad;


