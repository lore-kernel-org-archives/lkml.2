Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab2IEJSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:18:33 -0400
Received: from caiajhbdcagg.dreamhost.com ([208.97.132.66]:50016 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758285Ab2IEJSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:18:31 -0400
Subject: [PATCH 2/3] partitions: efi: verify header is outside usable area
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 05 Sep 2012 11:18:27 +0200
Message-ID: <1346836707.2559.5.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first usable logical block can be used by a GUID partition
entry, and therefore cannot be used by the header.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 block/partitions/efi.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 7795bb4..abf33a2 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -363,6 +363,13 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 		goto fail;
 	}
 
+	/* The header must be outside usable range */
+	if (le64_to_cpu((*gpt)->first_usable_lba) < lba &&
+	    le64_to_cpu((*gpt)->last_usable_lba) > lba) {
+		pr_debug("GPT: Header is inside usable area\n");
+		goto fail;
+	}
+
 	/* Check that sizeof_partition_entry has the correct value */
 	if (le32_to_cpu((*gpt)->sizeof_partition_entry) != sizeof(gpt_entry)) {
 		pr_debug("GUID Partitition Entry Size check failed.\n");
-- 
1.7.4.1




