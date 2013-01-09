Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932520Ab3AITUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 14:20:47 -0500
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:38387 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932499Ab3AITUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 14:20:46 -0500
Message-ID: <50EDC309.5010104@kernel.org>
Date: Wed, 09 Jan 2013 19:20:41 +0000
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@cam.ac.uk>, linux-iio@vger.kernel.org
Subject: Re: [PATCH 1/3] spi: Add helper functions for setting up transfers
References: <1357752671-30222-1-git-send-email-lars@metafoo.de>
In-Reply-To: <1357752671-30222-1-git-send-email-lars@metafoo.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 05:31 PM, Lars-Peter Clausen wrote:
> Quite often the pattern used for setting up and transferring a synchronous SPI
> transaction looks very much like the following:
> 
> 	struct spi_message msg;
> 	struct spi_transfer xfers[] = {
> 		...
> 	};
> 
> 	spi_message_init(&msg);
> 	spi_message_add_tail(&xfers[0], &msg);
> 	...
> 	spi_message_add_tail(&xfers[ARRAY_SIZE(xfers) - 1], &msg);
> 
> 	ret = spi_sync(&msg);
> 
> This patch adds two new helper functions for handling this case. The first
> helper function spi_message_init_with_transfers() takes a spi_message and an
> array of spi_transfers. It will initialize the message and then call
> spi_message_add_tail() for each transfer in the array. E.g. the following
> 
> 	spi_message_init(&msg);
> 	spi_message_add_tail(&xfers[0], &msg);
> 	...
> 	spi_message_add_tail(&xfers[ARRAY_SIZE(xfers) - 1], &msg);
> 
> can be rewritten as
> 
> 	spi_message_init_with_transfers(&msg, xfers, ARRAY_SIZE(xfers));
> 
> The second function spi_sync_transfer() takes a SPI device and an array of
> spi_transfers. It will allocate a new spi_message (on the stack) and add all
> transfers in the array to the message. Finally it will call spi_sync() on the
> message.
> 
> E.g. the follwing
> 
> 	struct spi_message msg;
> 	struct spi_transfer xfers[] = {
> 		...
> 	};
> 
> 	spi_message_init(&msg);
> 	spi_message_add_tail(&xfers[0], &msg);
> 	...
> 	spi_message_add_tail(&xfers[ARRAY_SIZE(xfers) - 1], &msg);
> 
> 	ret = spi_sync(spi, &msg);
> 
> can be rewritten as
> 
> 	struct spi_transfer xfers[] = {
> 		...
> 	};
> 
> 	ret = spi_sync_transfer(spi, xfers, ARRAY_SIZE(xfers));
> 
> The patch also adds a new cocci script which can detect such sequences as
> described above and transform them automatically to use the new helper
> functions.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> 
Principle looks good to me and some nice little duplication removal
savings.

My coccinelle isn't really up to checking that, but for the functions
Acked-by: Jonathan Cameron <jic23@kernel.org>

When all comments are in on the code we'll have to think about how to
merge this.  If you have much else planned that will hit those iio drivers
then things will get uggly unless it goes through that tree.

