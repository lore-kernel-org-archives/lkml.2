Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522Ab0HUJ1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:27:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:3679 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab0HUJ1C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:27:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,244,1280732400"; 
   d="scan'208";a="649883264"
Date: Sat, 21 Aug 2010 17:26:52 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RESEND] fix compilation error with CROSS_COMPILE
Message-ID: <20100821092652.GA9967@localhost>
References: <20100821062133.GA809@localhost>
 <20100821072454.GA25054@merkur.ravnborg.org>
 <20100821072955.GA4950@localhost>
 <20100821074021.GA25099@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100821074021.GA25099@merkur.ravnborg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 21, 2010 at 03:40:21PM +0800, Sam Ravnborg wrote:
> On Sat, Aug 21, 2010 at 03:29:56PM +0800, Wu Fengguang wrote:
> > On Sat, Aug 21, 2010 at 03:24:54PM +0800, Sam Ravnborg wrote:
> > > On Sat, Aug 21, 2010 at 02:21:33PM +0800, Wu Fengguang wrote:
> > > >         $ make CROSS_COMPILE=x86_64-linux-gnu-
> > > >         ...
> > > >         cc1: error: unrecognized command line option "-m64"
> > > >         cc1: error: unrecognized command line option "-mno-red-zone"
> > > >         cc1: error: unrecognized command line option "-mcmodel=kernel"
> > > >         cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
> > > > 
> > > > Cc: Tiago Maluta <tiago.maluta@gmail.com>
> > > > Cc: Michal Marek <mmarek@suse.cz>
> > > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > > > ---
> > > > 
> > > > Andrew: the compile error only occurs in the -mm tree
> > > > The bug is introduced by patch "Linux has an recent option to define
> > > > CROSS_COMPILE in menuconfig.".
> > > > 
> > > > diff --git a/Makefile b/Makefile
> > > > index d646d69..af8864e 100644
> > > > --- a/Makefile
> > > > +++ b/Makefile
> > > > @@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
> > > >  export KBUILD_BUILDHOST := $(SUBARCH)
> > > >  ARCH		?= $(SUBARCH)
> > > >  CROSS_COMPILE	?=
> > > > -CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> > > > +CROSS_COMPILE	?= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
> > > 
> > > I cannot see how this would solve your problem.
> > > Any variable assigned using := or ?= can be overrided by  variable
> > > assigned on the command line like this:
> > > 
> > >    make VAR=values
> > > 
> > > Please note that there is a big difference between the above and this:
> > > 
> > >     VAR=value make
> > 
> > Ah yes I'm using that form indeed. Sorry for the confusion.

Here is the exact command line (w/o this patch):

wfg@bee ~/cc/mmotm% ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- /usr/bin/make
/home/wfg/cc/mmotm/arch/x86/Makefile:81: stack protector enabled but no compiler support
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CC      kernel/bounds.s
cc1: error: unrecognized command line option "-m64"
cc1: error: unrecognized command line option "-mno-red-zone"
cc1: error: unrecognized command line option "-mcmodel=kernel"
cc1: error: unrecognized command line option "-maccumulate-outgoing-args"
make[1]: *** [kernel/bounds.s] Error 1
make: *** [prepare0] Error 2

> > > In the latter case you pass in VAR using the enviroment and it
> > > is just like any other environment variable as seen from make.
> > > 
> > > On top of that the upstream kernel does not have the first
> > > assignmnet to CROSS_COMPILE - so you need to update
> > > your sources (or Andrews --mm is not recent enough.
> > > 
> > > Please try again with upstream kernel and let us know what you
> > > conclude.
> > 
> > Upstream kernel uses the ?= form and runs always OK.
> > 
> > The recent -mm kernels I tried all have the problem.
> 
> Good.
> Then we can assume that next -mm has this fixed when he picks up
> this change from upstream. Or maybe -mm has a patch in needs for revert.
>
> Took a quick looks at -mm and only fould this:
> kbuild-fix-config_cross_compile-issue-in-config.patch

Yes it is.

> And this is already upstream.

However I confirmed that the linux-2.6 tree is OK, the above patch that caused
the problem is still sitting in -mm tree:

commit 7f48a0a8c15c41f382f2265088bc96007836e608
Author: Tiago Maluta <tiago.maluta@gmail.com>
Date:   Mon Jun 21 22:00:17 2010 +0200

    Linux has an recent option to define CROSS_COMPILE in menuconfig.
    
    Typically, one of the options when building for another target is
    ('arm' is just an example):
    
    # make ARCH=arm CROSS_COMPILE=arm-cc O=../build
    
    If I omit CROSS_COMPILE and use the new way in .config:
    CONFIG_CROSS_COMPILE="arm-cc"
    
    I got:
    
       cc1: error: unrecognized command line option "-mlittle-endian"
       cc1: error: unrecognized command line option "-mabi=aapcs-linux"
       cc1: error: unrecognized command line option "-mno-thumb-interwork"
       /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for -march= switch
       /usr/src/linux/kernel/bounds.c:1: error: bad value (armv5t) for -mtune= switch
       make[2]: *** [kernel/bounds.s] Error 1
       make[1]: *** [prepare0] Error 2
       make: *** [sub-make] Error 2
    
    Verbose output clearly says that I'm using the host compiler instead cross
    compiler.  This patch fixed my problem.
    
    Cc: Michal Marek <mmarek@suse.cz>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

diff --git a/Makefile b/Makefile
index 7431c28..13126ae 100644
--- a/Makefile
+++ b/Makefile
@@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH           ?= $(SUBARCH)
 CROSS_COMPILE  ?=
-CROSS_COMPILE  ?= $(CONFIG_CROSS_COMPILE:"%"=%)
+CROSS_COMPILE  := $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
 
 # Architecture as present in compile.h
 UTS_MACHINE    := $(ARCH)


Thanks,
Fengguang
