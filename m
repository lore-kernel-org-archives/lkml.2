Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253Ab0FYUMI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 16:12:08 -0400
Received: from mail.tpi.com ([70.99.223.143]:4230 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932103Ab0FYUME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 16:12:04 -0400
Message-ID: <4C250D8C.6030907@canonical.com>
Date: Fri, 25 Jun 2010 14:11:56 -0600
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: xiaosuo@gmail.com
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Regression caused by commit cc56f7de7f00d188c7c4da1e9861581853b9e92f
Content-Type: multipart/mixed;
 boundary="------------040206020008030700020201"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040206020008030700020201
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

I have bisected a strange regression down to this commit that you made. 
If I apply the attached patch (which restores the original 2 lines of 
code), then everything works correctly. I apologize, but I don't have a 
simple reproducer. The gist of the problem is that Java cannot decrypt a 
file under certain circumstances, e.g., "ERROR 
javax.crypto.BadPaddingException: pad block corrupted". There is more 
information in the bug report at http://bugs.launchpad.net/bugs/588861 , 
but not all of it is helpful.

Any thoughts?

rtg
-- 
Tim Gardner tim.gardner@canonical.com

--------------040206020008030700020201
Content-Type: text/x-patch;
 name="0001-fs-Restore-previously-removed-f_op-checks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-fs-Restore-previously-removed-f_op-checks.patch"

>From 8565505534da369292d593e174255cf5c398f703 Mon Sep 17 00:00:00 2001
From: Tim Gardner <tim.gardner@canonical.com>
Date: Fri, 25 Jun 2010 13:53:55 -0600
Subject: [PATCH] fs: Restore previously removed f_op checks.

BugLink: http://bugs.launchpad.net/bugs/588861

commit cc56f7de7f00d188c7c4da1e9861581853b9e92f removed
a check for output file f_op and f_op->sendpage. This appears
to have caused a regression in the ability of Java
to read and decrypt files. This would be simpler if
there was an easy reproducer, but so far the only way I've
been able to get it to fail is within the Maverick
UEC environment.

Signed-off-by: Tim Gardner <tim.gardner@canonical.com>
---
 fs/read_write.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 9c04852..3203ca1 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -845,6 +845,8 @@ static ssize_t do_sendfile(int out_fd, int in_fd, loff_t *ppos,
 	if (!(out_file->f_mode & FMODE_WRITE))
 		goto fput_out;
 	retval = -EINVAL;
+	if (!out_file->f_op || !out_file->f_op->sendpage)
+		goto fput_out;
 	in_inode = in_file->f_path.dentry->d_inode;
 	out_inode = out_file->f_path.dentry->d_inode;
 	retval = rw_verify_area(WRITE, out_file, &out_file->f_pos, count);
-- 
1.7.0.4


--------------040206020008030700020201--
