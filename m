Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab1ELGSa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 02:18:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:44910 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583Ab1ELGS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 02:18:26 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH v2 2/3] coredump: use task comm instead of (unknown)
Date: Thu, 12 May 2011 08:18:12 +0200
Message-Id: <1305181093-20871-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305181093-20871-1-git-send-email-jslaby@suse.cz>
References: <1305181093-20871-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we don't know the file corresponding to the binary (i.e. exe_file
is unknown), use "task->comm (path unknown)" instead of simple
"(unknown)" as suggested by ak.

The fallback is the same as %e except it will append "(path unknown)".

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Oleg Nesterov <oleg@redhat.com>
---
 fs/exec.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 155c6d4..8900f61 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1554,8 +1554,11 @@ static int cn_print_exe_file(struct core_name *cn)
 	int ret;
 
 	exe_file = get_mm_exe_file(current->mm);
-	if (!exe_file)
-		return cn_printf(cn, "(unknown)");
+	if (!exe_file) {
+		char comm[TASK_COMM_LEN];
+		return cn_printf(cn, "%s (path unknown)", get_task_comm(comm,
+					current));
+	}
 
 	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
 	if (!pathbuf) {
-- 
1.7.4.2

