Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310Ab2AOUdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 15:33:08 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:36773 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751950Ab2AOUdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 15:33:07 -0500
Message-ID: <1326659586.6164.18.camel@joe2Laptop>
Subject: Re: [PATCH] Bluetooth: bfusb: Fixed some coding style issues
From: Joe Perches <joe@perches.com>
To: mahendra singh meena <mahendra.devel@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sun, 15 Jan 2012 12:33:06 -0800
In-Reply-To: <4F132D37.7030405@gmail.com>
References: <4F132D37.7030405@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-01-16 at 01:17 +0530, mahendra singh meena wrote:
> Fixed some coding style issues shown by scripts/checkpatch.pl
[]
> diff --git a/drivers/bluetooth/bfusb.c b/drivers/bluetooth/bfusb.c
[]
> @@ -127,11 +127,13 @@ static int bfusb_send_bulk(struct bfusb_data *data, struct sk_buff *skb)
>  {
>  	struct bfusb_data_scb *scb = (void *) skb->cb;
>  	struct urb *urb = bfusb_get_completed(data);
> +	struct urb *urb_chk = urb;
>  	int err, pipe;
> 
>  	BT_DBG("bfusb %p skb %p len %d", data, skb, skb->len);
> +	urb = usb_alloc_urb(0, GFP_ATOMIC);
> 
> -	if (!urb && !(urb = usb_alloc_urb(0, GFP_ATOMIC)))
> +	if (!urb_chk && !urb)

Broken patch.

You are now always calling usb_alloc_urb and
overwriting the original urb that is returned
from bfusb_get_completed().

Not everything that checkpatch flags needs to be
modified.

The original is better than even a correct
proposed patch because it's more readable and it
uses fewer variables.

If you _really_ want to avoid checkpatch warnings,
then don't use the additional automatic.

	if (!urb) {
		urb = usb_alloc_urb(0, GFP_ATOMIC);
		if (!urb)
			return -ENOMEM;
	}

> @@ -145,7 +147,7 @@ static int bfusb_send_bulk(struct bfusb_data *data, struct sk_buff *skb)
> 
>  	err = usb_submit_urb(urb, GFP_ATOMIC);
>  	if (err) {
> -		BT_ERR("%s bulk tx submit failed urb %p err %d",
> +		BT_ERR("%s bulk tx submit failed urb %p err %d",

? What does checkpatch complain about this?

>  					data->hdev->name, urb, err);
>  		skb_unlink(skb, &data->pending_q);
>  		usb_free_urb(urb);
> @@ -214,11 +216,13 @@ static int bfusb_rx_submit(struct bfusb_data *data, struct urb *urb)
>  {
>  	struct bfusb_data_scb *scb;
>  	struct sk_buff *skb;
> +	struct urb *urb_chk = urb;
>  	int err, pipe, size = HCI_MAX_FRAME_SIZE + 32;
> 
>  	BT_DBG("bfusb %p urb %p", data, urb);
> +	urb = usb_alloc_urb(0, GFP_ATOMIC);
> 
> -	if (!urb && !(urb = usb_alloc_urb(0, GFP_ATOMIC)))
> +	if (!urb && !urb_chk)
>  		return -ENOMEM;

Same broken change.

> @@ -283,30 +288,37 @@ static inline int bfusb_recv_block(struct bfusb_data *data, int hdr, unsigned ch
>  		switch (pkt_type) {
>  		case HCI_EVENT_PKT:
>  			if (len >= HCI_EVENT_HDR_SIZE) {
> -				struct hci_event_hdr *hdr = (struct hci_event_hdr *) buf;
> +				struct hci_event_hdr *hdr;
> +				hdr = (struct hci_event_hdr *) buf;

It'd probably be better to change the type of "buf" to void *
and avoid all the casts.

> @@ -514,12 +528,14 @@ static int bfusb_send_frame(struct sk_buff *skb)
>  	while (count) {
>  		size = min_t(uint, count, BFUSB_MAX_BLOCK_SIZE);
> 
> -		buf[0] = 0xc1 | ((sent == 0) ? 0x04 : 0) | ((count == size) ? 0x08 : 0);
> +		buf[0] = 0xc1 | ((sent == 0) ? 0x04 : 0) |
> +						((count == size) ? 0x08 : 0);

When wrapping just for 80 columns, please try to use
alignments that are a bit more readable and perhaps
remove unnecessary parentheses like:

		buf[0] = 0xc1 |
			 (sent == 0 ? 0x04 : 0) |
			 (count == size ? 0x08 : 0);


