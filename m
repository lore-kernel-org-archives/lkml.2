Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932800Ab2ISRmJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:42:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:65462 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932775Ab2ISRmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:42:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,450,1344236400"; 
   d="scan'208";a="194945840"
Message-ID: <505A03EC.8090502@linux.intel.com>
Date: Wed, 19 Sep 2012 10:42:04 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.de>, kbuild@vger.kernel.org,
        Michal Marek <mmarek@suse.cz>
CC: Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH[ Makefile: Fix scripts_basic / archscripts build order
References: <505A02F8.4040804@suse.de>
In-Reply-To: <505A02F8.4040804@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kbuild people, any comments?

On 09/19/2012 10:38 AM, Jeff Mahoney wrote:
> The SUSE kernel packages are built by doing the following:
> 
> make silentoldonfig
> make prepare
> make scripts
> make clean
> 
> <capture file list used for building modules>
> 
> make -j$NCPUs
> 
> On parallel builds (also using -C/O=), this can occasionally fail with:
>   HOSTCC  scripts/basic/fixdep
>   /bin/sh: scripts/basic/fixdep: No such file or directory
>   make[3]: *** [arch/x86/tools/relocs] Error 1
>   make[2]: *** [archscripts] Error 2
>   make[2]: *** Waiting for unfinished jobs....
>   make[1]: *** [sub-make] Error 2
>   make: *** [all] Error 2
> 
> The error can also be "Permission denied."
> 
> Without the make clean this works ok.
> 
> What seems to be happening is that fixdep exists so relocs is able to be
> rebuilt, but then somewhere there is a FORCE rule that applies to fixdep
> so it is rebuilt. If the timing is right, the relocs build can happen while
> the fixdep rebuild is happening and we either get a non-executable fixdep
> or a nonexistent fixdep.
> 
> This patch moves the archscripts dependency after scripts_basic so that
> fixdep is always built after relocs. If I understand the build order
> correctly, this should be the case since scripts_basic is essentially
> a prereq of everything.
> 
> This was introduced by commit
> 6520fe55 (x86, realmode: 16-bit real-mode code support for relocs),
> which added the archscripts dependency to archprepare.
> 
> Signed-off-by: Jeff Mahoney <jeffm@suse.com>
> ---
>  Makefile |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- a/Makefile
> +++ b/Makefile
> @@ -835,7 +835,7 @@ prepare1: prepare2 include/linux/version
>                     include/config/auto.conf
>  	$(cmd_crmodverdir)
>  
> -archprepare: archheaders archscripts prepare1 scripts_basic
> +archprepare: archheaders scripts_basic archscripts prepare1
>  
>  prepare0: archprepare FORCE
>  	$(Q)$(MAKE) $(build)=.
> 


