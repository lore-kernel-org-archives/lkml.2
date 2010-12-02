Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758114Ab0LBVMM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:12:12 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50108
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757967Ab0LBVMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:12:10 -0500
Date: Thu, 02 Dec 2010 13:12:36 -0800 (PST)
Message-Id: <20101202.131236.28815617.davem@davemloft.net>
To: tomoya-linux@dsn.okisemi.com
Cc: wg@grandegger.com, w.sang@pengutronix.de, chripell@fsfe.org,
        21cnbao@gmail.com, sameo@linux.intel.com,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qi.wang@intel.com, yong.y.wang@intel.com,
        andrew.chih.howe.khor@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, margie.foster@intel.com
Subject: Re: [PATCH net-next-2.6 v6 04/20] can: EG20T PCH: Add Tx Flow
 Control
From: David Miller <davem@davemloft.net>
In-Reply-To: <4CF47B2C.4010507@dsn.okisemi.com>
References: <4CF47B2C.4010507@dsn.okisemi.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Date: Tue, 30 Nov 2010 13:18:52 +0900

> Currently, there is no flow control processing.
> Thus, Add flow control processing as
> when there is no empty of tx buffer,
> netif_stop_queue is called.
> When there is empty buffer, netif_wake_queue is called.
> 
> Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>

When implementing functionality like this it is better to use other
existing well tested network drivers as a guide rather then trying
to be unique and clever, as you are doing here.

First of all, your netif_wake_queue() call is racy.  Because another
thread can be queueing up packets, fill the queue, and execute a
stop queue right when you have made the decision to invoke
netif_wake_queue().

Second of all, checking the state of the device to determine if a
stop queue should be performed has two problems:

1) The test uses a magic constant mask, which is undocumented.

2) It causes the race you have on the wake queue side

Use pure software state to guide your actions, and let the hardware
interrupt trigger the wake queue.

Also, you don't implement this as a true ring buffer, you only
consider to stop the queue when you hit the last TX object entry.  But
all the previous slots could be available.

Your head and tail pointer need to be maintained by advancing the
head pointer only during pch_xmit(), and advancing the tail pointer
only in the NAPI code as you get indications from the hardware.

Then, after the NAPI TX code advances the tail pointer, you see if
1) the queue is stopped and 2) TX space is now available.  If both
are true you wake the queue.

Use a well tested and mature driver like drivers/net/tg3.c as a
guide.  Search for netif_tx_{stop,wake}_queue().

