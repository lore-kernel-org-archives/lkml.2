Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab2CQBGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 21:06:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:50703 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab2CQBF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 21:05:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="78561584"
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com> <20120315100812.6cda2ef9@pyramind.ukuu.org.uk> <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com> <4F630B4D.3040508@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com> <4F630E6D.4000307@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com> <4F63101D.70507@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com> <4F631449.7090302@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3DCC@SHSMSX102.ccr.corp.intel.com> <4F632C15.5070902@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3E02@SHSMSX102.ccr.corp.intel.com> <4F63A85B.4010304@suse.cz>
In-Reply-To: <4F63A85B.4010304@suse.cz>
MIME-Version: 1.0 (1.0)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="us-ascii"
Message-ID: <79074EDC-A60E-45CA-968C-027E194F7927@intel.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
X-Mailer: iPad Mail (9A405)
From: Alek Du <alek.du@intel.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling
Date: Sat, 17 Mar 2012 09:05:55 +0800
To: Jiri Slaby <jslaby@suse.cz>
X-Originating-IP: [10.239.127.40]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> On 03/16/2012 02:50 PM, Du, Alek wrote:
>> For #1, as I said, we already held the tty refcount. The tty refcount cannot help this crash.
> 
> Where exactly? Do you have some local changes?
> $ grep tty_port_tty_ drivers/tty/serial/mfd.c
> $

Yes, we do have local changes not upstream yet. But you should know now, TTY recount is not the key of the spin lock hole.


> 
>> For #2, this patch will avoid memcpy to a NULL pointer and avoid a kernel crash.
> 
> Ok, could you explain how? Linearized code from moxa.c with your patch
> applied follows:
> ofs = baseAddr + DynPage_addr + bufhead + head;
> size = (tail >= head) ? (tail - head) : (rx_mask + 1 - head);
> size = min(size, count);
> // call to tty_prepare_flip_string
>    spin_lock_irqsave(&tty->buf.lock, flags);
>    space = __tty_buffer_request_room(tty, size);
> 
>    tb = tty->buf.tail;
>    if (likely(space)) {
>        *chars = tb->char_buf_ptr + tb->used;
>        memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
>        tb->used += space;
>    }
>    spin_unlock_irqrestore(&tty->buf.lock, flags);
> // return to MoxaPortReadData
> memcpy_fromio(*chars, ofs, space); <- memcpy without buf.lock

Ok. This is true. Seems we need another patch to remove this prepare interface. And let callers use the protected interface.

Thanks,
Alek


> head = (head + len) & rx_mask;
> ...
> 
> thanks,
> -- 
> js
> suse labs
