Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab1FCWd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:33:28 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:7613 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754247Ab1FCWd0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:33:26 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 03 Jun 2011 15:33:05 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Vincent Palatin <vpalatin@chromium.org>
CC: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Fri, 3 Jun 2011 15:33:02 -0700
Subject: RE: [PATCH] i2c: i2c-tegra: fix possible race condition after tx
Thread-Topic: [PATCH] i2c: i2c-tegra: fix possible race condition after tx
Thread-Index: AcwiPEKi47Myye9TRlGtGK1hfYwPcQAAcT1w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF0498E1C896@HQMAIL01.nvidia.com>
References: <1303251276-18768-1-git-send-email-vpalatin@chromium.org>
 <BANLkTikeTQi6zz+yb4USWwaROFZJW2cfog@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF0498E1C887@HQMAIL01.nvidia.com>
 <BANLkTin_ypRamBbdmE1unWyovVc-h_nSa5jDkNkfc2S+n4fwdg@mail.gmail.com>
In-Reply-To: <BANLkTin_ypRamBbdmE1unWyovVc-h_nSa5jDkNkfc2S+n4fwdg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent Palatin wrote at Friday, June 03, 2011 4:19 PM:
> On Fri, Jun 3, 2011 at 18:01, Stephen Warren <swarren@nvidia.com> wrote:
> >Tested-by: Stephen Warren <swarren@nvidia.com>
> >
> > (using code based on 3.0-rc1, on Harmony, ran "speaker-test -c 2", and
> > then adjusted the volume a lot using alsamixer, thus causing quite a few
> > I2C transactions)
> 
> Thanks for the testing and the review !
> 
> >> > @@ -213,38 +213,41 @@ static int tegra_i2c_empty_rx_fifo(struct
> tegra_i2c_dev *i2c_dev)
> >> >        u32 val;
> >> >        int rx_fifo_avail;
> >> >        u8 *buf = i2c_dev->msg_buf;
> >> > -       size_t buf_remaining = i2c_dev->msg_buf_remaining;
> >
> > The old code read msg_buf_remaining once up front and did everything
> > based on that.
> >
> >> >        int words_to_transfer;
> >> > +       int bytes_to_transfer;
> >> >
> >> >        val = i2c_readl(i2c_dev, I2C_FIFO_STATUS);
> >> >        rx_fifo_avail = (val & I2C_FIFO_STATUS_RX_MASK) >>
> >> >                I2C_FIFO_STATUS_RX_SHIFT;
> >> >
> >> >        /* Rounds down to not include partial word at the end of buf
> */
> >> > -       words_to_transfer = buf_remaining / BYTES_PER_FIFO_WORD;
> >> > +       words_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining)
> /
> >> > +               BYTES_PER_FIFO_WORD;
> >
> > Whereas the new code reads msg_buf_remaining once here...
> >
> >> >        if (words_to_transfer > rx_fifo_avail)
> >> >                words_to_transfer = rx_fifo_avail;
> >> >
> >> > +       atomic_sub(words_to_transfer * BYTES_PER_FIFO_WORD,
> >> > +               &i2c_dev->msg_buf_remaining);
> >> >        i2c_readsl(i2c_dev, buf, I2C_RX_FIFO, words_to_transfer);
> >> >
> >> >        buf += words_to_transfer * BYTES_PER_FIFO_WORD;
> >> > -       buf_remaining -= words_to_transfer * BYTES_PER_FIFO_WORD;
> >> >        rx_fifo_avail -= words_to_transfer;
> >> >
> >> >        /*
> >> >         * If there is a partial word at the end of buf, handle it manually to
> >> >         * prevent overwriting past the end of buf
> >> >         */
> >> > -       if (rx_fifo_avail > 0 && buf_remaining > 0) {
> >> > -               BUG_ON(buf_remaining > 3);
> >> > +       bytes_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining);
> >
> > And again here...
> >
> >> > +       if (rx_fifo_avail > 0 && bytes_to_transfer > 0) {
> >> > +               BUG_ON(bytes_to_transfer > 3);
> >
> > That means that if msg_buf_remaining increases between those two reads,
> > this BUG_ON could trigger.
> >
> > I assume this isn't possible, because the I2C core only sends one
> > transaction to the I2C driver and doesn't send any more requests down
> > until the previous is complete. If so, then the new code seems fine, but
> > I did want to double-check this.
> 
> The transfers are serialized in the i2c_transfer function of the core
> (which calls the tegra_i2c_xfer callback) and msg_buf_remaining can
> only increase when it is set at the beginning of tegra_i2c_xfer_msg.
> So yes we have at most one transaction and I don't think we can
> trigger this BUG_ON.

Great, that's what I figured. So, the change looks good to me, so

Acked-by: Stephen Warren <swarren@nvidia.com>

too!

-- 
nvpublic

