Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761127Ab2CPKWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 06:22:08 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39925 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032712Ab2CPKWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 06:22:06 -0400
Message-ID: <4F631449.7090302@suse.cz>
Date: Fri, 16 Mar 2012 11:22:01 +0100
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
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com> <20120315100812.6cda2ef9@pyramind.ukuu.org.uk> <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com> <4F630B4D.3040508@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com> <4F630E6D.4000307@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com> <4F63101D.70507@suse.cz> <09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com>
In-Reply-To: <09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2012 11:08 AM, Du, Alek wrote:
> If you really look at the original patch from Xiaobing, the tty_prepare_flip_string is also patched :-)
> Actually it fills up all the possible spin_lock gaps in tty_buffer.c
> 
> 
> @@ -344,13 +375,20 @@ EXPORT_SYMBOL(tty_schedule_flip);  int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars,
>  								size_t size)
>  {
> -	int space = tty_buffer_request_room(tty, size);
> +	int space;
> +	unsigned long flags;
> +	struct tty_buffer *tb;
> +	
> +	spin_lock_irqsave(&tty->buf.lock, flags);
> +	space = __tty_buffer_request_room(tty, size);
> +
> +	tb = tty->buf.tail;
>  	if (likely(space)) {
> -		struct tty_buffer *tb = tty->buf.tail;
>  		*chars = tb->char_buf_ptr + tb->used;
                ^^^^^^
This is returned to the caller. And it writes to that. And it may be
gone as soon as the lock is unlocked below.

>  		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
>  		tb->used += space;
>  	}
> +	spin_unlock_irqrestore(&tty->buf.lock, flags);
>  	return space;
>  }

thanks,
-- 
js
suse labs
