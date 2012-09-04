Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682Ab2IDJZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:25:13 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:2899 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756576Ab2IDJZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:25:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,366,1344182400"; 
   d="scan'208";a="5781483"
From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-mm@kvack.org (open list:MEMORY MANAGEMENT),
        Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH] mm: fix mmap overflow checking
Date: Tue, 4 Sep 2012 17:23:00 +0800
Message-Id: <1346750580-11352-1-git-send-email-gaowanlong@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.12
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/04 17:24:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/04 17:24:49,
	Serialize complete at 2012/09/04 17:24:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

POSIX said that if the file is a regular file and the value of "off"
plus "len" exceeds the offset maximum established in the open file
description associated with fildes, mmap should return EOVERFLOW.

The following test from LTP can reproduce this bug.

	char tmpfname[256];
	void *pa = NULL;
	void *addr = NULL;
	size_t len;
	int flag;
	int fd;
	off_t off = 0;
	int prot;

	long page_size = sysconf(_SC_PAGE_SIZE);

	snprintf(tmpfname, sizeof(tmpfname), "/tmp/mmap_test_%d", getpid());
	unlink(tmpfname);
	fd = open(tmpfname, O_CREAT | O_RDWR | O_EXCL, S_IRUSR | S_IWUSR);
	if (fd == -1) {
		printf(" Error at open(): %s\n", strerror(errno));
		return 1;
	}
	unlink(tmpfname);

	flag = MAP_SHARED;
	prot = PROT_READ | PROT_WRITE;

	/* len + off > maximum offset */

	len = ULONG_MAX;
	if (len % page_size) {
		/* Lower boundary */
		len &= ~(page_size - 1);
	}

	off = ULONG_MAX;
	if (off % page_size) {
		/* Lower boundary */
		off &= ~(page_size - 1);
	}

	printf("off: %lx, len: %lx\n", (unsigned long)off, (unsigned long)len);
	pa = mmap(addr, len, prot, flag, fd, off);
	if (pa == MAP_FAILED && errno == EOVERFLOW) {
		printf("Test Pass: Error at mmap: %s\n", strerror(errno));
		return 0;
	}

	if (pa == MAP_FAILED)
		perror("Test FAIL: expect EOVERFLOW but get other error");
	else
		printf("Test FAIL : Expect EOVERFLOW but got no error\n");

	close(fd);
	munmap(pa, len);
	return 1;

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-mm@kvack.org (open list:MEMORY MANAGEMENT)
Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
---
 mm/mmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index ae18a48..5380764 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -980,6 +980,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 	struct mm_struct * mm = current->mm;
 	struct inode *inode;
 	vm_flags_t vm_flags;
+	off_t off = pgoff << PAGE_SHIFT;
 
 	/*
 	 * Does the application expect PROT_READ to imply PROT_EXEC?
@@ -1003,8 +1004,8 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
 		return -ENOMEM;
 
 	/* offset overflow? */
-	if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
-               return -EOVERFLOW;
+	if (off + len < off)
+		return -EOVERFLOW;
 
 	/* Too many mappings? */
 	if (mm->map_count > sysctl_max_map_count)
-- 
1.7.12

