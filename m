Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab2JPKYY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 06:24:24 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:41096 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751835Ab2JPKYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 06:24:24 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] binfmt_elf: Fix corner case kfree of uninitialized data
To: linux-kernel@vger.kernel.org
Date: Tue, 16 Oct 2012 11:48:04 +0100
Message-ID: <20121016104757.27601.56082.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

If elf_core_dump is called and fill_note_info fails in the kmalloc then
it returns 0 but has not yet initialised all the needed fields. As a result
we do a kfree(randomness) after correctly skipping the thread data.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 fs/binfmt_elf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fbd9f60..5c07218 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1600,8 +1600,10 @@ static int fill_note_info(struct elfhdr *elf, int phdrs,
 	info->thread = NULL;
 
 	psinfo = kmalloc(sizeof(*psinfo), GFP_KERNEL);
-	if (psinfo == NULL)
+	if (psinfo == NULL) {
+		info->psinfo.data = NULL;	/* So we don't free this wrongly */
 		return 0;
+        }
 
 	fill_note(&info->psinfo, "CORE", NT_PRPSINFO, sizeof(*psinfo), psinfo);
 

