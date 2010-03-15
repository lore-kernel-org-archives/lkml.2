Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936618Ab0COTne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 15:43:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:59217 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0COTnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 15:43:32 -0400
Date: Mon, 15 Mar 2010 20:43:33 +0100
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: f_mass_storage: dynamic buffers for better alignment
In-reply-to: <20100315192812.GE25452@gandalf>
To: me@felipebalbi.com
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>, gregkh@suse.de,
       linux-kernel@vger.kernel.org,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       Kyungmin Park <kyungmin.park@samsung.com>
Message-id: <op.u9mjqvz87p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1268647795-4095-1-git-send-email-m.nazarewicz@samsung.com>
 <20100315181020.GD3857@gandalf> <op.u9minutl7p4s8u@pikus>
 <20100315192812.GE25452@gandalf>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Mar 15, 2010 at 08:20:08PM +0100, Micha?? Nazarewicz wrote:
>> Each buffer is 4 pages and there are two such buffers in struct
>> fsg_common therefore the size of the structure is 9 pages.
>>
>> I've been simply concerned about using kamlloc() for such big
>> structures so in the end decided to split it into 3 allocations.
>>
>> Maybe I'm overeating though?  Or maybe vmalloc() would solve those
>> problems?  But then again, vmalloc() could degrade DMA performance
>> on systems w/o scatter-gather.

On Mon, 15 Mar 2010 20:28:13 +0100, Felipe Balbi <me@felipebalbi.com> wrote:
> I have no opinion anymore :-p
>
> I can only think about the devices I've been working on which would be a
> pain to allocate so much memory and would suffer if you use vmalloc()
> too, so both would be a no-no for me :-p

So here it is...  I think allocating buffers dynamically via kmalloc()
is the safest way. :)

>> 	bh = common->buffhds;
>> 	rc = -ENOMEM;
>> 	i = FSG_NUM_BUFFERS;
>> 	for(;;) {
>> 		bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
>> 		if (unlikely(!bh->buf))
>> 			goto error_release;
>> 		if (!--i)
>> 			break;
>> 		bh->next = bh + 1;
>> 		++bh;
>> 	}
>> 	bh->next = common->buffhds;

> how about ?
>
> for (i = FSG_NUM_BUFFER; i; i--, ++bh) {
> 	bh->buf = kmalloc(FSG_BUFLEN, GFP_KERNEL);
> 	if (!bh->buf)
> 		goto error_release;
> }

bh->next cyclic buffer needs to be initialised.  Otherwise I'd stick
with what you've posted.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
