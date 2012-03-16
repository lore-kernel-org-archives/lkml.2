Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030708Ab2CPJtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:49:35 -0400
Received: from mga14.intel.com ([143.182.124.37]:27934 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab2CPJtd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:49:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119725337"
From: "Du, Alek" <alek.du@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: RE: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Topic: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Index: Ac0CUERRacLD33MLTtaeiAHOWyOq2AAADUEAABDKXdAAIKULgAAQyYZQ
Date: Fri, 16 Mar 2012 09:49:30 +0000
Message-ID: <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
 <20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
 <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
 <4F630B4D.3040508@suse.cz>
In-Reply-To: <4F630B4D.3040508@suse.cz>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The tty structure is protect and not null, the tty->buf.tail is null. Many people think the tty reference count isn't protected and cause this bug, it is not true. :-)

For the flush case, it need acquire the spinlock to free the buffer and put buf.tail to NULL. So this patch will help:

Here is the example place, you can see the __tty_buffer_flush is inside the spinlock.

void tty_buffer_flush(struct tty_struct *tty)
{
        unsigned long flags;
        spin_lock_irqsave(&tty->buf.lock, flags);

        /* If the data is being pushed to the tty layer then we can't
           process it here. Instead set a flag and the flush_to_ldisc
           path will process the flush request before it exits */
        if (test_bit(TTY_FLUSHING, &tty->flags)) {
                set_bit(TTY_FLUSHPENDING, &tty->flags);
                spin_unlock_irqrestore(&tty->buf.lock, flags);
                wait_event(tty->read_wait,
                                test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
                return;
        } else
                __tty_buffer_flush(tty);
        spin_unlock_irqrestore(&tty->buf.lock, flags);
}



Thanks,
Alek

-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] On Behalf Of Jiri Slaby
Sent: Friday, March 16, 2012 5:44 PM
To: Du, Alek
Cc: Alan Cox; Tu, Xiaobing; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; Zhang, Yanmin; Zuo, Jiao; Jiri Slaby
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling

On 03/15/2012 11:14 AM, Du, Alek wrote:
> Alan,
> 
> I agree with you for the case of multiple writers to the tty buffer.
> 
> But there is another case that cause kernel hang: driver is writing data to tty, while app shutdown the port or flush through IOCTL. The buf.tail is set to NULL, here is the log:
> 
> 
> <1>[ 4713.451954] BUG: unable to handle kernel NULL pointer 
> dereference at
> 00000004

The trace only suggests that you don't increment tty reference count in irq properly. If you did that, you would not have tty buffer gone by concurrent shutdown.

For the latter case (flush via ioctl), your patch won't help for tty_prepare_string*, as we return pointer to the buffer which is freed by the flush, right?

thanks,
--
js
suse labs
