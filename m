Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0GTN2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 09:28:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:57454 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751584Ab0GTN2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 09:28:37 -0400
Date: Tue, 20 Jul 2010 15:28:51 +0200
From: Michal Marek <mmarek@suse.cz>
To: "Zheng, Jiajia" <jiajia.zheng@intel.com>
Cc: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: "make rpm" failed with parameter "--scm-only"
Message-ID: <20100720132851.GA31205@sepie.suse.cz>
References: <A24AE1FFE7AEC5489F83450EE98351BF1BD77643B1@shsmsx502.ccr.corp.intel.com>
 <20100715084233.GA5835@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100715084233.GA5835@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 10:42:33AM +0200, Michal Marek wrote:
> On Thu, Jul 15, 2010 at 11:23:19AM +0800, Zheng, Jiajia wrote:
> > # make rpm
> > make clean
> > set -e; cd ..; ln -sf /usr/src/iwlwifi-2.6 kernel-2.6.35rc4wl
> > /bin/sh /usr/src/iwlwifi-2.6/scripts/setlocalversion --scm-only > /usr/src/iwlwifi-2.6/.scmversion
> > cat: .scmversion: input file is output file
> > make[1]: *** [rpm] Error 1
> > make: *** [rpm] Error 2
> 
> Ah crap :-/. The following patch should fix it. BTW, if you remove the
> --scm-only option and use the LOCALVERSION mechanism, then the resulting
> kernel release string will have the localversion twice.

Hi jiajia,

were you able to test the fix? I'd like to send it to Linus.

Michal


> From 1df62f9175665a0573fe9708cb8604584a9b7bd5 Mon Sep 17 00:00:00 2001
> From: Michal Marek <mmarek@suse.cz>
> Date: Thu, 15 Jul 2010 10:36:37 +0200
> Subject: [PATCH] kbuild: Fix make rpm
> 
> make rpm was broken by commit 0915512:
> make clean
> set -e; cd ..; ln -sf /usr/src/iwlwifi-2.6 kernel-2.6.35rc4wl
> /bin/sh /usr/src/iwlwifi-2.6/scripts/setlocalversion --scm-only >
> /usr/src/iwlwifi-2.6/.scmversion
> cat: .scmversion: input file is output file
> make[1]: *** [rpm] Error 1
> 
> Reported-by: "Zheng, Jiajia" <jiajia.zheng@intel.com>
> Signed-off-by: Michal Marek <mmarek@suse.cz>
> 
> diff --git a/scripts/package/Makefile b/scripts/package/Makefile
> index 3a681ef..d2c29b6 100644
> --- a/scripts/package/Makefile
> +++ b/scripts/package/Makefile
> @@ -44,7 +44,7 @@ rpm-pkg rpm: $(objtree)/kernel.spec FORCE
>  	fi
>  	$(MAKE) clean
>  	$(PREV) ln -sf $(srctree) $(KERNELPATH)
> -	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --scm-only > $(objtree)/.scmversion
> +	$(CONFIG_SHELL) $(srctree)/scripts/setlocalversion --save-scmversion
>  	$(PREV) tar -cz $(RCS_TAR_IGNORE) -f $(KERNELPATH).tar.gz $(KERNELPATH)/.
>  	$(PREV) rm $(KERNELPATH)
>  	rm -f $(objtree)/.scmversion
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> index d6a866e..951b067 100755
> --- a/scripts/setlocalversion
> +++ b/scripts/setlocalversion
> @@ -10,13 +10,13 @@
>  #
>  
>  usage() {
> -	echo "Usage: $0 [--scm-only] [srctree]" >&2
> +	echo "Usage: $0 [--save-scmversion] [srctree]" >&2
>  	exit 1
>  }
>  
>  scm_only=false
>  srctree=.
> -if test "$1" = "--scm-only"; then
> +if test "$1" = "--save-scmversion"; then
>  	scm_only=true
>  	shift
>  fi
> @@ -131,7 +131,10 @@ collect_files()
>  }
>  
>  if $scm_only; then
> -	scm_version
> +	if test ! -e .scmversion; then
> +		res=$(scm_version)
> +		echo "$res" >.scmversion
> +	fi
>  	exit
>  fi
>  
