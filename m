Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753161Ab1BTUVO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:21:14 -0500
Received: from pqueueb.post.tele.dk ([193.162.153.10]:34549 "EHLO
	pqueueb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab1BTUVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:21:13 -0500
X-Greylist: delayed 1704 seconds by postgrey-1.27 at vger.kernel.org; Sun, 20 Feb 2011 15:21:12 EST
Date: Sun, 20 Feb 2011 20:52:22 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@alien8.de>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add extra gcc checks
Message-ID: <20110220195222.GA12915@merkur.ravnborg.org>
References: <1298219710-9846-1-git-send-email-bp@alien8.de> <20110220175709.GA5178@merkur.ravnborg.org> <20110220193906.GC6713@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110220193906.GC6713@liondog.tnic>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/Makefile b/Makefile
> index c9c8c8f..03989a1 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -102,6 +102,15 @@ ifeq ("$(origin O)", "command line")
>    KBUILD_OUTPUT := $(O)
>  endif
>  
> +ifeq ("$(origin W)", "command line")
> +  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 1
> +endif
> +ifndef KBUILD_ENABLE_EXTRA_GCC_CHECKS
> +  KBUILD_ENABLE_EXTRA_GCC_CHECKS = 0
> +endif

I do not see the purpose of setting KBUILD_ENABLE_EXTRA_GCC_CHECKS
equal to 0.

> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> index 4eb99ab..5bf9f40 100644
> --- a/scripts/Makefile.build
> +++ b/scripts/Makefile.build
> @@ -30,6 +30,33 @@ ldflags-y  :=
>  subdir-asflags-y :=
>  subdir-ccflags-y :=
>  
> +# make W=1 settings
> +ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS

The symbol KBUILD_ENABLE_EXTRA_GCC_CHECKS is always defined,
as you set it to "0" in the top-level Makefile.
So you will always have the extra checks enabled.

You also need to move the assignments down.
As it is now any kbuild file that assign
EXTRA_CFLAGS with

    EXTRA_CFLAGS := -D DEBUG

Will drop all the extra warnings.

>From Makefile.build:
# If the save-* variables changed error out
ifeq ($(KBUILD_NOPEDANTIC),)
        ifneq ("$(save-cflags)","$(CFLAGS)")
                $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use EXTRA_CFLAGS)
        endif
endif

<<<<< Here would be the better place to add this.

include scripts/Makefile.lib

> +EXTRA_CFLAGS += -Wextra -Wno-unused

Use of EXTRA_CFLAGS is deprecated - so that is not the right choice.
I suggest to use KBUILD_CFLAGS that is an KBUILD internal variable.

	Sam
