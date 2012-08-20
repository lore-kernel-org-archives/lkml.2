Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566Ab2HTVlZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 17:41:25 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:3523 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754308Ab2HTVlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 17:41:22 -0400
Message-ID: <1345498880.18442.33.camel@x61.thuisdomein>
Subject: Re: [PATCH 11/11] x86/Kconfig: Configurations to enable/disable the
 feature
From: Paul Bolle <pebolle@tiscali.nl>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Date: Mon, 20 Aug 2012 23:41:20 +0200
In-Reply-To: <1345277729-8399-12-git-send-email-fenghua.yu@intel.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
	 <1345277729-8399-12-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 20 Aug 2012 21:41:20.0914 (UTC) FILETIME=[89AB7720:01CD7F1C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fenghua,

I have a few comments, that were triggered by scanning just this patch
(they also assume I remember the kconfig language correctly).

On Sat, 2012-08-18 at 01:15 -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> MICROCODE_INTEL_LIB, MICROCODE_INTEL_EARLY, and MICROCODE_EARLY are three new
> configurations to enable or disable the feature.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> ---
>  arch/x86/Kconfig |   22 ++++++++++++++++++++++
>  1 files changed, 22 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 50c660d..32caa77 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1035,6 +1035,7 @@ config MICROCODE_INTEL
>  	depends on MICROCODE
>  	default MICROCODE
>  	select FW_LOADER
> +	select MICROCODE_INTEL_LIB

MICROCODE_INTEL_LIB depends on MICROCODE_INTEL_EARLY.
MICROCODE_INTEL_EARLY itself also selects MICROCODE_INTEL_LIB. So can't
this kconfig entry be made to select MICROCODE_INTEL_EARLY instead?

If it can't select MICROCODE_INTEL_EARLY (because of that symbol's
dependency on BLK_DEV_INITRD) it seems this select could be dropped.

>  	---help---
>  	  This options enables microcode patch loading support for Intel
>  	  processors.
> @@ -1055,6 +1056,27 @@ config MICROCODE_OLD_INTERFACE
>  	def_bool y
>  	depends on MICROCODE
>  
> +config MICROCODE_EARLY
> +	def_bool y
> +	depends on MICROCODE_INTEL_EARLY
> +

MICROCODE_INTEL_EARLY selects this kconfig symbol. Doesn't that mean
that this entry can be simplified to:
    config MICROCODE_EARLY
        bool

> +config MICROCODE_INTEL_LIB
> +	def_bool y
> +	depends on MICROCODE_INTEL_EARLY

If MICROCODE_INTEL could be made to select MICROCODE_INTEL_EARLY (see
above) it seems this could also be shortened:
    config MICROCODE_INTEL_LIB
        bool

> +config MICROCODE_INTEL_EARLY
> +	bool "Early load microcode"
> +	depends on MICROCODE_INTEL && BLK_DEV_INITRD

If MICROCODE_INTEL could be made to select this kconfig symbol than the
dependency on MICROCODE_INTEL could be dropped. But the dependency on
BLK_DEV_INITRD might make that impossible.

> +	default y
> +	select FW_LOADER
> +	select MICROCODE_EARLY
> +	select MICROCODE_INTEL_LIB
> +	help
> +	  This option provides functionality to read additional microcode data
> +	  at the beginning of initrd image. The data tells kernel to load
> +	  microcode to CPU's as early as possible. No functional change if no
> +	  microcode data is glued to the initrd, therefore it's safe to say Y.
> +
>  config X86_MSR
>  	tristate "/dev/cpu/*/msr - Model-specific register support"
>  	---help---


Paul Bolle

