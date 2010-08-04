Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796Ab0HDUw7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:52:59 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35816 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934429Ab0HDUww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:52:52 -0400
X-Authenticated: #11648398
X-Provags-ID: V01U2FsdGVkX18t6fRt6WYtseSUn/fmG2dxnGsCWTXvw8vgQSS33U
	WY3urozVr4zcCB
Date: Wed, 4 Aug 2010 22:52:46 +0200
From: Jan Andres <jandres@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [PATCH v2] isofs: Fix lseek() to position beyond 4 GB
Message-ID: <20100804205245.GA5312@pitr.home.jan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803211814.GA4436@pitr.home.jan>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

isofs supports files larger than 4 GB by using multi-extent files.
However an lseek() to a position beyond 4 GB in such a file will
fail with EINVAL, because s_maxbytes in the isofs superblock is
initialized to 2^32-1, and generic_file_llseek() checks against
that value.

I therefore suggest increasing the value of s_maxbytes to have
full support for large files in isofs. With multi-extent files, file
size is only limited by the maximum size of the file system (8 TB),
so this seems a reasonable value for s_maxbytes.

Signed-off-by: Jan Andres <jandres@gmx.net>


--- linux-2.6.35-j7/fs/isofs/inode.c.orig	2010-08-02 00:11:14.000000000 +0200
+++ linux-2.6.35-j7/fs/isofs/inode.c	2010-08-04 22:49:02.000000000 +0200
@@ -722,7 +722,12 @@ root_found:
 	}
 
 	s->s_magic = ISOFS_SUPER_MAGIC;
-	s->s_maxbytes = 0xffffffff; /* We can handle files up to 4 GB */
+
+	/*
+	 * With multi-extent files, file size is only limited by the maximum
+	 * size of a file system, which is 8 TB.
+	 */
+	s->s_maxbytes = 0x80000000000LL;
 
 	/*
 	 * The CDROM is read-only, has no nodes (devices) on it, and since
