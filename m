Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab2AWTY0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 14:24:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58580 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab2AWTYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 14:24:24 -0500
Date: Mon, 23 Jan 2012 11:23:59 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Sagar Borikar <sagar.borikar@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: mmap locked doesn't return
In-Reply-To: <CAFwMWxs7S+6VqA00NFVKum=QHU2266Mj2kXcoHzRfyXU8+dv7A@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1201231110540.1677@eggly.anvils>
References: <CAFwMWxs7S+6VqA00NFVKum=QHU2266Mj2kXcoHzRfyXU8+dv7A@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jan 2012, Sagar Borikar wrote:
> 
> We are observing that mmap when called with MAP_SHARED and MAP_LOCKED
> flags on the disk which has the bad sectors, doesn't return either
> success or failure and gets stuck somewhere in mmap routine. Disk
> replacement is the obvious solution but the question is what makes
> mmap not to return failure?
> Individual mapping works fine i.e. on the same disk at same offset
> when mmap is invoked with MAP_SHARED or MAP_LOCKED the call succeeds
> but when they both are clubbed together, it doesn't return anything.
> 
> strace output snippet
> 
> open("/dev/dm-4p2", O_RDWR)             = 3
> mmap(NULL, 10485760, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_LOCKED, 3, 0x4000000
> 
> 
> setup:
> 
> 2.6.23 LST kernel
> Westmere platform - 4 socket cpu
> RAM -192GB

2.6.23 is a four-year-old kernel.  There have been a lot of changes
since then, in mlocking and all over.  Here I suspect a change
in filemap_fault() may be relevant.  At the time of 2.6.23, its
page_not_uptodate IO error handling expected an IO error to be
reported by readpage() (which only initiates the read), and looks
in danger of retrying indefinitely.   Whereas in the current tree
I see a wait_on_page_locked() followed by EIO if !PageUptodate there.
My guess is a move to a more recent kernel would solve your problem.

Hugh
