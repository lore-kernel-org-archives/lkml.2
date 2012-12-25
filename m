Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2LYFdq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 00:33:46 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:37948 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab2LYFdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 00:33:43 -0500
Message-ID: <50D93AB6.7040905@wwwdotorg.org>
Date: Mon, 24 Dec 2012 22:33:42 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: tegra: dts: add aliases and DMA requestor for serial
 controller
References: <1355898671-3960-1-git-send-email-ldewangan@nvidia.com> <50D1F2CB.3090206@wwwdotorg.org> <50D2AD02.6060101@nvidia.com> <50D344E9.70305@wwwdotorg.org> <50D3E320.2090804@nvidia.com> <50D4CBB0.7080603@wwwdotorg.org> <50D614D9.8020106@nvidia.com>
In-Reply-To: <50D614D9.8020106@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2012 01:15 PM, Laxman Dewangan wrote:
> On Saturday 22 December 2012 02:20 AM, Stephen Warren wrote:
>> On 12/20/2012 09:18 PM, Laxman Dewangan wrote:
>>> On Thursday 20 December 2012 10:33 PM, Stephen Warren wrote:
>>>> On 12/19/2012 11:15 PM, Laxman Dewangan wrote:
>>>>> On Wednesday 19 December 2012 10:30 PM, Stephen Warren wrote:
>>>>>> On 12/18/2012 11:31 PM, Laxman Dewangan wrote:
>>>>>>> Add APB DMA requestor and serial aliases for serial controller.
>>>>>>> There will be two serial driver i.e. 8250 based simple serial driver
>>>>>>> and APB DMA based serial driver for higher baudrate and performace.
>> ...
>>>>>> This patch seems to do two things:
>> ...
>>>>>> 2) Add aliases for the serial ports. I have no idea why this is
>>>>>> useful.
>>>>> Serial aliases are added because we want to get the port number like
>>>>> /dev/ttyTHS0,  /d/ttyTHS2 etc. The uarta should be /dev/ttyTHS0 and
>>>>> uartc should be /dev/ttyTHS2. The port number can be found using
>>>>> aliases
>>>>> and of_alias_get_id() in driver file:
>>>>>
>>>>> port_number = of_alias_get_id(np, "serial");
>>>> Oh, I see. I guess the aliases make sense then.
>>>>
>>>> But, wouldn't you only add aliases for the specific UARTs that are in
>>>> use on a particular board (so put them in tegraNN-board.dts) rather
>>>> than
>>>> all UARTs on Tegra (i.e. the current patch which puts them into
>>>> tegraNN.dtsi)?
>>> I like to have this in tegraN N.dtsi file becasue:
>>> - This policy is not going to change the board to board. For high speed
>>> driver the uarta will be ttyTHS0 and uartb ttyTHS1.
>> Sure it is. Since the board files select which UARTs use the low-speed
>> driver vs. the high-speed driver by overriding the compatible value,
>> each board will have a different subset of UARTs which use the high
>> speed driver and hence which use the aliases. Don't you want to end up
>> with /dev/ttyHS0 on each board, rather than ending up with a "random"
>> device node name depending on which UART the board designer picked for
>> the high speed device?
> 
> We had this in past where we started the high speed driver always from 0
> like in one board uartc become ttyHS0 and another board uarta become
> ttyHS0 and uartc become ttyHS1.
> This confused more to other team (BT and modem team) as they need to
> know all uart instance and their corresponding driver.  So we kept uarta

That doesn't really make sense; The BT and MODEM team should only care
about the specific UARTs they use.

> will be always 0 and uartc will be always 2.

That seems a little unlikely; why can't different boards use different
UARTs for different purposes; after all, UARTA is often a debug UART not
a BT or MODEM UART.

> This way it is straight
> forward for the uart user to directly see the uart instance on board and
> decide the port number rather than going to what are other uart and
> their corresponding driver.

Still, there is some precedent in the kernel for your approach. So, I
guess we can go ahead with using the aliases as-is.

Your approach breaks down in the following scenarios though:

a) Somebody (random customer board designer or SW engineer, who NVIDIA
can't control) wants the console UART to always have alias serial0;
there are examples of this in the kernel. On just the boards we support
upstream, some use UART A for the debug/console and some use UART D. I
know of others that use UART B.

b) The board contains UARTs (e.g. PCIe) that aren't the Tegra-internal
UARTs, so the alias IDs can't all map to Tegra UART IDs.

c) Conceptually, the purpose of aliases seems to be to provide useful
names (numbers) for the relevant ports, and naming/numbering
non-existent ports doesn't seem particularly useful.
