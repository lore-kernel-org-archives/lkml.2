Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab0C3LSL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:18:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49822 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753276Ab0C3LSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:18:09 -0400
Date: Tue, 30 Mar 2010 12:22:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: pavan_savoy@ti.com
Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH] drivers:staging: sources for ST core
Message-ID: <20100330122201.02accf0f@lxorguk.ukuu.org.uk>
In-Reply-To: <1269559223-4043-3-git-send-email-pavan_savoy@ti.com>
References: <1269559223-4043-1-git-send-email-pavan_savoy@ti.com>
	<1269559223-4043-2-git-send-email-pavan_savoy@ti.com>
	<1269559223-4043-3-git-send-email-pavan_savoy@ti.com>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/* all debug macros go in here */
> +#define ST_DRV_ERR(fmt, arg...)  printk(KERN_ERR "(stc):"fmt"\n" , ## arg)
> +#if defined(DEBUG)		/* limited debug messages */
> +#define ST_DRV_DBG(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> +#define ST_DRV_VER(fmt, arg...)
> +#elif defined(VERBOSE)		/* very verbose */
> +#define ST_DRV_DBG(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> +#define ST_DRV_VER(fmt, arg...)  printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> +#else /* error msgs only */
> +#define ST_DRV_DBG(fmt, arg...)
> +#define ST_DRV_VER(fmt, arg...)
> +#endif

As Greg said earlier - needs to be using the standard debug macros

> +/*
> + * local data instances
> + */
> +static struct st_data_s *st_gdata;
> +/* function pointer pointing to either,
> + * st_kim_recv during registration to receive fw download responses
> + * st_int_recv after registration to receive proto stack responses
> + */
> +void (*st_recv) (const unsigned char *data, long count);

Need some form of context so you can have multiple device instances and
avoid games with globals (which always end up in pain)

