Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962Ab0ITS1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 14:27:09 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43634
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753830Ab0ITS1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 14:27:08 -0400
Date: Mon, 20 Sep 2010 11:27:27 -0700 (PDT)
Message-Id: <20100920.112727.214208208.davem@davemloft.net>
To: m.nazarewicz@samsung.com
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        eric.dumazet@gmail.com
Subject: Re: [PATCH] usb: gadget: rndis: don't use dev_get_stats()
From: David Miller <davem@davemloft.net>
In-Reply-To: <bdd595ff5a45c008254da0a0c4322b6e7b699cf2.1285006511.git.m.nazarewicz@samsung.com>
References: <bdd595ff5a45c008254da0a0c4322b6e7b699cf2.1285006511.git.m.nazarewicz@samsung.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Date: Mon, 20 Sep 2010 20:23:04 +0200

> This commit removes the call to dev_get_stats() from the
> gen_ndis_query_resp() function.  Since spin_lock_bh() was
> added to dev_txq_stats_fold() the call started causing
> warnings.  This is because gen_ndis_query_resp() can be
> (indirectly) called from rndis_command_complete() which is
> called with interrupts disabled.
> 
> While at it, this commit also changes the
> gen_ndis_query_resp() function so that "net" local variable is
> used instead of "rndis_per_dev_params[configNr].dev" in all
> places this is referenced.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>

The way this works is dev_get_stats() takes that "temp" object the
caller provides, it writes the correct statistics into it (with any
necessary translations), and then passes back a pointer to it.

See net/core/dev.c:dev_get_stats()

You must use dev_get_stats() or else the statistics won't be properly
converted.

Like I originally suggested, you need to rearrange the code in this
driver such that the gen_ndis_query_resp() work happens in a tasklet,
workqueue, or some other non-hardware-irq context.
