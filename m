Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751136Ab1LKHbN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 02:31:13 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56316 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1LKHbK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 02:31:10 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.57.177]
In-Reply-To: <20111210181546.6da7099a@notabene.brown>
References: <20111205125416.6093ecd8@notabene.brown> <CAK=Wgbb-6eV6aDxTdi3qFLZmu0cHSZvHRUpUEr3YQ=4tO5sCPw@mail.gmail.com>
 <20111206060654.0e8bebe0@notabene.brown> <CAK=WgbbqgAYZ8uurf+xVyCxfZxoHcLdytxzdUNtoP9VNYPd57A@mail.gmail.com>
 <20111210181546.6da7099a@notabene.brown>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 11 Dec 2011 09:30:48 +0200
Message-ID: <CAK=WgbbZU=NJupPCeXfy5WcFCvzoCgmcf5HPWUEFaHMwLLCWJg@mail.gmail.com>
Subject: Re: [PATCH] mmc/sdio: don't allow interface to runtime-suspend until
 probe is finished.
To: NeilBrown <neilb@suse.de>
Cc: linux-mmc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Daniel Drake <dsd@laptop.org>, Joe Woodward <jw@terrafix.co.uk>,
        Chris Ball <cjb@laptop.org>, Bing Zhao <bzhao@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 10, 2011 at 9:15 AM, NeilBrown <neilb@suse.de> wrote:
> When I force it to hold off suspend for a little while I see (starting at the
> same place):
>
> [  656.189697] bus: 'sdio': driver_probe_device: matched device mmc1:0001:1 with driver libertas_sdio
> [  656.212768] bus: 'sdio': really_probe: probing driver libertas_sdio with device mmc1:0001:1
> [  656.247741] libertas_sdio mmc1:0001:1: firmware: requesting libertas/sd8686_v9_helper.bin
> [  656.257537] device: 'mmc1:0001:1': device_add
> [  656.263580] PM: Adding info for No Bus:mmc1:0001:1
> [  656.298187] device: 'mmc1:0001:1': device_unregister
> [  656.303375] PM: Removing info for No Bus:mmc1:0001:1
> [  656.322967] libertas_sdio mmc1:0001:1: firmware: requesting libertas/sd8686_v8_helper.bin
> [  656.344207] device: 'mmc1:0001:1': device_add
> [  656.357147] PM: Adding info for No Bus:mmc1:0001:1
> [  656.395782] device: 'mmc1:0001:1': device_unregister
> [  656.407409] PM: Removing info for No Bus:mmc1:0001:1
> [  656.418579] libertas_sdio mmc1:0001:1: firmware: requesting sd8686_helper.bin
> [  656.435699] device: 'mmc1:0001:1': device_add
> [  656.446655] PM: Adding info for No Bus:mmc1:0001:1
> [  656.504974] device: 'mmc1:0001:1': device_unregister
> [  656.511749] PM: Removing info for No Bus:mmc1:0001:1
> [  656.521148] libertas_sdio mmc1:0001:1: firmware: requesting sd8686.bin
> [  656.529205] device: 'mmc1:0001:1': device_add
> [  656.535095] PM: Adding info for No Bus:mmc1:0001:1
> [  656.584625] device: 'mmc1:0001:1': device_unregister
> [  656.591369] PM: Removing info for No Bus:mmc1:0001:1
> [  657.384063] libertas_sdio mmc1:0001:1: (unregistered net_device): 00:19:88:3d:ff:f0, fw 9.70.3p24, cap 0x00000303
> [  657.454467] libertas_sdio mmc1:0001:1: (unregistered net_device): PREP_CMD: command 0x00a3 failed: 2
> [  657.464080] device: 'phy0': device_add
>
>
>  But shortly there after the extra tracing I put in shows that mmc_power_off
>  is called,

Probably right after libertas' if_sdio_probe() returns ?

> then mmc_sdio_power_restore calls mmc_send_io_op_cond

Is that as a result of libertas' if_sdio_power_restore() being called
(i.e. someone/something called 'ifconfig up') ?

> which again
>  returns -110, but now it isn't a problem and the wifi chip keeps working.

if_sdio_power_restore doesn't check the return value of
pm_runtime_get_sync, so it won't error out, but I wonder how come the
chip still works.

>  So maybe the fact that we error-out in the first case is a problem??

It might be nice if Marvell could comment on this, though we can
probably empirically deduce this too.

>  I found that if I pull the reset line down and then let it back up then it
>  all works.

Nice. Joe, did this work out for you too ?

> So I have run out of ideas.  I can make it work by reseting the chip during
> mmc_power_up but I have no idea what is causing the chip to need a reset.

I wonder why the sdio reset command isn't helpful for you - it did
seem to resolve some issues for Daniel. Maybe you have two different
hardware revisions of the 8686 which behave differently in this
respect ?

> However for now I think I'll go with my 'remux' hack.

Feel free to post it so we can take a look.

Thanks,
Ohad.