> +
> +/********************************************************************/
> +/* internal misc functions */
> +bool is_protocol_list_empty(void)
> +{
> +	unsigned char i = 0;
> +	ST_DRV_DBG(" %s ", __func__);
> +	for (i = 0; i < ST_MAX; i++) {
> +		if (st_gdata->list[i] != NULL)
> +			return ST_NOTEMPTY;
> +		/* not empty */
> +	}
> +	/* list empty */
> +	return ST_EMPTY;

Why not just keep a count of entries you've added/removed ?

> + *  This is the internal write function - a wrapper
> + *  to tty->ops->write
> + */
> +int st_int_write(const unsigned char *data, int count)
> +{
> +#ifdef VERBOSE			/* for debug */
> +	int i;
> +#endif
> +	struct tty_struct *tty;
> +	if (unlikely(st_gdata == NULL || st_gdata->tty == NULL)) {
> +		ST_DRV_ERR("tty unavailable to perform write");

You need to use the tty pointer passed, you don't want to walk
tty->something and back because you may race a hangup. Plus you would
need to manage the krefs (object references)

> +		return ST_ERR_FAILURE;

Should be using Linux error codes for upstream. A global search/replace
of the ST_ERR_xxx for a similar -Efoo code will do the trick I think

> +/*
> + * push the skb received to relevant
> + * protocol stacks
> + */
> +void st_send_frame(enum proto_type protoid, struct sk_buff *skb)
> +{
> +	ST_DRV_DBG(" %s(prot:%d) ", __func__, protoid);
> +
> +	if (unlikely
> +	    (st_gdata == NULL || skb == NULL
> +	     || st_gdata->list[protoid] == NULL)) {
> +		ST_DRV_ERR("protocol %d not registered, no data to send?",
> +			   protoid);
> +		kfree_skb(skb);
> +		return;
> +	}

What is the locking rule to ensure I don't unregister a protocol as send
frame is called ?

> + * to call registration complete callbacks
> + * of all protocol stack drivers
> + */
> +void st_reg_complete(char err)
> +{
> +	unsigned char i = 0;
> +	ST_DRV_DBG(" %s ", __func__);
> +	for (i = 0; i < ST_MAX; i++) {
> +		if (likely(st_gdata != NULL && st_gdata->list[i] != NULL &&

Except on very hot paths that go odd ways likely and unlikely are
normally a loss.

> +static inline int st_check_data_len(int protoid, int len)
> +{
> +	register int room = skb_tailroom(st_gdata->rx_skb);

No need to use register - gcc is generally smarter than humans here,
especially in the long term. You may optimise perfectly for a single
cpu/compiler revision but not for all


> +/* Decodes received RAW data and forwards to corresponding
> + * client drivers (Bluetooth,FM,GPS..etc).
> + *
> + */
> +void st_int_recv(const unsigned char *data, long count)

There are lots of globals here, in part it seems due to the lack of any
kind of context being passed around


>
> +	/* this function can be invoked in more then one context.
> +	 * so have a lock */

It's a good idea to document what data is locked and what the data
locking assumptions are. I'm finding that part of the code quite hard to
follow


> +/*
> + * internal wakeup function
> + * called from either
> + * - TTY layer when write's finished
> + * - st_write (in context of the protocol stack)
> + */
> +void st_tx_wakeup(struct st_data_s *st_data)


> +		while ((skb = st_int_dequeue(st_data))) {

Called in two paths but st_int_dequeue seems to have no internal locking


> +/* functions called from ST KIM
> +*/
> +void kim_st_list_protocols(char *buf)
> +{
> +	unsigned long flags = 0;
> +#ifdef DEBUG
> +	unsigned char i = ST_MAX;
> +#endif
> +	spin_lock_irqsave(&st_gdata->lock, flags);
> +#ifdef DEBUG			/* more detailed log */
> +	for (i = 0; i < ST_MAX; i++) {
> +		if (i == 0) {
> +			sprintf(buf, "%s is %s", protocol_strngs[i],
> +				st_gdata->list[i] !=
> +				NULL ? "Registered" : "Unregistered");

Always a good idea to use snprintf and track size (plus pass buffer size)
it avoida accidents later. Or also see the seq_ interface when you want
to build proc type files.

> +/********************************************************************/
> +/*
> + * functions called from protocol stack drivers
> + * to be EXPORT-ed
> + */
> +long st_register(struct st_proto_s *new_proto)
> +{
> +	long err = ST_SUCCESS;

>
> + * functions called from TTY layer
> + */
> +static int st_tty_open(struct tty_struct *tty)
> +{
> +	int err = ST_SUCCESS;
> +	ST_DRV_DBG("%s ", __func__);
> +
> +	st_gdata->tty = tty;

If you do this you need to use krefs and manage the reference properly
over open/close/hangup


> +static void st_tty_close(struct tty_struct *tty)
> +{
> +	/* Flush any pending characters in the driver and discipline. */

> +	tty_driver_flush_buffer(tty);

Close will deal with this anyway

> +static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
> +			   char *tty_flags, int count)
> +{
> +#ifdef VERBOSE
> +	long i;
> +	printk(KERN_ERR "incoming data...\n");
> +	for (i = 0; i < count; i++)
> +		printk(" %x", data[i]);
> +	printk(KERN_ERR "\n.. data end\n");
> +#endif
> +
> +	/*
> +	 * if fw download is in progress then route incoming data
> +	 * to KIM for validation
> +	 */
> +	st_recv(data, count);

If you passed tty up and used tty->disc_data you'd be able to handle
multiple devices

> +/********************************************************************/
> +static int __init st_core_init(void)
> +{
> +	long err;
> +	static struct tty_ldisc_ops *st_ldisc_ops;
> +
> +	/* populate and register to TTY line discipline */
> +	st_ldisc_ops = kzalloc(sizeof(*st_ldisc_ops), GFP_KERNEL);
> +	if (!st_ldisc_ops) {
> +		ST_DRV_ERR("no mem to allocate");
> +		return -ENOMEM;
> +	}
> +
> +	st_ldisc_ops->magic = TTY_LDISC_MAGIC;
> +	st_ldisc_ops->name = "n_st";	/*"n_hci"; */
> +	st_ldisc_ops->open = st_tty_open;
> +	st_ldisc_ops->close = st_tty_close;
> +	st_ldisc_ops->receive_buf = st_tty_receive;
> +	st_ldisc_ops->write_wakeup = st_tty_wakeup;
> +	st_ldisc_ops->flush_buffer = st_tty_flush_buffer;
> +	st_ldisc_ops->owner = THIS_MODULE;

You could just declare this as a static struct like other drivers do ?

