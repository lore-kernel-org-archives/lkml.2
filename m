Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab0I3KrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 06:47:17 -0400
Received: from ra.se.axis.com ([195.60.68.13]:42150 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750996Ab0I3KrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 06:47:16 -0400
From: Mikael Starvik <mikael.starvik@axis.com>
To: Namhyung Kim <namhyung@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesper Nilsson <jespern@axis.com>
Date: Thu, 30 Sep 2010 12:36:01 +0200
Subject: RE: [PATCH RESEND v3 08/24] ptrace: cleanup arch_ptrace() on cris
Thread-Topic: [PATCH RESEND v3 08/24] ptrace: cleanup arch_ptrace() on cris
Thread-Index: ActghSgPP194zN4xTKCji0fPSlNbDQABhpew
Message-ID: <4BEA3FF3CAA35E408EA55C7BE2E61D05583D6DB732@xmail3.se.axis.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
 <1285838880-4977-9-git-send-email-namhyung@gmail.com>
In-Reply-To: <1285838880-4977-9-git-send-email-namhyung@gmail.com>
Accept-Language: sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: sv-SE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mikael Starvik <starvik@axis.com>

-----Original Message-----
From: Namhyung Kim [mailto:namhyung@gmail.com] 
Sent: den 30 september 2010 11:28
To: Andrew Morton
Cc: Roland McGrath; Oleg Nesterov; linux-kernel@vger.kernel.org; Mikael Starvik; Jesper Nilsson
Subject: [PATCH RESEND v3 08/24] ptrace: cleanup arch_ptrace() on cris

Use new 'regno' variable in order to remove redandunt expression and
remove checking @addr less than 0 because @addr is now unsigned.
Also update 'datap' on PTRACE_GET/SETREGS to fix a bug on arch-v10.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Cc: Mikael Starvik <starvik@axis.com>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/kernel/ptrace.c |   17 ++++++++---------
 arch/cris/arch-v32/kernel/ptrace.c |   13 ++++++-------
 2 files changed, 14 insertions(+), 16 deletions(-)

diff --git a/arch/cris/arch-v10/kernel/ptrace.c b/arch/cris/arch-v10/kernel/ptrace.c
index d411e02..320065f 100644
--- a/arch/cris/arch-v10/kernel/ptrace.c
+++ b/arch/cris/arch-v10/kernel/ptrace.c
@@ -80,6 +80,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned int regno = addr >> 2;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
@@ -94,10 +95,10 @@ long arch_ptrace(struct task_struct *child, long request,
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			ret = put_user(tmp, datap);
 			break;
 		}
@@ -111,19 +112,17 @@ long arch_ptrace(struct task_struct *child, long request,
  		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			addr >>= 2;
-
-			if (addr == PT_DCCR) {
+			if (regno == PT_DCCR) {
 				/* don't allow the tracing process to change stuff like
 				 * interrupt enable, kernel/user bit, dma enables etc.
 				 */
 				data &= DCCR_MASK;
 				data |= get_reg(child, PT_DCCR) & ~DCCR_MASK;
 			}
-			if (put_reg(child, addr, data))
+			if (put_reg(child, regno, data))
 				break;
 			ret = 0;
 			break;
@@ -142,7 +141,7 @@ long arch_ptrace(struct task_struct *child, long request,
 					break;
 				}
 				
-				data += sizeof(unsigned long);
+				datap++;
 			}
 
 			break;
@@ -166,7 +165,7 @@ long arch_ptrace(struct task_struct *child, long request,
 				}
 				
 				put_reg(child, i, tmp);
-				data += sizeof(unsigned long);
+				datap++;
 			}
 			
 			break;
diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 3e058a1..511ece9 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -130,6 +130,7 @@ long arch_ptrace(struct task_struct *child, long request,
 		 unsigned long addr, unsigned long data)
 {
 	int ret;
+	unsigned int regno = addr >> 2;
 	unsigned long __user *datap = (unsigned long __user *)data;
 
 	switch (request) {
@@ -164,10 +165,10 @@ long arch_ptrace(struct task_struct *child, long request,
 			unsigned long tmp;
 
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			tmp = get_reg(child, addr >> 2);
+			tmp = get_reg(child, regno);
 			ret = put_user(tmp, datap);
 			break;
 		}
@@ -181,19 +182,17 @@ long arch_ptrace(struct task_struct *child, long request,
 		/* Write the word at location address in the USER area. */
 		case PTRACE_POKEUSR:
 			ret = -EIO;
-			if ((addr & 3) || addr < 0 || addr > PT_MAX << 2)
+			if ((addr & 3) || regno > PT_MAX)
 				break;
 
-			addr >>= 2;
-
-			if (addr == PT_CCS) {
+			if (regno == PT_CCS) {
 				/* don't allow the tracing process to change stuff like
 				 * interrupt enable, kernel/user bit, dma enables etc.
 				 */
 				data &= CCS_MASK;
 				data |= get_reg(child, PT_CCS) & ~CCS_MASK;
 			}
-			if (put_reg(child, addr, data))
+			if (put_reg(child, regno, data))
 				break;
 			ret = 0;
 			break;
-- 
1.7.2.2

