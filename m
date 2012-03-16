Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932692Ab2CPUxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:53:54 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:60855 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757339Ab2CPUxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:53:52 -0400
Message-ID: <4F63A85B.4010304@suse.cz>
Date: Fri, 16 Mar 2012 21:53:47 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Du, Alek" <alek.du@intel.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com> <20120315100812.6cda2ef9@pyramind.ukuu.org.uk> <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com> <4F630B4D.3040508@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com> <4F630E6D.4000307@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com> <4F63101D.70507@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com> <4F631449.7090302@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3DCC@SHSMSX102.ccr.corp.intel.com> <4F632C15.5070902@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3E02@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <09F19C497AD02E4EA4E14917772649B70FCD3E02@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 02:50 PM, Du, Alek wrote:
> For #1, as I said, we already held the tty refcount. The tty refcount cannot help this crash.

Where exactly? Do you have some local changes?
$ grep tty_port_tty_ drivers/tty/serial/mfd.c
$

> For #2, this patch will avoid memcpy to a NULL pointer and avoid a kernel crash.

Ok, could you explain how? Linearized code from moxa.c with your patch
applied follows:
ofs = baseAddr + DynPage_addr + bufhead + head;
size = (tail >= head) ? (tail - head) : (rx_mask + 1 - head);
size = min(size, count);
// call to tty_prepare_flip_string
	spin_lock_irqsave(&tty->buf.lock, flags);
	space = __tty_buffer_request_room(tty, size);

	tb = tty->buf.tail;
 	if (likely(space)) {
 		*chars = tb->char_buf_ptr + tb->used;
 		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
 		tb->used += space;
 	}
	spin_unlock_irqrestore(&tty->buf.lock, flags);
// return to MoxaPortReadData
memcpy_fromio(*chars, ofs, space); <- memcpy without buf.lock
head = (head + len) & rx_mask;
...

thanks,
-- 
js
suse labs
