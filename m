Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab0CUKB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 06:01:27 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:32924 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab0CUKBZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 06:01:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:date:x-google-sender-auth:message-id:subject
         :from:to:cc:content-type:content-transfer-encoding;
        b=tNybHLUwPAue3xKhlTB+StwNry1w71m+cE5t1n/OlU1HO6DIc6+f/Zm3SnUzSpC1rk
         8gz+LkTWrzzk75B2VVox5veF01lq/+FFcPGSJ355fFtercAboMFP/eM6EtdF+fEtff7S
         dBvwpOxHqGi6p73s/lCQE4+BXNzsCgK1tfELQ=
MIME-Version: 1.0
Date: Sun, 21 Mar 2010 11:01:24 +0100
X-Google-Sender-Auth: dcd553d6088cbb58
Message-ID: <10f740e81003210301m5886c85dwd20eb0991657fc8d@mail.gmail.com>
Subject: [PATCH] m68k: Fix asm constraints for atomic_sub_and_test() and 
	atomic_add_negative() (was: Re: atomic_sub_and_test() asm constraints)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: "Linux/m68k" <linux-m68k@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 15:30, Andreas Schwab <schwab@linux-m68k.org> wrote:
> Geert Uytterhoeven <geert@linux-m68k.org> writes:
>
>> |   CC      mm/memcontrol.o
>> | {standard input}: Assembler messages:
>> | {standard input}:4076: Error: operands mismatch -- statement `subl
>> 12(%fp),170(%a0)' ignored
>>
>> Seems like we have bad asm constraints in
>>
>> static inline int atomic_sub_and_test(int i, atomic_t *v)
>> {
>>         char c;
>>         __asm__ __volatile__("subl %2,%1; seq %0" : "=d" (c), "+m"
>> (*v): "g" (i));
>
> Surely "g" is wrong, sub only accepts a data register as source operand
> when the destination is in memory.

>From cd2b57976949934df61c4406af344294011d5c16 Mon Sep 17 00:00:00 2001
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sun, 21 Mar 2010 10:52:21 +0100
Subject: [PATCH] m68k: Fix asm constraints for atomic_sub_and_test()
and atomic_add_negative()

Recently, we started seeing this on allmodconfig builds:

  CC      mm/memcontrol.o
{standard input}: Assembler messages:
{standard input}:4076: Error: operands mismatch -- statement `subl
12(%fp),170(%a0)' ignored

Correct the asm constraint, like done for m68knommu.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/atomic_mm.h |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/atomic_mm.h
b/arch/m68k/include/asm/atomic_mm.h
index 88b7af2..d9d2ed6 100644
--- a/arch/m68k/include/asm/atomic_mm.h
+++ b/arch/m68k/include/asm/atomic_mm.h
@@ -148,14 +148,18 @@ static inline int atomic_xchg(atomic_t *v, int new)
 static inline int atomic_sub_and_test(int i, atomic_t *v)
 {
 	char c;
-	__asm__ __volatile__("subl %2,%1; seq %0" : "=d" (c), "+m" (*v): "g" (i));
+	__asm__ __volatile__("subl %2,%1; seq %0"
+			     : "=d" (c), "+m" (*v)
+			     : "id" (i));
 	return c != 0;
 }

 static inline int atomic_add_negative(int i, atomic_t *v)
 {
 	char c;
-	__asm__ __volatile__("addl %2,%1; smi %0" : "=d" (c), "+m" (*v): "g" (i));
+	__asm__ __volatile__("addl %2,%1; smi %0"
+			     : "=d" (c), "+m" (*v)
+			     : "id" (i));
 	return c != 0;
 }

-- 
1.6.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
