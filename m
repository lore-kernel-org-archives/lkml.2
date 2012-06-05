Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2FEXfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 19:35:36 -0400
Received: from hosting.visp.net.lb ([194.146.153.11]:34125 "EHLO
	hosting.visp.net.lb" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753806Ab2FEXff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 19:35:35 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 06 Jun 2012 02:35:31 +0300
From: Denys Fedoryshchenko <denys@visp.net.lb>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: BUG: =?UTF-8?Q?tty=5Finsert=5Fflip=5Fstring=5Ffixed=5Fflag=2C?=
 =?UTF-8?Q?=20unable=20to=20handle=20kernel=20NULL=20pointer=20dereference?=
 =?UTF-8?Q?=20at=20=30=30=30=30=30=30=30=34?=
In-Reply-To: <20120606002725.5fc9ffe9@pyramind.ukuu.org.uk>
References: <43517e56ecce834d141078f1918eba15@visp.net.lb>
 <20120606002725.5fc9ffe9@pyramind.ukuu.org.uk>
Message-ID: <4e01636b65b2348fda3ef06b544a5201@visp.net.lb>
User-Agent: VISP Webmail/0.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-06-06 02:27, Alan Cox wrote:
>> [ 5350.556089]  [<c027adc4>] pty_write+0x2c/0x4c
>> [ 5350.556089]  [<c0277a44>] n_tty_write+0x24e/0x2d6
>> [ 5350.556089]  [<c0144a2b>] ? try_to_wake_up+0x18c/0x18c
>
> Basically the other end hung up just as it went to write.
>
> It's a known race. In the current codebase it's very hard to fix up 
> nicely
> as we have to drop tty_lock during a pty close or we deadlock. It's 
> very
> hard to hit but your environment sounds rather like my test case for 
> it !
>
> It's one of a series of related bugs (another in n_gsm) that we can't 
> fix
> elegantly until the tty locking is fixed - which has been pushed from 
> 3.5
> hopefully to 3.6 assuming we can fix a couple of other locking 
> problems
> first.
>
> What may reduce it a lot is to change pty_write to do
>
>
> 	struct tty_struct *to = tty->link;
>
> 	if (tty->stopped)
> 		return 0;
>
> 	if (to == NULL)
> 		return -ENODEV;
> 	to = tty_kref_get(to);
> 	if (tty->link == NULL) {
> 		tty_kref_put(to);
> 		return -ENODEV;
> 	}
> 	if (c > 0) {
> 		...
> 	}
> 	tty_kref_put(to);
> 	return c;
> }
>
> Thats a pretty ugly bandaid but I'd be interested to know if it 
> helps, as
> that would verify the race you are hitting is the one I think it is.
Thank you a lot, i will try apply this.
This crash are only few times per week, but i will try to see, if it 
will help or change anything.

>
> Alan


---
Denys Fedoryshchenko, Network Engineer, Virtual ISP S.A.L.
