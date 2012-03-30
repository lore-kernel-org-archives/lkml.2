Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965962Ab2C3VUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:20:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33001 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965783Ab2C3VUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:20:35 -0400
Message-Id: <20120330194838.254761488@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 30 Mar 2012 12:49:36 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Roland Dreier <roland@purestorage.com>,
        Andy Grover <agrover@redhat.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [ 071/175] iscsi-target: Fix iscsit_alloc_buffs() failure cases
In-Reply-To: <20120330195801.GA31806@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit d335e6054db616bce3f040e659fa38440518ad1d upstream.

Make iscsit_alloc_buffs() failure case for page_alloc_failed use correct
__free_page() SGL pointer, and return -ENOMEM for iscsit_allocate_iovecs
failure to push se_cmd->t_mem_sg release into iscsit_release_cmd()
callback during iscsit_add_reject_from_cmd() connection reset.

Also drop cmd->t_mem_sg = NULL assignment from page_alloc_failed
failure case.

Reported-by: Roland Dreier <roland@purestorage.com>
Cc: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target.c |   14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -780,7 +780,7 @@ static int iscsit_alloc_buffs(struct isc
 	struct scatterlist *sgl;
 	u32 length = cmd->se_cmd.data_length;
 	int nents = DIV_ROUND_UP(length, PAGE_SIZE);
-	int i = 0, ret;
+	int i = 0, j = 0, ret;
 	/*
 	 * If no SCSI payload is present, allocate the default iovecs used for
 	 * iSCSI PDU Header
@@ -821,17 +821,15 @@ static int iscsit_alloc_buffs(struct isc
 	 */
         ret = iscsit_allocate_iovecs(cmd);
         if (ret < 0)
-		goto page_alloc_failed;
+		return -ENOMEM;
 
 	return 0;
 
 page_alloc_failed:
-	while (i >= 0) {
-		__free_page(sg_page(&sgl[i]));
-		i--;
-	}
-	kfree(cmd->t_mem_sg);
-	cmd->t_mem_sg = NULL;
+	while (j < i)
+		__free_page(sg_page(&sgl[j++]));
+
+	kfree(sgl);
 	return -ENOMEM;
 }
 


