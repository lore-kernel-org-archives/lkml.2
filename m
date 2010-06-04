Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0FDJ41 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:56:27 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50564 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754092Ab0FDJ4Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:56:25 -0400
From: Nicolas Palix <npalix@diku.dk>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
Date: Fri, 4 Jun 2010 11:56:20 +0200
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Roland Dreier <rdreier@cisco.com>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk> <1273508667-5152-2-git-send-email-npalix@diku.dk> <20100603102315.GA8002@merkur.ravnborg.org>
In-Reply-To: <20100603102315.GA8002@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006041156.20714.npalix@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 June 2010 12:23:15 Sam Ravnborg wrote:
> On Mon, May 10, 2010 at 06:24:24PM +0200, Nicolas Palix wrote:
> > Four targets are added. Each one generates a different
> > output kind: context, patch, org, report.
> > Every SmPL file in 'scripts/coccinelle' is given to the spatch frontend
> > (located in the 'scripts' directory), and applied to the entire
> > source tree.
> 
> A little late feedback.
> IIRC all points raised at first review has been addressed - good.
> 
> > 
> > Signed-off-by: Nicolas Palix <npalix@diku.dk>
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > ---
> >  MAINTAINERS           |   10 ++++++++++
> >  Makefile              |   20 ++++++++++++++++++--
> 
> The top-level Makefile is already in a very bad shape.
> Adding more stuff there is never good.
> 
> How about adding some infrastructure to support the various tools?
> Something along these lines:
> 
> All targets named %check will call a shell script:
> scripts/%check.sh
> 
> "make help" will call a script named:
> scripts/helpcheck.sh
> 
> helpcheck.sh will contain all the ugly details
> about help for the various targets.
> 
> We need to rename a few seldomly used targets to do this.
> Sample patch for top-level Makefile:
> 
> diff --git a/Makefile b/Makefile
> index efdc3d0..40bf83e 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -412,7 +412,7 @@ endif
>  # of make so .config is not included in this case either (for *config).
>  
>  no-dot-config-targets := clean mrproper distclean \
> -			 cscope TAGS tags help %docs check% \
> +			 cscope TAGS tags help %docs %check \
>  			 include/linux/version.h headers_% \
>  			 kernelrelease kernelversion
>  
> @@ -1024,10 +1024,6 @@ include/linux/version.h: $(srctree)/Makefile FORCE
>  include/generated/utsrelease.h: include/config/kernel.release FORCE
>  	$(call filechk,utsrelease.h)
>  
> -PHONY += headerdep
> -headerdep:
> -	$(Q)find include/ -name '*.h' | xargs --max-args 1 scripts/headerdep.pl
> -
>  # ---------------------------------------------------------------------------
>  
>  PHONY += depend dep
> @@ -1273,13 +1269,9 @@ help:
>  	 echo  '                    (default: $(INSTALL_HDR_PATH))'; \
>  	 echo  ''
>  	@echo  'Static analysers'
> -	@echo  '  checkstack      - Generate a list of stack hogs'
> -	@echo  '  namespacecheck  - Name space analysis on compiled kernel'
> -	@echo  '  versioncheck    - Sanity check on version.h usage'
> -	@echo  '  includecheck    - Check for duplicate included header files'
> +	@$(CONFIG_SHELL)$(srctree)/scripts/helpcheck.sh
>  	@echo  '  export_report   - List the usages of all exported symbols'
>  	@echo  '  headers_check   - Sanity check on exported headers'
> -	@echo  '  headerdep       - Detect inclusion cycles in headers'; \
>  	 echo  ''
>  	@echo  'Kernel packaging:'
>  	@$(MAKE) $(build)=$(package-dir) help
> @@ -1427,20 +1419,10 @@ tags TAGS cscope: FORCE
>  	$(call cmd,tags)
>  
>  # Scripts to check various things for consistency
> +# Call a helper script in scripts/ to do the actual job
>  # ---------------------------------------------------------------------------
> -
> -includecheck:
> -	find * $(RCS_FIND_IGNORE) \
> -		-name '*.[hcS]' -type f -print | sort \
> -		| xargs $(PERL) -w $(srctree)/scripts/checkincludes.pl
> -
> -versioncheck:
> -	find * $(RCS_FIND_IGNORE) \
> -		-name '*.[hcS]' -type f -print | sort \
> -		| xargs $(PERL) -w $(srctree)/scripts/checkversion.pl
> -
> -namespacecheck:
> -	$(PERL) $(srctree)/scripts/namespace.pl
> +%check:
> +	$(Q)$(CONFIG_SHELL)$(srctree)/scripts/$@.sh
>  
>  export_report:
>  	$(PERL) $(srctree)/scripts/export_report.pl
> @@ -1448,20 +1430,7 @@ export_report:
>  endif #ifeq ($(config-targets),1)
>  endif #ifeq ($(mixed-targets),1)
>  
> -PHONY += checkstack kernelrelease kernelversion
> -
> -# UML needs a little special treatment here.  It wants to use the host
> -# toolchain, so needs $(SUBARCH) passed to checkstack.pl.  Everyone
> -# else wants $(ARCH), including people doing cross-builds, which means
> -# that $(SUBARCH) doesn't work here.
> -ifeq ($(ARCH), um)
> -CHECKSTACK_ARCH := $(SUBARCH)
> -else
> -CHECKSTACK_ARCH := $(ARCH)
> -endif
> -checkstack:
> -	$(OBJDUMP) -d vmlinux $$(find . -name '*.ko') | \
> -	$(PERL) $(src)/scripts/checkstack.pl $(CHECKSTACK_ARCH)
> +PHONY += kernelrelease kernelversion
>  
>  kernelrelease:
>  	$(if $(wildcard include/config/kernel.release), $(Q)echo $(KERNELRELEASE), \
> 
> 
> 
> A nice simplification of the top-level Mkefile.
> and an opportunity to document some of the
> magic shell commands used by the various tools.
> 
> If we do this I know the scripts will sum up to a lot more
> lines but doing it distributed is better.
> And some of the lines would be comments that explains what is
> going on.
> 
> An additinal benefit is that we can avoid touching
> the top-level Makefile next time we add a new
> %check target.
> 
> As for cocci this would have the the effect that
> new scipts can be made as drop-in - no changes
> in any files. Just add the files to the
> correct directory.
> 
> 	Sam
> 

Hi,

I am not sure to understand your suggestion.

Should I make this change and integrate it into my patch series
or it is something to do later ?

In doing so, I will have to select the 'mode' in a different way.
I was thinking of renaming my targets in one of the following forms
or using an environment variable:

make cocci-report-check
make report-coccicheck
make coccicheck MODE=report

Do you have any preference ?

-- 
Nicolas Palix
Tel: (+33) 1 44 27 87 25
Tel: (+33) 6 81 07 91 72
Web: http://www.diku.dk/~npalix/
