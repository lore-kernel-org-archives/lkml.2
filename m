Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1CWIoh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 04:44:37 -0400
Received: from ja.ssi.bg ([178.16.129.10]:50608 "EHLO ja.ssi.bg"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S932163Ab1CWIof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 04:44:35 -0400
Date: Wed, 23 Mar 2011 10:49:53 +0200 (EET)
From: Julian Anastasov <ja@ssi.bg>
To: Jiri Slaby <jslaby@suse.cz>
cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH] tty: fix tty->ldisc leak on ENODEV from driver install
In-Reply-To: <4D89AB83.3000103@suse.cz>
Message-ID: <alpine.LFD.2.00.1103231040550.1463@ja.ssi.bg>
References: <201103230045.p2N0jQjL011728@ja.ssi.bg> <4D89AB83.3000103@suse.cz>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 	Hello,

On Wed, 23 Mar 2011, Jiri Slaby wrote:

>> --- linux-2.6.38/drivers/tty/tty_io.c
>> +++ linux-2.6.38/drivers/tty/tty_io.c
>> @@ -188,6 +188,7 @@ void free_tty_struct(struct tty_struct *
>>  		put_device(tty->dev);
>>  	kfree(tty->write_buf);
>>  	tty_buffer_free_all(tty);
>> +	kfree(tty->ldisc);
>
> We should not mess up with ldisc here. We should call something like
> tty_ldisc_deinit from tty_init_dev on fail path. The deinit should drop
> the reference (call put_ldisc). Or maybe even deinitialize_tty_struct ->
> tty_ldisc_deinit -> put_ldisc).
>
> Note that your way you do not drop the module refcount of ld ops.

 	Right, that is what I found before going to sleep.
>From the visible functions I see that currently only
tty_ldisc_deref does exactly what we need. But I suspect
it should be used for other purposes. I assume the authors
have a better idea what to do here. Let me know if I need
to test a better patch.

>>  	kfree(tty);
>>  }
>
> regards,
> -- 
> js
> suse labs

Regards

--
Julian Anastasov <ja@ssi.bg>
