Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab2FZQZZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 12:25:25 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:18164 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756880Ab2FZQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 12:25:23 -0400
Date: Tue, 26 Jun 2012 18:24:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: ben-linux@fluff.org, seth.heasley@intel.com, ben@decadent.org.uk,
        David.Woodhouse@intel.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, olofj@chromium.org, bleung@chromium.org
Subject: Re: [PATCH 3/3 v2] i2c: i801: enable irq for byte_by_byte 
 transactions
Message-ID: <20120626182452.18804d77@endymion.delvare>
In-Reply-To: <20120620153449.5cee35fa@endymion.delvare>
References: <1325847502-17841-1-git-send-email-djkurtz@chromium.org>
	<1325847502-17841-4-git-send-email-djkurtz@chromium.org>
	<20120620153449.5cee35fa@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Wed, 20 Jun 2012 15:34:49 +0200, Jean Delvare wrote:
> I'll get at least the I2C block read tested on ICH5.

Some more notes about this patch, now that have done some testing...

> > (...)
> > +		} else if (priv->count < priv->len - 1) {
> 
> Is this just paranoia or do you believe it could actually happen? I
> admit I don't see how. If it is paranoia then the same should be done
> for the read part.

This is good paranoia and I recommend doing the same for block reads,
where it is even more important. An array overrun on block write means
you'll be sending random memory bytes to your I2C device, which is
already bad. But an array overrun on block read means you'll _trash_
random memory bytes, with tragic consequences. The bug right below did
exactly this to me: the block read would never stop, and after a few
seconds only my machine would die with a different error each time,
depending on what memory got trashed.

I ended up testing for both count < len and len <= I2C_SMBUS_BLOCK_MAX,
for both reads and writes. Probably that's overkill and either should
be sufficient, but I wanted to play it really safe at first.

> 
> > +			outb(priv->data[++priv->count], SMBBLKDAT(priv));
> > +			outb_p(priv->cmd | I801_START, SMBHSTCNT(priv));
> 
> I don't get the I801_START here and above. We are in the middle of the block
> transaction. The polling-based code only sets I801_START at the
> beginning, not for every byte, so why would it be different here?

I confirm this is a serious bug. The patch broke I2C block read on my
ICH5 machine completely, until I removed these two I801_START.

After fixing this, testing is conclusive on my ICH5 machine (where the
SMBus interrupt is shared.) BTW, the debug message complaining when
pcists.ints isn't set should be dropped, in my case the interrupt is
shared with the sound chip and DVB-T card, and this caused a massive
flood of this message while I was debugging. The message isn't terribly
useful anyway IMHO, there's nothing wrong with that case.

Next step for me is testing on my ICH7-M laptop.

-- 
Jean Delvare
