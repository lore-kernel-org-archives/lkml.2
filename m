Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab2LMFVm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 00:21:42 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:35948 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751081Ab2LMFVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 00:21:40 -0500
Date: Wed, 12 Dec 2012 22:21:32 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] NTP: Add a CONFIG_RTC_SYSTOHC configuration
Message-ID: <20121213052132.GA19577@obsidianresearch.com>
References: <20121212055643.GA18078@obsidianresearch.com>
 <50C8DDAA.5010101@linaro.org>
 <20121212210443.GB11530@obsidianresearch.com>
 <50C91ED7.5050905@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C91ED7.5050905@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 04:18:31PM -0800, John Stultz wrote:

> I do, although again, in the case where the arch specific
> implementation is "better", we end up losing granularity (s390 is
> the specific example I'm thinking of), since this prefers the RTC
> implementation over the arch specific one.  So maybe I'd suggest
> switching it so we prefer the arch specific one, and then remove the
> arch specific implementations where they are inferior to the RTC
> one.

Unfortunately I put rtc_update_persistent_clock first because it can
have sensible error reporting. update_persistent_clock will return 0
if there is no RTC device available, or if the RTC was successfully
updated.

I can make rtc_update_persistent_clock return -ENODEV.

> As long as we have a clear iterative path forward, with a solution
> for the cases where the arch method is actually preferred, I think
> it sounds like a reasonable approach.

I think it is fine to leave it as a configure option, archs can
default it to yes when it is appropriate for them.

A quick scan through the 3.7 tree for update_persistent_clock::
 alpha - single non class RTC clock scheme
 cris - printk's and does nothing
 mips - weak function rtc_mips_set_time, all implementations are
        non class rtc
 mn10300 - single non class RTC clock scheme
 powerpc - indirects through ppc_md.set_rtc_time, all implementations
           do not use class RTC
 sh - indirects through rtc_sh_set_time, two implementations, neither
      use class RTC
 sparc - Seems to be class rtc converted. Already implements this
         patch's functionality in an arch specific file
 x86 - All the functions under the set_wallclock indirection seem
       to be non class RTC cases

No other arches seem to have update_persistent_clock in them.

I think the s390 functionality you are refering to is in its
read_persistant_clock, which looks like it has ns resolution.

That is also fine because s390 does not use class rtc so there is no
duplicate path to the 'tod' code either through
rtc_update_persistent_clock or through rtc_hctosys.

Basically, as far as I can tell, if rtc_update_persistent_clock
succeeds then update_persistent_clock is a nop. I can't find any case
where *both* could succeed. Thus trying rtc_update_persistent_clock
first is OK.

Jason
