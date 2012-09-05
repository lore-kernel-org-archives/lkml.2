Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab2IEJS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 05:18:27 -0400
Received: from caiajhbdcaid.dreamhost.com ([208.97.132.83]:60021 "EHLO
	homiemail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751564Ab2IEJS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 05:18:26 -0400
Subject: [PATCH 1/3] partitions: efi: compare first and last usable LBAs
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Wed, 05 Sep 2012 11:18:23 +0200
Message-ID: <1346836703.2559.4.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When verifying GPT header integrity, make sure that
first usable LBA is smaller than last usable LBA.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 block/partitions/efi.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

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
1.7.4.1




