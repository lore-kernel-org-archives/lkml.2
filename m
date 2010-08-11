Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756484Ab0HKTvg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 15:51:36 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:45847 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753420Ab0HKTve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 15:51:34 -0400
Date: Wed, 11 Aug 2010 21:51:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arve Hj?nnev?g <arve@android.com>
Cc: Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, ulfalizer.lkml@gmail.com,
        zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] kbuild: kconfig changes
Message-ID: <20100811195131.GA24193@merkur.ravnborg.org>
References: <20100804125156.GA23464@sepie.suse.cz> <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com> <20100807040101.GA30520@merkur.ravnborg.org> <AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinOWBfsncSZw3bvHa6Mp+eb5dzibKSV15OKgW2M@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 06, 2010 at 09:43:24PM -0700, Arve Hj?nnev?g wrote:
> On Fri, Aug 6, 2010 at 9:01 PM, Sam Ravnborg <sam@ravnborg.org> wrote:
> >>
> >> This change prevents some the minimal defconfig options from working.
> >> Specifically our usb gadget drivers do not get set.
> >
> > Can you help me reproduce this?
> >
> > I have found an issue with choice values in combination with
> > tristate logic that fails. I hope this is something similar.
> >
> 
> It is probably the same problem. The gadget driver that was not set is
> not buildable as a module (it is not in the mainline kernel). If I
> select another gadget driver instead it just gets changed to build as
> a module instead.
> 
> If you create a file, arch/arm/configs/test_defconfig with the following:
> CONFIG_MODULES=y
> CONFIG_USB_GADGET=y
> CONFIG_USB_MASS_STORAGE=y
> 
> then "make test_defconfig" results in .config having:
> CONFIG_USB_MASS_STORAGE=m
> 
>  (at least if you are set up to compile for arm)

Arve, can you please try the attached patch and check if this
fixes the issue you see.
At least I confirmed that it fixed the minimal test-case I used.

Note: the patch chenges how we interpret a minimal config,
it does not change the content of a minimal config.

Unfortunately the bug I had discovered is another bug.
If I do:
	make ARCH=avr32 atngw100_defconfig
	make ARCH=avr32 savedefconfig
	cp defconfig arch/avr32/configs/atngw100_defconfig
	make ARCH=avr32 atngw100_defconfig
	diff -u .config .config.old

then the diff shows an unexpected difference.

I will continue of that issue.
This is mainly to inform you that we have at least one
additional issue with "savedefconfig".

	Sam

>From 6f36cdab76c4ee26bc39c38a2895cac5166e253b Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Wed, 11 Aug 2010 21:40:23 +0200
Subject: [PATCH] kconfig: fix tristate choice with minimal config

If a minimal config did not specify the value
of all choice values, the resulting configuration
could have wrong values.

Consider following example:
config M
        def_bool y
        option modules
choice
        prompt "choice list"
config A
        tristate "a"
config B
	tristate "b"
endchoice

With a defconfig like this:
CONFIG_M=y
CONFIG_A=y

The resulting configuration would have

    CONFIG_A=m

which was unexpected.

The problem was not not all choice values were set and thus
kconfig calculated a wrong value.

The fix is to set all choice values when we
read a defconfig files.

conf_set_all_new_symbols() is refactored such that
random choice values are now handled by a dedicated function.
And new choice values are set by set_all_choice_values().

This was not the minimal fix, but the fix that resulted
in the most readable code.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Arve Hj?nnev?g <arve@android.com>
---
 scripts/kconfig/confdata.c |  102 +++++++++++++++++++++++++++++---------------
 1 files changed, 67 insertions(+), 35 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index f81f263..23d4fa6 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -919,13 +919,73 @@ void conf_set_changed_callback(void (*fn)(void))
 	conf_changed_callback = fn;
 }
 
+static void randomize_choice_values(struct symbol *csym)
+{
+	struct property *prop;
+	struct symbol *sym;
+	struct expr *e;
+	int cnt, def;
 
-void conf_set_all_new_symbols(enum conf_def_mode mode)
+	/*
+	 * If choice is mod then we may have more items slected
+	 * and if no then no-one.
+	 * In both cases stop.
+	 */
+	if (csym->curr.tri != yes)
+		return;
+
+	prop = sym_get_choice_prop(csym);
+
+	/* count entries in choice block */
+	cnt = 0;
+	expr_list_for_each_sym(prop->expr, e, sym)
+		cnt++;
+
+	/*
+	 * find a random value and set it to yes,
+	 * set the rest to no so we have only one set
+	 */
+	def = (rand() % cnt);
+
+	cnt = 0;
+	expr_list_for_each_sym(prop->expr, e, sym) {
+		if (def == cnt++) {
+			sym->def[S_DEF_USER].tri = yes;
+			csym->def[S_DEF_USER].val = sym;
+		}
+		else {
+			sym->def[S_DEF_USER].tri = no;
+		}
+	}
+	csym->flags |= SYMBOL_DEF_USER;
+	/* clear VALID to get value calculated */
+	csym->flags &= ~(SYMBOL_VALID);
+}
+
+static void set_all_choice_values(struct symbol *csym)
 {
-	struct symbol *sym, *csym;
 	struct property *prop;
+	struct symbol *sym;
 	struct expr *e;
-	int i, cnt, def;
+
+	prop = sym_get_choice_prop(csym);
+
+	/*
+	 * Set all non-assinged choice values to no
+	 */
+	expr_list_for_each_sym(prop->expr, e, sym) {
+		if (!sym_has_value(sym))
+			sym->def[S_DEF_USER].tri = no;
+	}
+	csym->flags |= SYMBOL_DEF_USER;
+	/* clear VALID to get value calculated */
+	csym->flags &= ~(SYMBOL_VALID);
+}
+
+void conf_set_all_new_symbols(enum conf_def_mode mode)
+{
+	struct symbol *sym, *csym;
+	int i, cnt;
 
 	for_all_symbols(i, sym) {
 		if (sym_has_value(sym))
@@ -961,8 +1021,6 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 
 	sym_clear_all_valid();
 
-	if (mode != def_random)
-		return;
 	/*
 	 * We have different type of choice blocks.
 	 * If curr.tri equal to mod then we can select several
@@ -977,35 +1035,9 @@ void conf_set_all_new_symbols(enum conf_def_mode mode)
 			continue;
 
 		sym_calc_value(csym);
-
-		if (csym->curr.tri != yes)
-			continue;
-
-		prop = sym_get_choice_prop(csym);
-
-		/* count entries in choice block */
-		cnt = 0;
-		expr_list_for_each_sym(prop->expr, e, sym)
-			cnt++;
-
-		/*
-		 * find a random value and set it to yes,
-		 * set the rest to no so we have only one set
-		 */
-		def = (rand() % cnt);
-
-		cnt = 0;
-		expr_list_for_each_sym(prop->expr, e, sym) {
-			if (def == cnt++) {
-				sym->def[S_DEF_USER].tri = yes;
-				csym->def[S_DEF_USER].val = sym;
-			}
-			else {
-				sym->def[S_DEF_USER].tri = no;
-			}
-		}
-		csym->flags |= SYMBOL_DEF_USER;
-		/* clear VALID to get value calculated */
-		csym->flags &= ~(SYMBOL_VALID);
+		if (mode == def_random)
+			randomize_choice_values(csym);
+		else
+			set_all_choice_values(csym);
 	}
 }
-- 
1.6.0.6

