Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab2JYLPj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:15:39 -0400
Received: from caiajhbdccah.dreamhost.com ([208.97.132.207]:42421 "EHLO
	homiemail-a61.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759378Ab2JYLPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:15:37 -0400
Message-ID: <1351163734.2513.15.camel@offbook>
Subject: [PATCH RESEND 1/3] partitions: efi: compare first and last usable
 LBAs
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2012 13:15:34 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When verifying GPT header integrity, make sure that
first usable LBA is smaller than last usable LBA.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 block/partitions/efi.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/block/partitions/efi.c b/block/partitions/efi.c
index 6296b40..7795bb4 100644
--- a/block/partitions/efi.c
+++ b/block/partitions/efi.c
@@ -344,6 +344,12 @@ static int is_gpt_valid(struct parsed_partitions *state, u64 lba,
 	 * within the disk.
 	 */
 	lastlba = last_lba(state->bdev);
+	if (le64_to_cpu((*gpt)->last_usable_lba) < le64_to_cpu((*gpt)->first_usable_lba)) {
+		pr_debug("GPT: last_usable_lba incorrect: %lld > %lld\n",
+			 (unsigned long long)le64_to_cpu((*gpt)->last_usable_lba),
+			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba));
+		goto fail;
+	}
 	if (le64_to_cpu((*gpt)->first_usable_lba) > lastlba) {
 		pr_debug("GPT: first_usable_lba incorrect: %lld > %lld\n",
 			 (unsigned long long)le64_to_cpu((*gpt)->first_usable_lba),
-- 
1.7.9.5




