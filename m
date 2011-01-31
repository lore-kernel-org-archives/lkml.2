Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab1AaPlW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 10:41:22 -0500
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:51109 "HELO
	cpoproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752550Ab1AaPlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 10:41:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=tao.ma;
	h=Received:From:To:Cc:Subject:Date:Message-Id:X-Mailer:In-Reply-To:References:X-Identified-User;
	b=w2TEvGmxTeEPOrEK7zomSLJMs7PXo3W3YMzCSmQtZEE/5HqQ6LdvSDXvK+6iYhKZ2idlCZuE95lp6AWKxKGoA+VZcvmpWm8+jfs+XNJQlHUtZ9SUdOduxy5QEAf/ewYa;
From: Tao Ma <tm@tao.ma>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Michel Lespinasse <walken@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2] mlock: set VM_WRITE in case we don't have read permission.
Date: Mon, 31 Jan 2011 23:41:03 +0800
Message-Id: <1296488463-15179-1-git-send-email-tm@tao.ma>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110131203943.4C77.A69D9226@jp.fujitsu.com>
References: <20110131203943.4C77.A69D9226@jp.fujitsu.com>
X-Identified-User: {1390:box585.bluehost.com:colyli:tao.ma} {sentby:smtp auth 114.251.86.0 authed with tm@tao.ma}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tao Ma <boyu.mt@taobao.com>

In 5ecfda0, we do some optimization in mlock, but it causes
a very basic test case(attached below) of mlock to fail. So
this patch add another check that if we don't have read permission,
still set FOLL_WRITE flag. Thank KOSAKI for the suggestion.
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

Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tao Ma <boyu.mt@taobao.com>
---
 mm/mlock.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 13e81ee..8508c5a 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -178,6 +178,13 @@ static long __mlock_vma_pages_range(struct vm_area_struct *vma,
 	if ((vma->vm_flags & (VM_WRITE | VM_SHARED)) == VM_WRITE)
 		gup_flags |= FOLL_WRITE;
 
+	/*
+	 * We don't have readable permission. Therefore we can't use read
+	 * operation even though it's faster.
+	 */
+	if ((vma->vm_flags & (VM_READ|VM_WRITE)) == VM_WRITE)
+		gup_flags |= FOLL_WRITE;
+
 	if (vma->vm_flags & VM_LOCKED)
 		gup_flags |= FOLL_MLOCK;
 
-- 
1.6.3.GIT

