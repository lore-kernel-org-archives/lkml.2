Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab1GSNNs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 09:13:48 -0400
Received: from DMZ-MAILSEC-SCANNER-2.MIT.EDU ([18.9.25.13]:55913 "EHLO
	dmz-mailsec-scanner-2.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab1GSNNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 09:13:47 -0400
X-AuditID: 1209190d-b7be0ae000000a16-74-4e258270f087
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@MIT.EDU>
Subject: [PATCH] x86: Set TPR to block external interrupts 0-31
Date: Tue, 19 Jul 2011 09:13:39 -0400
Message-Id: <120c0799734be30a05c31feaa67a4156248b20d6.1311080996.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMIsWRmVeSWpSXmKPExsUixCmqrVvQpOpnMGkrq0XflaPsFpd3zWGz
	+LHhMasDs8fOWXfZPTat6mTz+LxJLoA5issmJTUnsyy1SN8ugSvj2tXfLAXP+CsuN/ewNzC+
	5+li5OSQEDCRWHDtFQuELSZx4d56ti5GLg4hgX2MEns3dbBCOBsYJS6uO8cI4Txjkui6doQV
	pIVNQEWiY+kDpi5GDg4RASGJpXfrQMLMAg4Stx8fYQSxhQXsJc7d+wJmswioSnRc2Q/WyisQ
	JPF0xUFWiM1yEkcuP2eawMizgJFhFaNsSm6Vbm5iZk5xarJucXJiXl5qka6RXm5miV5qSukm
	RnBISPLuYHx3UOkQowAHoxIPr+V6FT8h1sSy4srcQ4ySHExKoryu9ap+QnxJ+SmVGYnFGfFF
	pTmpxYcYJTiYlUR4T20AKudNSaysSi3Kh0lJc7AoifOqef/3FRJITyxJzU5NLUgtgsnKcHAo
	SfCGA0NfSLAoNT21Ii0zpwQhzcTBCTKcB2g4D0gNb3FBYm5xZjpE/hSjMcf92/ePMHJ0tAJD
	RoglLz8vVUqcVxGkVACkNKM0D24aLK5fMYoDPSfMGwhSxQNMCXDzXgGtYgJa1aIOtqokESEl
	1cDIVxDpePvrBameKzm3u/9EdolYmJdfrReyivusU377oY3DQ++9ki8Yd097mcg5JzP+c6bc
	647bNQdMedY+ve3s/2K59WcL/oSvLH+mznqaWC7SEmzVNHOpkqlpRr2t18oeF8GAzpupFlVv
	vzbMenJ197pQs+lch1l/bW3IXc1cd7WFLVV2a50SS3FGoqEWc1FxIgB4u4j3xgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an external interrupt with vector 0-31 comes in, we are likely to
do the wrong thing, since we'll think it's a trap from the CPU.
Depending on which vector it is, we could get even more confused,
because some traps push an error code but traps do not, so we will
corrupt the stack on return.

We can reduce the chance that we get such an interrupt from a rogue
or malfunctioning device by changing the APIC's TPR.

This is not known to fix any real bugs, but it should not hurt and
it's has no performance cost.  It is inspired by, but much less
aggressive than this patch from Xen:

http://xenbits.xen.org/hg/staging/xen-4.0-testing.hg/rev/b85a9e58ec3a

Signed-off-by: Andy Lutomirski <luto@mit.edu>
---

The original paper is here and is rather interesting:
http://www.invisiblethingslab.com/resources/2011/Software%20Attacks%20on%20Intel%20VT-d.pdf

This patch *does not* prevent most of the interesting attacks in
that paper, and the fancy mitigation tricks that Xen added seem
silly.  They don't address all of the attacks, and they slow down
interrupt processing.  But this particular part should be free and
seems like a potentially worthwhile change to improve resistance to
dumb bugs.

 arch/x86/kernel/apic/apic.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index b9338b8..125e2b2 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1252,12 +1252,10 @@ void __cpuinit setup_local_APIC(void)
 #endif
 
 	/*
-	 * Set Task Priority to 'accept all'. We never change this
-	 * later on.
+	 * Set Task Priority to 'accept all external vectors'. We never
+	 * change this later on.
 	 */
-	value = apic_read(APIC_TASKPRI);
-	value &= ~APIC_TPRI_MASK;
-	apic_write(APIC_TASKPRI, value);
+	apic_write(APIC_TASKPRI, (FIRST_EXTERNAL_VECTOR & 0xF0) - 0x10);
 
 	/*
 	 * After a crash, we no longer service the interrupts and a pending
-- 
1.7.6

