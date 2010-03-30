Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755697Ab0C3GUW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 02:20:22 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:32918 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671Ab0C3GUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 02:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=DUqns7tDM2Gy07rlRbi9tlGfXHr/8mW60a1jzBBey/9aMN0DG5DW1J/eyEPbUkOLqz
         RpXc0KSUdnziusymaEnTCGxoh1IPrsX07kh0itczvTKzgiFMEoGu33qoLVRE2fOmIWE0
         scYeOhgOWs4Nx4lyPcS6fQbsH3exFXtquyZMA=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Al Viro <viro@ZenIV.linux.org.uk>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 4/6] procfs: Use generic_file_llseek in /proc/vmcore
Date: Tue, 30 Mar 2010 08:20:13 +0200
Message-Id: <1269930015-863-5-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
References: <1269930015-863-1-git-send-regression-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/vmcore has no llseek and then falls down to use default_llseek.
This is racy against read_vmcore() that directly manipulates fpos
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
 fs/proc/vmcore.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 0872afa..f942ecb 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -162,6 +162,7 @@ static ssize_t read_vmcore(struct file *file, char __user *buffer,
 
 static const struct file_operations proc_vmcore_operations = {
 	.read		= read_vmcore,
+	.lseek		= generic_file_llseek,
 };
 
 static struct vmcore* __init get_new_element(void)
-- 
1.6.2.3

