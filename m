Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab2GBKIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 06:08:41 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:46484 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932850Ab2GBKIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 06:08:39 -0400
Date: Mon, 2 Jul 2012 12:08:14 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8 v3] i2c: i801: check INTR after every transaction
Message-ID: <20120702120814.47d71bc5@endymion.delvare>
In-Reply-To: <CAGS+omDV_ynBL-PN0qmLmDRiHGbQFf+TwqC2-+KJY8zy9FDhrA@mail.gmail.com>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
	<1340805255-8041-4-git-send-email-djkurtz@chromium.org>
	<20120627180724.762f854a@endymion.delvare>
	<20120701232051.308c03d1@endymion.delvare>
	<CAGS+omDV_ynBL-PN0qmLmDRiHGbQFf+TwqC2-+KJY8zy9FDhrA@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 09:19:24 +0800, Daniel Kurtz wrote:
> On Mon, Jul 2, 2012 at 5:20 AM, Jean Delvare <khali@linux-fr.org> wrote:
> > I've done some performance measurements, and it turns out that, with the
> > version of this patch modified by me, all short transactions are twice
> > as slow as before. This is because i801_transaction waits twice now:
> > once for BUSY to be clear, and then again once for INTR to be set.
> 
> Does a fast sequence of such transactions actually take any longer? Or
> just a single short transaction?

Both are affected, this is the problem. See:

Original driver:

# time i2cdump -y 8 0x2f b >/dev/null

real	0m0.157s
user	0m0.000s
sys	0m0.010s

After this patch:

# time i2cdump -y 8 0x2f b >/dev/null

real	0m0.279s
user	0m0.003s
sys	0m0.011s

This is on a fast machine with recent kernel. On my ICH3-M laptop with
kernel 2.6.32, the slowdown for a full register dump is from 2 seconds
to 4 seconds. Big performance regression.

> My understanding is that the INTR wait is really waiting for the
> entire transaction to complete (ie., including i2c STOP condition),
> not just the byte transfer phase.

This is my understanding as well, but I'm fairly certain that this is
the case of the BUSY flag as well. I think BUSY gets cleared at the
same time INTR (or any of the error status bits) gets set. Which is why
I think checking BUSY is redundant. As a matter of fact, we ignore BUSY
completely in i801_block_transaction_byte_by_byte(), so I see no reason
why we couldn't do the same in i2c_transaction().

> By waiting here at the end of a transaction, we make sure the status
> bits are actually clear before starting the next transaction.

I have no objection to clearing the status bits, simply I think the
sequence is wrong. I'll write and post a RFC patch later today
illustrating what I think should be done.

-- 
Jean Delvare