Guess it all depends on whether others like the patch though ;)
> ---
> I'm not entirely happy with names of the two new functions and I'm open for
> better suggestions.
> ---
>  include/linux/spi/spi.h                        |  44 ++++++++
>  scripts/coccinelle/api/spi_sync_transfer.cocci | 141 +++++++++++++++++++++++++
>  2 files changed, 185 insertions(+)
>  create mode 100644 scripts/coccinelle/api/spi_sync_transfer.cocci
> 
> diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
> index f629189..7dbe586 100644
> --- a/include/linux/spi/spi.h
> +++ b/include/linux/spi/spi.h
> @@ -591,6 +591,26 @@ spi_transfer_del(struct spi_transfer *t)
>  	list_del(&t->transfer_list);
>  }
>  
> +/**
> + * spi_message_init_with_transfers - Initialize spi_message and append transfers
> + * @m: spi_message to be initialized
> + * @xfers: An array of spi transfers
> + * @num_xfers: Number of items in the xfer array
> + *
> + * This function initializes the given spi_message and adds each spi_transfer in
> + * the given array to the message.
> + */
> +static inline void
> +spi_message_init_with_transfers(struct spi_message *m,
> +struct spi_transfer *xfers, unsigned int num_xfers)
> +{
> +	unsigned int i;
> +
> +	spi_message_init(m);
> +	for (i = 0; i < num_xfers; ++i)
> +		spi_message_add_tail(&xfers[i], m);
> +}
> +
>  /* It's fine to embed message and transaction structures in other data
>   * structures so long as you don't free them while they're in use.
>   */
> @@ -683,6 +703,30 @@ spi_read(struct spi_device *spi, void *buf, size_t len)
>  	return spi_sync(spi, &m);
>  }
>  
> +/**
> + * spi_sync_transfer - synchronous SPI data transfer
> + * @spi: device with which data will be exchanged
> + * @xfers: An array of spi_transfers
> + * @num_xfers: Number of items in the xfer array
> + * Context: can sleep
> + *
> + * Does a synchronous SPI data transfer of the given spi_transfer array.
> + *
> + * For more specific semantics see spi_sync().
> + *
> + * It returns zero on success, else a negative error code.
> + */
> +static inline int
> +spi_sync_transfer(struct spi_device *spi, struct spi_transfer *xfers,
> +	unsigned int num_xfers)
> +{
> +	struct spi_message msg;
> +
> +	spi_message_init_with_transfers(&msg, xfers, num_xfers);
> +
> +	return spi_sync(spi, &msg);
> +}
> +
>  /* this copies txbuf and rxbuf data; for small transfers only! */
>  extern int spi_write_then_read(struct spi_device *spi,
>  		const void *txbuf, unsigned n_tx,
> diff --git a/scripts/coccinelle/api/spi_sync_transfer.cocci b/scripts/coccinelle/api/spi_sync_transfer.cocci
> new file mode 100644
> index 0000000..1e2efe3
> --- /dev/null
> +++ b/scripts/coccinelle/api/spi_sync_transfer.cocci
> @@ -0,0 +1,141 @@
> +///
> +/// Use spi_sync_transfer instead of open-coding it
> +///
> +// Confidence: High
> +// Options: --no-includes
> +//
> +// Keywords: spi_sync, spi_sync_transfer
> +// Version min: 3.9
> +//
> +
> +virtual context
> +virtual patch
> +virtual org
> +virtual report
> +
> +@r1@
> +identifier fn;
> +identifier xfers;
> +@@
> +fn(...)
> +{
> +	...
> +(
> +	struct spi_transfer xfers[...];
> +|
> +	struct spi_transfer xfers[];
> +)
> +	...
> +}
> +
> +@depends on patch@
> +identifier msg;
> +expression spi;
> +identifier r1.fn;
> +identifier r1.xfers;
> +@@
> +fn(...)
> +{
> +...
> +-struct spi_message msg;
> +...
> +-spi_message_init(&msg);
> +<...
> +-spi_message_add_tail(&xfers[...], &msg);
> +...>
> +
> +-spi_sync(spi, &msg)
> ++spi_sync_transfer(spi, xfers, ARRAY_SIZE(xfers))
> +...
> +}
> +
> +@r3 depends on context || org || report@
> +identifier msg;
> +expression spi;
> +identifier r1.xfers;
> +identifier r1.fn;
> +position p;
> +@@
> +fn(...)
> +{
> +...
> +*struct spi_message msg;
> +...
> +*spi_message_init(&msg);
> +<...
> +*spi_message_add_tail(&xfers[...], &msg);
> +...>
> +*spi_sync@p(spi, &msg)
> +...
> +}
> +
> +@r2@
> +identifier fn;
> +identifier xfer;
> +@@
> +fn(...)
> +{
> +	...
> +	struct spi_transfer xfer;
> +	...
> +}
> +
> +@depends on patch@
> +identifier msg;
> +expression spi;
> +identifier r2.xfer;
> +identifier r2.fn;
> +@@
> +fn(...)
> +{
> +...
> +-struct spi_message msg;
> +...
> +-spi_message_init(&msg);
> +...
> +-spi_message_add_tail(&xfer, &msg);
> +...
> +-spi_sync(spi, &msg)
> ++spi_sync_transfer(spi, &xfer, 1)
> +...
> +}
> +
> +@r4 depends on context || org || report@
> +identifier msg;
> +expression spi;
> +identifier r2.xfer;
> +identifier r2.fn;
> +position p;
> +@@
> +fn(...)
> +{
> +...
> +*struct spi_message msg;
> +...
> +*spi_message_init(&msg);
> +...
> +*spi_message_add_tail(&xfer, &msg);
> +...
> +*spi_sync@p(spi, &msg)
> +...
> +}
> +
> +@script:python depends on report@
> +p << r3.p;
> +@@
> +coccilib.report.print_report(p[0], "Consider using spi_sync_transfer instead of open-conding it.")
> +
> +@script:python depends on report@
> +p << r4.p;
> +@@
> +coccilib.report.print_report(p[0], "Consider using spi_sync_transfer instead of open-conding it.")
> +
> +@script:python depends on org@
> +p << r3.p;
> +@@
> +coccilib.org.print_todo(p[0], "Consider using spi_sync_transfer instead of open-conding it.")
> +
> +@script:python depends on org@
> +p << r4.p;
> +@@
> +coccilib.org.print_todo(p[0], "Consider using spi_sync_transfer instead of open-conding it.")
> 
