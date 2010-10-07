Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759939Ab0JGCep (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 22:34:45 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:51420 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0JGCeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 22:34:44 -0400
Subject: [PATCH v3] IPC: Initialize structure memory to zero for compat
 functions
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: linux-kernel@vger.kernel.org
Cc: stable@kernel.org, security@kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Oct 2010 22:34:41 -0400
Message-ID: <1286418881.4645.253.camel@Dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated to include compat shmctl() structs.  Now using memset().

This takes care of leaking uninitialized kernel stack memory to
userspace from non-zeroed fields in structs in compat ipc functions.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>

diff -urp linux-2.6.35.5.orig/ipc/compat.c linux-2.6.35.5/ipc/compat.c
--- linux-2.6.35.5.orig/ipc/compat.c	2010-09-20 16:59:09.000000000 -0400
+++ linux-2.6.35.5/ipc/compat.c	2010-10-06 22:17:21.000000000 -0400
@@ -241,6 +241,8 @@ long compat_sys_semctl(int first, int se
 	struct semid64_ds __user *up64;
 	int version = compat_ipc_parse_version(&third);
 
+	memset(&s64, 0, sizeof(s64));
+
 	if (!uptr)
 		return -EINVAL;
 	if (get_user(pad, (u32 __user *) uptr))
@@ -421,6 +423,8 @@ long compat_sys_msgctl(int first, int se
 	int version = compat_ipc_parse_version(&second);
 	void __user *p;
 
+	memset(&m64, 0, sizeof(m64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_INFO:
 	case IPC_RMID:
@@ -594,6 +598,8 @@ long compat_sys_shmctl(int first, int se
 	int err, err2;
 	int version = compat_ipc_parse_version(&second);
 
+	memset(&s64, 0, sizeof(s64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_RMID:
 	case SHM_LOCK:
diff -urp linux-2.6.35.5.orig/ipc/compat_mq.c linux-2.6.35.5/ipc/compat_mq.c
--- linux-2.6.35.5.orig/ipc/compat_mq.c	2010-09-20 16:59:09.000000000 -0400
+++ linux-2.6.35.5/ipc/compat_mq.c	2010-10-06 22:15:32.000000000 -0400
@@ -53,6 +53,9 @@ asmlinkage long compat_sys_mq_open(const
 	void __user *p = NULL;
 	if (u_attr && oflag & O_CREAT) {
 		struct mq_attr attr;
+
+		memset(&attr, 0, sizeof(attr));
+
 		p = compat_alloc_user_space(sizeof(attr));
 		if (get_compat_mq_attr(&attr, u_attr) ||
 		    copy_to_user(p, &attr, sizeof(attr)))
@@ -127,6 +130,8 @@ asmlinkage long compat_sys_mq_getsetattr
 	struct mq_attr __user *p = compat_alloc_user_space(2 * sizeof(*p));
 	long ret;
 
+	memset(&mqstat, 0, sizeof(mqstat));
+
 	if (u_mqstat) {
 		if (get_compat_mq_attr(&mqstat, u_mqstat) ||
 		    copy_to_user(p, &mqstat, sizeof(mqstat)))


