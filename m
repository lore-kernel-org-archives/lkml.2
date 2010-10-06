Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab0JFTrF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 15:47:05 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:56698 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab0JFTrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 15:47:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ujKipbfKhAZrMlo6ng3ekUjqOTYzqMa+RjBt1MkdwdXp+ovYrY0/SnJ8uS54Q5YO3o
         y1qfxBmZr3zVQGHiDK8gdBVp9ix+06oC3vbdc3Bi2ADGPy1mYihAIeu3H+eQAcx/IWq+
         3g0iE5CRFo7hLZ4pgTz71rJKJsbtCY5kfPylM=
Message-ID: <4CACD234.7020900@gmail.com>
Date: Wed, 06 Oct 2010 21:47:00 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.9) Gecko/20100914 SUSE/3.1.4 Thunderbird/3.1.4
MIME-Version: 1.0
To: pavan_savoy@ti.com
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 1/2] drivers:staging:ti-st: move TI_ST from staging
References: <1286381895-11329-1-git-send-email-pavan_savoy@ti.com> <1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
In-Reply-To: <1286381895-11329-2-git-send-email-pavan_savoy@ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have few comments below.

On 10/06/2010 06:18 PM, pavan_savoy@ti.com wrote:
> --- /dev/null
> +++ b/drivers/misc/ti-st/st_core.c
> @@ -0,0 +1,1031 @@
...
> +#define PROTO_ENTRY(type, name)	name
> +const unsigned char *protocol_strngs[] = {
> +	PROTO_ENTRY(ST_BT, "Bluetooth"),
> +	PROTO_ENTRY(ST_FM, "FM"),
> +	PROTO_ENTRY(ST_GPS, "GPS"),
> +};

Is this planned to be used somewhere?

