Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965576Ab2DLP5i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 11:57:38 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:26331 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441Ab2DLP5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 11:57:36 -0400
Date: Thu, 12 Apr 2012 17:57:34 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/5] tools: Connect to the kernel build system
Message-ID: <20120412155734.GA30170@merkur.ravnborg.org>
References: <1334162178-17152-1-git-send-email-bp@amd64.org> <1334162178-17152-6-git-send-email-bp@amd64.org> <20120411180434.GH16257@infradead.org> <20120411180837.GJ16257@infradead.org> <20120412152256.GH24549@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120412152256.GH24549@aftab>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> --
> From: Borislav Petkov <borislav.petkov@amd.com>
> Date: Thu, 12 Apr 2012 17:18:10 +0200
> Subject: [PATCH] tools, Makefile: Fix O= building
> 
> Make sure
> 
> $ make O=/tmp/somedir tools/perf
> 
> works with the current toplevel Makefile integration.
> 
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  Makefile                       |    9 +++++++--
>  tools/scripts/Makefile.include |   18 +++++++++++++++---
>  2 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index 23b9ce5a2c2c..2cb2ee2dc6ae 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -98,8 +98,13 @@ ifeq ($(KBUILD_SRC),)
>  
>  # OK, Make called in directory where kernel src resides
>  # Do we want to locate output files in a separate directory?
> +#
> +# Also, we don't want to set KBUILD_OUTPUT if we're building stuff
> +# in tools/
>  ifeq ("$(origin O)", "command line")
> -  KBUILD_OUTPUT := $(O)
> +  ifneq ($(findstring tools/,$(MAKECMDGOALS)),tools/)
> +    KBUILD_OUTPUT := $(O)
> +  endif
>  endif
It is complicated enough - this is not OK.
We cannot special case individual targets here...

>  
>  ifeq ("$(origin W)", "command line")
> @@ -1473,7 +1478,7 @@ tools/: FORCE
>  	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/
>  
>  tools/%: FORCE
> -	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
> +	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(O) -C $(src)/tools/ $*

I think we can do:
> +	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= O=$(KBUILD_OUTPUT) -C $(src)/tools/ $*
And then avoid the hacks above.


>  
>  # Single targets
>  # ---------------------------------------------------------------------------
> diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
> index 87b55a729a5f..297b51d8e4be 100644
> --- a/tools/scripts/Makefile.include
> +++ b/tools/scripts/Makefile.include
> @@ -38,11 +38,18 @@ else
>  NO_SUBDIR = :
>  endif
>  
> -QUIET_SUBDIR0  = +$(MAKE) -C # space to separate -C and subdir
> -QUIET_SUBDIR1  =

Who-ever came up with the names "QUIET_SUBDIR" must have had a bad day...
I think you could do all the tricks using:

QUIET_MAKE = ...

It looks much simpler to use:

foo: bar
	$(QUIET_MAKE) ...

But this is another patch...

	Sam
