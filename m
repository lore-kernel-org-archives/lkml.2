Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab0IZWs4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:48:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38992
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932504Ab0IZWsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:48:54 -0400
Date: Sun, 26 Sep 2010 15:49:14 -0700 (PDT)
Message-Id: <20100926.154914.48490607.davem@davemloft.net>
To: jgarzik@pobox.com
Cc: linux@rainbow-software.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: de2104x: fix power management
From: David Miller <davem@davemloft.net>
In-Reply-To: <4C9E2E88.3080101@pobox.com>
References: <201009251157.07197.linux@rainbow-software.org>
	<4C9E2E88.3080101@pobox.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Garzik <jgarzik@pobox.com>
Date: Sat, 25 Sep 2010 13:16:56 -0400

> On 09/25/2010 05:57 AM, Ondrej Zary wrote:
>> At least my 21041 cards come out of suspend with bus mastering
>> disabled so
>> they did not work after resume(no data transferred).
>> After adding pci_set_master(), the driver oopsed immediately on resume
>> -
>> because de_clean_rings() is called on suspend but de_init_rings() call
>> was missing in resume.
>>
>> Also disable link (reset SIA) before sleep (de4x5 does this too).
>>
>> Signed-off-by: Ondrej Zary<linux@rainbow-software.org>
 ...
> Acked-by: Jeff Garzik <jgarzik@redhat.com>

I'll apply this, thanks guys.

> IMO suspend/resume could use another look; if netif_running is false
> (interface is down), de2104x does not put the PCI device to sleep,
> which seems strange.

TG3 does the same.

The reason is that until we bringing the device up (and thus
netif_running becomes true) the device is left in the most appropriate
powered down state.

At least that is my understanding.

What is appropriate for any driver in this situation depends upon how
it programs the device before ->open() occurs.

> I also wonder if rtnl_lock() couldn't be eliminated, as other net
> drivers don't need it in suspend/resume.

I suspect the RTNL stuff here can be safely removed.

I think it's using it to guard the netif_running() check but that
isn't necessary.
