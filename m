Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab2EVO4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:56:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46637 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab2EVO4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:56:20 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Guard check in module loader against integer overflow
To: rusty@rustcorp.com.au
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>
Date: Tue, 22 May 2012 15:56:13 +0100
Message-ID: <20120522145613.32115.21217.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The check:

	if (len < hdr->e_shoff + hdr->e_shnum * sizeof(Elf_Shdr))

may not work if there's an overflow in the right-hand side of the condition.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 kernel/module.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/kernel/module.c b/kernel/module.c
index 78ac6ec..377cb06 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2429,7 +2429,8 @@ static int copy_and_check(struct load_info *info,
 		goto free_hdr;
 	}
 
-	if (len < hdr->e_shoff + hdr->e_shnum * sizeof(Elf_Shdr)) {
+	if (hdr->e_shoff >= len ||
+	    hdr->e_shnum * sizeof(Elf_Shdr) > len - hdr->e_shoff) {
 		err = -ENOEXEC;
 		goto free_hdr;
 	}

