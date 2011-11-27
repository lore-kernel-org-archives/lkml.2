Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab1K0GU7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 01:20:59 -0500
Received: from nbd.name ([46.4.11.11]:57195 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751635Ab1K0GU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 01:20:57 -0500
Message-ID: <4ED1D6AE.9070100@openwrt.org>
Date: Sun, 27 Nov 2011 13:20:30 +0700
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Wireless <linux-wireless@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Subject: Re: [Regression, 3.2-rc1] ath9k broken on AR928X
References: <CA+55aFyNUC+k1gp3MQkxQzernEzRZwYOH4EBnOq=6UiaJ2oh4A@mail.gmail.com> <201111250203.29786.rjw@sisk.pl> <201111262232.46195.rjw@sisk.pl>
In-Reply-To: <201111262232.46195.rjw@sisk.pl>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-27 4:32 AM, Rafael J. Wysocki wrote:
> On Friday, November 25, 2011, Rafael J. Wysocki wrote:
>> On Thursday, November 24, 2011, Linus Torvalds wrote:
>> > Hey, since most of the US will be in a food-induced coma tomorrow, I
>> > just *know* that doing a new release candidate is a good idea.
>> > 
>> > One quarter arch updates, two quarters drivers, and one quarter random
>> > changes. Shake vigorously and serve cold..
>> > 
>> > And maybe the rest of the world can try to make up for the lack of any
>> > expected US participation? Hmm?
>> 
>> Well, unfortunately, this kernel is unusable on my Acer Ferrari One.
>> 
>> First off, it hangs solid every time several seconds or at last a few
>> minutes after boot.  I haven't been able to collect any debug data from
>> it yet, but one of the symptoms is black screen with (unmovable) mouse
>> cursor (this only happens when X has been started, but the box hangs without
>> X too).
>> 
>> Second, the wireless is apparently unable to associate with the AP
>> (that 3.1-rc10 works with correctly on the same box).
>> 
>> Tomorrow I'll try to identify the offending commits.
> 
> Well, it took more time than I had hoped. :-(
> 
> Bisection turns up:
> 
> commit 2577c6e8f2320f1d2f09be122efef5b9118efee4
> Author: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> Date:   Tue Sep 13 22:38:18 2011 +0530
> 
>     ath9k_hw: Add support for AR946/8x chipsets.
>     
>     This patch adds support for AR946/8x chipets.
>     
>     Signed-off-by: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> which I think is wrong for at lest two reasons.  Not that I understand
> what it actually does to the driver, but first, it does much more than the
> changelog says and, second, it is practically impossible to revert
> because of the number of commits on top depending on it.  Quite frankly,
> it is about to make it to my list of examples of how things should _not_ be
> done in the kernel.
> 
> The commit immediately preceding it doesn't show any symptoms of failure, so
> I'm quite convinced this one really introduced the problem for me.
> 
> The chip in the affected box is (according to "lspci -v"):
> 
> 09:00.0 Network controller: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
>         Subsystem: Foxconn International, Inc. Device e01f
>         Flags: bus master, fast devsel, latency 0, IRQ 19
>         Memory at f0000000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 2
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [60] Express Legacy Endpoint, MSI 00
>         Capabilities: [90] MSI-X: Enable- Count=1 Masked-
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-00-00-00-00-00-00-00
>         Kernel driver in use: ath9k
> 
> Thanks,
> Rafael

Looking at the diff, the only thing I can find that would break AR928x
is this (in the function ath9k_set_power_sleep in hw.c):

        /* Clear Bit 14 of AR_WA after putting chip into Full Sleep mode. */
-       if (AR_SREV_9300_20_OR_LATER(ah))
-               REG_WRITE(ah, AR_WA,
-                         ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
+       if (!AR_SREV_9480(ah))
+               REG_WRITE(ah, AR_WA, ah->WARegVal & ~AR_WA_D3_L1_DISABLE);
 }


Please try changing the if line to:
if (AR_SREV_9300_20_OR_LATER(ah) && !AR_SREV_9480(ah))

Apparently later changes even removed this check. I'll take a look at the
history to figure out what's going on, this could probably explain other
regressions on pre-AR9380 chips as well.

- Felix
