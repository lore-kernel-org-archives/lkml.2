Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab0GaBd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 21:33:58 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:34536 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751303Ab0GaBd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 21:33:57 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <4C537A01.5040808@tuxonice.net>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
	 <1280532174.2583.1.camel@shrek.rexursive.com>
	 <4C5362E7.3000706@tuxonice.net>
	 <1280538184.2583.11.camel@shrek.rexursive.com>
	 <4C537A01.5040808@tuxonice.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Jul 2010 11:33:55 +1000
Message-ID: <1280540035.2658.5.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-07-31 at 11:18 +1000, Nigel Cunningham wrote:
> It should be possible to do the allocation at that point. I might see
> if I can take a look later on. 

Maybe it's related to the fact that with vmalloc() you get a different
thing then with __get_free_pages() in terms of using it with devices.

If found this in Linux Device Drivers:
---------------
Addresses allocated by vmalloc can't be used outside of the
microprocessor, because they make sense only on top of the processor's
MMU. When a driver needs a real physical address (such as a DMA address,
used by peripheral hardware to drive the system's bus), you can't easily
use vmalloc. The right time to call vmalloc is when you are allocating
memory for a large sequential buffer that exists only in software.
---------------

I'm guessing the page allocated by vmalloc() eventually gets passed down
the I/O chain and is supposed to be read into by some hardware, which
then causes a crash. (He, he... kernel according to Bojan - please
ignore :-).

In the first iteration of the patch, I allocated just one page using
__get_free_page() and used that for I/O operations. The only overhead
there was memcpy() from the page to vmalloc()-ed cmp. I can go back to
that easily. It didn't actually make any significant difference to
performance.

-- 
Bojan

