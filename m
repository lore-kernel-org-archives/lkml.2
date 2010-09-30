Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0I3MiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 08:38:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0I3MiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 08:38:22 -0400
Message-ID: <4CA484BA.7090809@redhat.com>
Date: Thu, 30 Sep 2010 14:38:18 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] procfs: fix numbering in /proc/locks
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The lock number in /proc/locks (first field) is implemented by a counter
(private field of struct seq_file) which is incremented at each call of
locks_show() and reset to 1 in locks_start() whatever the offset is. It
should be reset according to the actual position in the list.

Moreover, locks_show() can be called twice to print a single line thus
skipping a number. The counter should be incremented in locks_next().

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 locks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index ab24d49..49d7343 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2166,19 +2166,19 @@ static int locks_show(struct seq_file *f, void *v)
 	list_for_each_entry(bfl, &fl->fl_block, fl_block)
 		lock_get_status(f, bfl, (long)f->private, " ->");
 
-	f->private++;
 	return 0;
 }
 
 static void *locks_start(struct seq_file *f, loff_t *pos)
 {
 	lock_kernel();
-	f->private = (void *)1;
+	f->private = (void *) (*pos + 1);
 	return seq_list_start(&file_lock_list, *pos);
 }
 
 static void *locks_next(struct seq_file *f, void *v, loff_t *pos)
 {
+	f->private++;
 	return seq_list_next(v, &file_lock_list, pos);
 }
 
