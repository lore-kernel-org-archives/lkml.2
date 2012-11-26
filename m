Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab2KZRKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:10:31 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47806 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933535Ab2KZRK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:10:27 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sasha Levin <levinsasha928@gmail.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 169/270] SUNRPC: Prevent kernel stack corruption on long values of flush
Date: Mon, 26 Nov 2012 14:57:39 -0200
Message-Id: <1353949160-26803-170-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit 212ba90696ab4884e2025b0b13726d67aadc2cd4 upstream.

The buffer size in read_flush() is too small for the longest possible values
for it. This can lead to a kernel stack corruption:

[   43.047329] Kernel panic - not syncing: stack-protector: Kernel stack is corrupted in: ffffffff833e64b4
[   43.047329]
[   43.049030] Pid: 6015, comm: trinity-child18 Tainted: G        W    3.5.0-rc7-next-20120716-sasha #221
[   43.050038] Call Trace:
[   43.050435]  [<ffffffff836c60c2>] panic+0xcd/0x1f4
[   43.050931]  [<ffffffff833e64b4>] ? read_flush.isra.7+0xe4/0x100
[   43.051602]  [<ffffffff810e94e6>] __stack_chk_fail+0x16/0x20
[   43.052206]  [<ffffffff833e64b4>] read_flush.isra.7+0xe4/0x100
[   43.052951]  [<ffffffff833e6500>] ? read_flush_pipefs+0x30/0x30
[   43.053594]  [<ffffffff833e652c>] read_flush_procfs+0x2c/0x30
[   43.053596]  [<ffffffff812b9a8c>] proc_reg_read+0x9c/0xd0
[   43.053596]  [<ffffffff812b99f0>] ? proc_reg_write+0xd0/0xd0
[   43.053596]  [<ffffffff81250d5b>] do_loop_readv_writev+0x4b/0x90
[   43.053596]  [<ffffffff81250fd6>] do_readv_writev+0xf6/0x1d0
[   43.053596]  [<ffffffff812510ee>] vfs_readv+0x3e/0x60
[   43.053596]  [<ffffffff812511b8>] sys_readv+0x48/0xb0
[   43.053596]  [<ffffffff8378167d>] system_call_fastpath+0x1a/0x1f

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 net/sunrpc/cache.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/cache.c b/net/sunrpc/cache.c
index 47ad266..97bbcdc 100644
--- a/net/sunrpc/cache.c
+++ b/net/sunrpc/cache.c
@@ -1406,11 +1406,11 @@ static ssize_t read_flush(struct file *file, char __user *buf,
 			  size_t count, loff_t *ppos,
 			  struct cache_detail *cd)
 {
-	char tbuf[20];
+	char tbuf[22];
 	unsigned long p = *ppos;
 	size_t len;
 
-	sprintf(tbuf, "%lu\n", convert_to_wallclock(cd->flush_time));
+	snprintf(tbuf, sizeof(tbuf), "%lu\n", convert_to_wallclock(cd->flush_time));
 	len = strlen(tbuf);
 	if (p >= len)
 		return 0;
-- 
1.7.9.5

