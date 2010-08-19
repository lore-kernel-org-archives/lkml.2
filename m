Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab0HSDiC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 23:38:02 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:37632 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197Ab0HSDhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 23:37:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dbHVr3P001sP1K0RB6pklVTUr6HxdzFFrwMHT33BZ86mAucUZ7tGa54Kh7tJr4E2ar
         jeVVKMlKwRi1SZvYsoKfr3emdXZQAeq3K6ydCGVy7o9HP6eSw9MZXflM05jlHIMKikaT
         n1n8GQs2ZrsoyP1PeE7vatoLTet7fgkhUzPNc=
From: Namhyung Kim <namhyung@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/4] initramfs: refactor clean_path()
Date: Thu, 19 Aug 2010 12:37:41 +0900
Message-Id: <1282189064-3904-2-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

first param, path, is used only on calling syscall routines which means it is
always considered as a user pointer. So add __user markup on parameter
declaration. And &st should be a user pointer also, mark it.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 init/initramfs.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index d9c6e78..75a43c5 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -276,11 +276,12 @@ static int __init maybe_link(void)
 	return 0;
 }
 
-static void __init clean_path(char *path, mode_t mode)
+static void __init clean_path(char __user *path, mode_t mode)
 {
 	struct stat st;
 
-	if (!sys_newlstat(path, &st) && (st.st_mode^mode) & S_IFMT) {
+	if (!sys_newlstat(path, (struct stat __user __force *)&st) &&
+	    (st.st_mode^mode) & S_IFMT) {
 		if (S_ISDIR(st.st_mode))
 			sys_rmdir(path);
 		else
-- 
1.7.0.4

