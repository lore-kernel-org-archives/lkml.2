Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759451Ab2DJUhh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 16:37:37 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:20883 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759399Ab2DJUhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 16:37:35 -0400
Date: Tue, 10 Apr 2012 22:37:33 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Michal Marek <mmarek@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: Re: [PATCH v4 4/4] tools: Connect to the kernel build system
Message-ID: <20120410203733.GD28293@merkur.ravnborg.org>
References: <1334071240-28692-1-git-send-email-bp@amd64.org> <1334071240-28692-5-git-send-email-bp@amd64.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334071240-28692-5-git-send-email-bp@amd64.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 05:20:40PM +0200, Borislav Petkov wrote:
> From: Borislav Petkov <borislav.petkov@amd.com>
> 
> Now you can do
> 
> $ make tools/<toolname>
> 
> from the toplevel kernel directory and have the respective tool built.
> 
> If you want to build and install it, do
> 
> $ make tools/<toolname>_install
> 
> $ make tools/<toolname>_clean
> 
> should clean the respective tool directories.
> 
> If you want to clean all in tools, simply do
> 
> $ make tools/clean
> 
> Also, if you want to get what the possible targets are, simply calling
> 
> $ make tools/
> 
> should give you the short help.
> 
> $ make tools/install
> 
> installs all tools, of course. Doh.
> 
> Cc: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
> ---
>  Makefile       |    7 +++++++
>  tools/Makefile |   25 ++++++++++++++++++++++++-
>  2 files changed, 31 insertions(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 0df3d003a079..e24ce7104f63 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -1468,6 +1468,13 @@ kernelrelease:
>  kernelversion:
>  	@echo $(KERNELVERSION)
>  
> +# Clear a bunch of variables before executing the submake
> +tools/: FORCE
> +	$(Q)$(MAKE) LDFLAGS= -C $(src)/tools/
I think you need to clear MAKEFLAGS here too?

> +
> +tools/%: FORCE
> +	$(Q)$(MAKE) LDFLAGS= MAKEFLAGS= -C $(src)/tools/ $*
> +

>  
> -perf firewire lguest usb virtio vm: FORCE
> +firewire lguest perf usb virtio vm: FORCE
>  	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)

Fold this into 2/4

>  
>  cpupower: FORCE
> @@ -32,6 +42,19 @@ turbostat x86_energy_perf_policy: FORCE
>  selftests: FORCE
>  	$(QUIET_SUBDIR0)testing/$@/ $(QUIET_SUBDIR1)
>  
> +firewire_install lguest_install perf_install usb_install virtio_install vm_install:
> +	$(QUIET_SUBDIR0)$(@:_install=)/ $(QUIET_SUBDIR1) install
> +
> +cpupower_install:
> +	$(QUIET_SUBDIR0)power/$(@:_install=)/ $(QUIET_SUBDIR1) install
> +
> +turbostat_install x86_energy_perf_policy_install:
> +	$(QUIET_SUBDIR0)power/x86/$(@:_install=)/ $(QUIET_SUBDIR1) install
> +
> +install: firewire_install lguest_install perf_install usb_install \
> +		virtio_install vm_install cpupower_install turbostat_install \
> +		x86_energy_perf_policy_install
> +

This really belongs in 2/4 or a separate patch.

Sorry for bing picky about these details - but they destroy
an otherwise fine patch-set.

	Sam
