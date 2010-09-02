Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab0IBFDY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 01:03:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:53174 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab0IBFDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 01:03:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer:in-reply-to:references;
        b=wnsuRFap9uDdgb2KJA4C+eSftIK8ia+XqIdZtRJG9NNl/BJiCTj9FNmk8yRAIjKryn
         bfvq2hQOwpDAuNutQy/axyPCS062HPkYjBE9z9XFtfUDtDUMT7hkf+bgMVAwMcg4Nr6d
         OVaiKxgczYFGnkqtSLtmqw+Qf/mKf0rhuzdn8=
From: Namhyung Kim <namhyung@gmail.com>
To: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5/5] kprobes: add sparse context annotations
Date: Thu,  2 Sep 2010 14:02:38 +0900
Message-Id: <1283403758-3827-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
References: <1283403758-3827-1-git-send-email-namhyung@gmail.com>
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

