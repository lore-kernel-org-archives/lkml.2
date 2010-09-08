Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0IHWzC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:55:02 -0400
Received: from tex.lwn.net ([70.33.254.29]:38672 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755835Ab0IHWy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:54:56 -0400
Date: Wed, 8 Sep 2010 16:54:54 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@ZenIV.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] lglock: make lg_lock_global() actually lock globally
Message-ID: <20100908165454.40f0710f@bike.lwn.net>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lg_lock_global() currently only acquires spinlocks for online CPUs, but
it's meant to lock all possible CPUs.  Lglock-protected resources may be
associated with removed CPUs - and, indeed, that could happen with the
per-superblock open files lists.  At Nick's suggestion, change
for_each_online_cpu() to for_each_possible_cpu() to protect accesses to
those resources.

Cc: Al Viro <viro@ZenIV.linux.org.uk>
Acked-by: Nick Piggin <npiggin@kernel.dk>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 include/linux/lglock.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/lglock.h b/include/linux/lglock.h
index b288cb7..f549056 100644
--- a/include/linux/lglock.h
+++ b/include/linux/lglock.h
@@ -150,7 +150,7 @@
 	int i;								\
 	preempt_disable();						\
 	rwlock_acquire(&name##_lock_dep_map, 0, 0, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_possible_cpu(i) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_lock(lock);					\
@@ -161,7 +161,7 @@
  void name##_global_unlock(void) {					\
 	int i;								\
 	rwlock_release(&name##_lock_dep_map, 1, _RET_IP_);		\
-	for_each_online_cpu(i) {					\
+	for_each_possible_cpu(i) {					\
 		arch_spinlock_t *lock;					\
 		lock = &per_cpu(name##_lock, i);			\
 		arch_spin_unlock(lock);					\
-- 
1.7.2.1

