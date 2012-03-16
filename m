Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422741Ab2CPMDj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 08:03:39 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33378 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422726Ab2CPMDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 08:03:37 -0400
Message-ID: <4F632C15.5070902@suse.cz>
Date: Fri, 16 Mar 2012 13:03:33 +0100
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
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com> <20120315100812.6cda2ef9@pyramind.ukuu.org.uk> <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com> <4F630B4D.3040508@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com> <4F630E6D.4000307@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com> <4F63101D.70507@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com> <4F631449.7090302@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3DCC@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <09F19C497AD02E4EA4E14917772649B70FCD3DCC@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 12:33 PM, Du, Alek wrote:
> Isn't this the nature of "flush" ? If the driver is trying to insert chars to tty buffer, while the app is going to flush the buffer, or shutdown the port, 
> that's quite nature that those data gone. Why should I care ?
> 
> Sorry, you missed the point of this patch.

No, you do not follow what I am writing.

1) Your driver is broken.
2) Your patch does not solve the problem universally.

ad 1) Use tty refcounting and you won't need to care about buf.tail
being NULL due to shutdown. As an added value, you will fix the other
races too.

ad 2) With your patch, drivers which use tty_prepare_flip_string are
given a tty buffer (chars parameter) which may be *freed* (not flushed,
_freed_) at any time by ioctl flush after the function returns. I.e. the
relocking is hopeless in that case. It only helps drivers which use
tty_insert_flip_string*.

I don't know right now what could be a real cure for point 2). Maybe
RCU. Maybe leaving the lock locked in tty_prepare_flip_string and
introducing tty_finish_flip_string containing an unlock. To be called
right after memcpy_fromio or alike in the drivers.

Or maybe even removing that interface completely...

thanks,
-- 
js
suse labs
