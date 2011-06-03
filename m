Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1FCWTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:19:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55218 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756527Ab1FCWTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:19:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=D7SL5L1+squ4lUFA4BjgjaAkR6pdvOORNJXDTvMgvcOwfefWiXKytUL+blM0d8X6Ul
         dOxZCm4iafkDxPqEI8JA==
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF0498E1C887@HQMAIL01.nvidia.com>
References: <1303251276-18768-1-git-send-email-vpalatin@chromium.org>
 <BANLkTikeTQi6zz+yb4USWwaROFZJW2cfog@mail.gmail.com> <74CDBE0F657A3D45AFBB94109FB122FF0498E1C887@HQMAIL01.nvidia.com>
From: Vincent Palatin <vpalatin@chromium.org>
Date: Fri, 3 Jun 2011 18:18:45 -0400
X-Google-Sender-Auth: IkycFXyIomevBRMIKDe-0s1Fq0M
Message-ID: <BANLkTin_ypRamBbdmE1unWyovVc-h_nSa5jDkNkfc2S+n4fwdg@mail.gmail.com>
Subject: Re: [PATCH] i2c: i2c-tegra: fix possible race condition after tx
To: Stephen Warren <swarren@nvidia.com>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        Olof Johansson <olofj@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Colin Cross <ccross@android.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 3, 2011 at 18:01, Stephen Warren <swarren@nvidia.com> wrote:
>Tested-by: Stephen Warren <swarren@nvidia.com>
>
> (using code based on 3.0-rc1, on Harmony, ran "speaker-test -c 2", and
> then adjusted the volume a lot using alsamixer, thus causing quite a few
> I2C transactions)

Thanks for the testing and the review !

>> > @@ -213,38 +213,41 @@ static int tegra_i2c_empty_rx_fifo(struct tegra_i2c_dev *i2c_dev)
>> >        u32 val;
>> >        int rx_fifo_avail;
>> >        u8 *buf = i2c_dev->msg_buf;
>> > -       size_t buf_remaining = i2c_dev->msg_buf_remaining;
>
> The old code read msg_buf_remaining once up front and did everything
> based on that.
>
>> >        int words_to_transfer;
>> > +       int bytes_to_transfer;
>> >
>> >        val = i2c_readl(i2c_dev, I2C_FIFO_STATUS);
>> >        rx_fifo_avail = (val & I2C_FIFO_STATUS_RX_MASK) >>
>> >                I2C_FIFO_STATUS_RX_SHIFT;
>> >
>> >        /* Rounds down to not include partial word at the end of buf */
>> > -       words_to_transfer = buf_remaining / BYTES_PER_FIFO_WORD;
>> > +       words_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining) /
>> > +               BYTES_PER_FIFO_WORD;
>
> Whereas the new code reads msg_buf_remaining once here...
>
>> >        if (words_to_transfer > rx_fifo_avail)
>> >                words_to_transfer = rx_fifo_avail;
>> >
>> > +       atomic_sub(words_to_transfer * BYTES_PER_FIFO_WORD,
>> > +               &i2c_dev->msg_buf_remaining);
>> >        i2c_readsl(i2c_dev, buf, I2C_RX_FIFO, words_to_transfer);
>> >
>> >        buf += words_to_transfer * BYTES_PER_FIFO_WORD;
>> > -       buf_remaining -= words_to_transfer * BYTES_PER_FIFO_WORD;
>> >        rx_fifo_avail -= words_to_transfer;
>> >
>> >        /*
>> >         * If there is a partial word at the end of buf, handle it manually to
>> >         * prevent overwriting past the end of buf
>> >         */
>> > -       if (rx_fifo_avail > 0 && buf_remaining > 0) {
>> > -               BUG_ON(buf_remaining > 3);
>> > +       bytes_to_transfer = atomic_read(&i2c_dev->msg_buf_remaining);
>
> And again here...
>
>> > +       if (rx_fifo_avail > 0 && bytes_to_transfer > 0) {
>> > +               BUG_ON(bytes_to_transfer > 3);
>
> That means that if msg_buf_remaining increases between those two reads,
> this BUG_ON could trigger.
>
> I assume this isn't possible, because the I2C core only sends one
> transaction to the I2C driver and doesn't send any more requests down
> until the previous is complete. If so, then the new code seems fine, but
> I did want to double-check this.

The transfers are serialized in the i2c_transfer function of the core
(which calls the tegra_i2c_xfer callback) and msg_buf_remaining can
only increase when it is set at the beginning of tegra_i2c_xfer_msg.
So yes we have at most one transaction and I don't think we can
trigger this BUG_ON.


-- 
Vincent
