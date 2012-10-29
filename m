Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932908Ab2J2S7o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:59:44 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50316 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab2J2S7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:59:39 -0400
Date: Mon, 29 Oct 2012 21:57:08 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] zram: factor-out zram_decompress_page() function (v2)
Message-ID: <20121029185708.GA2336@swordfish>
References: <20121027160052.GA4771@swordfish>
 <508EB96C.4040505@vflare.org>
 <20121029180558.GE3706@swordfish.minsk.epam.com>
 <CAPkvG_eZObsD=uCRGNygsrTs=ymjoA09XkoHD9KUUq_YWyuA3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPkvG_eZObsD=uCRGNygsrTs=ymjoA09XkoHD9KUUq_YWyuA3A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (10/29/12 11:32), Nitin Gupta wrote:
> 
> Nothing should be printed (even a debug only message) for
> the ZRAM_ZERO case. This case can be quite common for certain
> kinds of data and would cause a huge log spew.  Also (!handle) case
> is not the same as zero-filled page case, so this message would
> be misleading.
> 
> So, we should either get rid of this warning entirely or only do
> pr_debug("Read before write ....") for (!handle) case and log nothing
> for ZRAM_ZERO case.
> 

I'd rather remove this message. Will resend.



By the way, about use after-free. I'm afraid you fix is not covering 100% of the
cases.

The problem is with this case:
[..]
334 
335         if (unlikely(clen > max_zpage_size)) {
336                 zram_stat_inc(&zram->stats.bad_compress);
337                 src = uncmem;
338                 clen = PAGE_SIZE;
339         }
340 
[..]

where uncmem could be:
-- kmap'ed page
-- kmalloc'ed page

both of which were unmap'ed/kfree'd before. you moved kfree to the end of the function,
while kunmap_atomic(user_mem) is still happening before src = uncmem/memcpy(cmem, src, clen)
pair.


	-ss
