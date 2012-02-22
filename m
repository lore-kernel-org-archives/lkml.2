Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab2BVFa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 00:30:28 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41889 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793Ab2BVFa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 00:30:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bobbypowers@gmail.com designates 10.229.114.203 as permitted sender) smtp.mail=bobbypowers@gmail.com; dkim=pass header.i=bobbypowers@gmail.com
From: Bobby Powers <bobbypowers@gmail.com>
To: dhowells@redhat.com
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, viro@zeniv.linux.org.uk,
        Bobby Powers <bobbypowers@gmail.com>
Subject: [PATCH tip/x86/x32] fs: fix close_on_exec pointer in alloc_fdtable
Date: Wed, 22 Feb 2012 00:29:47 -0500
Message-Id: <1329888587-3087-1-git-send-email-bobbypowers@gmail.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_fdtable allocates space for the open_fds and close_on_exec
bitfields together, as 2 * nr / BITS_PER_BYTE.  close_on_exec needs to
point to open_fds + nr / BITS_PER_BYTE, not open_fds + nr /
BITS_PER_LONG, as introducted in 1fd36adc: Replace the fd_sets in
struct fdtable with an array of unsigned longs.

Signed-off-by: Bobby Powers <bobbypowers@gmail.com>
---
 fs/file.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 2d479dd..171f6b4 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -179,7 +179,7 @@ static struct fdtable * alloc_fdtable(unsigned int nr)
 	if (!data)
 		goto out_arr;
 	fdt->open_fds = data;
-	data += nr / BITS_PER_LONG;
+	data += nr / BITS_PER_BYTE;
 	fdt->close_on_exec = data;
 	fdt->next = NULL;
 
-- 
1.7.7.6

