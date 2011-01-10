Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754134Ab1AJOmc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 09:42:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8687 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203Ab1AJOmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 09:42:31 -0500
Message-ID: <4D2B1AD5.9000707@redhat.com>
Date: Mon, 10 Jan 2011 09:42:29 -0500
From: Dave Anderson <anderson@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080515)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: fweisbec@gmail.com
Subject: [PATCH] /proc/kcore: fix seeking
Content-Type: multipart/mixed;
 boundary="------------040509040604090007040104"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040509040604090007040104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

From: Dave Anderson <anderson@redhat.com>

Commit 34aacb2920667d405a8df15968b7f71ba46c8f18
("procfs: Use generic_file_llseek in /proc/kcore")
broke seeking on /proc/kcore.  This changes it back
to use default_llseek in order to restore the original
behavior.

The problem with generic_file_llseek is that it only
allows seeks up to inode->i_sb->s_maxbytes, which is
2GB-1 on procfs, where the memory file offset values in
the /proc/kcore PT_LOAD segments may exceed or start
beyond that offset value.

A similar revert was made for /proc/vmcore.

Signed-off-by: Dave Anderson <anderson@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
--

--------------040509040604090007040104
Content-Type: text/x-patch;
 name="kcore.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="kcore.patch"

--- linux-2.6.37/fs/proc/kcore.c.orig
+++ linux-2.6.37/fs/proc/kcore.c
@@ -558,7 +558,7 @@ static int open_kcore(struct inode *inod
 static const struct file_operations proc_kcore_operations = {
 	.read		= read_kcore,
 	.open		= open_kcore,
-	.llseek		= generic_file_llseek,
+	.llseek		= default_llseek,
 };
 
 #ifdef CONFIG_MEMORY_HOTPLUG

--------------040509040604090007040104--
