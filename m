Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab0DOFpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 01:45:16 -0400
Received: from mail-gx0-f227.google.com ([209.85.217.227]:37422 "EHLO
	mail-gx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab0DOFpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 01:45:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=oWi+zWKEUp0BQIZBp6qLbPEETUWEmuzW2mjWKDnrYuG7CV1BDPRQN7fUigCo04Hs14
         ygZ6udWmrMv68sIQhsc3vrDTEcLjSNtbAUFiEsT/eTK0OqmtDqs7wyqNtSQZ2QZQMlSf
         7Ges6JdvCkXb7cEXpoplmyYcI43i/aHyiEut0=
Date: Thu, 15 Apr 2010 13:51:32 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, jmorris@namei.org,
       eparis@parisplace.org
Subject: [RFC][PATCH] Security: fix cap_file_mmap() off-by-one error to avoid kernel null pointer exploit
Message-ID: <20100415055132.GA3921@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when addr < dac_mmap_min_addr, cap_file_mmap() will check the process 
CAP_SYS_RAWIO capability. some code from kernel null pointer exploit:

        if ((personality(0xffffffff)) != PER_SVR4) {
                if ((page = mmap(0x0, 0x1000, PROT_READ | PROT_WRITE, 
			MAP_FIXED | MAP_ANONYMOUS| MAP_PRIVATE, 0, 0))
			 == MAP_FAILED) {
                        perror("mmap");
                        return -1;
                }
        } else {
                if (mprotect(0x0, 0x1000, PROT_READ | PROT_WRITE | 
			PROT_EXEC) < 0) {
                        perror("mprotect");
                        return -1;
                }
        }
        printf("[+] Mmap zero memory ok.\n");

[root@localhost ~]# echo "1024" > /proc/sys/vm/mmap_min_addr
[wzt@localhost ~]$ ./exp
mmap: Operation not permitted

[root@localhost ~]# echo "1" > /proc/sys/vm/mmap_min_addr
[wzt@localhost ~]$ ./exp
mmap: Operation not permitted

[root@localhost ~]# echo "0" > /proc/sys/vm/mmap_min_addr
[wzt@localhost ~]$ ./exp
[+] Mmap zero memory ok.

[root@localhost ~]# cat /etc/selinux/config ;uname -a
SELINUX=enforcing
Linux localhost.localdomain 2.6.31.13 #4 SMP Wed Apr 14 17:51:21 
CST 2010 i686 i686 i386 GNU/Linux

if mmap_min_addr is equal 0, whether the process has the CAP_SYS_RAWIO 
capability or not, it can mmap zero memory. The administrator set 
dac_mmap_min_addr as 0 for some reason, the kernel null pointer bugs 
will be exploited again. when dac_mmap_min_addr equal 1, cap_file_mmap() 
will check it, but dac_mmap_min_addr equal 0, it not check it though the 
process not has the CAP_SYS_RAWIO capability. when kernel null pointer 
bug happens, eip is below PAGE_SIZE, that means if eip=0x00000001 
for example, and dac_mmap_min_addr=0, user process can mmap zero memory.
        *(char *)0 = '\x90';
        *(char *)1 = '\x90';
        *(char *)2 = '\xe9';
        *(unsigned long *)3 = (unsigned long)&exploit_code - 7;
the kernel null pointer bug can be exploited. So if the process not has the 
CAP_SYS_RAWIO capability, though the dac_mmap_min_addr is equal 0, it will 
not be mmapd in zero memory. Also fix the comment of cap_file_mmap().

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/commoncap.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 6166973..cc6b458 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -931,7 +931,7 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
  * @addr: address attempting to be mapped
  * @addr_only: unused
  *
- * If the process is attempting to map memory below mmap_min_addr they need
+ * If the process is attempting to map memory below dac_mmap_min_addr they need
  * CAP_SYS_RAWIO.  The other parameters to this function are unused by the
  * capability security module.  Returns 0 if this mapping should be allowed
  * -EPERM if not.
@@ -942,7 +942,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
 {
 	int ret = 0;
 
-	if (addr < dac_mmap_min_addr) {
+	if (addr <= dac_mmap_min_addr) {
 		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
 				  SECURITY_CAP_AUDIT);
 		/* set PF_SUPERPRIV if it turns out we allow the low mmap */
-- 
1.6.5.3

