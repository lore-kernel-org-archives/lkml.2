Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab0IOKGH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 06:06:07 -0400
Received: from hera.kernel.org ([140.211.167.34]:40067 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab0IOKGF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 06:06:05 -0400
Date: Wed, 15 Sep 2010 10:05:39 GMT
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1284512670-2369-6-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-6-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] kprobes: Add sparse context annotations
Message-ID: <tip-635c17c2b2b4e5cd34f5dcba19d751b4e58533c2@git.kernel.org>
Git-Commit-ID: 635c17c2b2b4e5cd34f5dcba19d751b4e58533c2
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 15 Sep 2010 10:05:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  635c17c2b2b4e5cd34f5dcba19d751b4e58533c2
Gitweb:     http://git.kernel.org/tip/635c17c2b2b4e5cd34f5dcba19d751b4e58533c2
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 15 Sep 2010 10:04:30 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 15 Sep 2010 10:44:02 +0200

kprobes: Add sparse context annotations

This removes following warnings when build with C=1

 warning: context imbalance in 'kretprobe_hash_lock' - wrong count at exit
 warning: context imbalance in 'kretprobe_table_lock' - wrong count at exit
 warning: context imbalance in 'kretprobe_hash_unlock' - unexpected unlock
 warning: context imbalance in 'kretprobe_table_unlock' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
LKML-Reference: <1284512670-2369-6-git-send-email-namhyung@gmail.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/kprobes.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index c53aad5..6dd5359 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -831,6 +831,7 @@ void __kprobes recycle_rp_inst(struct kretprobe_instance *ri,
 
 void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
 			 struct hlist_head **head, unsigned long *flags)
+__acquires(hlist_lock)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
 	spinlock_t *hlist_lock;
@@ -842,6 +843,7 @@ void __kprobes kretprobe_hash_lock(struct task_struct *tsk,
 
 static void __kprobes kretprobe_table_lock(unsigned long hash,
 	unsigned long *flags)
+__acquires(hlist_lock)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_lock_irqsave(hlist_lock, *flags);
@@ -849,6 +851,7 @@ static void __kprobes kretprobe_table_lock(unsigned long hash,
 
 void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
 	unsigned long *flags)
+__releases(hlist_lock)
 {
 	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
 	spinlock_t *hlist_lock;
@@ -859,6 +862,7 @@ void __kprobes kretprobe_hash_unlock(struct task_struct *tsk,
 
 static void __kprobes kretprobe_table_unlock(unsigned long hash,
        unsigned long *flags)
+__releases(hlist_lock)
 {
 	spinlock_t *hlist_lock = kretprobe_table_lock_ptr(hash);
 	spin_unlock_irqrestore(hlist_lock, *flags);
