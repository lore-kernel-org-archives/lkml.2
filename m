Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759563Ab0I0PNq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 11:13:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752196Ab0I0PNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 11:13:45 -0400
Message-ID: <4CA0B4A5.1090701@redhat.com>
Date: Mon, 27 Sep 2010 17:13:41 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pavel Emelianov <xemul@openvz.org>
Subject: [PATCH] procfs: fix numbering in /proc/locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The lock number in /proc/locks (first field) is implemented by a counter
(private field of struct seq_file) which is incremented at each call of
locks_show(). Currently it is reset each time locks_start() is called,
that is each time we call the read() syscall on /proc/locks. Because of
that, the numbering erratically restarts at 1 several times when reading
a long /proc/locks file.
We want the counter to be initialized at opening time and then never
reset until we close the file. Fortunately, seq_open() memzeros the
seq_file structure, so we can just drop the reset in locks_start() and
move the increment the counter before actually printing the line so the
numbering still starts at 1.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..a5eab5e 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2161,19 +2161,18 @@ static int locks_show(struct seq_file *f, void *v)
 
 	fl = list_entry(v, struct file_lock, fl_link);
 
+	f->private++;
 	lock_get_status(f, fl, (long)f->private, "");
 
 	list_for_each_entry(bfl, &fl->fl_block, fl_block)
 		lock_get_status(f, bfl, (long)f->private, " ->");
 
-	f->private++;
 	return 0;
 }
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
 {
 	lock_kernel();
-	f->private = (void *)1;
 	return seq_list_start(&file_lock_list, *pos);
 }
 
