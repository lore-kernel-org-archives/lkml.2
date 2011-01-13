Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932926Ab1AMKy6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 05:54:58 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60362 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932424Ab1AMKy5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 05:54:57 -0500
Subject: Re: sparc boot failure due to perf init
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
In-Reply-To: <20110109.153745.35032992.davem@davemloft.net>
References: <1294431832.2016.457.camel@laptop>
	 <1294432055.2016.458.camel@laptop>
	 <20110107203119.GA30408@merkur.ravnborg.org>
	 <20110109.153745.35032992.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 13 Jan 2011 11:55:28 +0100
Message-ID: <1294916129.19601.88.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 15:37 -0800, David Miller wrote:
> sparc64: Fix bootup regression due to perf init ordering.
> 
> Commit 004417a6d468e24399e383645c068b498eed84ad
> ("perf, arch: Cleanup perf-pmu init vs lockup-detector")
> move the perf events init to be an early_initcall.
> 
> But this won't work properly unless the dependencies for
> this code initialize beforehand.
> 
> Fix it by making cpu_type_probe and pcr_arch_init be
> an early_initcall as well.
> 
> Reported-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  arch/sparc/kernel/cpu.c |    2 +-
>  arch/sparc/kernel/pcr.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/sparc/kernel/cpu.c b/arch/sparc/kernel/cpu.c
> index e447938..0dc714f 100644
> --- a/arch/sparc/kernel/cpu.c
> +++ b/arch/sparc/kernel/cpu.c
> @@ -375,5 +375,5 @@ static int __init cpu_type_probe(void)
>         return 0;
>  }
>  
> -arch_initcall(cpu_type_probe);
> +early_initcall(cpu_type_probe);
>  #endif
> diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
> index b87873c..ae96cf5 100644
> --- a/arch/sparc/kernel/pcr.c
> +++ b/arch/sparc/kernel/pcr.c
> @@ -168,4 +168,4 @@ out_unregister:
>         return err;
>  }
>  
> -arch_initcall(pcr_arch_init);
> +early_initcall(pcr_arch_init);


I just realized, doesn't this make bootability depend on link order?
Since both the pmu init and its dependencies are now early_initcall()
how do we guarantee pcr_arch_init() and cpu_type_probe() are in fact
called _before_ init_hw_perf_events()?
