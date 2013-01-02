Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418Ab3ABHaF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 02:30:05 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:49315
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896Ab3ABHaC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 02:30:02 -0500
X-IronPort-AV: E=Sophos;i="4.84,394,1355094000"; 
   d="scan'208";a="167241448"
Date: Wed, 2 Jan 2013 08:29:57 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Tony Prisk <linux@prisktech.co.nz>
cc: Dan Carpenter <error27@gmail.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        kernel-janitors@vger.kernel.org,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH RESEND 6/6] clk: s5p-g2d: Fix incorrect usage of
 IS_ERR_OR_NULL
In-Reply-To: <1357104713.30504.8.camel@gitbox>
Message-ID: <alpine.DEB.2.02.1301020827040.2241@localhost6.localdomain6>
References: <1355852048-23188-1-git-send-email-linux@prisktech.co.nz>  <1355852048-23188-7-git-send-email-linux@prisktech.co.nz>  <50D62BC9.9010706@mvista.com> <50E32C06.5020104@gmail.com>  <CA+_b7DK2zbBzbCh15ikEAeGP5h-V9gQ_YcX15O-RNvWxCk8Zfg@mail.gmail.com>
 <1357104713.30504.8.camel@gitbox>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Jan 2013, Tony Prisk wrote:

> On Wed, 2013-01-02 at 08:10 +0300, Dan Carpenter wrote:
>> clk_get() returns NULL if CONFIG_HAVE_CLK is disabled.
>>
>> I told Tony about this but everyone has been gone with end of year
>> holidays so it hasn't been addressed.
>>
>> Tony, please fix it so people don't apply these patches until
>> clk_get() is updated to not return NULL.  It sucks to have to revert
>> patches.
>>
>> regards,
>> dan carpenter
>
> I posted the query to Mike Turquette, linux-kernel and linux-arm-kernel
> mailing lists, regarding the return of NULL when HAVE_CLK is undefined.
>
> Short Answer: A return value of NULL is valid and not an error therefore
> we should be using IS_ERR, not IS_ERR_OR_NULL on clk_get results.
>
> I see the obvious problem this creates, and asked this question:
>
> If the driver can't operate with a NULL clk, it should use a
> IS_ERR_OR_NULL test to test for failure, rather than IS_ERR.
>
>
> And Russell's answer:
>
> Why should a _consumer_ of a clock care?  It is _very_ important that
> people get this idea - to a consumer, the struct clk is just an opaque
> cookie.  The fact that it appears to be a pointer does _not_ mean that
> the driver can do any kind of dereferencing on that pointer - it should
> never do so.
>
> Thread can be viewed here:
> https://lkml.org/lkml/2012/12/20/105

There are dereferences to the result of clk_get a few times.  I tried the 
following semantic patch:

@@ expression E; identifier I; @@
* E = clk_get(...) ... E->I

It gives the results shown below (- marks matched lines, not lines to 
remove).  I also tried with devm_clk_get instead of clk_get, but got 
nothing.

julia

diff -u -p /var/linuxes/linux-next/arch/sh/kernel/cpufreq.c /tmp/nothing/arch/sh/kernel/cpufreq.c
--- /var/linuxes/linux-next/arch/sh/kernel/cpufreq.c
+++ /tmp/nothing/arch/sh/kernel/cpufreq.c
@@ -117,15 +117,11 @@ static int sh_cpufreq_cpu_init(struct cp

  	dev = get_cpu_device(cpu);

-	cpuclk = clk_get(dev, "cpu_clk");
-	if (IS_ERR(cpuclk)) {
  		dev_err(dev, "couldn't get CPU clk\n");
  		return PTR_ERR(cpuclk);
  	}

-	policy->cur = policy->min = policy->max = sh_cpufreq_get(cpu);

-	freq_table = cpuclk->nr_freqs ? cpuclk->freq_table : NULL;
  	if (freq_table) {
  		int result;

diff -u -p /var/linuxes/linux-next/arch/mips/kernel/cpufreq/loongson2_cpufreq.c /tmp/nothing/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
--- /var/linuxes/linux-next/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
+++ /tmp/nothing/arch/mips/kernel/cpufreq/loongson2_cpufreq.c
@@ -111,13 +111,10 @@ static int loongson2_cpufreq_cpu_init(st
  	if (!cpu_online(policy->cpu))
  		return -ENODEV;

-	cpuclk = clk_get(NULL, "cpu_clk");
-	if (IS_ERR(cpuclk)) {
  		printk(KERN_ERR "cpufreq: couldn't get CPU clk\n");
  		return PTR_ERR(cpuclk);
  	}

-	cpuclk->rate = cpu_clock_freq / 1000;
  	if (!cpuclk->rate)
  		return -EINVAL;

diff -u -p /var/linuxes/linux-next/drivers/net/ethernet/ti/cpts.c /tmp/nothing/drivers/net/ethernet/ti/cpts.c
--- /var/linuxes/linux-next/drivers/net/ethernet/ti/cpts.c
+++ /tmp/nothing/drivers/net/ethernet/ti/cpts.c
@@ -241,14 +241,10 @@ static void cpts_overflow_check(struct w

  static void cpts_clk_init(struct cpts *cpts)
  {
-	cpts->refclk = clk_get(NULL, CPTS_REF_CLOCK_NAME);
-	if (IS_ERR(cpts->refclk)) {
  		pr_err("Failed to clk_get %s\n", CPTS_REF_CLOCK_NAME);
  		cpts->refclk = NULL;
  		return;
  	}
-	clk_enable(cpts->refclk);
-	cpts->freq = cpts->refclk->recalc(cpts->refclk);
  }

  static void cpts_clk_release(struct cpts *cpts)
diff -u -p /var/linuxes/linux-next/drivers/i2c/busses/i2c-sh7760.c /tmp/nothing/drivers/i2c/busses/i2c-sh7760.c
--- /var/linuxes/linux-next/drivers/i2c/busses/i2c-sh7760.c
+++ /tmp/nothing/drivers/i2c/busses/i2c-sh7760.c
@@ -397,11 +397,7 @@ static int calc_CCR(unsigned long scl_hz
  	signed char cdf, cdfm;
  	int scgd, scgdm, scgds;

-	mclk = clk_get(NULL, "peripheral_clk");
-	if (IS_ERR(mclk)) {
  		return PTR_ERR(mclk);
-	} else {
-		mck = mclk->rate;
  		clk_put(mclk);
  	}

