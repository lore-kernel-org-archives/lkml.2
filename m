Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0LMAQD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 19:16:03 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35987 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab0LLXqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:46:22 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: drosenberg@vsecurity.com, manfred@colorfullife.com, arnd@arndb.de,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: [PATCH] [82/223] ipc: initialize structure memory to zero for compat functions
Message-Id: <20101212234621.77FC7B27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:46:21 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 03145beb455cf5c20a761e8451e30b8a74ba58d9 upstream.

This takes care of leaking uninitialized kernel stack memory to
userspace from non-zeroed fields in structs in compat ipc functions.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 ipc/compat.c    |    6 ++++++
 ipc/compat_mq.c |    5 +++++
 2 files changed, 11 insertions(+)

Index: linux/ipc/compat.c
===================================================================
--- linux.orig/ipc/compat.c
+++ linux/ipc/compat.c
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
Index: linux/ipc/compat_mq.c
===================================================================
--- linux.orig/ipc/compat_mq.c
+++ linux/ipc/compat_mq.c
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
