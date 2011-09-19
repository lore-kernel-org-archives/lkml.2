Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab1ISV2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 17:28:38 -0400
Received: from smtp-out.google.com ([74.125.121.67]:34480 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932360Ab1ISV2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 17:28:37 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:to:cc:subject:message-id:in-reply-to:references:
	x-mailer:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=w49PYAWZCu1WMzwfjqffkENOsPFFRkO9jSb836SrI31F6ZSUONUCgU/4hv2tPOeWv
	CRHmxFpmhvw0Eq4XU9AQA==
Date: Mon, 19 Sep 2011 14:28:01 -0700
From: Andrew Morton <akpm@google.com>
To: Daniel Drake <dsd@laptop.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, rjw@sisk.pl, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] wait for VX855 RTC to become ready during resume
Message-Id: <20110919142801.101ae0ad.akpm@google.com>
In-Reply-To: <20110919103637.E116D9D401D@zog.reactivated.net>
References: <20110919103637.E116D9D401D@zog.reactivated.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Sep 2011 11:36:37 +0100 (BST)
Daniel Drake <dsd@laptop.org> wrote:

> Hi,
> 
> As diagnosed at http://dev.laptop.org/ticket/10757 we are finding that
> the RTC on the VIA VX855 frequently is not 'ready' during system resume.
> 
> Reading from it produces zero. This causes the resume code to fail to
> increment the system clock for the amount of time that was spent sleeping,
> so the time is then wrong.
> 
> We have found that if we wait for the RTC_REF_CLCK_32KHZ signal, the RTC
> does soon start returning 'good' values.
> 
> The patch below demonstrates the solution we have found, but will probably
> make x86 maintainers cry. What would be a good approach to get this
> appropriately quirked and worked around? Detect VX855 southbridge on PCI bus
> and apply the quirk in this case? Do it from OLPC platform code?
> 
> Thanks,
> Daniel
> 
> 
> ---
>  arch/x86/kernel/rtc.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/rtc.c b/arch/x86/kernel/rtc.c
> index 88ee70d..3ad2e47 100644
> --- a/arch/x86/kernel/rtc.c
> +++ b/arch/x86/kernel/rtc.c
> @@ -100,6 +100,21 @@ unsigned long mach_get_cmos_time(void)
>  	unsigned int status, year, mon, day, hour, min, sec, century = 0;
>  
>  	/*
> +	 * dev.laptop.org #10757, sometimes the RTC returns zero data
> +	 * immediately after a resume, so this code will give it some
> +	 * more time by waiting for the 32KHz clock bit to be set, in the
> +	 * hope that this means it is ready to be used.
> +	 */
> +	if (!(CMOS_READ(RTC_FREQ_SELECT) & RTC_REF_CLCK_32KHZ)) {
> +		int n = 0;
> +		printk(KERN_INFO "rtc is insane, waiting for it\n");
> +		while (!(CMOS_READ(RTC_FREQ_SELECT) & RTC_REF_CLCK_32KHZ)) {
> +			cpu_relax();
> +			n++;
> +		}
> +		printk(KERN_INFO "rtc was insane for %d counts\n", n);
> +	}

If the rtc is permanently insane, the kernel locks up.  I'd suggest
adding a timeout.

Perhaps also replace the cpu_relax() with a udelay(1), so the timeout
can be properly implemented and so that the information in that printk
has some useful meaning: "102 microseconds" is better than "11,434 counts".

