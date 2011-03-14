Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab1CNPeZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 11:34:25 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63627 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915Ab1CNPeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 11:34:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Mon, 14 Mar 2011 16:34:10 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: matti.j.aaltonen@nokia.com, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103101720.53782.arnd@arndb.de> <99B09243E1A5DA4898CDD8B7001114481082FAE10A@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481082FAE10A@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103141634.10865.arnd@arndb.de>
X-Provags-ID: V02:K0:02VN0N31Lzub4WhWu54f3DA+mm6k4CUBYJsljq7RudP
 Eknr3KAlS3WaVwGtayEkBLziCFro+RPSwASf9kOEY+Sz8QNKXL
 D03p1T+B26eI4QhXWLb5skjSPHe5nyNwJdR7c8lOw4LRNyzJ9k
 0RmrR/aLNS7GlmJqW0PAWBv2v32IOjwlDikux5sO39tVBsSGsm
 CvTe9rQfyhCmjI22fGxTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >Oh, I see you simply do
> >
> >       ret = i2c_master_send(client, info->buf, len);
> >       usleep_range(1000, 10000);
> >
> >and assume that the buffer can always be written within a 
> >milisecond, so you just slow down output enough to never have 
> >to worry about it, right?
> >
> >A nicer solution would be to have an interrupt driven output 
> >so you know when the i2c buffers have been flushed.
> 
> Well, I get the idea of interrupt driven output, but as I have
> little linux kernel experience I'm not sure how to implement this. 
> Can you extend you thoughts or if you know piont me a driver which
> uses that concept?

Most serial drivers do this, see drivers/tty/serial for a number
of examples, or drivers/serial on older kernels.

> I'm not sure who should rise an interrupt when data has
> been flushed. I2c core or the chip itself?

That would depend on your hardware. The only important
part is that you make sure you can send out data at any
time. If i2c_master_send() causes accesses to your
buffer after returning, there has to be an i2c method
of making sure that it has completed.

If the usleep_range is trying to synchronize between the
NFC and the I2C chip, you must wait for a notication from
the NFC hardware that it's done.

> What's more, I guess the i2c_master_send  is a synchronous
> call and when it returnes we know it flushed data. Right? 

If i2c_master_send is synchronous, you might not
need the usleep_range() at all. Removing that call
would be entirely reasonable.

	Arnd
