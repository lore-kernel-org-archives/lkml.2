Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966Ab2JNO5Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:57:25 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46533 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754554Ab2JNOn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:28 -0400
Message-Id: <20121014143543.169892076@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:36:42 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Venu Byravarasu <vbyravarasu@nvidia.com>
Subject: [ 069/147] coredump: prevent double-free on an error path in core dumper
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denys Vlasenko <vda.linux@googlemail.com>

commit f34f9d186df35e5c39163444c43b4fc6255e39c5 upstream.

In !CORE_DUMP_USE_REGSET case, if elf_note_info_init fails to allocate
memory for info->fields, it frees already allocated stuff and returns
error to its caller, fill_note_info.  Which in turn returns error to its
caller, elf_core_dump.  Which jumps to cleanup label and calls
free_note_info, which will happily try to free all info->fields again.
BOOM.

This is the fix.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Venu Byravarasu <vbyravarasu@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/binfmt_elf.c |   19 ++++---------------
 1 file changed, 4 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 1b52956..0225fdd 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1696,30 +1696,19 @@ static int elf_note_info_init(struct elf_note_info *info)
 		return 0;
 	info->psinfo = kmalloc(sizeof(*info->psinfo), GFP_KERNEL);
 	if (!info->psinfo)
-		goto notes_free;
+		return 0;
 	info->prstatus = kmalloc(sizeof(*info->prstatus), GFP_KERNEL);
 	if (!info->prstatus)
-		goto psinfo_free;
+		return 0;
 	info->fpu = kmalloc(sizeof(*info->fpu), GFP_KERNEL);
 	if (!info->fpu)
-		goto prstatus_free;
+		return 0;
 #ifdef ELF_CORE_COPY_XFPREGS
 	info->xfpu = kmalloc(sizeof(*info->xfpu), GFP_KERNEL);
 	if (!info->xfpu)
-		goto fpu_free;
+		return 0;
 #endif
 	return 1;
-#ifdef ELF_CORE_COPY_XFPREGS
- fpu_free:
-	kfree(info->fpu);
-#endif
- prstatus_free:
-	kfree(info->prstatus);
- psinfo_free:
-	kfree(info->psinfo);
- notes_free:
-	kfree(info->notes);
-	return 0;
 }
 
 static int fill_note_info(struct elfhdr *elf, int phdrs,


