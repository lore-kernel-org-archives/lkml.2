Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933130Ab2EJXmg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:42:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932829Ab2EJXm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:42:29 -0400
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 18/29] Guard check in module loader against integer overflow
 [ver #4]
To: rusty@rustcorp.com.au
Cc: kyle@mcmartin.ca, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@linux-nfs.org,
        David Howells <dhowells@redhat.com>
Date: Fri, 11 May 2012 00:42:21 +0100
Message-ID: <20120510234221.4137.83826.stgit@warthog.procyon.org.uk>
In-Reply-To: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
References: <20120510233901.4137.19023.stgit@warthog.procyon.org.uk>
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

