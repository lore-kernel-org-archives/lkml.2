Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751937Ab1DPQhi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 12:37:38 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60038 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750769Ab1DPQhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 12:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=uhKzrsnOzqHogLTDF2phKtS8HpvMsA1AhN0d0DKFaQqkFprf2w4SzoG/9d+7uoTDnO
         qLjQy4DZsAYkkUY3i4pvTnRYFNKFW4jEGjQwOk9+uC9QwP1F78xDjgt/2SqraKi2mS5E
         ZqJvpq77WCP9DgK7nBKgF92kR2AEBU/pNJ8Qs=
Subject: Re: [PATCH] [media] lmedm04: Do not unlock mutex if
 mutex_lock_interruptible failed
From: Malcolm Priestley <tvboxspy@gmail.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1302912068.2177.16.camel@localhost>
References: <1302900017-10437-1-git-send-email-khoroshilov@ispras.ru>
	 <1302912068.2177.16.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Apr 2011 17:37:23 +0100
Message-ID: <1302971843.3068.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-04-16 at 01:01 +0100, Malcolm Priestley wrote:
> On Sat, 2011-04-16 at 00:40 +0400, Alexey Khoroshilov wrote:
> > There are a couple of places where mutex_unlock() is called even 
> > if mutex_lock_interruptible() failed. The patch fixes the issue.
> > 
> > Found by Linux Driver Verification project (linuxtesting.org).
> > 
> > Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
> > ---
> >  drivers/media/dvb/dvb-usb/lmedm04.c |   12 +++++++-----
> >  1 files changed, 7 insertions(+), 5 deletions(-)
> > 
> > diff --git a/drivers/media/dvb/dvb-usb/lmedm04.c b/drivers/media/dvb/dvb-usb/lmedm04.c
> > index f2db012..40907df 100644
> > --- a/drivers/media/dvb/dvb-usb/lmedm04.c
> > +++ b/drivers/media/dvb/dvb-usb/lmedm04.c
> > @@ -591,9 +591,10 @@ static int lme2510_streaming_ctrl(struct dvb_usb_adapter *adap, int onoff)
> >  	else {
> >  		deb_info(1, "STM Steam Off");
> >  		/* mutex is here only to avoid collision with I2C */
> > -		ret = mutex_lock_interruptible(&adap->dev->i2c_mutex);
> > +		if (mutex_lock_interruptible(&adap->dev->i2c_mutex) < 0)
> > +			return -EAGAIN;
> >  
> > -		ret |= lme2510_usb_talk(adap->dev, clear_reg_3,
> > +		ret = lme2510_usb_talk(adap->dev, clear_reg_3,
> >  				sizeof(clear_reg_3), rbuf, rlen);
> >  		st->stream_on = 0;
> >  		st->i2c_talk_onoff = 1;
> 
> Unfortunately dvb-usb does not provide -EAGAIN on streaming_ctrl
> stopping and returns 0 instead.
> 

I have added a patch to dvb-usb to return device errors to the demuxer

This patch may now be applied.

Tested by: Malcolm Priestley <tvboxspy@gmail.com>

Regards

Malcolm


