Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab1CHAxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 19:53:01 -0500
Received: from mail.windriver.com ([147.11.1.11]:45799 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab1CHAxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 19:53:00 -0500
Message-ID: <4D757DE8.30602@windriver.com>
Date: Mon, 07 Mar 2011 19:52:56 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110127 Thunderbird/3.1.7
MIME-Version: 1.0
To: Fernando Lopez-Lezcano <nando@ccrma.stanford.edu>
CC: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] RT for v2.6.34.8 now available.
References: <4D71668F.9050201@windriver.com> <4D748070.1030502@localhost> <4D753970.4030607@localhost> <4D7542E9.4000008@localhost> <4D754591.1090602@windriver.com> <4D7545F5.6080706@localhost>
In-Reply-To: <4D7545F5.6080706@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2011 00:52:57.0821 (UTC) FILETIME=[2A9940D0:01CBDD2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-03-07 03:54 PM, Fernando Lopez-Lezcano wrote:
> On 03/07/2011 12:52 PM, Paul Gortmaker wrote:
>> On 11-03-07 03:41 PM, Fernando Lopez-Lezcano wrote:

[...]

>>> ...
>>>> - EeePC netbook, Fedora 13, Intel Mobile 945GME graphics: X does not start
>>>> - Lenovo laptop, fedora 14, Intel 9xx graphics (at home): X does not start
>>>> These last two share Intel graphics and the problem seems to be the
>>>> same, something to do with dri.
>>>
>>> This is what I'm getting (dmesg|grep i915):
>>>
>>> i915 0000:00:02.0 PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
>>> i915 0000:00:02.0 setting latency timer to 64
>>> i915 0000:00:02.0 PCI INT A disabled
>>> i915: probe of 0000:00:02.0 failed with error -5
>>>
>>> Same kernel w/o rt...:
>>>
>>> i915 0000:00:02.0 PCI INT A ->  GSI 16 (level, low) ->  IRQ 16
>>> i915 0000:00:02.0 setting latency timer to 64
>>> [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
>>>
>>> So, some problem with irq processing?
>>> Where should I go look?
>>
>> Try v2.6.33-rt -- see if it is a new regression, or was a problem that
>> already existed and has just been carried forward.
> 
> 2.6.33.x-rt30 works on all of the above so it seems this is new... (yuck :-)
> (just in case, this is not pristine 2.6.34.8 + rt git)

I'm pretty sure I know what this is.  If you cherry pick the two
commits from tip, namely:

	e89fab2bf44afccaa48ffb8ae33c03f4f3dcd208 and
	cd4ac9b7a1c80cfcd9b8e76a1f6855a0329d982f

then I'll bet your i915 gets detected OK.  I was forced to
drop these because they allow ATOMIC_IOMAP to be selected
for RT & HIGHMEM, which causes sporadic bootup Oops (approx
one in 10) for intel ata_piix.  (This problem isn't new; it
is present in v2.6.33.7.2-rt30 by the way.)

But w/o ATOMIC_IOMAP, people on 32bit stuff end up trying to
grab a big chunk of address space that they can't afford, and
so the driver init fails.

The proper solution needs more thought, but in the meantime I'll
bet the above makes your i915 work again.

Related info to this can be found here:

http://lkml.indiana.edu/hypermail/linux/kernel/0811.0/00411.html

Tip repo, if you don't have it, is here:

git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git

Paul.


> 
> -- Fernando
