Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932753Ab1LEXqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 18:46:45 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:51569 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932481Ab1LEXqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 18:46:43 -0500
Date: Mon, 05 Dec 2011 18:45:31 -0500 (EST)
Message-Id: <20111205.184531.2200249993229147892.davem@davemloft.net>
To: romieu@fr.zoreil.com
Cc: booster@wolke7.net, hayeswang@realtek.com, jrnieder@gmail.com,
        eric.dumazet@gmail.com, netdev@vger.kernel.org, nic_swsd@realtek.com,
        linux-kernel@vger.kernel.org, armin.kazmi@tu-dortmund.de
Subject: Re: [PATCH 2/2] r8169: fix Rx index race between FIFO overflow
 recovery and NAPI handler.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20111205063052.GB3103@electric-eye.fr.zoreil.com>
References: <4ED7E6AB.6050308@wolke7.net>
	<20111201222612.GA27998@electric-eye.fr.zoreil.com>
	<20111205063052.GB3103@electric-eye.fr.zoreil.com>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Mon, 05 Dec 2011 15:45:34 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Francois Romieu <romieu@fr.zoreil.com>
Date: Mon, 5 Dec 2011 07:30:52 +0100

> Since 92fc43b4159b518f5baae57301f26d770b0834c9, rtl8169_tx_timeout ends up
> resetting Rx and Tx indexes and thus racing with the NAPI handler via
> -> rtl8169_hw_reset
>    -> rtl_hw_reset
>       -> rtl8169_init_ring_indexes
> 
> What about returning to the original state ?
> 
> rtl_hw_reset is only used by rtl8169_hw_reset and rtl8169_init_one.
> 
> The latter does not need rtl8169_init_ring_indexes because the indexes
> still contain their original values from the newly allocated network
> device private data area (i.e. 0).
> 
> rtl8169_hw_reset is used by:
> 1. rtl8169_down
>    Helper for rtl8169_close. rtl8169_open explicitely inits the indexes
>    anyway.
> 2. rtl8169_pcierr_interrupt
>    Indexes are set by rtl8169_reinit_task.
> 3. rtl8169_interrupt
>    rtl8169_hw_reset is needed when the device goes down. See 1.
> 4. rtl_shutdown
>    System shutdown handler. Indexes are irrelevant.
> 5. rtl8169_reset_task
>    Indexes must be set before rtl_hw_start is called.
> 6. rtl8169_tx_timeout
>    Indexes should not be set. This is the job of rtl8169_reset_task anyway.
> 
> The removal of rtl8169_hw_reset in rtl8169_tx_timeout and its move in
> rtl8169_reset_task do not change the analysis.
> 
> Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
> Cc: hayeswang <hayeswang@realtek.com>

Applied.
