Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab0FUFx5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 01:53:57 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:56812 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0FUFxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 01:53:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=TSb17VNJC7IWSqOcToYyYU+Vs4mcVoV4pd8MOoLgdxpguHAGWGDYMBsPWmpUonWSp4
         OsFSZ4shZvuxLuxPNtZtRVCKsLW6qoWuJDmdPG/as5G1X00BVl+T9F0ZYX0f/g0JYs+G
         eZT813dBOLFgHVQzR7E7IQGgaDEuA9aBuWt7w=
MIME-Version: 1.0
In-Reply-To: <1277032723.9555.12.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan> <1276806785.20754.8.camel@maxim-laptop> 
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info> <1276856142.9114.1.camel@maxim-laptop> 
	<20100618134930.124225d4fsi8w1fk@naisho.dyndns.info> <1276859156.19554.2.camel@maxim-laptop> 
	<AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> 
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop> 
	<AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com> 
	<1277032723.9555.12.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 20 Jun 2010 22:53:32 -0700
Message-ID: <AANLkTim8iZmm8pEERJUsrQWOiLSjPUfCN-TFFzZZQWx2@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: David Quan <David.Quan@atheros.com>, Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 20, 2010 at 4:18 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> On Sun, 2010-06-20 at 01:13 -0700, Luis R. Rodriguez wrote:
>> > commit ac5de416f822917b927958b21186a82141550da7
>> > Author: Maxim Levitsky <maximlevitsky@gmail.com>
>> > Date:   Thu Jun 17 23:21:42 2010 +0300
>> >
>> >    ath5k: disable ASPM
>>
>> You are not disabling ASPM, you are disabling L0s. ASPM can work with
>> L1, for example.
> This is left over from original patch.

Your latest patch still has all this old info, please adjust.

> with open coded code I was able to disable just L0s and get stable
> operation.
> Note however that with this patch which implies CONFIG_PCIEASPM, pci
> core disables both L0s and L1

You do not need CONFIG_PCIEASPM to use ASPM on Linux, that is another
thing I have been meaning to clarify upstream but haven't had time to
do so yet.

> (I still need to test and see if I need that patch at all. Maybe just
> enabling CONFIG_PCIEASPM is enough...)

You should be able to test ASPM by just enabling the driver.

>> >    Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
>> >    Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
>> >    enabled. With ASPM ath5k will eventually stall on heavy traffic with often
>> >    'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
>> >    these problems.
>> >
>> >    Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
>> >    both ends (usually stalls within seconds).
>>
>> I *highly* discourage the use of pcie_aspm=force, in fact I'm inclined
>> to just remove this junk code from the kernel. What you should do to
>> test ASPM on a device is to use setpci on the config space. I have
>> documented how you can do this here:
>>
>> http://wireless.kernel.org/en/users/Documentation/ASPM
>>
>> Reason for discouraging this is when you use this you enable ASPM on
>> *all* root complexes and *all* devices which do support ASPM. If you
>> have another device which is capable of ASPM but has it disabled for
>> some reason you will run into other issues.
>>
>> I should also note that loading a module already has an effect on
>> devices for ASPM. An example today is ath9k's ath9k_hw_init() which
>> runs simply during module load, this has some ASPM related code which
>> for example disables the PLL for ASPM for AR9003. I don't recall
>> exactly what we do with ath5k but just giving you an idea. To truly
>> test ASPM well I recommend to do something similar as with this script
>> or you can just give it a shot.
>>
>> http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm
>>
>> Not like I expect very different results but just wanted to clarify
>> the details on force aspm.
>>
>> Why are you disabling L0s for all devices though? Why not just for the
>> reported device? Granted, L0s won't save you much more power but
>> still, why remove it completely, your commit log does not address that
>> in any way. It only states you have issues with L0s on one chipset but
>> what the patch really implies is you are disabling L0s completely for
>> all ath5k chipsets.
>
> First of all there aren't many PCIE ath5k based devices.

Doesn't matter.

> Two of them are known to be broken.

Which ones?

> Also Jussi Kivilinna said that he found that in windows .inf file there
> are some instructions to enable L1 but not L0s.

For which chipsets?

> Note that I tested that again, and card works very stable.

Thanks for your work on this, I want to just check internally if there
is another way, that's all.

> I didn't see a single drop to 0 bytes/s. In fact throughput never drops
> below 1 Mb/s. (usually about 2.4 Mb/s, with rare drops for few seconds
> to ~1Mb/s)

Disabling L0s should not affect performance.

  Luis
