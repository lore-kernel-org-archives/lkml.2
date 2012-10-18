Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756212Ab2JROSU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 10:18:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45264 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755810Ab2JROSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 10:18:18 -0400
Message-ID: <50800F8C.10600@zytor.com>
Date: Thu, 18 Oct 2012 07:17:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: =?UTF-8?B?Q8OpZHJpYyBHb2Rpbg==?= <cedric@belbone.be>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, linux-pm@vger.kernel.org
Subject: Re: [Bisected] 3.7-rc1 can't resume
References: <507FF583.1070407@belbone.be>
In-Reply-To: <507FF583.1070407@belbone.be>
Content-Type: multipart/mixed;
 boundary="------------020900070803080204040106"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020900070803080204040106
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/18/2012 05:26 AM, Cédric Godin wrote:
> Hello,
>
> After upgrading my kernel from 3.6 to 3.7-rc1 on my laptop, I can't resume anymore.
> I bisected the problem to
>

There is a fix for this already queued up.  Please try the attached 
patch to verify that it fixes your problem.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


--------------020900070803080204040106
Content-Type: text/x-patch;
 name="0001-x86-suspend-Correct-the-restore-of-CR4-EFER-skip-com.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-x86-suspend-Correct-the-restore-of-CR4-EFER-skip-com.pa";
 filename*1="tch"

>From 1396adc3c2bdc556d4cdd1cf107aa0b6d59fbb1e Mon Sep 17 00:00:00 2001
From: "H. Peter Anvin" <hpa@linux.intel.com>
Date: Mon, 1 Oct 2012 14:34:42 -0700
Subject: [PATCH] x86, suspend: Correct the restore of CR4, EFER; skip
 computing EFLAGS.ID

The patch:

    73201dbe x86, suspend: On wakeup always initialize cr4 and EFER

... was incorrectly committed in an intermediate (unfinished) form.

- We need to test CF, not ZF, for a bit test with btl.
- We don't actually need to compute the existence of EFLAGS.ID,
  since we set a flag at suspend time if CR4 should be restored.

Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Link: http://lkml.kernel.org/r/1348529239-17943-1-git-send-email-hpa@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/realmode/rm/wakeup_asm.S | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/arch/x86/realmode/rm/wakeup_asm.S b/arch/x86/realmode/rm/wakeup_asm.S
index e56479e..9e7e147 100644
--- a/arch/x86/realmode/rm/wakeup_asm.S
+++ b/arch/x86/realmode/rm/wakeup_asm.S
@@ -74,18 +74,9 @@ ENTRY(wakeup_start)
 
 	lidtl	wakeup_idt
 
-	/* Clear the EFLAGS but remember if we have EFLAGS.ID */
-	movl $X86_EFLAGS_ID, %ecx
-	pushl %ecx
-	popfl
-	pushfl
-	popl %edi
+	/* Clear the EFLAGS */
 	pushl $0
 	popfl
-	pushfl
-	popl %edx
-	xorl %edx, %edi
-	andl %ecx, %edi		/* %edi is zero iff CPUID & %cr4 are missing */
 
 	/* Check header signature... */
 	movl	signature, %eax
@@ -120,12 +111,12 @@ ENTRY(wakeup_start)
 	movl	%eax, %cr3
 
 	btl	$WAKEUP_BEHAVIOR_RESTORE_CR4, %edi
-	jz	1f
+	jnc	1f
 	movl	pmode_cr4, %eax
 	movl	%eax, %cr4
 1:
 	btl	$WAKEUP_BEHAVIOR_RESTORE_EFER, %edi
-	jz	1f
+	jnc	1f
 	movl	pmode_efer, %eax
 	movl	pmode_efer + 4, %edx
 	movl	$MSR_EFER, %ecx
-- 
1.7.11.7


--------------020900070803080204040106--
