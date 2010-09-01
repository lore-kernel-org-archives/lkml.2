Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab0IAJvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:51:32 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34109 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077Ab0IAJvb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:51:31 -0400
Date: Wed, 1 Sep 2010 11:51:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Robert Richter <robert.richter@amd.com>
Cc: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt@console-pimps.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] oprofile, x86: fix init_sysfs error handling
Message-ID: <20100901095117.GA4246@elte.hu>
References: <1283107921-21464-1-git-send-email-will.deacon@arm.com>
 <1283107921-21464-2-git-send-email-will.deacon@arm.com>
 <1283107921-21464-3-git-send-email-will.deacon@arm.com>
 <1283107921-21464-4-git-send-email-will.deacon@arm.com>
 <20100830090929.GU22783@erda.amd.com>
 <1283244880.645.17.camel@e102144-lin.cambridge.arm.com>
 <20100831090518.GZ22783@erda.amd.com>
 <1283247089.4063.2.camel@e102144-lin.cambridge.arm.com>
 <20100831103001.GC22783@erda.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100831103001.GC22783@erda.amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> On 31.08.10 05:31:29, Will Deacon wrote:
> > > For x86 wont change the code (actually I found a bug in the init_sysfs
> > > error handler for which I will send a fix). Just wanted to get your
> > > confirmation in case I was missing something that x86 is not affected.
> > > I will apply the first 2 patches, no need to resubmit.
> 
> This is the patch, applied to:
> 
>  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git urgent
> 
> -Robert
> 
> --
> 
> >From 10f0412f57f2a76a90eff4376f59cbb0a39e4e18 Mon Sep 17 00:00:00 2001
> From: Robert Richter <robert.richter@amd.com>
> Date: Mon, 30 Aug 2010 10:56:18 +0200
> Subject: [PATCH] oprofile, x86: fix init_sysfs error handling
> 
> On failure init_sysfs() might not properly free resources. The error
> code of the function is not checked. And, when reinitializing the exit
> function might be called twice. This patch fixes all this.
> 
> Cc: stable@kernel.org
> Signed-off-by: Robert Richter <robert.richter@amd.com>
> ---
>  arch/x86/oprofile/nmi_int.c |   16 +++++++++++++---
>  1 files changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
> index f6b48f6..73a41d3 100644
> --- a/arch/x86/oprofile/nmi_int.c
> +++ b/arch/x86/oprofile/nmi_int.c
> @@ -568,8 +568,13 @@ static int __init init_sysfs(void)
>  	int error;
>  
>  	error = sysdev_class_register(&oprofile_sysclass);
> -	if (!error)
> -		error = sysdev_register(&device_oprofile);
> +	if (error)
> +		return error;
> +
> +	error = sysdev_register(&device_oprofile);
> +	if (error)
> +		sysdev_class_unregister(&oprofile_sysclass);
> +
>  	return error;
>  }
>  
> @@ -695,6 +700,8 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  	char *cpu_type = NULL;
>  	int ret = 0;
>  
> +	using_nmi = 0;
> +
>  	if (!cpu_has_apic)
>  		return -ENODEV;
>  
> @@ -774,7 +781,10 @@ int __init op_nmi_init(struct oprofile_operations *ops)
>  
>  	mux_init(ops);
>  
> -	init_sysfs();
> +	ret = init_sysfs();

FYI, this causes a build error if CONFIG_PM is off:

   arch/x86/oprofile/nmi_int.c:784: error: expected expression before ‘do’

Due to this assymetric form of the wrapper:

  #define init_sysfs() do { } while (0)

The wrapper should be changed to return 0 i suspect, via something like 
this:

  static inline int init_sysfs(void) { return 0; }

(untested)

Thanks,

	Ingo
