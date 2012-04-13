Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935233Ab2DMKqO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 06:46:14 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:53778 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab2DMKqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 06:46:11 -0400
Date: Fri, 13 Apr 2012 12:45:58 +0200
From: Borislav Petkov <bp@amd64.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Borislav Petkov <bp@amd64.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120413104558.GD27686@aftab>
References: <1334162178-17152-1-git-send-email-bp@amd64.org>
 <1334162178-17152-6-git-send-email-bp@amd64.org>
 <20120411180434.GH16257@infradead.org>
 <20120411180837.GJ16257@infradead.org>
 <20120412152256.GH24549@aftab>
 <20120412155734.GA30170@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412155734.GA30170@merkur.ravnborg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 05:57:34PM +0200, Sam Ravnborg wrote:
> >  ifeq ("$(origin W)", "command line")
> > @@ -1473,7 +1478,7 @@ tools/: FORCE
> >  	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
> >  
> >  tools/%: FORCE
> > -	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
> > +	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(O) -C $(src)/tools/ $*
> 
> I think we can do:
> > +	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(KBUILD_OUTPUT) -C $(src)/tools/ $*
> And then avoid the hacks above.

This has the side effect of starting a sub-make in that output directory
and trying to build the kernel i.e. I'm looking at the code around
"ifneq ($(KBUILD_OUTPUT),)":

$ make O=/tmp/pbuild tools/perf
  HOSTCC  scripts/basic/fixdep
  GEN     /tmp/pbuild/Makefile
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/zconf.tab.o
  HOSTLD  scripts/kconfig/conf
scripts/kconfig/conf --silentoldconfig Kconfig
***
*** Configuration file ".config" not found!
***
*** Please run some configurator (e.g. "make oldconfig" or
*** "make menuconfig" or "make xconfig").
***
make[3]: *** [silentoldconfig] Error 1
make[2]: *** [silentoldconfig] Error 2
    SUBDIR perf/

but then descends into tools/perf/

...

I haven't looked at the branch where KBUILD_OUTPUT is not empty yet,
maybe there we could do something...

> >  # Single targets
> >  # ---------------------------------------------------------------------------
> > diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> > index 87b55a729a5f..297b51d8e4be 100644
> > --- a/tools/scripts/Makefile.include
> > +++ b/tools/scripts/Makefile.include
> > @@ -38,11 +38,18 @@ else
> >  NO_SUBDIR = :
> >  endif
> >  
> > -QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
> > -QUIET_SUBDIR1  =
> 
> Who-ever came up with the names "QUIET_SUBDIR" must have had a bad day...
> I think you could do all the tricks using:
> 
> QUIET_MAKE = ...
> 
> It looks much simpler to use:
> 
> foo: bar
> 	$(QUIET_MAKE) ...
> 
> But this is another patch...

Right, so this could probably reuse the quiet_cmd_* machinery from the
toplevel Makefile now...

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
