Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755071Ab1LVJfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 04:35:41 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52316 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755057Ab1LVJfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 04:35:38 -0500
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <4EF2F9EB.7000006@jp.fujitsu.com>
Date: Thu, 22 Dec 2011 18:35:39 +0900
From: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.25) Gecko/20111213 Thunderbird/3.1.17
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] mm: mmap system call does not return EOVERFLOW
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the system call mmap(), if the value of "offset" plus "length"
exceeds the offset maximum of "off_t", the error EOVERFLOW should be
returned.

------------------------------------------------------------------------
void *mmap(void *addr, size_t length, int prot, int flags,
       	   int fd, off_t offset)
------------------------------------------------------------------------

Here is the detail how EOVERFLOW is returned:

The argument "offset" is shifted right by PAGE_SHIFT bits
in sys_mmap(mmap systemcall).

------------------------------------------------------------------------
sys_mmap(unsigned long addr, unsigned long len,
	unsigned long prot, unsigned long flags,
	unsigned long fd, unsigned long off)
{
	error = sys_mmap_pgoff(addr, len, prot, flags, fd, off >> PAGE_SHIFT);
}
------------------------------------------------------------------------

In sys_mmap_pgoff(addr, len, prot, flags, fd, pgoff), do_mmap_pgoff()
is called as follows:

------------------------------------------------------------------------
sys_mmap_pgoff(unsigned long addr, unsigned long len,
		unsigned long prot, unsigned long flags,
		unsigned long fd, unsigned long pgoff)
{
	retval = do_mmap_pgoff(file, addr, len, prot, flags, pgoff);
}
------------------------------------------------------------------------

In do_mmap_pgoff(file, addr, len, prot, flags, pgoff),
the code path which returns with the error EOVERFLOW exists already.

------------------------------------------------------------------------
do_mmap_pgoff(struct file *file, unsigned long addr,
		unsigned long len, unsigned long prot,
		unsigned long flags, unsigned long pgoff)
{
	if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
		return -EOVERFLOW;
}
------------------------------------------------------------------------

However, in this case, giving off=0xfffffffffffff000 and
len=0xfffffffffffff000 on x86_64 arch, EOVERFLOW is not
returned. It is because the argument, "off" and "len" are shifted right
by PAGE_SHIFT bits and thus the condition "(pgoff + (len >> PAGE_SHIFT)) < pgoff"
never becomes true.

To fix this bug, it is necessary to compare "off" plus "len"
with "off" by units of "off_t". The patch is here:

Signed-off-by: Naotaka Hamaguchi <n.hamaguchi@jp.fujitsu.com>
---
 mm/mmap.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index eae90af..e74e736 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -948,6 +948,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
        vm_flags_t vm_flags;
        int error;
        unsigned long reqprot = prot;
+       off_t off = pgoff << PAGE_SHIFT;
 
        /*
         * Does the application expect PROT_READ to imply PROT_EXEC?
@@ -971,7 +972,7 @@ unsigned long do_mmap_pgoff(struct file *file, unsigned long addr,
                return -ENOMEM;
 
        /* offset overflow? */
-       if ((pgoff + (len >> PAGE_SHIFT)) < pgoff)
+       if ((off + len) < off)
                return -EOVERFLOW;
 
        /* Too many mappings? */
-- 
1.7.7.4
---

