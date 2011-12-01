Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1LAOG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:06:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:54613 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1LAOGy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:06:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: prevent inlining in arxescsi.c causing build failures
Date: Thu, 1 Dec 2011 14:06:49 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "Uwe =?iso-8859-1?q?Kleine-K=F6nig?=" 
	<u.kleine-koenig@pengutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-kernel@vger.kernel.org, JBottomley@parallels.com,
        linux-scsi@vger.kernel.org
References: <1322713611-30003-1-git-send-email-paul.gortmaker@windriver.com> <20111201080613.GF26618@pengutronix.de>
In-Reply-To: <20111201080613.GF26618@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Message-Id: <201112011406.49554.arnd@arndb.de>
X-Provags-ID: V02:K0:+HbameW0386p9FYN46GjR6kqFjc/Waxb667bLSWgspS
 9GuVVhurxKTVVs+gjITET0bFMdHK8jRoDMMQUTqItwhLIbvRFp
 bx+LxiNtvmUG9yH2rDLLT87L6dAV/t9qzkCs6yGENPcQvp7O6f
 NUaf/DLCvBWPrDprL2tpR3KJIzlHkCBYG6jX1QCWDgGMJlHf+S
 vWq8Y7f0nXj3Qmm3BO/bjrsrPY+RwCA+DCMezJREGjCzPtzWod
 I5osa698T89emmrc8VMDt6DI0UOzf5VJNQ0ZA611heRvr/nBc/
 PaSZf64QcX+JJ65KUf2fvph2DQzlWR0OSXF3M5tWl/XxyA0OS6
 D7YNqllMuty6smyWPQQE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 December 2011, Uwe Kleine-König wrote:
> On Wed, Nov 30, 2011 at 11:26:51PM -0500, Paul Gortmaker wrote:
> > The following failure is seen in routine coverage builds:
> > 
> >   CC [M]  drivers/scsi/arm/arxescsi.o
> > /tmp/cccEyiO7.s: Assembler messages:
> > /tmp/cccEyiO7.s:334: Error: symbol `.loop_1' is already defined
> > /tmp/cccEyiO7.s:337: Error: symbol `.loop_2' is already defined
> > /tmp/cccEyiO7.s:343: Error: symbol `.loop_3' is already defined
> > /tmp/cccEyiO7.s:365: Error: symbol `.loop_1' is already defined
> > /tmp/cccEyiO7.s:368: Error: symbol `.loop_2' is already defined
> > /tmp/cccEyiO7.s:374: Error: symbol `.loop_3' is already defined
> > make[4]: *** [drivers/scsi/arm/arxescsi.o] Error 1
> > 
> > It is caused by multiple inline of arxescsi_pseudo_dma_write()
> > which is responsible for the above labels.  Marking the fcn
> > as non-inline fixes the issue.
> > 
> > Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> Is that a compiler or a code issue? If it's the compiler please fix
> that. If it's the code, then please document why you added the noinline.

The problem is mostly in the code: The symbols are defined in an
inline assembly that is not meant to be instantiated multiple times.
gcc may decide to unroll the loop in which this is done, which causes
the error above. Unrolling the loop is a rather silly thing to do
here, because the code is rather large and does not at all benefit
from unrolling. You can use the patch below to fix the code to still
work if the loop is unrolled, but I also think that marking the
function as uninline is a good idea, in particular because I don't
trust the old assembly to still do the right thing otherwise:
It manually saves and restores the registers on the stack, where
you nowadays would specify specific clobbers for the registers
it uses, and let the compiler take care of it. It also doesn't
contain a memory clobber for the buffer, so keeping the function
out-of-line is probably the safe choice.

> Having said that, "my" compiler compiles drivers/scsi/arm/arxescsi.o
> just fine (using rpc_defconfig on v3.2-rc2).

You should be able to reproduce it by adding -funroll-all-loops to
the CFLAGS. That made the difference for me on gcc-4.6 from Ubuntu.

	Arnd

8<-----
PATCH: scsi/arxcescsi: use local assembler symbols

> > /tmp/cccEyiO7.s: Assembler messages:
> > /tmp/cccEyiO7.s:334: Error: symbol `.loop_1' is already defined
> > /tmp/cccEyiO7.s:337: Error: symbol `.loop_2' is already defined
> > /tmp/cccEyiO7.s:343: Error: symbol `.loop_3' is already defined
> > /tmp/cccEyiO7.s:365: Error: symbol `.loop_1' is already defined
> > /tmp/cccEyiO7.s:368: Error: symbol `.loop_2' is already defined
> > /tmp/cccEyiO7.s:374: Error: symbol `.loop_3' is already defined
> > make[4]: *** [drivers/scsi/arm/arxescsi.o] Error 1

Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/drivers/scsi/arm/arxescsi.c b/drivers/scsi/arm/arxescsi.c
index a750aa7..689838a 100644
--- a/drivers/scsi/arm/arxescsi.c
+++ b/drivers/scsi/arm/arxescsi.c
@@ -80,21 +80,21 @@ static void arxescsi_pseudo_dma_write(unsigned char *addr, void __iomem *base)
        "               mov     r1, %1\n"
        "               add     r2, r1, #512\n"
        "               mov     r4, #256\n"
-       ".loop_1:       ldmia   r3!, {r6, r8, r10, r12}\n"
+       "1:             ldmia   r3!, {r6, r8, r10, r12}\n"
        "               mov     r5, r6, lsl #16\n"
        "               mov     r7, r8, lsl #16\n"
-       ".loop_2:       ldrb    r0, [r1, #1536]\n"
+       "2:             ldrb    r0, [r1, #1536]\n"
        "               tst     r0, #1\n"
-       "               beq     .loop_2\n"
+       "               beq     2b\n"
        "               stmia   r2, {r5-r8}\n\t"
        "               mov     r9, r10, lsl #16\n"
        "               mov     r11, r12, lsl #16\n"
-       ".loop_3:       ldrb    r0, [r1, #1536]\n"
+       "3:             ldrb    r0, [r1, #1536]\n"
        "               tst     r0, #1\n"
-       "               beq     .loop_3\n"
+       "               beq     3b\n"
        "               stmia   r2, {r9-r12}\n"
        "               subs    r4, r4, #16\n"
-       "               bne     .loop_1\n"
+       "               bne     1b\n"
        "               ldmia   sp!, {r0-r12}\n"
        :
        : "r" (addr), "r" (base));
