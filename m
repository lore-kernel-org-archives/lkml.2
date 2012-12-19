Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab2LSHCO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 02:02:14 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:51535 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751232Ab2LSHCG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 02:02:06 -0500
Message-ID: <1355900525.2139.24.camel@joe-AO722>
Subject: Re: [PATCH] staging: iio: cleanup ring_sw.c
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Cong Ding <dinggnu@gmail.com>, Jonathan Cameron <jic23@cam.ac.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Tue, 18 Dec 2012 23:02:05 -0800
In-Reply-To: <20121219064247.GL5032@mwanda>
References: <1355873999-32098-1-git-send-email-dinggnu@gmail.com>
	 <20121219064247.GL5032@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-19 at 09:42 +0300, Dan Carpenter wrote:
> On Wed, Dec 19, 2012 at 12:39:59AM +0100, Cong Ding wrote:
> > clean the checkpatch warnings in ring_sw.c. mostly are 80 characters per line
> > issue.
[]
> > diff --git a/drivers/staging/iio/ring_sw.c b/drivers/staging/iio/ring_sw.c
[]
> > @@ -77,7 +77,8 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
> >  		 * as long as the read pointer is valid before this
> >  		 * passes it - guaranteed as set later in this function.
> >  		 */
> > -		ring->half_p = ring->data - ring->buf.length*ring->buf.bytes_per_datum/2;
> > +		ring->half_p = ring->data -
> > +			ring->buf.length*ring->buf.bytes_per_datum/2;
> 
> Please put spaces around the '*' and '/' characters.
> 			ring->buf.length * ring->buf.bytes_per_datum / 2;

or maybe add a helper like ring_datum_size(ring):

size_t ring_datum_size(const struct iio_sw_ring_buffer *ring)
{
	return ring->buf.length * ring->buf.bytes_per_datum;
}

so this becomes

	ring->half_p = ring->data - ring_datum_size(ring) / 2;

> > @@ -112,8 +113,8 @@ static int iio_store_to_sw_ring(struct iio_sw_ring_buffer *ring,
> >  	else if (ring->write_p == ring->read_p) {
> >  		change_test_ptr = ring->read_p;
> >  		temp_ptr = change_test_ptr + ring->buf.bytes_per_datum;
> > -		if (temp_ptr
> > -		    == ring->data + ring->buf.length*ring->buf.bytes_per_datum) {
> > +		if (temp_ptr == ring->data +
> > +		    ring->buf.length*ring->buf.bytes_per_datum) {

> 
> This needs spaces as well.  It might look cleaner if you broke it
> up like this:
> 		if (temp_ptr == ring->data + ring->buf.length *
> 				ring->buf.bytes_per_datum) {

or
		if (temp_ptr == ring->data + ring_datum_size(ring)) {

etc...

> > @@ -153,7 +155,8 @@ static int iio_read_first_n_sw_rb(struct iio_buffer *r,
> >  	if (n % ring->buf.bytes_per_datum) {
> >  		ret = -EINVAL;
> >  		printk(KERN_INFO "Ring buffer read request not whole number of"
> > -		       "samples: Request bytes %zd, Current bytes per datum %d\n",
> > +		       "samples: Request bytes %zd, Current bytes per"
> > +		       "datum %d\n",
> 
> No space between "of" and "samples" and also "per" and "datum".
> 
> The warning here is that the print should be on one line instead of
> two.  But actually that is a decision for the maintainer.
> Checkpatch.pl is not the king of us, we do not have to do what it
> says.

Yup.

It is nicer though to coalesce formats so that it's easier to
grep for strings and substrings.

> > @@ -201,7 +205,8 @@ static int iio_read_first_n_sw_rb(struct iio_buffer *r,
> >  	if (initial_read_p + bytes_to_rip >= ring->data + buffer_size) {
> >  		max_copied = ring->data + buffer_size - initial_read_p;
> >  		memcpy(data, initial_read_p, max_copied);
> > -		memcpy(data + max_copied, ring->data, bytes_to_rip - max_copied);
> > +		memcpy(data + max_copied,
> > +				ring->data, bytes_to_rip - max_copied);
> 
> Line it up like this:
> 		memcpy(data + max_copied, ring->data,
> 		       bytes_to_rip - max_copied);
> 
> 
> [tab][tab][space][space][space][space][space][space][space]bytes_

checkpatch --strict emits alignment messages

or not worry about 80 columns in this case.


