Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab2DTPCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:02:05 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:33545 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127Ab2DTPCD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:02:03 -0400
Date: Fri, 20 Apr 2012 17:02:01 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Daney <ddaney.cavm@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, Andrew Morton <akpm@linux-foundation.org>,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v2 3/5] kbuild/extable: Hook up sortextable into the
	build system.
Message-ID: <20120420150201.GB2891@merkur.ravnborg.org>
References: <1334872799-14589-1-git-send-email-ddaney.cavm@gmail.com> <1334872799-14589-4-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334872799-14589-4-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 02:59:57PM -0700, David Daney wrote:
> From: David Daney <david.daney@cavium.com>
> 
> Define a config variable BUILDTIME_EXTABLE_SORT to control build time
> sorting of the kernel's exception table.
> 
> Patch Makefile to do the sorting when BUILDTIME_EXTABLE_SORT is
> selected.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> ---
>  Makefile     |   10 ++++++++++
>  init/Kconfig |    3 +++
>  2 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index ae947cc..e3bbca9 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -784,6 +784,10 @@ quiet_cmd_vmlinux_version = GEN     .version
>  quiet_cmd_sysmap = SYSMAP
>        cmd_sysmap = $(CONFIG_SHELL) $(srctree)/scripts/mksysmap
>  
> +# Sort exception table at build time
> +quiet_cmd_sortextable = SORTEX
> +      cmd_sortextable = $(objtree)/scripts/sortextable
> +
>  # Link of vmlinux
>  # If CONFIG_KALLSYMS is set .version is already updated
>  # Generate System.map and verify that the content is consistent
> @@ -796,6 +800,12 @@ define rule_vmlinux__
>  	$(call cmd,vmlinux__)
>  	$(Q)echo 'cmd_$@ := $(cmd_vmlinux__)' > $(@D)/.$(@F).cmd
>  
> +	$(if $(CONFIG_BUILDTIME_EXTABLE_SORT),				\
> +	  $(Q)$(if $($(quiet)cmd_sortextable),				\
> +	    echo '  $($(quiet)cmd_sortextable)  vmlinux' &&)		\
> +	  $(cmd_sortextable)  vmlinux)
> +
> +

Anything that add complexity to the top-level Makefile is bad :-(
I once looked at moving all the final link stuff to a script.
Maybe it is time to open that again...


> +config BUILDTIME_EXTABLE_SORT
> +	bool
> +
Please add a comment about what this symbol is used for.
Also we often name such symbols: HAVE_*

	Sam
