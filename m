Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab1E1Ksn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 06:48:43 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62336 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1E1Ksm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 06:48:42 -0400
Message-ID: <4DE0D303.8000106@landley.net>
Date: Sat, 28 May 2011 05:48:35 -0500
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org
Subject: Re: MIPS panic in 2.6.39 (bisected to 7eaceaccab5f)
References: <4DDB5673.5060206@landley.net> <20110524143937.GB30117@linux-mips.org> <4DDCB1EB.4020707@landley.net> <20110527075512.GE30117@linux-mips.org> <20110527140011.GF30117@linux-mips.org>
In-Reply-To: <20110527140011.GF30117@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2011 09:00 AM, Ralf Baechle wrote:
> On Fri, May 27, 2011 at 08:55:13AM +0100, Ralf Baechle wrote:
> 
>>> Have you guys been able to reproduce the problem?
>>
>> Staring at the disassembly was good enough, I think.  The commit you
>> bisected is restructuring some of the hardware probing code for Malta and
>> seems to result in gcmp_present being set without _gcmp_base having been
>> assigned, thus the null pointer dereference.
> 
> Can you test below patch?  Thanks,
> 
>   Ralf
> 
> Since af3a1f6f4813907e143f87030cde67a9971db533 the Malta code does no
> longer probe for presence of GCMP if CMP is not configured.  This means
> that the variable gcmp_present well be left at its default value of -1
> which normally is meant to indicate that GCMP has not yet been mmapped.
> This non-zero value is now interpreted as GCMP being present resulting
> in a write attempt to a GCMP register resulting in a crash.
> 
> Signed-off-by: Ralf Baechle <ralf@linux-mips.org>

patch patch patch...

> diff --git a/arch/mips/mti-malta/malta-init.c b/arch/mips/mti-malta/malta-init.c
> index 31180c3..4163d09e 100644
> --- a/arch/mips/mti-malta/malta-init.c
> +++ b/arch/mips/mti-malta/malta-init.c

Your missing hunk at the top of this file is:

@@ -29,6 +29,7 @@
 #include <asm/system.h>
 #include <asm/cacheflush.h>
 #include <asm/traps.h>
+#include <asm/smp-ops.h>

 #include <asm/gcmpregs.h>
 #include <asm/mips-boards/prom.h>

And then the patch works!  Yay!  Thank you.

Signed-off-by: Rob Landley <rob@landley.net>

Rob
