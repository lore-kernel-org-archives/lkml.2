Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755794Ab0C3GVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:21:21 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32918 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755647Ab0C3GUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:20:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=U6JsW9d8fVjwc34bpg7+6OA80qFk3w7B0/PLUWkvRbEZdZ4tmpjmtmnZPlLaiH1gBq
         anNi9ZMRVJPqshkTuAvMl9oADBxhbXc3jS/cvNND+UT01LrFee+H1E4jm9Ei+kdvAxWz
         PKrCE/a9HY9TQuw4KCYx+ay8AuxR7aR2+dE30=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 2/6] procfs: Use generic_file_llseek in /proc/kcore
Date: Tue, 30 Mar 2010 08:20:11 +0200
Message-Id: <1269930015-863-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/kcore has no llseek and then falls down to use default_llseek.
This is racy against read_kcore() that directly manipulates fpos
but it doesn't hold the bkl there so using it in llseek doesn't
protect anything.

Let's use generic_file_llseek() instead.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: John Kacur <jkacur@redhat.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 fs/proc/kcore.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/kcore.c b/fs/proc/kcore.c
index a44a789..da21060 100644
--- a/fs/proc/kcore.c
+++ b/fs/proc/kcore.c
@@ -557,6 +557,7 @@ static int open_kcore(struct inode *inode, struct file *filp)
 static const struct file_operations proc_kcore_operations = {
 	.read		= read_kcore,
 	.open		= open_kcore,
+	.llseek		= generic_file_llseek,
 };
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-- 
1.6.2.3

