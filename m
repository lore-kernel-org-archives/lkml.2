Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab2HPNuw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:50:52 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37002 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755389Ab2HPNuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:50:50 -0400
Message-ID: <1345125049.26882.16.camel@joe2Laptop>
Subject: Re: Regression: Spurious "^A" in UML output
From: Joe Perches <joe@perches.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Date: Thu, 16 Aug 2012 06:50:49 -0700
In-Reply-To: <CAMuHMdVEKpVYn+Yr5rzdOvV5zUWrD12Fas197Mn2oVDC5YgVgw@mail.gmail.com>
References: <CAMuHMdVEKpVYn+Yr5rzdOvV5zUWrD12Fas197Mn2oVDC5YgVgw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-16 at 15:17 +0200, Geert Uytterhoeven wrote:
> In v3.6-rc1 UML, I see spurious "^A" (ASCII 1, SOH) characters in some kernel
> messages:
> 
> Calibrating delay loop... 4640.76 BogoMIPS (lpj=23203840)
> pid_max: default: 32768 minimum: 301
> Mount-cache hash table entries: 256
> ^AChecking that host ptys support output SIGIO...Yes
> ^AChecking that host ptys support SIGIO on close...No, enabling workaround
> ^AUsing 2.6 host AIO
> NET: Registered protocol family 16
> bio: create slab <bio-0> at 0
> Switching to clocksource itimer
> 
> This happens for all output using the "printk(UM_KERN_XXX ...)" idiom.

Were these emitted with "KERN_<LEVEL>" string constants
before this change (not <[0-7]>", but the string text
KERN_INFO, KERN_WARNING, etc...)?

> The "UM_KERN_XXX" defines are generated from the KERN_XXX defines in
> arch/um/include/shared/common-offsets.h using:
> 
> DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
[]
> I.e. only the SOH character is retained in the actual define, the remainder ends
> up in the comment.
> 
> Apparently the combo of DEFINE_STR() in
> arch/x86/um/shared/sysdep/kernel-offsets.h
> and sed-y in Kbuild doesn't support string constants consisting of
> multiple parts.
> 
> A quick fix is the (whitespace-damaged) patch below, but this would reduce
> readability. And I'm afraid my sed-foo is not good enough to fix it better.
> Any takers?

Perhaps it's better to change the um STR macro instead

$ git grep -w DEFINE_STR
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_EMERG, KERN_EMERG);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_ALERT, KERN_ALERT);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_CRIT, KERN_CRIT);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_ERR, KERN_ERR);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_WARNING, KERN_WARNING);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_NOTICE, KERN_NOTICE);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_INFO, KERN_INFO);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_DEBUG, KERN_DEBUG);
arch/um/include/shared/common-offsets.h:DEFINE_STR(UM_KERN_CONT, KERN_CONT);
arch/x86/um/shared/sysdep/kernel-offsets.h:#define DEFINE_STR(sym, val) asm volatile("\n->" #sym " " STR(val) " " #val: : )

$ git grep -w STR arch/x86/um/shared/
arch/x86/um/shared/sysdep/kernel-offsets.h:#define STR(x) #x
arch/x86/um/shared/sysdep/kernel-offsets.h:#define DEFINE_STR(sym, val) asm volatile("\n->" #sym " " STR(val) " " #val: : )


