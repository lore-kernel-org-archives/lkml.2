Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757241Ab2BXLIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 06:08:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65396 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab2BXLIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 06:08:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] Remove missed ->fds_bits from cessation use of fd_set structs
 internally
To: hpa@zytor.com
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        David Howells <dhowells@redhat.com>,
        Ralf =?utf-8?q?B=C3=A4chle?= <ralf@linux-mips.org>,
        Arve =?utf-8?b?SGrDuG5uZXbDpWc=?= <arve@android.com>
Date: Fri, 24 Feb 2012 10:57:07 +0000
Message-ID: <20120224105707.32170.11550.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix places where ->fds_bits needed to be removed as the core kernel no longer
uses fd_set internally for file descriptor table management.  There are two
places:

 (1) drivers/staging/android/binder.c

 (2) arch/mips/kernel/kspd.c

     Question: Should sp_cleanup() in the MIPS arch be using find_next_bit()
     or fls()?

Signed-off-by: David Howells <dhowells@redhat.com>
cc: Ralf Bächle <ralf@linux-mips.org>
cc: Arve Hjønnevåg <arve@android.com>
---

 arch/mips/kernel/kspd.c          |    2 +-
 drivers/staging/android/binder.c |    3 +--
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/mips/kernel/kspd.c b/arch/mips/kernel/kspd.c
index 29811f0..84d0639 100644
--- a/arch/mips/kernel/kspd.c
+++ b/arch/mips/kernel/kspd.c
@@ -326,7 +326,7 @@ static void sp_cleanup(void)
 		i = j * __NFDBITS;
 		if (i >= fdt->max_fds)
 			break;
-		set = fdt->open_fds->fds_bits[j++];
+		set = fdt->open_fds[j++];
 		while (set) {
 			if (set & 1) {
 				struct file * file = xchg(&fdt->fd[i], NULL);
diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index 347bd6e..eeaa9b8 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -380,8 +380,7 @@ int task_get_unused_fd_flags(struct binder_proc *proc, int flags)
 
 repeat:
 	fdt = files_fdtable(files);
-	fd = find_next_zero_bit(fdt->open_fds->fds_bits, fdt->max_fds,
-				files->next_fd);
+	fd = find_next_zero_bit(fdt->open_fds, fdt->max_fds, files->next_fd);
 
 	/*
 	 * N.B. For clone tasks sharing a files structure, this test

