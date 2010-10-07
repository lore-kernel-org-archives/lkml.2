Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602Ab0JGBVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 21:21:14 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:58367 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388Ab0JGBVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 21:21:13 -0400
Subject: [PATCH v2] IPC: Initialize structure memory to zero for compat
 functions
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 21:21:11 -0400
Message-ID: <1286414471.4645.156.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore the previous patch, no sense in splitting these up.

This takes care of leaking uninitialized kernel stack memory to
userspace from non-zeroed fields in structs in compat ipc functions.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

diff -urp linux-2.6.35.5.orig/ipc/compat.c linux-2.6.35.5/ipc/compat.c
--- linux-2.6.35.5.orig/ipc/compat.c	2010-09-20 16:59:09.000000000 -0400
+++ linux-2.6.35.5/ipc/compat.c	2010-10-06 21:19:04.000000000 -0400
@@ -237,7 +237,7 @@ long compat_sys_semctl(int first, int se
 	union semun fourth;
 	u32 pad;
 	int err, err2;
-	struct semid64_ds s64;
+	struct semid64_ds s64 = {};
 	struct semid64_ds __user *up64;
 	int version = compat_ipc_parse_version(&third);
 
@@ -417,7 +417,7 @@ static inline int put_compat_msqid_ds(st
 long compat_sys_msgctl(int first, int second, void __user *uptr)
 {
 	int err, err2;
-	struct msqid64_ds m64;
+	struct msqid64_ds m64 = {};
 	int version = compat_ipc_parse_version(&second);
 	void __user *p;
 
diff -urp linux-2.6.35.5.orig/ipc/compat_mq.c linux-2.6.35.5/ipc/compat_mq.c
--- linux-2.6.35.5.orig/ipc/compat_mq.c	2010-09-20 16:59:09.000000000 -0400
+++ linux-2.6.35.5/ipc/compat_mq.c	2010-10-06 20:55:08.000000000 -0400
@@ -52,7 +52,7 @@ asmlinkage long compat_sys_mq_open(const
 {
 	void __user *p = NULL;
 	if (u_attr && oflag & O_CREAT) {
-		struct mq_attr attr;
+		struct mq_attr attr = {};
 		p = compat_alloc_user_space(sizeof(attr));
 		if (get_compat_mq_attr(&attr, u_attr) ||
 		    copy_to_user(p, &attr, sizeof(attr)))
@@ -123,7 +123,7 @@ asmlinkage long compat_sys_mq_getsetattr
 			const struct compat_mq_attr __user *u_mqstat,
 			struct compat_mq_attr __user *u_omqstat)
 {
-	struct mq_attr mqstat;
+	struct mq_attr mqstat = {};
 	struct mq_attr __user *p = compat_alloc_user_space(2 * sizeof(*p));
 	long ret;
 



