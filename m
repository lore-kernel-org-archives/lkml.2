Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab0EHPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:25:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36117 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab0EHPZz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:25:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XZaUVHD/olb0iDFFB7HmhksHXGcnZMXSUOWMiVS4xjMqI0kxXBkMwgBwuS3p/+6ZFl
         4qZdO6RGDFdHWB4iqEzOs2RiokwHwE8cgT9v+f6emAv/yY27Ak9TdJtJn/GveGP7TcdZ
         SImZHk1GqYZan33PaKml0bGMyUyMWwtuYs55w=
MIME-Version: 1.0
In-Reply-To: <4BE537E2.6010809@canonical.com>
References: <1273199239-11057-1-git-send-email-bryan.wu@canonical.com>
	 <1273199239-11057-2-git-send-email-bryan.wu@canonical.com>
	 <i2l2acbd3e41005070906me50416bapd8154a567406b886@mail.gmail.com>
	 <4BE537E2.6010809@canonical.com>
Date: Sat, 8 May 2010 10:25:53 -0500
Message-ID: <AANLkTim8SJ0CzC_tRLhSqXdSXHwcDtx5qFy5A4qo3sae@mail.gmail.com>
Subject: Re: [PATCH 1/2] netdev/fec: fix performance impact from mdio poll 
	operation
From: Andy Fleming <afleming@gmail.com>
To: "bryan.wu@canonical.com" <bryan.wu@canonical.com>
Cc: "davem@davemloft.net" <davem@davemloft.net>,
       Sascha Hauer <s.hauer@pengutronix.de>, Greg Ungerer <gerg@uclinux.org>,
       Amit Kucheria <amit.kucheria@canonical.com>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 8, 2010, Bryan Wu <bryan.wu@canonical.com> wrote:
> On 05/08/2010 12:06 AM, Andy Fleming wrote:

> From the BugLink, we experienced a lot of error
>
> The Phy lib is not going to respond well if an mdio
> write times out without returning an error.  And returning an error
> means the whole state machine has to reset, as a failed write is not
> something we currently handle gracefully.
>
>
>
> Right, if we return error to phylib due to mdio read times out, the performance will drop a lot.


Yes, and if you *don't* return an error, you risk incorrect behavior.
This patch changes the driver to return the read result, after
detecting that the read result is invalid.  I don't know what the
value in that register will be, but it can't be correct.  If the
hardware is broken, then we need to find a workaround that doesn't
break things for chips which have working mdio.  It's also possible we
just need a longer timeout.  Does the mdio bus ever return correct
values?




>
>
> Is it possible to use an interrupt to get the phy state change?  This
> would allow the phy lib to stop its incessant polling.  It doesn't
> solve the question of why it's timing out, though.
>
>
>
> I'm going to try the interrupt, but fec driver is shared by several SoCs. It might be a little complicated and still cannot fix the timing out issue. Is there any example driver to use an interrupt to get the phy state change?

Well, there are examples, but they may be only somewhat helpful.  From
the perspective of the PHY Lib, all you have to do is put a correct
value into the irqs array in the mdio bus struct for your bus.  The
part where you will probably have to solve a problem is in figuring
out how to convey that information to the bus driver.  On Power CPUs
and socs, we use a device tree, which has an interrupt associated with
each PHY.  Look at wherever your mdio bus *device* is registered.
That's probably where you'll have that information.

Feel free to look at drivers/net/fsl_pq_mdio.c

Another possibility is to use the fixed link phy driver, which will
never attempt to use the mdio bus, and won't poll.
