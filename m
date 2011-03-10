Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1CJQVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:21:00 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:62507 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab1CJQU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:20:58 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com, matti.j.aaltonen@nokia.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Thu, 10 Mar 2011 17:20:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        hthebaud@insidefr.com
References: <1299766808-2535-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <201103101452.54862.arnd@arndb.de> <99B09243E1A5DA4898CDD8B7001114481082EF2A65@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481082EF2A65@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101720.53782.arnd@arndb.de>
X-Provags-ID: V02:K0:b4PCAvKPNkznZgwix6CTBuCxDzuZlf2vq00ehtU4qbJ
 4OpJvH+t4c1kl9FzBBJdkfQd0ed50uGnz1OmPYrI/iyKiV0GEH
 tq67yn4R5umA5sgCQ2I/O767jefGcJhXuathrTlGeDkn1OsTUa
 ALimmLLw7OvOB3YgQHdjpPWX5HFJ/uO2Qh65wd85fuwDHTJ3EO
 LhLkAIrTmWhL1WPU/LuyA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:

> >What I suggest you do is to work with the maintainers of the existing
> >pn544 driver (Matti and Jari) to create an NFC core library 
> >that takes care of the character device interface and that can 
> >be shared between the two drivers. Instead of each driver 
> >registering a misc device, make it call a 
> >nfc_device_register() function that is implemented in a common module.
> 
> I've been already thinking about that and it's seems like next obvious step.

Ok, cool.

> >mdev, rx_waitq and mutex would go into the common module.
> >I would expect that you also need a tx_waitq. What happens 
> >when the buffer is full?
> 
> Do you mean info->buff ?

Oh, I see you simply do

       ret = i2c_master_send(client, info->buf, len);
       usleep_range(1000, 10000);

and assume that the buffer can always be written within a milisecond,
so you just slow down output enough to never have to worry about it,
right?

A nicer solution would be to have an interrupt driven output
so you know when the i2c buffers have been flushed.

> >Note that the microread_is_busy() logic does not protect you 
> >from having multiple concurrent readers, because multiple 
> >threads may share a single file descriptor.
> 
> It's just used to ensure that only one reader can open the device.
> It's called only in open callback.
> The mutex actually secures concurrent read operations. 

So if having multiple readers is safe (though possibly not
meaningful), I guess you don't really need the microread_is_busy()
logic.

I suppose it doesn't hurt either, it just seems a bit pointless
when it does the right thing most of the time, but not always.

	Arnd
