Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2FEPGI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 11:06:08 -0400
Received: from smtp109.prem.mail.ac4.yahoo.com ([76.13.13.92]:29939 "HELO
	smtp109.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750912Ab2FEPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 11:06:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: LyOFRbAVM1l6KY0dDIM_aG7ZPHCEkgMUqOQUXP2mSTn6jek
 lTmNnhVZ1sHRIgOQRFMczDtgoYehBljnm7dxoTXBx90SnE7w8z9Zt6ucqa_r
 SQvEYJpZzn.w3ut4m9isMpZuTyOfJhDm95yABRlMCWRWHMdvtwDVImSi32yA
 bosbhhgXQQTtaO9kL4w1nUds1CLEIA301X9EFUkR70XuhXdm4tvBN_uHibF7
 ipziaimXTxdNmmQTMMN_LlPuOdYMn_9d2vt2OPe6eXEm5OOd_bYhe2stFtGm
 osEPAzDyRWmz5Het9MHUOqJFjpPwag7TfQZ6uAdfDaqaapgg.Z2JRzKTkjkF
 S17Od6fUuuahIl8ey6mHL0f2Aky8Uwu4x4ftIEp4Ry9yXgq0issx1DP4lpbm
 BjoGaxGPm8e.e7LL9ExcrwmWtTuwWHiLaWobH
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 5 Jun 2012 09:30:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Anton Vorontsov <anton.vorontsov@linaro.org>
cc: Pekka Enberg <penberg@kernel.org>,
        Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: Re: [PATCH 1/5] vmstat: Implement refresh_vm_stats()
In-Reply-To: <1338553446-22292-1-git-send-email-anton.vorontsov@linaro.org>
Message-ID: <alpine.DEB.2.00.1206050921050.26490@router.home>
References: <20120601122118.GA6128@lizard> <1338553446-22292-1-git-send-email-anton.vorontsov@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Jun 2012, Anton Vorontsov wrote:

> This function forcibly flushes per-cpu vmstat diff counters to the
> global counters.

Why is it necessary to have a function that does not expire the pcps? Is
that side effect important? We use refresh_vm_cpu_stats(cpu) in
page_alloc.c already to flush the vmstat counters. Is the flushing of the
pcps in 2 seconds insteads of 3 once really that important?

Also if we do this

Can we therefore also name the function in a different way like

	flush_vmstats()


> @@ -456,11 +457,15 @@ void refresh_cpu_vm_stats(int cpu)
>  				local_irq_restore(flags);
>  				atomic_long_add(v, &zone->vm_stat[i]);
>  				global_diff[i] += v;
> +				if (!drain_pcp)
> +					continue;
>  #ifdef CONFIG_NUMA
>  				/* 3 seconds idle till flush */
>  				p->expire = 3;
>  #endif

Erm. This should be

#ifdef CONFIG_NUMA
	if (drain_pcp)
		p->expire = 3;
#endif

The construct using "continue" is weird.


>  			}
> +		if (!drain_pcp)
> +			continue;
>  		cond_resched();
>  #ifdef CONFIG_NUMA
>  		/*
> @@ -495,6 +500,21 @@ void refresh_cpu_vm_stats(int cpu)
>  			atomic_long_add(global_diff[i], &vm_stat[i]);
>  }
>
> +void refresh_cpu_vm_stats(int cpu)
> +{
> +	__refresh_cpu_vm_stats(cpu, 1);
> +}

Fold __refresh_cpu_vm_stats into this function and modify the caller
of refresh_cpu_vm_stats instead.

