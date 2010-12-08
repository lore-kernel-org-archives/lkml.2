Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab0LHArD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:47:03 -0500
Received: from kroah.org ([198.145.64.141]:45988 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab0LHAqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:46:55 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:44:27 2010
Message-Id: <20101208004427.356573938@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:43:36 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: [030/127] ipc: initialize structure memory to zero for compat functions
In-Reply-To: <20101208004456.GA23578@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

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

---
 ipc/compat.c    |    6 ++++++
 ipc/compat_mq.c |    5 +++++
 2 files changed, 11 insertions(+)

--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -242,6 +242,8 @@ long compat_sys_semctl(int first, int se
 	struct semid64_ds __user *up64;
 	int version = compat_ipc_parse_version(&third);
 
+	memset(&s64, 0, sizeof(s64));
+
 	if (!uptr)
 		return -EINVAL;
 	if (get_user(pad, (u32 __user *) uptr))
@@ -422,6 +424,8 @@ long compat_sys_msgctl(int first, int se
 	int version = compat_ipc_parse_version(&second);
 	void __user *p;
 
+	memset(&m64, 0, sizeof(m64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_INFO:
 	case IPC_RMID:
@@ -595,6 +599,8 @@ long compat_sys_shmctl(int first, int se
 	int err, err2;
 	int version = compat_ipc_parse_version(&second);
 
+	memset(&s64, 0, sizeof(s64));
+
 	switch (second & (~IPC_64)) {
 	case IPC_RMID:
 	case SHM_LOCK:
--- a/ipc/compat_mq.c
+++ b/ipc/compat_mq.c
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


