Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab0LPQxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 11:53:49 -0500
Received: from zone0.gcu-squad.org ([212.85.147.21]:8001 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746Ab0LPQxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 11:53:46 -0500
Date: Thu, 16 Dec 2010 17:53:37 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Matthias Zacharias <Matthias.Zacharias@bmk-solutions.de>
Subject: Re: [RFC] i2c-algo-bit: Disable interrupts while SCL is high
Message-ID: <20101216175337.2b1ae6ee@endymion.delvare>
In-Reply-To: <20101216160046.GE20097@trinity.fluff.org>
References: <20101216150638.7d3850b5@endymion.delvare>
	<20101216160046.GE20097@trinity.fluff.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On Thu, 16 Dec 2010 16:00:46 +0000, Ben Dooks wrote:
> On Thu, Dec 16, 2010 at 03:06:38PM +0100, Jean Delvare wrote:
> > Add a spinlock to every user of i2c-algo-bit, which is taken before
> > raising SCL and released after lowering SCL. We don't really need
> > the exclusion functionality, but we have to disable local interrupts.
> > This is needed to comply with SMBus requirements that SCL shouldn't
> > be high for longer than 50 us.
> > 
> > SMBus slaves can consider SCL being high for 50 us as a timeout
> > condition. This has been observed to happen reproducibly with the
> > Melexis MLX90614.
> > 
> > The drawback of this approach is that spin_lock_irqsave() and
> > spin_unlock_irqrestore() will be called once for each bit going on the
> > I2C bus in either direction. This can mean up to 100 kHz for standard
> > I2C and SMBus and up to 250 kHz for fast I2C. The good thing is that
> > this limits the latency to reasonable values (2us at 250 kHz, 5 us at
> > 100 kHz and 50 us at 10 kHz).
> 
> Hmm, this is going to be a drain on interrupt latency... disabling
> interrupts in a system for that long could cause other things to
> jitter.

So you consider that even disabling interrupts for 5 us is too long? Or
are you only worried by the 50 us case?

> I think if there's a time constraint, we should look at a method of
> using a high-resolution timer to run the clocks so that we don't
> have to wait around polling stuff.

Good suggestion. Are you willing to try and implement this yourself? I
am not familiar with high resolution timers.

Another possibility would be to make the spinlock usage optional. Only
SMBus slaves care about the timeout, I2C slaves do not, and not all
SMBus slaves are as sensitive as the MLX90614. I didn't want to make it
optional at first because it will make the code even more bloated, but
if you really think that disabling interrupts for 2 to 50 us will cause
problems in practice, I could look into it again.

> > An alternative would be to keep the lock held for the whole transfer
> > of every single byte. This would divide the number of calls to
> > spin_lock_irqsave() and spin_unlock_irqrestore() by 9 (i.e. up to 11
> > kHz for standard I2C and up to 28 kHz for fast I2C) at the price of
> > multiplying the latency by 18 (i.e. 36 us at 250 kHz, 90 us at 100 kHz
> > and 900 us at 10 kHz).

If you consider even per-bit locking as too high latency, I guess that
this alternative proposal is out of the question?

> > I would welcome comments on this. I sincerely have no idea what is
> > considered a reasonable duration during which local interrupts can be
> > disabled, and I have also no idea above what frequency taking and
> > releasing a (never busy) spinlock is considered unreasonable.
> 
> The cost of IRQ-spinlock on UP-ARM is about 4 instructions for each lock
> and unlock. So taking it a-lot isn't costly in this place... not sure
> for the MP variants.
>  
> >  /* ----- global defines ----------------------------------------------- */
> > @@ -130,12 +131,17 @@ static void i2c_start(struct i2c_algo_bi
> >  
> >  static void i2c_repstart(struct i2c_algo_bit_data *adap)
> >  {
> > +	unsigned long flags;
> > +
> >  	/* assert: scl is low */
> >  	sdahi(adap);
> > +	spin_lock_irqsave(&adap->lock, flags);
> >  	sclhi(adap);
> >  	setsda(adap, 0);
> >  	udelay(adap->udelay);
> > -	scllo(adap);
> > +	setscl(adap, 0);
> > +	spin_unlock_irqrestore(&adap->lock, flags);
> > +	udelay(adap->udelay / 2);
> >  }
> 
> would be nice to document why we're taking this lock here... or in the
> header add some more explanation other than 'whilst clock is high'

The comment is where the spinlock is initialized:

	/* We use a spinlock to block interrupts while SCL is high.
	 * Otherwise the very short SMBus SCL high timeout (50 us)
	 * can be reached, causing SMBus slaves to stop responding. */
	spin_lock_init(&bit_adap->lock);

Do you consider this insufficient, or do you simply think it should be
located somewhere else?

> anyway, the rest looks fine from reading through, there's no obvious
> problems.

Thanks for the review.

-- 
Jean Delvare
