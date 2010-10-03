Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140Ab0JCVRD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 17:17:03 -0400
Received: from cantor.suse.de ([195.135.220.2]:37337 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab0JCVRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 17:17:02 -0400
From: Thomas Renninger <trenn@suse.de>
To: Heinz Diehl <htd@fritha.org>
Subject: Re: [cpufreq] ondemand: Intel i5-450M gets stuck in lowest state
Date: Sun, 3 Oct 2010 23:16:52 +0200
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
References: <20101003190012.GA29952@fritha.org>
In-Reply-To: <20101003190012.GA29952@fritha.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010032316.52532.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

best you open a bug on:
https://bugzilla.kernel.org

attach acpidump and dmesg and paste below as description.
The root cause should be ACPI related, the patch is in the cpufreq subsystem,
can you assign the bug against ACPI and also CC myself and the cpufreqlist:
cpufreq@vger.kernel.org

It shouldn't be a big deal to get this sanity check in, but it would still
be interesting to know about the latency value exported by the ACPI
tables which seem to be wrong.
Eh, best you also check for a BIOS update, this could fix it.
We might want to reduce the sampling rate
even further for latest CPUs.

Thanks,

        Thomas

On Sunday 03 October 2010 09:00:12 pm Heinz Diehl wrote:
> Hi,
>
> I own a brand new ASUS U45JC laptop with an Intel i5-450M CPU built in.
> During the first compile on it, I noticed that the CPU reached max. 1.33
> GHz using governor "ondemand". Kicking the CPU with a kernel compile using
> "make -j4" didn't help either, max. frequency was nailed at 1.33 GHz. Both
> the latest stable 2.6.35.7 and release candidate 2.6.36-rc6-git2 are
> affected.
>
> After 2 days investigating (I'm not primarily a kernel
> programmer/developer), I came across the solution, and there was already a
> patch available from Thomas Renninger @suse, which I have included in this
> mail. I blindly guess now that a lot of people own a notebook with an Intel
> i5 inside, and maybe (could) have the same problem.
>
> Any chance to get this included in the kernel, or is it just me who
> encounters this problem? The patch applies cleanly against the latest rc,
> and I can confirm that it also fixes the above mentioned problem in
> 2.6.35.7 (I backported it and did try).
>
> Thanks,
> Heinz.
>
>
> ---
>  drivers/cpufreq/cpufreq_ondemand.c |   24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>
> --- a/drivers/cpufreq/cpufreq_ondemand.c
> +++ b/drivers/cpufreq/cpufreq_ondemand.c
> @@ -35,6 +35,7 @@
>  #define MICRO_FREQUENCY_MIN_SAMPLE_RATE		(10000)
>  #define MIN_FREQUENCY_UP_THRESHOLD		(11)
>  #define MAX_FREQUENCY_UP_THRESHOLD		(100)
> +#define MAX_DEFAULT_SAMPLING_RATE		(300 * 1000U)
>
>  /*
>   * The polling frequency of this governor depends on the capability of
> @@ -736,6 +737,29 @@ static int cpufreq_governor_dbs(struct c
>  			dbs_tuners_ins.sampling_rate =
>  				max(min_sampling_rate,
>  				    latency * LATENCY_MULTIPLIER);
> +			/*
> +			 * Cut def_sampling rate to 300ms if it was above,
> +			 * still consider to not set it above latency
> +			 * transition * 100
> +			 */
> +			if (dbs_tuners_ins.sampling_rate > MAX_DEFAULT_SAMPLING_RATE) {
> +				dbs_tuners_ins.sampling_rate =
> +					max(min_sampling_rate, MAX_DEFAULT_SAMPLING_RATE);
> +				printk(KERN_INFO "CPUFREQ: ondemand sampling "
> +				       "rate set to %d ms\n",
> +				       dbs_tuners_ins.sampling_rate / 1000);
> +			}
> +			/*
> +			 * Be conservative in respect to performance.
> +			 * If an application calculates using two threads
> +			 * depending on each other, they will be run on several
> +			 * CPU cores resulting on 50% load on both.
> +			 * SLED might still want to prefer 80% up_threshold
> +			 * by default, but we cannot differ that here.
> +			 */
> +			if (num_online_cpus() > 1)
> +				dbs_tuners_ins.up_threshold =
> +					DEF_FREQUENCY_UP_THRESHOLD / 2;
>  			dbs_tuners_ins.io_is_busy = should_io_be_busy();
>  		}
>  		mutex_unlock(&dbs_mutex);


