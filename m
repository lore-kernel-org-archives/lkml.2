Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758119Ab0LNL5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 06:57:19 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54351 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757819Ab0LNL5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 06:57:18 -0500
Date: Tue, 14 Dec 2010 11:56:00 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Carlos Chinea <carlos.chinea@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Andras Domokos <andras.domokos@nokia.com>
Subject: Re: [RFC PATCHv4 4/7] HSI: hsi_char: Add HSI char device driver
Message-ID: <20101214115600.62388d5d@lxorguk.ukuu.org.uk>
In-Reply-To: <1292321383-30200-5-git-send-email-carlos.chinea@nokia.com>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
	<1292321383-30200-5-git-send-email-carlos.chinea@nokia.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#define HSI_CHST_RD(c)		((c)->state & HSI_CHST_RD_MASK)
> +#define HSI_CHST_WR(c)		((c)->state & HSI_CHST_WR_MASK)
> +
> +#define HSI_CHST_OC_SET(c, v) \
> +	do { \
> +		(c)->state &= ~HSI_CHST_OC_MASK; \
> +		(c)->state |= v; \
> +	} while (0);
> +
> +#define HSI_CHST_RD_SET(c, v) \
> +	do { \
> +		(c)->state &= ~HSI_CHST_RD_MASK; \
> +		(c)->state |= v; \
> +	} while (0);
> +
> +#define HSI_CHST_WR_SET(c, v) \
> +	do { \
> +		(c)->state &= ~HSI_CHST_WR_MASK; \
> +		(c)->state |= v; \
> +	} while (0);


These sort of macros just hide detail - eg the lack of internal locking,
which can lead to problems later, plus they reference their arguments
multiple times so may have weird side effects.

They should probably be inline functions so they at least type check and
behave sanely, and their locking rules defintiely need documenting



> +static long hsi_char_ioctl(struct file *file, unsigned int cmd,
> +							unsigned long arg)
> +{
> +	struct hsi_char_channel *channel = file->private_data;
> +	unsigned int state;
> +	struct hsi_config cfg;
> +	struct hsc_rx_config rx_cfg;
> +	struct hsc_tx_config tx_cfg;
> +	long ret = 0;
> +
> +	if (HSI_CHST_OC(channel) != HSI_CHST_OPENED)
> +		return -ENODEV;

-EIO is the traditional response in this case if the channel has been
closed by the other end - ENODEV indicates there is no physical device
present - not sure which is right here from the code.


> +		} else if ((state == HSC_PM_ENABLE)
> +				&& (channel->wlrefcnt > 0)) {
> +			ret = hsi_stop_tx(channel->cl);
> +			if (!ret)
> +				channel->wlrefcnt--;

What locks this lot against races (ditto some of the other ioctl code)

> +	refcnt = atomic_inc_return(&cl_data->refcnt);
> +	if (refcnt == 1) {

You seem to construct a lot of clever stuff using atomic_inc_return and
friends where it looks like test_and_set_bit - or even a mutex over
open/close would be far easier to understand ?

> +	ret = hsi_char_msgs_alloc(channel);
> +
> +	if (ret < 0) {
> +		refcnt = atomic_dec_return(&cl_data->refcnt);
> +		if (!refcnt)
> +			hsi_release_port(channel->cl);
> +		spin_lock_bh(&channel->lock);
> +		HSI_CHST_OC_SET(channel, HSI_CHST_CLOSED);
> +		goto out;
> +	}
> +	if (refcnt == 1)
> +		cl_data->attached = 1;

What happens here if a second open passes the first, the attached will
stay zero and other stuff will be in strange states but the open flag
will be set ?


> +	for (i = 0; i < HSI_CHAR_DEVS && channels_map[i] >= 0; i++) {
> +		if (channels_map[i] >= HSI_CHAR_DEVS) {
> +			pr_err("Invalid HSI/SSI channel specified");
> +			return -EINVAL;
> +		}
> +		set_bit(channels_map[i], &ch_mask);

How will this integrate with hot discovery of SSI supporting devices ?

