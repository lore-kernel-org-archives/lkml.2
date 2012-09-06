Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758877Ab2IFPtP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 11:49:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46648 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758581Ab2IFPtM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 11:49:12 -0400
MIME-Version: 1.0
X-Originating-IP: [84.202.62.221]
In-Reply-To: <20120905.173023.2235590074897156746.davem@davemloft.net>
References: <cover.1346775479.git.nicolas.ferre@atmel.com>
	<40f02ee50a29aaec6c949432a1bcf09f4b027181.1346775479.git.nicolas.ferre@atmel.com>
	<20120905.173023.2235590074897156746.davem@davemloft.net>
Date: Thu, 6 Sep 2012 17:49:11 +0200
Message-ID: <CACiLriTSddM-5pnpii9c+4dA++OrsKovGLabegdwSRLchuSnAA@mail.gmail.com>
Subject: Re: [PATCH 04/10] net/macb: Fix a race in macb_start_xmit()
From: Havard Skinnemoen <havard@skinnemoen.net>
To: David Miller <davem@davemloft.net>
Cc: nicolas.ferre@atmel.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, plagnioj@jcrosoft.com,
        jamie@jamieiles.com, linux-kernel@vger.kernel.org,
        patrice.vilchez@atmel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 5, 2012 at 11:30 PM, David Miller <davem@davemloft.net> wrote:
> From: Nicolas Ferre <nicolas.ferre@atmel.com>
> Date: Wed, 5 Sep 2012 10:19:11 +0200
>
>> From: Havard Skinnemoen <havard@skinnemoen.net>
>>
>> Fix a race in macb_start_xmit() where we unconditionally set the TSTART bit.
>> If an underrun just happened (we do this with interrupts disabled, so it might
>> not have been handled yet), the controller starts transmitting from the first
>> entry in the ring, which is usually wrong.
>> Restart the controller after error handling.
>>
>> Signed-off-by: Havard Skinnemoen <havard@skinnemoen.net>
>> [nicolas.ferre@atmel.com: split patch in topics]
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>
> Accumulating special case code and checks into the hot path of TX packet
> processing is extremely unwise.
>
> Instead, when you handle the TX error conditions and reset the chip you
> should first ensure that there are no flows of control in the transmit
> function of your driver by using the appropriate locking et al. facilities.

IIRC, the hardware resets the ring pointers when an error happens, and
if we set TSTART right after that happens, the hardware will happily
transmit whatever is sitting in the beginning of the ring. This is
what I was trying to avoid.

The details are a bit hazy as it's been a while since I looked at
this, so it could be that simply letting it happen and using a bigger
hammer during reset processing might work just as well. Just want to
make sure y'all understand that we're talking about a race against
hardware, not against interrupt handlers, threads or anything that can
be solved by locking :)

Havard
