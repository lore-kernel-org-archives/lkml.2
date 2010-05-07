Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab0EGMIS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 08:08:18 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:52942 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab0EGMIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 08:08:17 -0400
Date: Fri, 7 May 2010 14:07:53 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Oskar Schirmer <os@emlix.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>
Subject: Re: [PATCH] ad7877: keep dma rx buffers in seperate cache lines
Message-ID: <20100507120753.GB4413@cmpxchg.org>
References: <1273142265-11929-1-git-send-email-os@emlix.com> <1273142265-11929-2-git-send-email-os@emlix.com> <g2j8bd0f97a1005061146l2b01e45do15bf46162e38ce84@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <g2j8bd0f97a1005061146l2b01e45do15bf46162e38ce84@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 06, 2010 at 02:46:04PM -0400, Mike Frysinger wrote:
> On Thu, May 6, 2010 at 06:37, Oskar Schirmer wrote:
> >  struct ser_req {
> > +       u16                     sample;
> > +       char                    __padalign[L1_CACHE_BYTES - sizeof(u16)];
> > +
> >        u16                     reset;
> >        u16                     ref_on;
> >        u16                     command;
> > -       u16                     sample;
> >        struct spi_message      msg;
> >        struct spi_transfer     xfer[6];
> >  };
> 
> are you sure this is necessary ?  ser_req is only ever used with
> spi_sync() and it's allocated/released on the fly, so how could
> anything be reading that memory between the start of the transmission
> and the return to adi7877 ?

The master driver can.  atmel_spi flushes the cache of the buffers
pretty early when queuing a message and touches the message members
afterwards.

> >  struct ad7877 {
> > +       u16                     conversion_data[AD7877_NR_SENSE];
> > +       char                    __padalign[L1_CACHE_BYTES
> > +                                       - AD7877_NR_SENSE * sizeof(u16)];
> > +
> >        struct input_dev        *input;
> >        char                    phys[32];
> >
> > @@ -182,8 +188,6 @@ struct ad7877 {
> >        u8                      averaging;
> >        u8                      pen_down_acc_interval;
> >
> > -       u16                     conversion_data[AD7877_NR_SENSE];
> > -
> >        struct spi_transfer     xfer[AD7877_NR_SENSE + 2];
> >        struct spi_message      msg;
> 
> i can see the spi_message inside of this struct being a problem
> because the spi transfer is doing asynchronously with spi_async().
> however, i would add a comment right above these two fields with a
> short explanation as to why they're at the start and why the pad
> exists so someone down the line doesnt move it.

Good idea.
