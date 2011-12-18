Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab1LRWUt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 17:20:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37986 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab1LRWUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 17:20:47 -0500
Date: Sun, 18 Dec 2011 23:20:45 +0100
From: Michal Marek <mmarek@suse.cz>
To: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH] kbuild: add Makefile snippet to list compiled files
Message-ID: <20111218222045.GF25931@sepie.suse.cz>
References: <20111207062524.GA6570@faui49.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207062524.GA6570@faui49.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 07, 2011 at 07:25:37AM +0100, Christian Dietrich wrote:
> To list the compilation units compiled by the current configuration the
> scripts/Makefile.list can be executed. It supports:
> 
> - printing of all compilation units
> - all directories considered for compilation units
> - test if a given file is compiled by the configuration
> - use a different auto.conf
> 
> Signed-off-by: Christian Dietrich <christian.dietrich@informatik.uni-erlangen.de>
> ---
>  Hi,
> 
>  the following patch is a result of our research work at VAMOS[1],
>  where we try to examine the perconditions under which a file is
>  compiled into the linux kernel.
> 
>  While working on this, we needed a way to get all compilation units,
>  which are compiled with the current configuration. And since this
>  might be useful for others, I think it would be great to have this
>  possibility in the mainline kernel.

I agree it would be useful, I have just a couple of comments.

- The user interface should either be a target of the main makefile or
  a script. The make -f call seems a bit clumsy to me.
- You should perhaps start with less features. E.g. overriding the
  location of auto.conf is hardly needed, also the compiled= option adds
  some code, while the goal could be achieved by simply grepping the full
  output.
- The deficiency of the approach is that it misses directories that are
  only visited by an explicit make call in another makefile. An example
  is the arch/x86/boot directory on x86. This should be at least
  documented.
- The output can contain duplicates, if a object file is listed twice in
  a Makefile (e.g. arch/x86/kernel/apic/ipi.o with x86_64 defconfig)
- lib-y is not considered.
- In general, it would be good to do a comparison between the output of
  your Makefile and find -name '*.o' after a build and either fix or
  document the differences.


> +# Read auto.conf if it exists, otherwise ignore
> +ifeq ($(auto_conf),)
> +-include include/config/auto.conf
> +else
> +include $(auto_conf)
> +endif

auto.conf missing should be considered fatal.


> +# The filename Kbuild has precedence over Makefile
> +kbuild-dir := $(if $(filter /%,$(src)),$(src),$(srctree)/$(src))
> +include $(if $(wildcard $(kbuild-dir)/Kbuild), $(kbuild-dir)/Kbuild, $(kbuild-dir)/Makefile)
> +
> +# Figure out what we need to build from the various variables
> +# ==========================================================================
> +
> +__subdir-y	:= $(patsubst %/,%,$(filter %/, $(obj-y)))
> +subdir-y	+= $(__subdir-y)
> +__subdir-m	:= $(patsubst %/,%,$(filter %/, $(obj-m)))
> +subdir-m	+= $(__subdir-m)
> +__subdir-n	:= $(patsubst %/,%,$(filter %/, $(obj-n)))
> +subdir-n	+= $(__subdir-n)
> +__subdir-	:= $(patsubst %/,%,$(filter %/, $(obj-)))
> +subdir-		+= $(__subdir-)
> +
> +# Subdirectories we need to descend into
> +subdir-ym	:= $(sort $(subdir-y) $(subdir-m))
> +subdir-ymn      := $(sort $(subdir-ym) $(subdir-n) $(subdir-))

You are assiging variables that are immediatelly reassigned by
Makefile.lib (if there is a special reason that I'm missing, please
explain in a comment).

Michal
