Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab1IHXxS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 19:53:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756556Ab1IHXxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 19:53:12 -0400
Date: Thu, 8 Sep 2011 16:52:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: rtc-linux@googlegroups.com, a.zummo@towertech.it,
        linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] rtc: rtc-s3c: fix no occurrence of alarm interrupt
Message-Id: <20110908165247.32902b28.akpm@linux-foundation.org>
In-Reply-To: <1314786110-1297-1-git-send-email-dg77.kim@samsung.com>
References: <1314786110-1297-1-git-send-email-dg77.kim@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Aug 2011 19:21:50 +0900
Donggeun Kim <dg77.kim@samsung.com> wrote:

> The driver does not generate alarm interrupt
> even though time for alarm is set.
> This results from disabling rtc_clk after setting time for alarm.
> To generate alarm interrupt,
> the driver should maintain enabled state for rtc_clk
> until alarm interrupt occurs.
> This patch allows to generate alarm interrupt.
> 
> ...
>
> +static DEFINE_SPINLOCK(s3c_rtc_alarm_clk_lock);
> +
> +static void s3c_rtc_alarm_clk_enable(bool enable)
> +{
> +	static bool alarm_clk_enabled;
> +	unsigned long irq_flags;
> +
> +	spin_lock_irqsave(&s3c_rtc_alarm_clk_lock, irq_flags);
> +	if (enable) {
> +		if (!alarm_clk_enabled) {
> +			clk_enable(rtc_clk);
> +			alarm_clk_enabled = true;
> +		}
> +	} else {
> +		if (alarm_clk_enabled) {
> +			clk_disable(rtc_clk);
> +			alarm_clk_enabled = false;
> +		}
> +	}
> +	spin_unlock_irqrestore(&s3c_rtc_alarm_clk_lock, irq_flags);
> +}

s3c_rtc_alarm_clk_lock is only used within s3c_rtc_alarm_clk_enable(),
so we can reduce its scope:

--- a/drivers/rtc/rtc-s3c.c~rtc-rtc-s3c-fix-no-occurrence-of-alarm-interrupt-fix
+++ a/drivers/rtc/rtc-s3c.c
@@ -50,10 +50,10 @@ static bool wake_en;
 static enum s3c_cpu_type s3c_rtc_cpu_type;
 
 static DEFINE_SPINLOCK(s3c_rtc_pie_lock);
-static DEFINE_SPINLOCK(s3c_rtc_alarm_clk_lock);
 
 static void s3c_rtc_alarm_clk_enable(bool enable)
 {
+	static DEFINE_SPINLOCK(s3c_rtc_alarm_clk_lock);
 	static bool alarm_clk_enabled;
 	unsigned long irq_flags;
 
_

