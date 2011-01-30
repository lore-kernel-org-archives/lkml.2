Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1A3HP4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 02:15:56 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:39307 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751165Ab1A3HPz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 02:15:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:X-Identified-User;
	b=M96EAhbJNtA3xzee58R1Ta1z09UyKTiTJ0A7+q+NQsj6BL/+JoeKUL2AQVWkySi4NLWvTSMChBmMaAFsG6tWaOy3wlbGJZvlchqeGx/3b3QratFTPiEw55NXnq5IHdxv;
From: Tao Ma <tm@tao.ma>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mlock: revert the optimization for dirtying pages and triggering writeback.
Date: Sun, 30 Jan 2011 15:15:20 +0800
Message-Id: <1296371720-4176-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 5ecfda0, we do some optimization in mlock, but it causes
a very basic test case(attached below) of mlock to fail. So
this patch revert it with some tiny modification so that it
apply successfully with the lastest 38-rc2 kernel.
The test program is attached below.

#include <sys/mman.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/types.h>

int main()
{
	char *buf, *testfile = "test_mmap";
	int fd, file_len = 40960, ret = -1;

	fd = open(testfile, O_RDWR);
	if (fd < 0) {
		perror("open");
		return -1;
	}

	if (ftruncate(fd, file_len) < 0) {
		perror("ftruncate");
		goto out;
	}

	buf = mmap(NULL, file_len, PROT_WRITE, MAP_SHARED, fd, 0);
	if (buf == MAP_FAILED) {
		perror("mmap");
		goto out;
	}

	if (mlock(buf, file_len) < 0) {
		perror("mlock");
		goto out;
	}

	munlock(buf, file_len);
	munmap(buf, file_len);
	ret = 0;
out:
	close(fd);
	return ret;
}

Cc: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 mm/mlock.c |    8 ++------
 1 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 13e81ee..76e106c 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -170,12 +170,8 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	VM_BUG_ON(!rwsem_is_locked(&mm->mmap_sem));
 
 	gup_flags = FOLL_TOUCH;
-	/*
-	 * We want to touch writable mappings with a write fault in order
-	 * to break COW, except for shared mappings because these don't COW
-	 * and we would not want to dirty them for nothing.
-	 */
-	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
+
+	if (vma->vm_flags & VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
 	if (vma->vm_flags & VM_LOCKED)
-- 
1.6.3.GIT

