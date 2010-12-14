Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759499Ab0LNRYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 12:24:07 -0500
Received: from smtp.nokia.com ([147.243.128.24]:47282 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757219Ab0LNRYF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 12:24:05 -0500
Subject: Re: [RFC PATCHv4 4/7] HSI: hsi_char: Add HSI char device driver
From: Carlos Chinea <carlos.chinea@nokia.com>
To: ext Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        Andras Domokos <andras.domokos@nokia.com>
In-Reply-To: <20101214115600.62388d5d@lxorguk.ukuu.org.uk>
References: <1292321383-30200-1-git-send-email-carlos.chinea@nokia.com>
	 <1292321383-30200-5-git-send-email-carlos.chinea@nokia.com>
	 <20101214115600.62388d5d@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 14 Dec 2010 19:24:28 +0200
Message-ID: <1292347468.2529.220.camel@groo>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-14 at 11:56 +0000, ext Alan Cox wrote:
> > +#define HSI_CHST_RD(c)		((c)->state & HSI_CHST_RD_MASK)
> > +#define HSI_CHST_WR(c)		((c)->state & HSI_CHST_WR_MASK)
> > +
> > +#define HSI_CHST_OC_SET(c, v) \
> > +	do { \
> > +		(c)->state &= ~HSI_CHST_OC_MASK; \
> > +		(c)->state |= v; \
> > +	} while (0);
> > +
> > +#define HSI_CHST_RD_SET(c, v) \
> > +	do { \
> > +		(c)->state &= ~HSI_CHST_RD_MASK; \
> > +		(c)->state |= v; \
> > +	} while (0);
> > +
> > +#define HSI_CHST_WR_SET(c, v) \
> > +	do { \
> > +		(c)->state &= ~HSI_CHST_WR_MASK; \
> > +		(c)->state |= v; \
> > +	} while (0);
> 
> 
> These sort of macros just hide detail - eg the lack of internal locking,
> which can lead to problems later, plus they reference their arguments
> multiple times so may have weird side effects.
> 
> They should probably be inline functions so they at least type check and
> behave sanely, and their locking rules defintiely need documenting

Agree. We would change that.

> 
> 
> 
> > +static long hsi_char_ioctl(struct file *file, unsigned int cmd,
> > +							unsigned long arg)
> > +{
> > +	struct hsi_char_channel *channel = file->private_data;
> > +	unsigned int state;
> > +	struct hsi_config cfg;
> > +	struct hsc_rx_config rx_cfg;
> > +	struct hsc_tx_config tx_cfg;
> > +	long ret = 0;
> > +
> > +	if (HSI_CHST_OC(channel) != HSI_CHST_OPENED)
> > +		return -ENODEV;
> 
> -EIO is the traditional response in this case if the channel has been
> closed by the other end - ENODEV indicates there is no physical device
> present - not sure which is right here from the code.
> 

The initial idea of this code was to guard against underneath removal of
the device. That was the reason for the -ENODEV.

Now after, rechecking the code I think that we need also to lock the
device to avoid that the removal happening in the middle of the
function.

> 
> > +		} else if ((state == HSC_PM_ENABLE)
> > +				&& (channel->wlrefcnt > 0)) {
> > +			ret = hsi_stop_tx(channel->cl);
> > +			if (!ret)
> > +				channel->wlrefcnt--;
> 
> What locks this lot against races (ditto some of the other ioctl code)

Right. We will fix this also.

> 
> > +	refcnt = atomic_inc_return(&cl_data->refcnt);
> > +	if (refcnt == 1) {
> 
> You seem to construct a lot of clever stuff using atomic_inc_return and
> friends where it looks like test_and_set_bit - or even a mutex over
> open/close would be far easier to understand ?

Yep a mutex will be a better option here. It would also take care of the
next comment.

> 
> > +	ret = hsi_char_msgs_alloc(channel);
> > +
> > +	if (ret < 0) {
> > +		refcnt = atomic_dec_return(&cl_data->refcnt);
> > +		if (!refcnt)
> > +			hsi_release_port(channel->cl);
> > +		spin_lock_bh(&channel->lock);
> > +		HSI_CHST_OC_SET(channel, HSI_CHST_CLOSED);
> > +		goto out;
> > +	}
> > +	if (refcnt == 1)
> > +		cl_data->attached = 1;
> 
> What happens here if a second open passes the first, the attached will
> stay zero and other stuff will be in strange states but the open flag
> will be set ?
> 
> 
> > +	for (i = 0; i < HSI_CHAR_DEVS && channels_map[i] >= 0; i++) {
> > +		if (channels_map[i] >= HSI_CHAR_DEVS) {
> > +			pr_err("Invalid HSI/SSI channel specified");
> > +			return -EINVAL;
> > +		}
> > +		set_bit(channels_map[i], &ch_mask);
> 
> How will this integrate with hot discovery of SSI supporting devices ?
> 

For every SSI port there is an HSI char client device, which is the
device received through probe. The driver will export for every HSI char
client device, HSI_CHAR_DEVS char devices, one char device per channel.

The intention of this piece of code is to allow the user to configure
which channels the user wants to be available to userspace.

Thanks for the comments,
Carlos

