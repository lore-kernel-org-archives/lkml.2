Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab1CFOBg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Mar 2011 09:01:36 -0500
Received: from ist.d-labs.de ([213.239.218.44]:55624 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873Ab1CFOBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Mar 2011 09:01:35 -0500
Date: Sun, 6 Mar 2011 15:00:57 +0100
From: Florian Mickler <florian@mickler.org>
To: Jack Stone <jwjstone@fastmail.fm>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <greg@kroah.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [PATCH] [media] dib0700: get rid of on-stack dma buffers
Message-ID: <20110306150057.0e1fd078@schatten.dmk.lab>
In-Reply-To: <4D739104.7030007@fastmail.fm>
References: <1299410212-24897-1-git-send-email-florian@mickler.org>
	<4D739104.7030007@fastmail.fm>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 06 Mar 2011 13:49:56 +0000
Jack Stone <jwjstone@fastmail.fm> wrote:

> On 06/03/2011 11:16, Florian Mickler wrote:
> > This should fix warnings seen by some:
> > 	WARNING: at lib/dma-debug.c:866 check_for_stack
> > 
> > Fixes: https://bugzilla.kernel.org/show_bug.cgi?id=15977.
> > Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
> > Signed-off-by: Florian Mickler <florian@mickler.org>
> > CC: Mauro Carvalho Chehab <mchehab@infradead.org>
> > CC: linux-media@vger.kernel.org
> > CC: linux-kernel@vger.kernel.org
> > CC: Greg Kroah-Hartman <greg@kroah.com>
> > CC: Rafael J. Wysocki <rjw@sisk.pl>
> > CC: Maciej Rutecki <maciej.rutecki@gmail.com>
> > ---
> > @@ -101,8 +109,19 @@ int dib0700_ctrl_rd(struct dvb_usb_device *d, u8 *tx, u8 txlen, u8 *rx, u8 rxlen
> >  
> >  int dib0700_set_gpio(struct dvb_usb_device *d, enum dib07x0_gpios gpio, u8 gpio_dir, u8 gpio_val)
> >  {
> > -	u8 buf[3] = { REQUEST_SET_GPIO, gpio, ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6) };
> > -	return dib0700_ctrl_wr(d, buf, sizeof(buf));
> > +	s16 ret;
> > +	u8 *buf = kmalloc(3, GFP_KERNEL);
> > +	if (!buf)
> > +		return -ENOMEM;
> > +
> > +	buf[0] = REQUEST_SET_GPIO;
> > +	buf[1] = gpio;
> > +	buf[2] = ((gpio_dir & 0x01) << 7) | ((gpio_val & 0x01) << 6);
> > +
> > +	ret = dib0700_ctrl_wr(d, buf, sizeof(buf));
> 
> Shouldn't this sizeof be changed as well?
> 
> Thanks,
> 
> Jack

argh... indeed. 
