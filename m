Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757438Ab2IKBxS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 21:53:18 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47808 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757288Ab2IKBxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 21:53:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120910084025.GP13739@n2100.arm.linux.org.uk>
References: <CAOAMb1CTk1_dQAUiHy5ch=UxN7vSe0of81KcKbjPjCFqR9e9tw@mail.gmail.com>
	<20120910084025.GP13739@n2100.arm.linux.org.uk>
Date: Tue, 11 Sep 2012 10:53:14 +0900
Message-ID: <CAOAMb1A71iNuRHkuTynBF35DjZx0jHMz+SrwbMUzkdp4i1FZ7A@mail.gmail.com>
Subject: Re: [PATCH] ARM: Fix build warning in do_alignment.
From: Chanho Min <chanho0207@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Stephen Warren <swarren@nvidia.com>,
        David Howells <dhowells@redhat.com>, Nicolas Pitre <nico@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What it's caused by is do_alignment_t32_to_handler(), and its assignment
> through a pointer of this variable.  You can see that this is the cause
> because the patch below fixes the warning.
We couldn't fix the warning with your patch. the patch below fixes it instead.
IMHO, gcc can't seems to know that do_alignment_ldmstm never returns TYPE_LDST.
So It just warn that do_alignment_finish_ldst is called with the
uninitialized value.
I know gcc is not smart enough to see all the reasons. So, It is optional.
Also, I'm not sure these optional warning should be fixed.
Anyway, this is the last build warning in our whole source when using gcc-4.6.3

Thanks
Chanho,

diff --git a/arch/arm/mm/alignment.c b/arch/arm/mm/alignment.c
index 9107231..978db1f 100644
--- a/arch/arm/mm/alignment.c
+++ b/arch/arm/mm/alignment.c
@@ -856,8 +856,10 @@ do_alignment(unsigned long addr, unsigned int
fsr, struct pt_regs *regs)
 	case 0x08000000:	/* ldm or stm, or thumb-2 32bit instruction */
 		if (thumb2_32b)
 			handler = do_alignment_t32_to_handler(&instr, regs, &offset);
-		else
+		else {
+			offset.un = 0;
 			handler = do_alignment_ldmstm;
+		}
 		break;

 	default:
