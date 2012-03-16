Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161938Ab2CPWXc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 18:23:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53151 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964942Ab2CPWXa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 18:23:30 -0400
Date: Fri, 16 Mar 2012 15:23:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: shuox.liu@intel.com
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yanmin Zhang <yanmin_zhang@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "Brown, Len" <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Greg KH <gregkh@linuxfoundation.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "H. Peter Anvin" <hpa@zytor.com>, andi.kleen@intel.com,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: Re: [linux-pm] [PATCH v4] cpuidle: Add a sysfs entry to disable
 specific C state for debug purpose.
Message-Id: <20120316152323.3c629e5c.akpm@linux-foundation.org>
In-Reply-To: <4F600F78.2060902@intel.com>
References: <CAGF5oy_BUytjeDa8Oc62pRabaEqwqKCFuVJuzLd-XNZg34ne2w@mail.gmail.com>
	<1330998885.1916.89.camel@ymzhang>
	<20120306052236.GA19416@kroah.com>
	<1331013078.1916.103.camel@ymzhang>
	<20120306143935.GA23346@kroah.com>
	<20120312181151.GE14020@sirena.org.uk>
	<20120312192936.GC24873@kroah.com>
	<1331602594.1916.155.camel@ymzhang>
	<20120313192949.GA8568@kroah.com>
	<1331686500.1916.172.camel@ymzhang>
	<20120314024619.GC22955@kroah.com>
	<4F600F78.2060902@intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2012 11:24:40 +0800
ShuoX Liu <shuox.liu@intel.com> wrote:

> From: ShuoX Liu <shuox.liu@intel.com>
> 
> Some C states of new CPU might be not good. One reason is BIOS might configure
> them incorrectly. To help developers root cause it quickly, the patch adds a
> new sysfs entry, so developers could disable specific C state manually.
> 
> In addition, C state might have much impact on performance tuning, as it takes
> much time to enter/exit C states, which might delay interrupt processing. With
> the new debug option, developers could check if a deep C state could  impact
> performance and how much impact it could cause.
> 
> ...
>
> +#define define_store_state_function(_name) \
> +static ssize_t store_state_##_name(struct cpuidle_state *state, \
> +		const char *buf, size_t size) \
> +{ \
> +	long value; \
> +	if (!capable(CAP_SYS_ADMIN)) \
> +		return -EPERM; \
> +	kstrtol(buf, 0, &value); \
> +	if (value) \
> +		state->disable = 1; \
> +	else \
> +		state->disable = 0; \
> +	return size; \
> +}

drivers/cpuidle/sysfs.c: In function 'store_state_disable':
drivers/cpuidle/sysfs.c:274: warning: ignoring return value of 'kstrtol', declared with attribute warn_unused_result

The check is there for a reason - the kernel shouldn't silently accept
random garbage inputs.

--- a/drivers/cpuidle/sysfs.c~cpuidle-add-a-sysfs-entry-to-disable-specific-c-state-for-debug-purpose-fix
+++ a/drivers/cpuidle/sysfs.c
@@ -238,9 +238,12 @@ static ssize_t store_state_##_name(struc
 		const char *buf, size_t size) \
 { \
 	long value; \
+	int err; \
 	if (!capable(CAP_SYS_ADMIN)) \
 		return -EPERM; \
-	kstrtol(buf, 0, &value); \
+	err = kstrtol(buf, 0, &value); \
+	if (err) \
+		return err; \
 	if (value) \
 		state->disable = 1; \
 	else \
_

