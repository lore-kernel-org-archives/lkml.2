Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab0HUM65 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 08:58:57 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:41053 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab0HUM6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 08:58:55 -0400
Date: Sat, 21 Aug 2010 14:58:53 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] fix compilation error with CROSS_COMPILE
Message-ID: <20100821125853.GA25430@merkur.ravnborg.org>
References: <20100821062133.GA809@localhost> <20100821072454.GA25054@merkur.ravnborg.org> <20100821072955.GA4950@localhost> <20100821074021.GA25099@merkur.ravnborg.org> <20100821092652.GA9967@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821092652.GA9967@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> However I confirmed that the linux-2.6 tree is OK, the above patch that caused
> the problem is still sitting in -mm tree:
> 
> commit 7f48a0a8c15c41f382f2265088bc96007836e608
> Author: Tiago Maluta <tiago.maluta@gmail.com>
> Date:   Mon Jun 21 22:00:17 2010 +0200
> 
>     Linux has an recent option to define CROSS_COMPILE in menuconfig.
>     
>     Typically, one of the options when building for another target is
>     ('arm' is just an example):
>     
>     # make ARCH=arm CROSS_COMPILE=arm-cc O=../build
>     
>     If I omit CROSS_COMPILE and use the new way in .config:
>     CONFIG_CROSS_COMPILE="arm-cc"
>     
>     I got:
>     
>        cc1: error: unrecognized command line option "-mlittle-endian"
>        cc1: error: unrecognized command line option "-mabi=aapcs-linux"
>        cc1: error: unrecognized command line option "-mno-thumb-interwork"
>        /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for -march= switch
>        /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for -mtune= switch
>        make[2]: *** [kernel/bounds.s] Error 1
>        make[1]: *** [prepare0] Error 2
>        make: *** [sub-make] Error 2
>     
>     Verbose output clearly says that I'm using the host compiler instead cross
>     compiler.  This patch fixed my problem.
>     
>     Cc: Michal Marek <mmarek@suse.cz>
>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> 
> diff --git a/Makefile b/Makefile
> index 7431c28..13126ae 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
>  export KBUILD_BUILDHOST := $(SUBARCH)
>  ARCH           ?= $(SUBARCH)
>  CROSS_COMPILE  ?=
> -CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)
> +CROSS_COMPILE  := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)

So this patch does two things:
1) It grep for CONFIG_CROSS_COMPILE because we may not have incldued .config
2) It no longer pick up CROSS_COMPILE from the environment.

Traditionally we have picked up ARCH and CROSS_COMPILE from the environmnet,
hence the use of "?=".
"?=" says - perfrom this assignmnet unless lhs is already defined.
And lhs may be already defined is we have the ysmbol defined in the
environmnet.

I think the original submitter chenged from ?= to := without
realising this.
So the patch should be adjusted to use ?= again as you suggest
before it is applied.
I assume Michal / Andrew will take care.

Subject on patch could also be better.
Suggestion: kbuild: fix reading CROSS_COMPILE from .config

	Sam
