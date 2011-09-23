Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab1IWWDu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 18:03:50 -0400
Received: from exprod7og105.obsmtp.com ([64.18.2.163]:33273 "EHLO
	exprod7og105.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1IWWDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 18:03:49 -0400
Message-ID: <4E7D0218.7020502@genband.com>
Date: Fri, 23 Sep 2011 16:03:04 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Ricardo Nabinger Sanchez <rnsanchez@taghos.com.br>
CC: linux-kernel@vger.kernel.org
Subject: Re: write() on pipe blocking due to in-page fragmentation?
References: <20110923164226.211a76dc@darkmoor.lan.box>
In-Reply-To: <20110923164226.211a76dc@darkmoor.lan.box>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Sep 2011 22:03:06.0469 (UTC) FILETIME=[92B25950:01CC7A3C]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-18404.002
X-TM-AS-Result: No--11.545700-5.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2011 01:42 PM, Ricardo Nabinger Sanchez wrote:
> Hello,
>
> The simple program attached allocates a pipe, perform a number of
> writes in it in order to fill the pipe, and then reads that data to
> empty the pipe.  The argument is used to determine how much data to
> write per write iteration.
>
> Values that are power of 2 up to PIPE_BUF work without any issues.
> Other values may cause the write() call to block.

> Intuitively, it seems that pages in the pipe are getting fragmented,
> and eventually it will reach the limit of 16 pages and, if the data is
> not consumed, will cause writers to block --- even though the data
> would fit nicely otherwise.

I suggest reading "man 7 pipe" carefully, looking at the pipe capacity 
and pipe_buf sections.

I suspect that what you're seeing is that due to the atomicity 
requirements the kernel will not spread a single write over multiple 
pages, so that when writing 3 bytes at a time each page in the queue has 
a byte of free space.

Thus, you succeed in writing up to byte 65520 (out of 65536) but 
anything after that blocks.  Note that 65536-65520=16.

>
> Is this understanding correct?  If so, is it something that should be
> fixed in the Linux kernel?
>
> Or should the application ensure that data written to the pipe will be
> done carefully as to not block a writer?

 From the man page:

"Applications should not rely on a particular capacity: an application 
should be designed so that a reading process consumes data as soon as it 
is available, so that a writing process does not remain blocked."

Chris


-- 
Chris Friesen
Software Developer
GENBAND
chris.friesen@genband.com
www.genband.com
