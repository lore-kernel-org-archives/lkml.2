Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756756Ab1CRPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 11:05:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60343 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab1CRPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 11:05:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Date: Fri, 18 Mar 2011 16:05:36 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: alan@lxorguk.ukuu.org.uk, linux-i2c@vger.kernel.org, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <20110318110348.728f6036@lxorguk.ukuu.org.uk> <99B09243E1A5DA4898CDD8B7001114481085881963@EXMB04.eu.tieto.com>
In-Reply-To: <99B09243E1A5DA4898CDD8B7001114481085881963@EXMB04.eu.tieto.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103181605.36877.arnd@arndb.de>
X-Provags-ID: V02:K0:7ISOC3ASl1pxJqql+8Qh5nbQWRsJb24RX7TJpnEjTER
 ggB5DYWK11Mo6d4O7TPRQR3cZ3e1wfKBuRAUom/oC+1UpijfoY
 rj95+zxjI3dMl39yOp/UmnJZzywsnahPhS3O9cwTP1JZdzH9rU
 LiDFzkN6b7KKimD8EokSltKR1MjNyyh9r9T9ZeZhU9GV2m802u
 rphn4uH9yyQtQwOISfZlw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011, Waldemar.Rymarkiewicz@tieto.com wrote:
> >
> >Ermm nope.. why do we have do nothing ioctls ?
> >
> 
> onfc stack requires those ones, but they are only valid for a specific test enviroment.
> This should not be a case for driver and the stack should care about it if it needs
> this. Then will remove it.

The way this normally works is to figure out the correct
way to implement the kernel driver first and then write
a user space stack around it, not the other way round...
  
> >> +
> >> +    mutex_lock(&info->rx_mutex);
> >> +    info->irq_state = 1;
> >> +    mutex_unlock(&info->rx_mutex);
> >
> >Would it not be lighter to use atomic bit ops ?
> 
> Do you mean  in order to remove rx_mutex? 
> 
> mutex_lock(&info->rx_mutex);
> atomic_set(info->irq_state ,1);
> mutex_unlock(&info->rx_mutex);
> 
> looks a bit strange. I still need the rx_mutex to protect irq_state while reading i2c.
> 
>         mutex_lock(&info->rx_mutex);
>         ret = i2c_master_recv(client, info->buf, info->buflen);
>         info->irq_state = 0;
>         mutex_unlock(&info->rx_mutex);

What Alan meant was set_bit/test_and_clear_bit here, not atomic_*().
As I mentioned in the other mail, the way you check the flag is
probably still racy with the current mutex use.

Note that the interrupt handler doesn't do much at all, so it's probably
a good idea to use a regular (non-threaded) handler here to reduce
the overhead, once you have removed the mutex.

	Arnd
