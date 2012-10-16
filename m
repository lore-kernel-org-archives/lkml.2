Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866Ab2JPXaz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 19:30:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755696Ab2JPXay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 19:30:54 -0400
Date: Tue, 16 Oct 2012 19:30:49 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: [PATCH] percpu-rwsem: use barrier in unlock path
In-Reply-To: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1210161924350.20581@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1210151716310.10685@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

When I read my patch 62ac665ff9fc07497ca524bd20d6a96893d11071 again, it 
turns out that it is missing a barrier in percpu_up_write. Please apply 
this.

Mikulas

---

percpu-rwsem: use barrier in unlock path

Fix missing barrier in patch 62ac665ff9fc07497ca524bd20d6a96893d11071.

The lock is considered unlocked when p->locked is set to false.
Use barrier prevent reordering of operations around p->locked.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 include/linux/percpu-rwsem.h |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: linux-3.6.2-fast/include/linux/percpu-rwsem.h
===================================================================
--- linux-3.6.2-fast.orig/include/linux/percpu-rwsem.h	2012-10-17 01:17:55.000000000 +0200
+++ linux-3.6.2-fast/include/linux/percpu-rwsem.h	2012-10-17 01:21:46.000000000 +0200
@@ -66,6 +66,15 @@ static inline void percpu_down_write(str
 
 static inline void percpu_up_write(struct percpu_rw_semaphore *p)
 {
+	/*
+	 * The lock is considered unlocked when p->locked is set to false.
+	 * Use barrier prevent reordering of operations around p->locked.
+	 */
+#if defined(CONFIG_X86) && (!defined(CONFIG_X86_PPRO_FENCE) && !defined(CONFIG_X86_OOSTORE))
+	barrier();
+#else
+	smp_mb();
+#endif
 	p->locked = false;
 	mutex_unlock(&p->mtx);
 }

