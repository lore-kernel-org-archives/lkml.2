Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177Ab0HFXTX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 19:19:23 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41336 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751953Ab0HFXTU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 19:19:20 -0400
MIME-Version: 1.0
In-Reply-To: <20100804125156.GA23464@sepie.suse.cz>
References: <20100804125156.GA23464@sepie.suse.cz>
Date: Fri, 6 Aug 2010 16:19:19 -0700
Message-ID: <AANLkTinN4npO7qfSa-42B-Cq5mKZX+--H0=1SuSrWTEP@mail.gmail.com>
Subject: Re: [GIT] kbuild: kconfig changes
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, JBeulich@novell.com,
        aris@redhat.com, catalin.marinas@arm.com, jacmet@sunsite.dk,
        justinmattock@gmail.com, lizf@cn.fujitsu.com, sam@ravnborg.org,
        ulfalizer.lkml@gmail.com, zippel@linux-m68k.org,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 5:51 AM, Michal Marek <mmarek@suse.cz> wrote:
> Hi Linus,
>
> this is the kconfig part of kbuild. We have four new *config targets:
> * oldnoconfig: set all new options to 'n'
> * listnewconfig: list all unset config options
> * alldefconfig: set all options to their defaults specified in Kconfig
>  files
> * savedefconfig: write a defconfig file with only the differences from
>  an alldefconfig (aka minimal defconfig)
>
> Kconfig also warns when a select statement selects a symbol with unmet
> dependencies (which typically results in a broken config). Li Zefan did
> quite some usability fixes to the visual config interfaces.
>
> Michal
>
> The following changes since commit 9fe6206f400646a2322096b56c59891d530e8d51:
>
>  Linux 2.6.35 (2010-08-01 15:11:14 -0700)
>
> are available in the git repository at:
>  git://git.kernel.org/pub/scm/linux/kernel/git/mmarek/kbuild-2.6.git kconfig
>
> Aristeu Rozanski (1):
>      kconfig: introduce nonint_oldconfig and loose_nonint_oldconfig
>
> Catalin Marinas (1):
>      kbuild: Warn on selecting symbols with unmet direct dependencies
>
> Jan Beulich (1):
>      kconfig: Don't write invisible choice values

This change prevents some the minimal defconfig options from working.
Specifically our usb gadget drivers do not get set. Reverting this
part of the changes fixes my problem, but I don't know what other side
effects it may have:

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index e95718f..1797226 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -261,18 +261,14 @@ struct symbol *sym_choice_default(struct symbol *sym)
 static struct symbol *sym_calc_choice(struct symbol *sym)
 {
        struct symbol *def_sym;
-       struct property *prop;
-       struct expr *e;
-
-       /* first calculate all choice values' visibilities */
-       prop = sym_get_choice_prop(sym);
-       expr_list_for_each_sym(prop->expr, e, def_sym)
-               sym_calc_visibility(def_sym);

        /* is the user choice visible? */
        def_sym = sym->def[S_DEF_USER].val;
-       if (def_sym && def_sym->visible != no)
-               return def_sym;
+       if (def_sym) {
+               sym_calc_visibility(def_sym);
+               if (def_sym->visible != no)
+                       return def_sym;
+       }

        def_sym = sym_choice_default(sym);


-- 
Arve Hjønnevåg
