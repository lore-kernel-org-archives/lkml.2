Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0KAOWI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 10:22:08 -0400
Received: from slowhand.arndnet.de ([88.198.19.76]:56046 "EHLO mail.unitix.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756461Ab0KAOWG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:22:06 -0400
Message-ID: <4CCECD09.2010505@arndnet.de>
Date: Mon, 01 Nov 2010 15:22:01 +0100
From: Arnd Hannemann <arnd@arndnet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Lightning/1.0b1 Thunderbird/3.0.10
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: regression: b43-sdio: probe of mmc0:0001:1 failed with error
 -16
References: <4CCDA454.708@arndnet.de> <AANLkTin80pwnb1DX8OdZK3Wgsq0nj==G9VM3pahsmo0U@mail.gmail.com> <4CCDE4EB.7060001@arndnet.de> <AANLkTik52SVa0SC_RtNtgFu2U9Gye7BKtQ7jNgMPKe=W@mail.gmail.com> <4CCE74DB.8000206@arndnet.de> <AANLkTinhYqhcQor3PhTKoS3At3Tt2Qv5WAGSirfR8eNG@mail.gmail.com>
In-Reply-To: <AANLkTinhYqhcQor3PhTKoS3At3Tt2Qv5WAGSirfR8eNG@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.11.2010 10:02, schrieb Ohad Ben-Cohen:
> On Mon, Nov 1, 2010 at 10:05 AM, Arnd Hannemann <arnd@arndnet.de> wrote:
>> No, actually mmc_sdio_init_card() is called _before_ sdio_bus_probe
> 
> Yes, it is called once at boot while the card is mmc_rescan()ed.
> 
> But that's not interesting, because the card is then powered down, and
> will only be powered on again when it is probed with a driver.
> 
>> Also mmd_sdio_resume is not called at all.
> 
> Sorry, I meant mmc_sdio_restore_host.
> 
> You should see something like this:
> 
> sdio_bus_probe - >
>     ... (runtime PM function calls) ... ->
>            mmc_power_restore_host ->
>                  mmc_sdio_power_restore ->
>                         mmc_sdio_init_card -> ...
> 
> We have 1 report where the latter mmc_sdio_init_card fails at this
> point, and I'm interested to know whether it fails for you, too (and
> if yes, where). If it is not even called, I'd appreciate if you can
> check out where does this flow break in your case.

It looks like this:

root@ap4evb:~# modprobe b43
[   36.023437] cfg80211: Calling CRDA to update world regulatory domain
[   36.460937] sdio_bus_probe()
[   36.468750] sdio_bus_probe() calling pm_runtime_get_sync()
[   36.468750] mmc_power_restore_host() begin
[   36.570312] mmc_sdio_power_restore() begin
[   36.570312] mmc_sdio_init_card()
[   36.578125] mmc_sdio_init_card() mmc_send_io_op_cond ret=-110
[   36.585937] mmc_sdio_power_restore() end ret=-110
[   36.593750] mmc_power_restore_host() end ret=-110
[   36.593750] sdio_bus_probe() pm_runtime_get_sync ret=-16
[   36.601562] b43-sdio: probe of mmc0:0001:1 failed with error -16

So it seems to fail in mmc_sdio_init_card at the mmc_send_io_op_cond()
call.

> 
>> No mmc_send_relative_addr() does _not_ return -110, actually it
>> is not called at all.
> 
> OK.
> 
>> I inserted a WARN_ON() in sdio_bus_probe, and here is the backtrace I get:
> 
> The interesting part is actually what happens after sdio_bus_probe(),
> not before it.

Actually nothing special happens after sdio_bus_probe()

> 
> Is mmc_power_restore_host being called ? mmc_sdio_power_restore ?
> mmc_sdio_init_card ? etc...
> 
> I'm also attaching a patch that requires hosts to explicitly indicate
> whether they support powering off/on their cards after boot (which
> would prevent SDIO core from powering off you card after boot since
> your host doesn't indicate that capability).
> 
> Can you please see if the problem goes away with it ?

With your patch the problem goes away, thanks.

Regards,
Arnd

