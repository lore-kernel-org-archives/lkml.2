Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab0FTIOP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 04:14:15 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:49669 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078Ab0FTIOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 04:14:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=Dn7crRvhtCwf+Ga77PZQW63W2Mliumvt4Ot1VSKABbrAZZkgEiIpEG/o3UEBGuvgni
         R2aavXqtpYnPHxiMQfI+WLgW2KymRxZEN8pGb+bNSqP/2p16ki2x9VVb8EDmtghpdfEl
         33KcBBnq9azEPoqET7L8RlMXg5acfBTqv6GlM=
MIME-Version: 1.0
In-Reply-To: <1276933774.16697.11.camel@maxim-laptop>
References: <20100528100901.14580.1322.stgit@fate.lan> <1276806785.20754.8.camel@maxim-laptop> 
	<20100618112026.17623g6uhdjk8hts@naisho.dyndns.info> <1276856142.9114.1.camel@maxim-laptop> 
	<20100618134930.124225d4fsi8w1fk@naisho.dyndns.info> <1276859156.19554.2.camel@maxim-laptop> 
	<AANLkTimdTjedtoeKAp5tcTqefrUB6k373Kx9EacuYFcO@mail.gmail.com> 
	<1276870309.23783.3.camel@maxim-laptop> <1276933774.16697.11.camel@maxim-laptop>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Sun, 20 Jun 2010 01:13:44 -0700
Message-ID: <AANLkTimIjaxq7IDWwIl1vv93k9bNQ2i89Sb5R5TiJmmA@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH v2] ath5k: disable ASPM
To: Maxim Levitsky <maximlevitsky@gmail.com>,
       David Quan <David.Quan@atheros.com>
Cc: Bob Copeland <me@bobcopeland.com>,
       "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this e-mail is on a public mailing list.

On Sat, Jun 19, 2010 at 12:49 AM, Maxim Levitsky
<maximlevitsky@gmail.com> wrote:
> On Fri, 2010-06-18 at 17:11 +0300, Maxim Levitsky wrote:
>> On Fri, 2010-06-18 at 09:59 -0400, Bob Copeland wrote:
>> > On Fri, Jun 18, 2010 at 7:05 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
>> > >> Patch I made uses GPL code from e1000e, but since ath5k is
>> > >> dual-licensed so patch can't be accepted. So if I got it right, patch
>> > >> has to be remade from scratch by someone who really knows about pci
>> > >> registers etc. I don't, and learning this to fix something that is
>> > >> already fixed in my point of view is waste of (my) time.
>> > > Sure, regardless of licensing, this patch has to be redone (and e1000
>> > > with it)
>> >
>> > At any rate, Jussi, thanks a bundle for tracking it down.  I owe you a
>> > beer, lots of bugs have been reported on these devices.
>> >
>> > Maxim, this device was always broken in the same way, right?  Just
>> > curious if anything made it worse recently.
>>
>> Always was broken, of course even with madwifi.
>>
>> Recently I think driver stopped doing reset on RXORN, which sometimes
>> helped. This did made things a bit worse.
>>
>> Anyway, just disable L0S, and card works perfectly.
>
> How this patch?
> Its same patch but without open coded ASPM disabler.
> Of course to work therefore you need CONFIG_PCIEASPM.
> Without it, this reduces to noop.
> However I asked at linux-pci, and they said that its not a bad idea to
> just remove CONFIG_PCIEASPM and make it default.
>
> I hope there won't be a silly GPL vs BSD debate over one line of code...

When you use the SOB you respect the license of the file you are
editing, please see Documentation/SubmittingPatches Developer's
Certificate of Origin 1.1.

> commit ac5de416f822917b927958b21186a82141550da7
> Author: Maxim Levitsky <maximlevitsky@gmail.com>
> Date:   Thu Jun 17 23:21:42 2010 +0300
>
>    ath5k: disable ASPM

You are not disabling ASPM, you are disabling L0s. ASPM can work with
L1, for example.

>    Atheros card on Acer Aspire One (AOA150, Atheros Communications Inc. AR5001
>    Wireless Network Adapter [168c:001c] (rev 01)) doesn't work well with ASPM
>    enabled. With ASPM ath5k will eventually stall on heavy traffic with often
>    'unsupported jumbo' warnings appearing. Disabling ASPM L0s in ath5k fixes
>    these problems.
>
>    Reproduced with pcie_aspm=force and by using 'nc < /dev/zero > /dev/null' at
>    both ends (usually stalls within seconds).

I *highly* discourage the use of pcie_aspm=force, in fact I'm inclined
to just remove this junk code from the kernel. What you should do to
test ASPM on a device is to use setpci on the config space. I have
documented how you can do this here:

http://wireless.kernel.org/en/users/Documentation/ASPM

Reason for discouraging this is when you use this you enable ASPM on
*all* root complexes and *all* devices which do support ASPM. If you
have another device which is capable of ASPM but has it disabled for
some reason you will run into other issues.

I should also note that loading a module already has an effect on
devices for ASPM. An example today is ath9k's ath9k_hw_init() which
runs simply during module load, this has some ASPM related code which
for example disables the PLL for ASPM for AR9003. I don't recall
exactly what we do with ath5k but just giving you an idea. To truly
test ASPM well I recommend to do something similar as with this script
or you can just give it a shot.

http://kernel.org/pub/linux/kernel/people/mcgrof/aspm/enable-aspm

Not like I expect very different results but just wanted to clarify
the details on force aspm.

Why are you disabling L0s for all devices though? Why not just for the
reported device? Granted, L0s won't save you much more power but
still, why remove it completely, your commit log does not address that
in any way. It only states you have issues with L0s on one chipset but
what the patch really implies is you are disabling L0s completely for
all ath5k chipsets.

David, are you aware of recent L0s issues with some legacy cards?

>    Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
>    Signed-off-by: Maxim Levitsky <maximlevitsky@gmail.com>
>
>
> diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
> index 3abbe75..e7a189a 100644
> --- a/drivers/net/wireless/ath/ath5k/base.c
> +++ b/drivers/net/wireless/ath/ath5k/base.c
> @@ -48,6 +48,7 @@
>  #include <linux/netdevice.h>
>  #include <linux/cache.h>
>  #include <linux/pci.h>
> +#include <linux/pci-aspm.h>
>  #include <linux/ethtool.h>
>  #include <linux/uaccess.h>
>  #include <linux/slab.h>
> @@ -469,6 +470,9 @@ ath5k_pci_probe(struct pci_dev *pdev,
>        int ret;
>        u8 csz;
>
> +       /* Disable PCIE ASPM L0S. It is never enabled by windows driver */
> +       pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +
>        ret = pci_enable_device(pdev);
>        if (ret) {
>                dev_err(&pdev->dev, "can't enable device\n");
> @@ -722,6 +726,8 @@ static int ath5k_pci_resume(struct device *dev)
>        struct ieee80211_hw *hw = pci_get_drvdata(pdev);
>        struct ath5k_softc *sc = hw->priv;
>
> +       pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
> +
>        /*
>         * Suspend/Resume resets the PCI configuration space, so we have to
>         * re-disable the RETRY_TIMEOUT register (0x41) to keep
>
>
>
>
>
>
> _______________________________________________
> ath5k-devel mailing list
> ath5k-devel@lists.ath5k.org
> https://lists.ath5k.org/mailman/listinfo/ath5k-devel
>
