Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338Ab0HKUe5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 16:34:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47970 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757129Ab0HKUez (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 16:34:55 -0400
Date: Wed, 11 Aug 2010 22:34:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild: kconfig changes
Message-ID: <20100811203453.GB28777@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com> <20100807040101.GA30520@merkur.ravnborg.org> <AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com> <20100811195131.GA24193@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100811195131.GA24193@merkur.ravnborg.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Unfortunately the bug I had discovered is another bug.
> If I do:
> 	make ARCH=avr32 atngw100_defconfig
> 	make ARCH=avr32 savedefconfig
> 	cp defconfig arch/avr32/configs/atngw100_defconfig
> 	make ARCH=avr32 atngw100_defconfig
> 	diff -u .config .config.old
> 
> then the diff shows an unexpected difference.
> 
> I will continue of that issue.
Fixed it - see patch below.

@Michal - I will do a proper patch submission if Arve
can confirm that the problem he saw has been fixed
with these patches.

	Sam

>From d93f83bbd650499c146f29a8a4de2b1f98dfbefe Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 11 Aug 2010 22:29:05 +0200
Subject: [PATCH] kconfig: fix savedefconfig for tristate choices

savedefconfig failed to save choice symbols equal to 'y'
for tristate choices.
This resulted in this value being lost.

In particular is fixes an issue where

make ARCH=avr32 atngw100_defconfig
make ARCH=avr32 savedefconfig
cp defconfig arch/avr32/configs/atngw100_defconfig
make ARCH=avr32 atngw100_defconfig
diff -u .config .config.old

failed to produce an identical .config.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/confdata.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index f81f263..e5d66e4 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -497,7 +497,7 @@ int conf_write_defconfig(const char *filename)
 			/*
 			 * If symbol is a choice value and equals to the
 			 * default for a choice - skip.
-			 * But only if value equal to "y".
+			 * But only if value is bool and equal to "y" .
 			 */
 			if (sym_is_choice_value(sym)) {
 				struct symbol *cs;
@@ -506,9 +506,8 @@ int conf_write_defconfig(const char *filename)
 				cs = prop_get_symbol(sym_get_choice_prop(sym));
 				ds = sym_choice_default(cs);
 				if (sym == ds) {
-					if ((sym->type == S_BOOLEAN ||
-					sym->type == S_TRISTATE) &&
-					sym_get_tristate_value(sym) == yes)
+					if ((sym->type == S_BOOLEAN) &&
+					    sym_get_tristate_value(sym) == yes)
 						goto next_menu;
 				}
 			}
-- 
1.6.0.6

