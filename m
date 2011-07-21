Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab1GUJTJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 05:19:09 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:57232 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751925Ab1GUJSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 05:18:46 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net,
        Davidlohr Bueso <dave@gnu.org>, Richard Weinberger <richard@nod.at>
Subject: [PATCH 04/10] uml: free resources
Date: Thu, 21 Jul 2011 11:18:28 +0200
Message-Id: <1311239914-8301-4-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311239914-8301-1-git-send-email-richard@nod.at>
References: <1311239914-8301-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

When creating the temp file there's a memory and file descriptor leak upon error.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Vitaliy Ivanov <vitalivanov@gmail.com>
---
 arch/um/os-Linux/mem.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/um/os-Linux/mem.c b/arch/um/os-Linux/mem.c
index e696144..62878cf 100644
--- a/arch/um/os-Linux/mem.c
+++ b/arch/um/os-Linux/mem.c
@@ -176,7 +176,7 @@ static int __init make_tempfile(const char *template, char **out_tempname,
 
 	find_tempdir();
 	if ((tempdir == NULL) || (strlen(tempdir) >= MAXPATHLEN))
-		return -1;
+		goto out;
 
 	if (template[0] != '/')
 		strcpy(tempname, tempdir);
@@ -191,13 +191,15 @@ static int __init make_tempfile(const char *template, char **out_tempname,
 	}
 	if (do_unlink && (unlink(tempname) < 0)) {
 		perror("unlink");
-		goto out;
+		goto close;
 	}
 	if (out_tempname) {
 		*out_tempname = tempname;
 	} else
 		free(tempname);
 	return fd;
+close:
+	close(fd);
 out:
 	free(tempname);
 	return -1;
-- 
1.7.6

