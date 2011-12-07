Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933670Ab1LGQeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 11:34:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:34518 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933679Ab1LGQYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 11:24:39 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Dec  7 08:12:21 2011
Message-Id: <20111207161221.779235017@clark.kroah.org>
User-Agent: quilt/0.50-23.1
Date: Wed, 07 Dec 2011 08:12:27 -0800
From: Greg KH <gregkh@suse.de>
To: <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Cc: <torvalds@linux-foundation.org>, <akpm@linux-foundation.org>,
        <alan@lxorguk.ukuu.org.uk>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [085/104] [S390] add missing .set function for NT_S390_LAST_BREAK regset
In-Reply-To: <20111207161246.GA10995@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

commit b934069c991355d27a053a932591c77960f4e414 upstream.

The last breaking event address is a read-only value, the regset misses the
.set function. If a PTRACE_SETREGSET is done for NT_S390_LAST_BREAK we
get an oops due to a branch to zero:

Kernel BUG at 0000000000000002 verbose debug info unavailable
illegal operation: 0001 #1 SMP
...
Call Trace:
(<0000000000158294> ptrace_regset+0x184/0x188)
 <00000000001595b6> ptrace_request+0x37a/0x4fc
 <0000000000109a78> arch_ptrace+0x108/0x1fc
 <00000000001590d6> SyS_ptrace+0xaa/0x12c
 <00000000005c7a42> sysc_noemu+0x16/0x1c
 <000003fffd5ec10c> 0x3fffd5ec10c
Last Breaking-Event-Address:
 <0000000000158242> ptrace_regset+0x132/0x188

Add a nop .set function to prevent the branch to zero.

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/s390/kernel/ptrace.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/arch/s390/kernel/ptrace.c
+++ b/arch/s390/kernel/ptrace.c
@@ -897,6 +897,14 @@ static int s390_last_break_get(struct ta
 	return 0;
 }
 
+static int s390_last_break_set(struct task_struct *target,
+			       const struct user_regset *regset,
+			       unsigned int pos, unsigned int count,
+			       const void *kbuf, const void __user *ubuf)
+{
+	return 0;
+}
+
 #endif
 
 static const struct user_regset s390_regsets[] = {
@@ -923,6 +931,7 @@ static const struct user_regset s390_reg
 		.size = sizeof(long),
 		.align = sizeof(long),
 		.get = s390_last_break_get,
+		.set = s390_last_break_set,
 	},
 #endif
 };
@@ -1080,6 +1089,14 @@ static int s390_compat_last_break_get(st
 	return 0;
 }
 
+static int s390_compat_last_break_set(struct task_struct *target,
+				      const struct user_regset *regset,
+				      unsigned int pos, unsigned int count,
+				      const void *kbuf, const void __user *ubuf)
+{
+	return 0;
+}
+
 static const struct user_regset s390_compat_regsets[] = {
 	[REGSET_GENERAL] = {
 		.core_note_type = NT_PRSTATUS,
@@ -1103,6 +1120,7 @@ static const struct user_regset s390_com
 		.size = sizeof(long),
 		.align = sizeof(long),
 		.get = s390_compat_last_break_get,
+		.set = s390_compat_last_break_set,
 	},
 	[REGSET_GENERAL_EXTENDED] = {
 		.core_note_type = NT_S390_HIGH_GPRS,


