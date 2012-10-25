Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935224Ab2JYLPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:15:48 -0400
Received: from caiajhbdcbhh.dreamhost.com ([208.97.132.177]:38103 "EHLO
	homiemail-a60.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759405Ab2JYLPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:15:46 -0400
Message-ID: <1351163742.2513.16.camel@offbook>
Subject: [PATCH RESEND 2/3] partitions: efi: verify header is outside usable
 area
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2012 13:15:42 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first usable logical block can be used by a GUID partition
entry, and therefore cannot be used by the header.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 block/partitions/efi.c |    7 +++++++
 1 file changed, 7 insertions(+)

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
1.7.9.5




