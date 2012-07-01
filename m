Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab2GAVVV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 17:21:21 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:5769 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2GAVVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 17:21:19 -0400
Date: Sun, 1 Jul 2012 23:20:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Ben Dooks <ben-linux@fluff.org>, Wolfram Sang <w.sang@pengutronix.de>,
        Seth Heasley <seth.heasley@intel.com>, Olof Johansson <olof@lixom.net>,
        Benson Leung <bleung@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8 v3] i2c: i801: check INTR after every transaction
Message-ID: <20120701232051.308c03d1@endymion.delvare>
In-Reply-To: <20120627180724.762f854a@endymion.delvare>
References: <1340805255-8041-1-git-send-email-djkurtz@chromium.org>
 <1340805255-8041-4-git-send-email-djkurtz@chromium.org>
 <20120627180724.762f854a@endymion.delvare>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again Daniel,

On Wed, 27 Jun 2012 18:07:24 +0200, Jean Delvare wrote:
> On Wed, 27 Jun 2012 21:54:10 +0800, Daniel Kurtz wrote:
> > Per ICH10 datasheet [1] pg. 711, after completing a block transaction,
> > INTR should be checked & cleared separately, only after BYTE_DONE is
> > first cleared:
> > 
> >   When the last byte of a block message is received, the host controller
> > sets DS. However, it does not set the INTR bit (and generate another
> > interrupt) until DS is cleared. Thus, for a block message of n bytes,
> > the ICH10 will generate n+1 interrupts.
> > 
> > [1] http://www.intel.com/content/dam/doc/datasheet/io-controller-hub-10-family-datasheet.pdf
> > 
> > Currently, the INTR bit was only checked & cleared separately if the PEC
> > was used.
> > This patch checks and clears INTR at the very end of every successful
> > transaction, regardless of whether the PEC is used.
> > 
> > Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> > ---
> >  drivers/i2c/busses/i2c-i801.c |   46 ++++++++++++++++++++--------------------
> >  1 files changed, 23 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> > index 8b74e1e..6a53338 100644
> > --- a/drivers/i2c/busses/i2c-i801.c
> > +++ b/drivers/i2c/busses/i2c-i801.c
> > @@ -257,6 +257,24 @@ static int i801_check_post(struct i801_priv *priv, int status, int timeout)
> >  	return result;
> >  }
> >  
> > +/* wait for INTR bit as advised by Intel */
> > +static void i801_wait_intr(struct i801_priv *priv)
> > +{
> > +	int timeout = 0;
> > +	int status;
> > +
> > +	status = inb_p(SMBHSTSTS(priv));
> > +	while ((!(status & SMBHSTSTS_INTR)) && (timeout++ < MAX_RETRIES)) {
> > +		usleep_range(250, 500);
> > +		status = inb_p(SMBHSTSTS(priv));
> > +	}
> 
> Per my comment on previous patch, I've swapped the logic here to be in
> line with what we had before. I have no objection to trying this change
> again, but later, and only if you have actual numbers to back it up.

I've done some performance measurements, and it turns out that, with the
version of this patch modified by me, all short transactions are twice
as slow as before. This is because i801_transaction waits twice now:
once for BUSY to be clear, and then again once for INTR to be set.

I don't think this makes much sense, as both events normally happen at
the same time. As a matter of fact, the original code did clear INTR at
the end of i801_transaction without checking that it was set. Also, we
call i801_check_post() _before_ i801_wait_intr(), which makes no sense
IMHO. If INTR was really not set yet, then checking for errors was
wrong, it was too early.

I'm not even sure why we rely on the BUSY bit in the first place. It
would seem easier to just wait for INTR.

Thinking about it some more, the idea of function i801_wait_intr() is a
little strange. Normally, you'd wait for INTR, then do what you have
to, and lastly clear the INTR bit. Having a function which waits for
INTR and clears it immediately seems wrong.

-- 
Jean Delvare
