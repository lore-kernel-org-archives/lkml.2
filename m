Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966306Ab2DLXrj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 19:47:39 -0400
Received: from mail.windriver.com ([147.11.1.11]:60696 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966259Ab2DLXrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 19:47:36 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, davem@davemloft.net,
        tony@bakeyournoodle.com, mmarek@suse.cz, lacombar@gmail.com,
        sfr@canb.auug.org.au, Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH 0/3] RFC v2: strip 15,000 lines from a typical autoconf.h
Date: Thu, 12 Apr 2012 19:46:31 -0400
Message-Id: <1334274394-13466-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <CA+55aFx15+eHNA4LobwiFhe4k94XPTVTLdiBmuR4hDKR5HpWPg@mail.gmail.com>
References: <CA+55aFx15+eHNA4LobwiFhe4k94XPTVTLdiBmuR4hDKR5HpWPg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [PATCH 0/5] RFC: strip 15,000 lines from a typical autoconf.h] On 12/04/2012 (Thu 12:29) Linus Torvalds wrote:

> On Wed, Apr 11, 2012 at 8:10 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Can we leave the CONFIG_ part in the caller, so they are still grepable, please?
> >
> > So:
> >
> >	#define config_enabled(x)	(__stringify(x)[0] == '1')
> 
> Sure. Except G+ came through, and we now have an even better hack for
> this, that works entirely in the preprocessor.
> 
> That also means that you can use it for static initializers etc, so you can do
> 
>    int some_value = config_enabled(CONFIG_ENABLE_XYZ_BY_DEFAULT);
> 
> Paul, do you want to write the patch to change IS_ENABLED() to use this trick?

Sure -- I've done this in patch #1 of the (now) three patches.

I've dropped all the patches relating to phasing out the users
of IS_ENABLED within C code, since now they should just work.

> 
> Trick courtesy of "comex ." on G+ (please do give him credit even if
> he doesn't seem to use his real name):
> 
>   #define is_set(macro) is_set_(macro)
>   #define macrotest_1 ,
>   #define is_set_(value) is_set__(macrotest_##value)
>   #define is_set__(comma) is_set___(comma 1, 0)
>   #define is_set___(_, v, ...) v
> 
> and now "is_set(CONFIG_xyzzy)" works, and gives either 1 or 0 directly
> in the preprocessor.
> 
> Obviously the names have to be changed here (let's not use
> "macrotest_1" - make it something more internal), but the concept is
> solid, and I would actually suggest having this as a generic "is this
> macro set to 1" helper first, and then implement IS_ENABLED() in terms
> of that.

Hopefully the names I've chosen are OK.  Please have a look.

Thanks,
Paul.

> 
> My likee.
> 
>                        Linus

Paul Gortmaker (3):
  kconfig: fix IS_ENABLED to not require all options to be defined
  Revert "kconfig: fix __enabled_ macros definition for invisible and
    un-selected symbols"
  kconfig: delete last traces of __enabled_ from autoconf.h

 include/linux/kconfig.h    |   22 ++++++++++++++++++----
 scripts/kconfig/confdata.c |   38 ++------------------------------------
 2 files changed, 20 insertions(+), 40 deletions(-)

-- 
1.7.9.1

