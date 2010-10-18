Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932793Ab0JRPpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:45:46 -0400
Received: from smarthost01.mail.zen.net.uk ([212.23.3.140]:52859 "EHLO
	smarthost01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932167Ab0JRPpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:45:45 -0400
Message-ID: <4CBC6BA0.60507@cyconix.com>
Date: Mon, 18 Oct 2010 16:45:36 +0100
From: Tom Brown <sa212+emis@cyconix.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        Yong Zhang <yong.zhang@windriver.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: Question: how to copy to user space from a tasklet
References: <4CB6DEC4.4040408@cyconix.com> <4CB7ED67.2000407@s5r6.in-berlin.de>
In-Reply-To: <4CB7ED67.2000407@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-Smarthost01-IP: [82.70.243.134]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/10/2010 06:57, Stefan Richter wrote:

> One way would be to use mmap() to allocate the DMA buffer and insert it into
> the user address space before DMA commences.  An additional poll/read/write
> based protocol or so can be used for buffer management during DMA.

Thanks, think I'm there:

1 - The user calls mmap() with a specific offset to flag that he wants a 
DMA buffer

2 - I then 'vmalloc' the buffer, and call 'setPageReserved' for each page

I then step over each page, and:

3 - call 'vmalloc_to_pfn' to get a PFN for each page, and then

4 - call 'remap_page_range' for that page (I instead call 
'remap_pfn_range' for kernels >= 2.6.10, but I'm on 2.6.9)

This gives me the buffer, and the interrupt handler then just uses 
'memcpy' to copy data to the user.

I've got to say, this was incredibly hard work. I can't find any useful 
documentation and it can take a couple of hours on Google to write a few 
lines of code. LDD is next to useless. There's no 'vmalloc_to_pfn' on 
2.6.9, so I copied an old deprecated one from 2.6.10 (which was also in 
a kernel prior to 2.6.9, I think). I'm not yet convinced that all this 
is working; I think I've seen one instance when the 'memcpy' to the 
buffer didn't work, so I think there might potentially be a problem with 
setting the reserved bit (and isn't the reserved bit deprecated in 
2.6.15??)

On the other stuff, thanks Yong for the 'probe_kernel_' suggestion, but 
I can't find any documentation on it.

linux-newbie only had one thread on it for the entire month when I 
checked a couple of days ago, apart from a couple of 419 scams.

Thanks -

Tom
