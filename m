Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab0DUWYt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 18:24:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42291 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754602Ab0DUWYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 18:24:47 -0400
Date: Wed, 21 Apr 2010 15:24:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anders Larsen <al@alarsen.net>
Cc: Iwo Mergler <iwo@call-direct.com.au>, linux-mtd@lists.infradead.org,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       Ian McDonnell <ian@brightstareng.com>, Nicolas Pitre <nico@fluxnic.net>,
       linux-kernel@vger.kernel.org, Matthias Kaehlcke <matthias@kaehlcke.net>,
       David Woodhouse <dwmw2@infradead.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: Re: [PATCH] Fix Oops with Atmel SPI
Message-Id: <20100421152410.0fea5e12.akpm@linux-foundation.org>
In-Reply-To: <1271231840l.5270l.0l@i-dmzi_al.realan.de>
References: <4BC56F21.6040909@call-direct.com.au>
	<1271231840l.5270l.0l@i-dmzi_al.realan.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 09:57:20 +0200
Anders Larsen <al@alarsen.net> wrote:

> On 2010-04-14 09:30:41, Iwo Mergler wrote:
> > I wouldn't recommend that. MTD erase blocks are 64K or more. In a typical
> > embedded system you will not be able to kmalloc that much memory after
> > a few day's of operation - the page pool gets fragmented.
> 
> the original problem occurs with SPI flashes, which typically have a much
> smaller erase block size (and it only occurs when they are driven by an Atmel
> SoC SPI controller, hence the #ifdefs)
> 
> > A possibly better approach is to arrange for that memory to get allocated
> > at driver start time.
> 
> The buffer in question is indeed allocated _once_ (at the first write
> operation to the device) and only deallocated when the device is unmounted,
> so allocating it at driver load time wouldn't make much difference IMHO.
> 
> I realize that my patch also affects e.g. parallel NOR flash on the system,
> but unless an MTD device is unmounted/remounted over and over again, I don't
> see a problem.

Attempting the allocation at mtdblock_writesect()-time is the least
reliable approach.

It would be much more reliable to perform the allocation at boot-time
or modprobe-time.

It would be 100% reliable to perform the allocation at compile time
too!  If that's possible.  A statically allocated buffer with
appropriate locking around it to prevent it from getting scribbled on. 
Of course, this assumes that the buffer is shared between different
devices and it won't work at all if cache_data is really a "cache".

Ho-hum.  Anyway, please do try to find a way to make this allocation
more reliable.  It'd be pretty bad to have an embedded device go crump
when the user tries to save his data.

Also, the mdtblock code has changed a lot in this very area in the
linux-next tree (mtdblks[] has gone away).  So please redo any patch
against linux-next.


Finally..  Wouldn't it be better to just fix the atmel SPI driver so
that it doesn't barf when handed vmalloc'ed memory?  Who do we ridicule
about that?  <checks, adds cc>


