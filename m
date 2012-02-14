Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab2BNRiI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Feb 2012 12:38:08 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:59805 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752562Ab2BNRiG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Feb 2012 12:38:06 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Jonathan Cameron <jic23@cam.ac.uk>
Subject: Re: [PATCH] adis16080: fix compiler -Wuninitialized
Date: Tue, 14 Feb 2012 18:36:59 +0100
User-Agent: KMail/1.9.10
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, "Lars-Peter Clausen" <lars@metafoo.de>,
        Michael Hennerich <michael.hennerich@analog.com>,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
References: <1329230136-26576-1-git-send-email-danny.kukawka@bisect.de> <20120214150455.GN4141@mwanda> <4F3A7B29.10603@cam.ac.uk>
In-Reply-To: <4F3A7B29.10603@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <201202141837.01552.danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329241086;b5d848e6;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 14. Februar 2012, Jonathan Cameron wrote:
> On 2/14/2012 3:04 PM, Dan Carpenter wrote:
> > On Tue, Feb 14, 2012 at 03:35:36PM +0100, Danny Kukawka wrote:
> >> Fix for:
> >> drivers/staging/iio/gyro/adis16080_core.c: In function
> >>    ‘adis16080_read_raw’:
> >> drivers/staging/iio/gyro/adis16080_core.c:99:8: warning: ‘ut’
> >>    may be used uninitialized in this function [-Wuninitialized]
> >>
> >> Initialize ut and change error handling from adis16080_read_raw().
> >>
> >> Signed-off-by: Danny Kukawka<danny.kukawka@bisect.de>
> >> ---
> >>   drivers/staging/iio/gyro/adis16080_core.c |    4 ++--
> >>   1 files changed, 2 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/drivers/staging/iio/gyro/adis16080_core.c
> >> b/drivers/staging/iio/gyro/adis16080_core.c index 1815490..e0b2a29
> >> 100644
> >> --- a/drivers/staging/iio/gyro/adis16080_core.c
> >> +++ b/drivers/staging/iio/gyro/adis16080_core.c
> >> @@ -82,7 +82,7 @@ static int adis16080_read_raw(struct iio_dev
> >> *indio_dev, long mask)
> >>   {
> >>   	int ret = -EINVAL;
> >> -	u16 ut;
> >> +	u16 ut = 0;
> >>   	/* Take the iio_dev status lock */
> >>
> >>   	mutex_lock(&indio_dev->mlock);
> >> @@ -94,7 +94,7 @@ static int adis16080_read_raw(struct iio_dev
> >> *indio_dev, if (ret<  0)
> >>   			break;
> >>   		ret = adis16080_spi_read(indio_dev,&ut);
> >> -		if (ret<  0)
> >> +		if (ret)
> >>   			break;
> >
> > Either one of these changes would silence the warning from gcc
> > (which is a false positive).  I would keep the "ut = 0;" change and
> > leave the error handling the same.  That way we check for less than
> > zero consistently instead of checking some for non-zero and some for
> > less than zero.
>
> Agreed.  I've always been lazy on this one as it was a false positive,
> but might as well
> get rid of it...

I'm okay with 'ut = 0;'. 

I guess it's hard for gcc to find out that spi_read() will only return 0 or a 
negative value in error case. That's why gcc may assume 'ut' could be used 
initialized since adis16080_spi_read() may return with a value > 0.

And in case spi_read() or one of the functions behind would change it could 
cause an initialized 'ut'. The code may should always check for "ret != 0" as 
already done in some other places (in similar cases) to be save.

Danny
