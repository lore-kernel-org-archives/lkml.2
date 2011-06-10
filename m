Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1FJKGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 06:06:55 -0400
Received: from co202.xi-lite.net ([149.6.83.202]:36831 "EHLO co202.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750769Ab1FJKGw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 06:06:52 -0400
Message-ID: <4DF1EC83.5070106@parrot.com>
Date: Fri, 10 Jun 2011 12:05:55 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100228)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: uart : lost characters when system is busy
References: <4DF1DCA9.9060604@parrot.com> <20110610102026.01f7da05@lxorguk.ukuu.org.uk>
In-Reply-To: <20110610102026.01f7da05@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox a écrit :
>> uart_throttle/uart_unthrottle is called from a workqueue.
>> If the system is busy, and the uart receive lot's of data, we fill the tty
>> buffer, but the workqueue doesn't run and we never have a chance to call
>> uart_throttle. So the uart is never slow down.
> 
> You should have around 64K of buffering (actually n_tty worst case
> should be 63.5Kbyte) that's a lot of slack so what is holding off the
> work queue for so long on your problem system ? I think that should be
> answered first as it sounds like some other part of your kernel is
> misbehaving.
The uart is connected to a BT chip, and it is configured to 3 Mbps.
64K buffer is 166 ms.

Some task on the system have higher priority than the worker thread (rt priority
or cgroup), and can preempt it more than 166 ms.

Also I believe some virtual usb uart (3G dongle, cdc-acm) that use higher rate
(more than 10 Mbps)  will have the same problem. They will fill the buffer very
quickly.

> 
>> A workaround could be to check the buffer threshold in tty_flip_buffer_push and
>> call throttle callback if needed.
> 
> tty_flip_buffer_push can be called from an IRQ, the throttle callback
> needs to be able to sleep.
> 
> What might work if it is needed though is to provide a tty_is_throttled()
> method that a driver can use to check the instantaneous throttle state.
> Trouble is that will require a lot of care on the drivers part to deal
> with asynchronus throttle/unthrottle events while peering at the state in
> its IRQ handler as well.
I think tty_is_throttled() is better than checking tty_insert_flip_char status,
because we know earlier that the fifo is becoming full and we don't have to save
the remaining data somewhere.

For example the "USB: cdc-acm: Prevent loss of data when filling tty buffer"
patch may be changed to something like :

    /* throttle device if requested by tty */
    spin_lock_irqsave(&acm->read_lock, flags);
    acm->throttled = acm->throttle_req;
    if (!acm->throttled && !acm->susp_count && !tty_is_throttled()) {
        spin_unlock_irqrestore(&acm->read_lock, flags);
        acm_submit_read_urb(acm, rb->index, GFP_ATOMIC);
    } else {
        spin_unlock_irqrestore(&acm->read_lock, flags);
    }

Matthieu