> +void st_send_frame(enum proto_type protoid, struct st_data_s *st_gdata)
> +{
> +	pr_info(" %s(prot:%d) ", __func__, protoid);

This is rather a kind of debug info... (with missing \n)

> +	if (unlikely
> +	    (st_gdata == NULL || st_gdata->rx_skb == NULL
> +	     || st_gdata->list[protoid] == NULL)) {

This is not much readable.

> +		pr_err("protocol %d not registered, no data to send?",
> +			   protoid);

Missing \n. And all over the code.

> +static inline int st_check_data_len(struct st_data_s *st_gdata,

It doesn't look like a candidate for inlining.

> +	int protoid, int len)
> +{
> +	register int room = skb_tailroom(st_gdata->rx_skb);

register... hmm, leave this on compiler.

> +	pr_debug("len %d room %d", len, room);
> +
> +	if (!len) {
> +		/* Received packet has only packet header and
> +		 * has zero length payload. So, ask ST CORE to
> +		 * forward the packet to protocol driver (BT/FM/GPS)
> +		 */
> +		st_send_frame(protoid, st_gdata);
> +
> +	} else if (len > room) {
> +		/* Received packet's payload length is larger.
> +		 * We can't accommodate it in created skb.
> +		 */
> +		pr_err("Data length is too large len %d room %d", len,
> +			   room);
> +		kfree_skb(st_gdata->rx_skb);
> +	} else {
> +		/* Packet header has non-zero payload length and
> +		 * we have enough space in created skb. Lets read
> +		 * payload data */
> +		st_gdata->rx_state = ST_BT_W4_DATA;
> +		st_gdata->rx_count = len;
> +		return len;
> +	}
> +
> +	/* Change ST state to continue to process next
> +	 * packet */
> +	st_gdata->rx_state = ST_W4_PACKET_TYPE;
> +	st_gdata->rx_skb = NULL;
> +	st_gdata->rx_count = 0;
> +
> +	return 0;
> +}
> +
> +/**
> + * st_wakeup_ack - internal function for action when wake-up ack
> + *	received
> + */
> +static inline void st_wakeup_ack(struct st_data_s *st_gdata,
> +	unsigned char cmd)
> +{
> +	register struct sk_buff *waiting_skb;
> +	unsigned long flags = 0;

No need to initialize.

> +	spin_lock_irqsave(&st_gdata->lock, flags);
> +	/* de-Q from waitQ and Q in txQ now that the
> +	 * chip is awake
> +	 */
> +	while ((waiting_skb = skb_dequeue(&st_gdata->tx_waitq)))
> +		skb_queue_tail(&st_gdata->txq, waiting_skb);
> +
> +	/* state forwarded to ST LL */
> +	st_ll_sleep_state(st_gdata, (unsigned long)cmd);
> +	spin_unlock_irqrestore(&st_gdata->lock, flags);
> +
> +	/* wake up to send the recently copied skbs from waitQ */
> +	st_tx_wakeup(st_gdata);
> +}
> +
> +/**
> + * st_int_recv - ST's internal receive function.
> + *	Decodes received RAW data and forwards to corresponding
> + *	client drivers (Bluetooth,FM,GPS..etc).
> + *	This can receive various types of packets,
> + *	HCI-Events, ACL, SCO, 4 types of HCI-LL PM packets
> + *	CH-8 packets from FM, CH-9 packets from GPS cores.
> + */
> +void st_int_recv(void *disc_data,
> +	const unsigned char *data, long count)
> +{
> +	register char *ptr;
> +	struct hci_event_hdr *eh;
> +	struct hci_acl_hdr *ah;
> +	struct hci_sco_hdr *sh;
> +	struct fm_event_hdr *fm;
> +	struct gps_event_hdr *gps;
> +	register int len = 0, type = 0, dlen = 0;
> +	static enum proto_type protoid = ST_MAX;
> +	struct st_data_s *st_gdata = (struct st_data_s *)disc_data;
> +
> +	ptr = (char *)data;

Too much of casts and registers.

> +	/* tty_receive sent null ? */
> +	if (unlikely(ptr == NULL) || (st_gdata == NULL)) {
> +		pr_err(" received null from TTY ");
> +		return;
> +	}
> +
> +	pr_info("count %ld rx_state %ld"
> +		   "rx_count %ld", count, st_gdata->rx_state,
> +		   st_gdata->rx_count);

It's a debug info. + \n

> +int st_core_init(struct st_data_s **core_data)
> +{
> +	struct st_data_s *st_gdata;
> +	long err;
> +	static struct tty_ldisc_ops *st_ldisc_ops;
> +
> +	/* populate and register to TTY line discipline */
> +	st_ldisc_ops = kzalloc(sizeof(*st_ldisc_ops), GFP_KERNEL);
> +	if (!st_ldisc_ops) {
> +		pr_err("no mem to allocate");
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

This can be static structure, you don't need to allocate this on heap.
It should be a singleton.

> +
> +	err = tty_register_ldisc(N_TI_WL, st_ldisc_ops);
> +	if (err) {
> +		pr_err("error registering %d line discipline %ld",
> +			   N_TI_WL, err);
> +		kfree(st_ldisc_ops);
> +		return err;
> +	}
> +	pr_debug("registered n_shared line discipline");
> +
> +	st_gdata = kzalloc(sizeof(struct st_data_s), GFP_KERNEL);
> +	if (!st_gdata) {
> +		pr_err("memory allocation failed");
> +		err = tty_unregister_ldisc(N_TI_WL);
> +		if (err)
> +			pr_err("unable to un-register ldisc %ld", err);
> +		kfree(st_ldisc_ops);
> +		err = -ENOMEM;
> +		return err;
> +	}
> +
> +	/* Initialize ST TxQ and Tx waitQ queue head. All BT/FM/GPS module skb's
> +	 * will be pushed in this queue for actual transmission.
> +	 */
> +	skb_queue_head_init(&st_gdata->txq);
> +	skb_queue_head_init(&st_gdata->tx_waitq);
> +
> +	/* Locking used in st_int_enqueue() to avoid multiple execution */
> +	spin_lock_init(&st_gdata->lock);
> +
> +	/* ldisc_ops ref to be only used in __exit of module */
> +	st_gdata->ldisc_ops = st_ldisc_ops;
> +
> +#if 0
> +	err = st_kim_init();
> +	if (err) {
> +		pr_err("error during kim initialization(%ld)", err);
> +		kfree(st_gdata);
> +		err = tty_unregister_ldisc(N_TI_WL);
> +		if (err)
> +			pr_err("unable to un-register ldisc");
> +		kfree(st_ldisc_ops);
> +		return -1;
> +	}
> +#endif
> +
> +	err = st_ll_init(st_gdata);
> +	if (err) {
> +		pr_err("error during st_ll initialization(%ld)", err);
> +		kfree(st_gdata);
> +		err = tty_unregister_ldisc(N_TI_WL);
> +		if (err)
> +			pr_err("unable to un-register ldisc");
> +		kfree(st_ldisc_ops);

Please use goto fail-paths.

> +		return -1;
> +	}
> +	*core_data = st_gdata;
> +	return 0;
> +}
...
> --- /dev/null
> +++ b/drivers/misc/ti-st/st_kim.c
> @@ -0,0 +1,798 @@
...
> +#define PROTO_ENTRY(type, name)	name
> +const unsigned char *protocol_names[] = {
> +	PROTO_ENTRY(ST_BT, "Bluetooth"),
> +	PROTO_ENTRY(ST_FM, "FM"),
> +	PROTO_ENTRY(ST_GPS, "GPS"),
> +};

Here they appear again. It should be static and have a better name to
not collide with the rest of the world.

> +#define MAX_ST_DEVICES	3	/* Imagine 1 on each UART for now */
> +struct platform_device *st_kim_devices[MAX_ST_DEVICES];

static? Doesn't sparse warn about this?

> +void kim_int_recv(struct kim_data_s *kim_gdata,
> +	const unsigned char *data, long count)
> +{
> +	register char *ptr;
> +	struct hci_event_hdr *eh;
> +	register int len = 0, type = 0;

registers

> +	pr_debug("%s", __func__);

\n

> +	/* Decode received bytes here */
> +	ptr = (char *)data;

Casting from const to non-const. It doesn't look correct.

> +static long read_local_version(struct kim_data_s *kim_gdata, char *bts_scr_name)
> +{
> +	unsigned short version = 0, chip = 0, min_ver = 0, maj_ver = 0;

No need to initialize all of them.

> +	char read_ver_cmd[] = { 0x01, 0x01, 0x10, 0x00 };

static const perhaps.

> +long st_kim_start(void *kim_data)
> +{
> +	long err = 0;
> +	long retry = POR_RETRY_COUNT;
> +	struct kim_data_s	*kim_gdata = (struct kim_data_s *)kim_data;
> +
> +	pr_info(" %s", __func__);
> +
> +	do {
> +		/* TODO: this is only because rfkill sub-system
> +		 * doesn't send events to user-space if the state
> +		 * isn't changed
> +		 */
> +		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 1);
> +		/* Configure BT nShutdown to HIGH state */
> +		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_LOW);
> +		mdelay(5);	/* FIXME: a proper toggle */
> +		gpio_set_value(kim_gdata->gpios[ST_BT], GPIO_HIGH);
> +		mdelay(100);

You can sleep here instead (below you wait for completion). 100 ms of
busy waiting is way too much.

> +		/* re-initialize the completion */
> +		INIT_COMPLETION(kim_gdata->ldisc_installed);
> +#if 0 /* older way of signalling user-space UIM */
> +		/* send signal to UIM */
> +		err = kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 0);
> +		if (err != 0) {
> +			pr_info(" sending SIGUSR2 to uim failed %ld", err);
> +			err = -1;
> +			continue;
> +		}
> +#endif
> +		/* unblock and send event to UIM via /dev/rfkill */
> +		rfkill_set_hw_state(kim_gdata->rfkill[ST_BT], 0);
> +		/* wait for ldisc to be installed */
> +		err = wait_for_completion_timeout(&kim_gdata->ldisc_installed,
> +				msecs_to_jiffies(LDISC_TIME));

regards,
-- 
js
