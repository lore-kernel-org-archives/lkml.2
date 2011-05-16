Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1EPMzx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:55:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63104 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753623Ab1EPMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:55:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=DaAEeGQRrp8NRt7jqRh2m5YS2v7DK5jOARlZhQ9JFqk065KDa0ueJi7jzM2q7fd1hE
         Oyg78Lw4NXk/XPnCiQ3NBhAkjw78S52MarCP/Unhnqo8aknQj+Nqa0tXipBXAcGgQOzj
         dKKRMGlo1Xt40xBtY9pqFPoB1F3B44Q0neKhA=
MIME-Version: 1.0
Date: Mon, 16 May 2011 20:55:51 +0800
Message-ID: <BANLkTikqKnQgyLr0OmL86iEHE95xB4Z50Q@mail.gmail.com>
Subject: [PATCH] sched: fix priority leakage in pick_next_highest_task_rt()
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Mike Galbraith <efault@gmx.de>, Yong Zhang <yong.zhang0@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When picking the second highest RT task for a given runqueue, if no
task found after scanning the queue of priority == idx, the next idx
should also be checked even in case that next is already existing, or
the window of priority leakage could be opened.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- a/kernel/sched_rt.c	2011-04-27 11:48:50.000000000 +0800
+++ b/kernel/sched_rt.c	2011-05-16 19:58:42.000000000 +0800
@@ -1166,6 +1166,8 @@ static struct task_struct *pick_next_hig
 	int idx;

 	for_each_leaf_rt_rq(rt_rq, rq) {
+		struct task_struct *this;
+
 		array = &rt_rq->active;
 		idx = sched_find_first_bit(array->bitmap);
 next_idx:
@@ -1173,6 +1175,7 @@ next_idx:
 			continue;
 		if (next && next->prio < idx)
 			continue;
+		this = NULL;
 		list_for_each_entry(rt_se, array->queue + idx, run_list) {
 			struct task_struct *p;

@@ -1181,11 +1184,15 @@ next_idx:

 			p = rt_task_of(rt_se);
 			if (pick_rt_task(rq, p, cpu)) {
-				next = p;
+				this = p;
 				break;
 			}
 		}
-		if (!next) {
+		if (this != NULL)
+			next = this;
+		else {	/*
+			 * we have to check next idx even if next != NULL
+			 */
 			idx = find_next_bit(array->bitmap, MAX_RT_PRIO, idx+1);
 			goto next_idx;
 		}
