Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab1GGEDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:03:34 -0400
Received: from imovil.entelpcs.cl ([200.72.211.69]:14526 "EHLO
	localhost6.localdomain6" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750739Ab1GGEDd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:03:33 -0400
Subject: [PATCH] uml: free resources
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>
Cc: uml <user-mode-linux-devel@lists.sourceforge.net>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: GNU
Date: Thu, 07 Jul 2011 00:02:51 -0400
Message-ID: <1310011371.3309.2.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

When creating the temp file there's a memory and file descriptor leak upon error.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
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
1.7.4.1


