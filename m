Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004Ab0IOBFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:05:09 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38459 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754876Ab0IOBFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:05:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=s83NPNi0OgiAt+mkMxjJFTOLlOXDBgaTIpi6TRRCuRK38taFsokSHfvSc5wwC3vj1X
         aG7S/0FhssAxSgXA+tmFKFXx7JdguSokWcyWZmLhk0KHurdJMsySXk6HtJpqbYDwTHFB
         tz+eL0UvtQ9m9pSPnMRs9S5azewZlhg3vWyG8=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] kprobes: add sparse context annotations
Date: Wed, 15 Sep 2010 10:04:30 +0900
Message-Id: <1284512670-2369-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
References: <1284512670-2369-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this removes following warnings when build with C=1

 warning: context imbalance in 'kretprobe_hash_lock' - wrong count at exit
 warning: context imbalance in 'kretprobe_table_lock' - wrong count at exit
 warning: context imbalance in 'kretprobe_hash_unlock' - unexpected unlock
 warning: context imbalance in 'kretprobe_table_unlock' - unexpected unlock

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
-- 
1.7.2.2

