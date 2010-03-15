Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965767Ab0COTUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:20:15 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:58400 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965730Ab0COTUH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:20:07 -0400
Date: Mon, 15 Mar 2010 20:20:08 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: f_mass_storage: dynamic buffers for better alignment
In-reply-to: <20100315181020.GD3857@gandalf>
To: me@felipebalbi.com
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.u9minutl7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1268647795-4095-1-git-send-email-m.nazarewicz@samsung.com>
 <20100315181020.GD3857@gandalf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 15, 2010 at 11:09:55AM +0100, Michal Nazarewicz wrote:
>> "Static" buffers in fsg_buffhd structure (ie. fields which are arrays
>> rather then pointers to dynamically allocated memory) are not aligned
>> to any "big" power of two which may lead to poor DMA performance

On Mon, 15 Mar 2010 19:10:21 +0100, Felipe Balbi <me@felipebalbi.com> wrote:
> not so true as you can add __attribute__ ((aligned(32))) to those.

I admit, I haven't thought about that.  Some fields rearrangement
could help avoid some padding but yes, it can be done.

However, there is one more thing I've had in mind.  Each buffer
is 4 pages (16 KiB) and there are two such buffers in struct
fsg_common therefore the whole size of the structure is
9 pages (> 32 KiB).

I've been simply concerned about using kamlloc() for such big
structures so in the end decided to split it into 3 allocations.

Maybe I'm overeating though?  Or maybe vmalloc() would solve those
problems?  But then again, vmalloc() could degrade DMA performance
on systems w/o scatter-gather.

What do you think?

>>  	bh = common->buffhds;
>> -	i = FSG_NUM_BUFFERS - 1;
>> -	do {
>> +	i = FSG_NUM_BUFFERS;
>> +	for (i = FSG_NUM_BUFFERS;; ++bh) {

> something like
>
> for (i = 0; i < FSG_NUM_BUFFERS; i++, ++bh) {
>
> wouldn't it do it ??

I admit I'm a bit addicted to "downwards to zero" loops and avoiding
checking of the condition prior to the first iteration.  (As such I
often use do-while where others would use for.)

Besides counting to zero is not really an issue here.  I didn't
particularly fancy the "bh[-1]" that have to be used if the break
is not inside the loop, ie:

	bh = common->buffhds;
	rc = -ENOMEM;
	for (i = FSG_NUM_BUFFERS; i--; ++bh) {
		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
		if (unlikely(!bh->buf))
			goto error_release;
		bh->next = bh + 1;
	}
	bh[-1].next = common->buffhds;

Note also that the last bh->next is assigned twice.

So personally I'd still stick with my version but since
readability is important how about:

	bh = common->buffhds;
	rc = -ENOMEM;
	i = FSG_NUM_BUFFERS;
	for(;;) {
		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
		if (unlikely(!bh->buf))
			goto error_release;
		if (!--i)
			break;
		bh->next = bh + 1;
		++bh;
	}
	bh->next = common->buffhds;

What do you think?

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
