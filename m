Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933693Ab1D2TDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 15:03:41 -0400
Received: from kroah.org ([198.145.64.141]:50337 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128Ab1D2S6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:58:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Apr 29 11:56:55 2011
Message-Id: <20110429185655.869230858@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Fri, 29 Apr 2011 11:55:57 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jonathan Nieder <jrnieder@gmail.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [34/55] [S390] pfault: fix token handling
In-Reply-To: <20110429185706.GA12824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Heiko Carstens <heiko.carstens@de.ibm.com>

commit e35c76cd47c244eaa7a74adaabde4d0a1cadb907 upstream.

f6649a7e "[S390] cleanup lowcore access from external interrupts" changed
handling of external interrupts. Instead of letting the external interrupt
handlers accessing the per cpu lowcore the entry code of the kernel reads
already all fields that are necessary and passes them to the handlers.
The pfault interrupt handler was incorrectly converted. It tries to
dereference a value which used to be a pointer to a lowcore field. After
the conversion however it is not anymore the pointer to the field but its
content. So instead of a dereference only a cast is needed to get the
task pointer that caused the pfault.

Fixes a NULL pointer dereference and a subsequent kernel crash:

Unable to handle kernel pointer dereference at virtual kernel address (null)
Oops: 0004 [#1] SMP
Modules linked in: nfsd exportfs nfs lockd fscache nfs_acl auth_rpcgss sunrpc
                   loop qeth_l3 qeth vmur ccwgroup ext3 jbd mbcache dm_mod
                   dasd_eckd_mod dasd_diag_mod dasd_mod
CPU: 0 Not tainted 2.6.38-2-s390x #1
Process cron (pid: 1106, task: 000000001f962f78, ksp: 000000001fa0f9d0)
Krnl PSW : 0404200180000000 000000000002c03e (pfault_interrupt+0xa2/0x138)
           R:0 T:1 IO:0 EX:0 Key:0 M:1 W:0 P:0 AS:0 CC:2 PM:0 EA:3
Krnl GPRS: 0000000000000000 0000000000000001 0000000000000000 0000000000000001
           000000001f962f78 0000000000518968 0000000090000002 000000001ff03280
           0000000000000000 000000000064f000 000000001f962f78 0000000000002603
           0000000006002603 0000000000000000 000000001ff7fe68 000000001ff7fe48
Krnl Code: 000000000002c036: 5820d010            l       %r2,16(%r13)
           000000000002c03a: 1832                lr      %r3,%r2
           000000000002c03c: 1a31                ar      %r3,%r1
          >000000000002c03e: ba23d010            cs      %r2,%r3,16(%r13)
           000000000002c042: a744fffc            brc     4,2c03a
           000000000002c046: a7290002            lghi    %r2,2
           000000000002c04a: e320d0000024        stg     %r2,0(%r13)
           000000000002c050: 07f0                bcr     15,%r0
Call Trace:
 ([<000000001f962f78>] 0x1f962f78)
  [<000000000001acda>] do_extint+0xf6/0x138
  [<000000000039b6ca>] ext_no_vtime+0x30/0x34
  [<000000007d706e04>] 0x7d706e04
Last Breaking-Event-Address:
  [<0000000000000000>] 0x0

For stable maintainers:
the first kernel which contains this bug is 2.6.37.

Reported-by: Stephen Powell <zlinuxman@wowway.com>
Cc: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/mm/fault.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/s390/mm/fault.c
+++ b/arch/s390/mm/fault.c
@@ -558,9 +558,9 @@ static void pfault_interrupt(unsigned in
 	 * Get the token (= address of the task structure of the affected task).
 	 */
 #ifdef CONFIG_64BIT
-	tsk = *(struct task_struct **) param64;
+	tsk = (struct task_struct *) param64;
 #else
-	tsk = *(struct task_struct **) param32;
+	tsk = (struct task_struct *) param32;
 #endif
 
 	if (subcode & 0x0080) {


