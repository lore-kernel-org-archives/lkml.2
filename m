Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161276Ab2CPJ5H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 05:57:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53224 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760969Ab2CPJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 05:57:04 -0400
Message-ID: <4F630E6D.4000307@suse.cz>
Date: Fri, 16 Mar 2012 10:57:01 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120307 Thunderbird/11.0
MIME-Version: 1.0
To: "Du, Alek" <alek.du@intel.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com> <20120315100812.6cda2ef9@pyramind.ukuu.org.uk> <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com> <4F630B4D.3040508@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 10:49 AM, Du, Alek wrote:
> The tty structure is protect and not null, the tty->buf.tail is null. Many people think the tty reference count isn't protected and cause this bug, it is not true. :-)

You protect the pointer, not what is inside that structure. If you
increment a tty reference count, tty->buf.tail won't be NULL iff tty is
not NULL. IOW, you have to use tty_port_tty_set/get all around.

> For the flush case, it need acquire the spinlock to free the buffer and put buf.tail to NULL. So this patch will help:
> 
> Here is the example place, you can see the __tty_buffer_flush is inside the spinlock.

I'm not talking about flush. I'm talking about prepare. It returns a
pointer to a tty buffer which may be concurrently freed by flush.

     A                                   B
================================================
prepare(&chars);
                                        flush();
memcpy(chars, data_from_HW); <- chars is freed now
flip();

thanks,
-- 
js
suse labs
