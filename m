Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754551Ab1DDMRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 08:17:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60884 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1DDMRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 08:17:18 -0400
Message-ID: <4D99B6CC.7080707@suse.cz>
Date: Mon, 04 Apr 2011 14:17:16 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paulo Marques <pmarques@grupopie.com>
Subject: Re: [PATCH 2/2] kbuild: move KALLSYMS_EXTRA_PASS from Kconfig to
 Makefile
References: <1301913651-9055-1-git-send-email-dedekind1@gmail.com> <1301913651-9055-2-git-send-email-dedekind1@gmail.com>
In-Reply-To: <1301913651-9055-2-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.4.2011 12:40, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> 
> At the moment we have the CONFIG_KALLSYMS_EXTRA_PASS Kconfig switch,
> which users can enable or disable while configuring the kernel. This
> option is then used by 'make' to determine whether an extra kallsyms
> pass is needed or not.
> 
> However, this approach is not nice and confusing, and this patch moves
> CONFIG_KALLSYMS_EXTRA_PASS from Kconfig to Makefile instead. The
> rationale is below.
> 
> 1. CONFIG_KALLSYMS_EXTRA_PASS is really about the build time, not
>    run-time. There is no real need for it to be in Kconfig. It is
>    just an additional work-around which should be used only in rare
>    cases, when someone breaks kallsyms, so Kbuild/Makefile is much
>    better place for this option.
> 2. Grepping CONFIG_KALLSYMS_EXTRA_PASS shows that many defconfigs have
>    it enabled, probably not because they try to work-around a kallsyms
>    bug, but just because the Kconfig help text is confusing and does
>    not really make it clear that this option should not be used unless
>    except when kallsyms is broken.
> 3. And since many people have CONFIG_KALLSYMS_EXTRA_PASS enabled in
>    their Kconfig, we do might fail to notice kallsyms bugs in time. E.g.,
>    many testers use "make allyesconfig" to test builds, which will enable
>    CONFIG_KALLSYMS_EXTRA_PASS and kallsyms breakage will not be noticed.
> 
> To address that, this patch:
> 
> 1. Kills CONFIG_KALLSYMS_EXTRA_PASS
> 2. Changes Makefile so that people can use "make KALLSYMS_EXTRA_PASS=1"
>    to enable the extra pass if needed.
> 3. By default KALLSYMS_EXTRA_PASS is disabled and if kallsyms has issues,
>    "make" should print a warning and suggest using KALLSYMS_EXTRA_PASS
> 4. Add "make help" entry for KALLSYMS_EXTRA_PASS
> 
> Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
> Cc: Paulo Marques <pmarques@grupopie.com>
> Cc: Michal Marek <mmarek@suse.cz>
> ---
>  Makefile     |   13 ++++++++-----
>  init/Kconfig |   12 ------------
>  2 files changed, 8 insertions(+), 17 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index ba7a55c..b66a43a 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -797,15 +797,16 @@ ifdef CONFIG_KALLSYMS
>  # o The correct .tmp_kallsyms2.o is linked into the final vmlinux.
>  # o Verify that the System.map from vmlinux matches the map from
>  #   .tmp_vmlinux2, just in case we did not generate kallsyms correctly.
> -# o If CONFIG_KALLSYMS_EXTRA_PASS is set, do an extra pass using
> +# o If 'make KALLSYMS_EXTRA_PASS=1" was used, do an extra pass using
>  #   .tmp_vmlinux3 and .tmp_kallsyms3.o.  This is only meant as a
>  #   temporary bypass to allow the kernel to be built while the
>  #   maintainers work out what went wrong with kallsyms.
>  
> -ifdef CONFIG_KALLSYMS_EXTRA_PASS
> -last_kallsyms := 3
> -else
>  last_kallsyms := 2
> +ifeq ("$(origin KALLSYMS_EXTRA_PASS)", "command line")

I would drop the origin check here. We use it for single-letter
variables that could be used outside the kernel with a different
meaning, but if you export KALLSYMS_EXTRA_PASS, then you certainly mean
the kernel's KALLSYMS_EXTRA_PASS.

Michal
