Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755979Ab2GaNB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:01:59 -0400
Received: from smtp-out-178.synserver.de ([212.40.185.178]:1086 "EHLO
	smtp-out-178.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753356Ab2GaNB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:01:58 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 31105
Message-ID: <5017D843.8070001@metafoo.de>
Date: Tue, 31 Jul 2012 15:06:11 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Jonathan Cameron <jic23@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: NULL pointer dereference in iio_buffer_register()
References: <20120708115331.GA16281@localhost> <20120731103155.GA16388@localhost> <5017D2BD.1070109@metafoo.de> <20120731125547.GA18655@localhost>
In-Reply-To: <20120731125547.GA18655@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 02:55 PM, Fengguang Wu wrote:
>>> The panic happens while trying to dereference the NULL indio_dev->buffer:
>>>
>>>         266 int iio_buffer_register(struct iio_dev *indio_dev,
>>>         267                         const struct iio_chan_spec *channels,
>>>         268                         int num_channels)
>>>         269 {  
>>>         270         struct iio_dev_attr *p;
>>>         271         struct attribute **attr;
>>>         272         struct iio_buffer *buffer = indio_dev->buffer;
>>>         273         int ret, i, attrn, attrcount, attrcount_orig = 0;
>>>         274 
>>> ==>     275         if (buffer->attrs)
>>>         276                 indio_dev->groups[indio_dev->groupcounter++] = buffer->attrs;
>>>
>>> iio_dummy_probe() has the code to configure that buffer, however
>>> iio_simple_dummy_configure_buffer() is defined to do nothing on
>>> !CONFIG_IIO_SIMPLE_DUMMY_BUFFER..
>>>
>>>         448         /* Configure buffered capture support. */
>>> ==>     449         ret = iio_simple_dummy_configure_buffer(indio_dev);
>>>         450         if (ret < 0)
>>>         451                 goto error_unregister_events;
>>>         452 
>>>         453         /*
>>>         454          * Register the channels with the buffer, but avoid the output
>>>         455          * channel being registered by reducing the number of channels by 1.
>>>         456          */
>>>         457         ret = iio_buffer_register(indio_dev, iio_dummy_channels, 5);
>>>         458         if (ret < 0)
>>>         459                 goto error_unconfigure_buffer;
>>>
>>> Any ideas to fix it?
>>>
>>
>> Hi,
>>
>> I think the best would be to move the iio_buffer_register to
>> iio_simple_dummy_configure_buffer.
> 
> Lars, thanks for the quick reply! Hmm, that looks more like a code
> refactor recommendation than fix ;)  In the simplest form, can the
> bug fixed like this?
> 
>   static inline int iio_simple_dummy_configure_buffer(struct iio_dev *indio_dev)
>   {
> -         return 0;
> +         return -1;
>   };
> 

No, we want iio_simple_dummy_configure_buffer to be a noop if buffer support
is disabled, since the driver works fine without it. Except for the issue
you discovered. This issue only appears if CONFIG_IIO_BUFFER=y and
CONFIG_IIO_SIMPLE_DUMMY_BUFFER=n. E.g. if both are not set the driver works
fine without buffers.

I can prepare a patch which moves the iio_buffer_register to
iio_simple_dummy_configure_buffer if you want to.

- Lars
