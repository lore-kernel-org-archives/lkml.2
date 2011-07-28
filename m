Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754731Ab1G1BOZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 21:14:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40715 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752863Ab1G1BOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 21:14:19 -0400
Date: Wed, 27 Jul 2011 18:15:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Shaohua Li <shaohua.li@intel.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Minchan Kim <minchan.kim@gmail.com>,
        "mgorman@suse.de" <mgorman@suse.de>, linux-mm <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]vmscan: add block plug for page reclaim
Message-Id: <20110727181527.c4f6d806.akpm@linux-foundation.org>
In-Reply-To: <1311815060.15392.375.camel@sli10-conroe>
References: <1311130413.15392.326.camel@sli10-conroe>
	<CAEwNFnDj30Bipuxrfe9upD-OyuL4v21tLs0ayUKYUfye5TcGyA@mail.gmail.com>
	<1311142253.15392.361.camel@sli10-conroe>
	<CAEwNFnD3iCMBpZK95Ks+Z7DYbrzbZbSTLf3t6WXDQdeHrE6bLQ@mail.gmail.com>
	<1311144559.15392.366.camel@sli10-conroe>
	<4E287EC0.4030208@fusionio.com>
	<1311311695.15392.369.camel@sli10-conroe>
	<4E2B17A6.6080602@fusionio.com>
	<20110727164523.c2b1d569.akpm@linux-foundation.org>
	<1311815060.15392.375.camel@sli10-conroe>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011 09:04:20 +0800 Shaohua Li <shaohua.li@intel.com> wrote:

> > Using an additional 44 bytes of stack on that path is also
> > significant(ly bad).  But we need to fix that problem anyway.  One way
> > we could improve things in mm/vmscan.c is to move the blk_plug into
> > scan_control then get the scan_control off the stack in some manner. 
> > That's easy for kswapd: allocate one scan_control per kswapd at
> > startup.  Doing it for direct-reclaim would be a bit trickier...
> unfortunately, the direct-reclaim case is what cares about stack.
> 
> BTW, the scan_control can be dieted. may_unmap/may_swap/may_writepage
> can be a bit. swappiness < 100, so can be a char. order <= 11, can be a
> char. should I do it to cut the size?

All five will fit in a 32-bit word, at some expense in code size.

But I think first it would be better to work on a way of getting it all
off the stack, along with the blk_plug.

Could be done with a per-cpu array and CPU pinning, but CPU pinning is
a bit expensive nowadays.  Could put a scan_control* into the
tack_struct, but that's dopey.


