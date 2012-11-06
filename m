Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab2KFPWl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 10:22:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52668 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168Ab2KFPWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 10:22:40 -0500
Date: Tue, 6 Nov 2012 10:22:03 -0500
From: Jarod Wilson <jarod@redhat.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Matt Mackall <mpm@selenic.com>, linux-crypto@vger.kernel.org
Subject: Re: [PATCH] random: prime last_data value per fips requirements
Message-ID: <20121106152203.GA24076@redhat.com>
References: <1352149210-4790-1-git-send-email-jarod@redhat.com>
 <20121106120523.GA2805@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121106120523.GA2805@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 07:05:23AM -0500, Neil Horman wrote:
> On Mon, Nov 05, 2012 at 04:00:10PM -0500, Jarod Wilson wrote:
> > The value stored in last_data must be primed for FIPS 140-2 purposes. Upon
> > first use, either on system startup or after an RNDCLEARPOOL ioctl, we
> > need to take an initial random sample, store it internally in last_data,
> > then pass along the value after that to the requester, so that consistency
> > checks aren't being run against stale and possibly known data.
> > 
> > CC: Herbert Xu <herbert@gondor.apana.org.au>
> > CC: "David S. Miller" <davem@davemloft.net>
> > CC: Neil Horman <nhorman@tuxdriver.com>
> > CC: Matt Mackall <mpm@selenic.com>
> > CC: linux-crypto@vger.kernel.org
> > Signed-off-by: Jarod Wilson <jarod@redhat.com>
> > ---
> >  drivers/char/random.c |   11 +++++++++++
> >  1 files changed, 11 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/char/random.c b/drivers/char/random.c
> > index b86eae9..24d17b8 100644
> > --- a/drivers/char/random.c
> > +++ b/drivers/char/random.c
> > @@ -437,6 +437,7 @@ struct entropy_store {
> >  	int entropy_count;
> >  	int entropy_total;
> >  	unsigned int initialized:1;
> > +	bool last_data_init;
> >  	__u8 last_data[EXTRACT_SIZE];
> >  };
> >  
> > @@ -967,6 +968,15 @@ static ssize_t extract_entropy(struct entropy_store *r, void *buf,
> >  		if (fips_enabled) {
> >  			unsigned long flags;
> >  
> > +			/* prime last_data value if need be, per fips 140-2 */
> > +			if (!r->last_data_init) {
> > +				spin_lock_irqsave(&r->lock, flags);
> > +				memcpy(r->last_data, tmp, EXTRACT_SIZE);
> > +				r->last_data_init = true;
> > +				spin_unlock_irqrestore(&r->lock, flags);
> > +				continue;
> Continue?  Is that left over from earlier work?  Or did you have some other
> purpose in mind for it?

The continue takes you back to the top of the while loop for another
extract_buf() call, but continue could simply be replaced with another
extract_buf() call, so we don't have to restart the loop and check
last_data_init again. Otherwise, we're going to fail the memcmp and panic,
because tmp and r->last_data will be identical.

> Also, not that its in a hot path or anything, but it might be nice to
> consolodate this code such that you only lock and unlock r->flags once instead
> of twice here.

I thought about that, but figured it would be more trouble and possibly
more code to execute than it was worth in the normal case. But I can spin
up a v2 that tries to be a bit cleaner here.

-- 
Jarod Wilson
jarod@redhat.com

