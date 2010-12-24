Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751270Ab0LXJRb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 04:17:31 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:38640 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0LXJR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 04:17:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=aWAJ5qlp8V2aClOa270m9XqCWCkftKu4LjaKeuWLkcse8pOk1h1+jIWQO5IBORS27F
         LQPYYxe/OeGuWamQmh7+43J3fkW7L3PT8WkEAEmyoS4WkBqyN07iO8xd7Tw5xRe0pfMS
         OKhvLv2AhQZ1zBHl0SwbQrL88QClPf7UGpxZw=
From: Namhyung Kim <namhyung@gmail.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH] compat: fix use of an uninitialized variable in compat_sys_io_setup()
Date: Fri, 24 Dec 2010 18:16:26 +0900
Message-Id: <1293182186-23462-1-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.3.4.600.g982838b0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The upper bytes of ctx64 might contain garbages because it was
set by get_user() which copied only lower 4 bytes as its second
argument points to. Since sys_io_setup() requires its argumet
is properly initialized to 0 we should set it explicitly.

On x86, this was not a problem since its implementation of
get_user() does a C assignment so that it can fill upper bytes
with 0's. But other archs that use __get_user_asm() or something
might have a problem.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
---
 fs/compat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/compat.c b/fs/compat.c
index 4376e07febbb..b074e9f79148 100644
--- a/fs/compat.c
+++ b/fs/compat.c
@@ -526,7 +526,7 @@ asmlinkage long
 compat_sys_io_setup(unsigned nr_reqs, u32 __user *ctx32p)
 {
 	long ret;
-	aio_context_t ctx64;
+	aio_context_t ctx64 = 0;
 
 	mm_segment_t oldfs = get_fs();
 	if (unlikely(get_user(ctx64, ctx32p)))
-- 
1.7.3.4.600.g982838b0

