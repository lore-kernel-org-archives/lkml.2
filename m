Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2GaMzz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:55:55 -0400
Received: from mga11.intel.com ([192.55.52.93]:22272 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756245Ab2GaMzy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:55:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="191117657"
Date: Tue, 31 Jul 2012 20:55:47 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Jonathan Cameron <jic23@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer dereference in iio_buffer_register()
Message-ID: <20120731125547.GA18655@localhost>
References: <20120708115331.GA16281@localhost>
 <20120731103155.GA16388@localhost>
 <5017D2BD.1070109@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5017D2BD.1070109@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The panic happens while trying to dereference the NULL indio_dev->buffer:
> > 
> >         266 int iio_buffer_register(struct iio_dev *indio_dev,
> >         267                         const struct iio_chan_spec *channels,
> >         268                         int num_channels)
> >         269 {  
> >         270         struct iio_dev_attr *p;
> >         271         struct attribute **attr;
> >         272         struct iio_buffer *buffer = indio_dev->buffer;
> >         273         int ret, i, attrn, attrcount, attrcount_orig = 0;
> >         274 
> > ==>     275         if (buffer->attrs)
> >         276                 indio_dev->groups[indio_dev->groupcounter++] = buffer->attrs;
> > 
> > iio_dummy_probe() has the code to configure that buffer, however
> > iio_simple_dummy_configure_buffer() is defined to do nothing on
> > !CONFIG_IIO_SIMPLE_DUMMY_BUFFER..
> > 
> >         448         /* Configure buffered capture support. */
> > ==>     449         ret = iio_simple_dummy_configure_buffer(indio_dev);
> >         450         if (ret < 0)
> >         451                 goto error_unregister_events;
> >         452 
> >         453         /*
> >         454          * Register the channels with the buffer, but avoid the output
> >         455          * channel being registered by reducing the number of channels by 1.
> >         456          */
> >         457         ret = iio_buffer_register(indio_dev, iio_dummy_channels, 5);
> >         458         if (ret < 0)
> >         459                 goto error_unconfigure_buffer;
> > 
> > Any ideas to fix it?
> > 
> 
> Hi,
> 
> I think the best would be to move the iio_buffer_register to
> iio_simple_dummy_configure_buffer.

Lars, thanks for the quick reply! Hmm, that looks more like a code
refactor recommendation than fix ;)  In the simplest form, can the
bug fixed like this?

  static inline int iio_simple_dummy_configure_buffer(struct iio_dev *indio_dev)
  {
-         return 0;
+         return -1;
  };

Thanks,
Fengguang
