Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756216Ab1AKPrv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 10:47:51 -0500
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39110 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755858Ab1AKPrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 10:47:49 -0500
Subject: Re: [tip:x86/urgent] x86: tsc: Prevent delayed init if initial tsc
 calibration failed
From: John Stultz <john.stultz@linaro.org>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, kas@openvz.org
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-29fe359ca20326e57b25e8545c49ed9ff5e830c7@git.kernel.org>
References: <tip-29fe359ca20326e57b25e8545c49ed9ff5e830c7@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Jan 2011 07:46:46 -0800
Message-ID: <1294760806.2744.8.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-11 at 10:51 +0000, tip-bot for Thomas Gleixner wrote:
> Commit-ID:  29fe359ca20326e57b25e8545c49ed9ff5e830c7
> Gitweb:     http://git.kernel.org/tip/29fe359ca20326e57b25e8545c49ed9ff5e830c7
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Tue, 11 Jan 2011 11:40:48 +0100
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Tue, 11 Jan 2011 11:48:39 +0100
> 
> x86: tsc: Prevent delayed init if initial tsc calibration failed
> 
> commit a8760ec (x86: Check tsc available/disabled in the delayed init
> function) missed to prevent the setup of the delayed init function in
> case the initial tsc calibration failed. This results in the same
> divide by zero bug as we have seen without the tsc disabled check.
> 
> Skip the delayed work setup when tsc_khz (the initial calibration
> value) is 0.
> 
> Bisected-and-tested-by: Kirill A. Shutemov <kas@openvz.org>
> Cc: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Krill: Thanks for reporting and testing!

Thomas: Thanks for the fix. I'll see if we can't condense the invalid
states a bit more. If tsc_khz=0, we probably should set tsc_disabled.

Acked-by: John Stultz <johnstul@us.ibm.com>

> ---
>  arch/x86/kernel/tsc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
> index 356a0d4..463901e 100644
> --- a/arch/x86/kernel/tsc.c
> +++ b/arch/x86/kernel/tsc.c
> @@ -965,7 +965,7 @@ out:
> 
>  static int __init init_tsc_clocksource(void)
>  {
> -	if (!cpu_has_tsc || tsc_disabled > 0)
> +	if (!cpu_has_tsc || tsc_disabled > 0 || !tsc_khz)
>  		return 0;
> 
>  	if (tsc_clocksource_reliable)


