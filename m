Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422716Ab2CPLdd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 07:33:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:54548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215Ab2CPLdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 07:33:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="119749257"
From: "Du, Alek" <alek.du@intel.com>
To: Jiri Slaby <jslaby@suse.cz>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Tu, Xiaobing" <xiaobing.tu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>,
        "Zuo, Jiao" <jiao.zuo@intel.com>
Subject: RE: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Topic: [PATCH] tty: hold lock across tty buffer finding and buffer
 filling
Thread-Index: Ac0CUERRacLD33MLTtaeiAHOWyOq2AAADUEAABDKXdAAIKULgAAQyYZQ//99bYD//3mIQIAAiHuA//95JNCAAIvVgP//ZyLg
Date: Fri, 16 Mar 2012 11:33:28 +0000
Message-ID: <09F19C497AD02E4EA4E14917772649B70FCD3DCC@SHSMSX102.ccr.corp.intel.com>
References: <EE928378561BF1449699C96571234A740FCC580F@SHSMSX102.ccr.corp.intel.com>
 <20120315100812.6cda2ef9@pyramind.ukuu.org.uk>
 <09F19C497AD02E4EA4E14917772649B70FCD36C2@SHSMSX102.ccr.corp.intel.com>
 <4F630B4D.3040508@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3D3F@SHSMSX102.ccr.corp.intel.com>
 <4F630E6D.4000307@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3D59@SHSMSX102.ccr.corp.intel.com>
 <4F63101D.70507@suse.cz>
 <09F19C497AD02E4EA4E14917772649B70FCD3D6B@SHSMSX102.ccr.corp.intel.com>
 <4F631449.7090302@suse.cz>
In-Reply-To: <4F631449.7090302@suse.cz>
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

Isn't this the nature of "flush" ? If the driver is trying to insert chars to tty buffer, while the app is going to flush the buffer, or shutdown the port, 
that's quite nature that those data gone. Why should I care ?

Sorry, you missed the point of this patch.

Thanks,
Alek
-----Original Message-----
From: Jiri Slaby [mailto:jirislaby@gmail.com] On Behalf Of Jiri Slaby
Sent: Friday, March 16, 2012 6:22 PM
To: Du, Alek
Cc: Jiri Slaby; Alan Cox; Tu, Xiaobing; linux-kernel@vger.kernel.org; gregkh@linuxfoundation.org; Zhang, Yanmin; Zuo, Jiao
Subject: Re: [PATCH] tty: hold lock across tty buffer finding and buffer filling

On 03/16/2012 11:08 AM, Du, Alek wrote:
> If you really look at the original patch from Xiaobing, the 
> tty_prepare_flip_string is also patched :-) Actually it fills up all 
> the possible spin_lock gaps in tty_buffer.c
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
This is returned to the caller. And it writes to that. And it may be gone as soon as the lock is unlocked below.

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
