Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734Ab1I2UpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:45:20 -0400
Received: from 1wt.eu ([62.212.114.60]:33282 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755239Ab1I2UpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:45:18 -0400
Date: Thu, 29 Sep 2011 22:45:05 +0200
From: Willy Tarreau <w@1wt.eu>
To: Con Kolivas <kernel@kolivas.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: BFS cpu scheduler and skip list implementation
Message-ID: <20110929204505.GA8810@1wt.eu>
References: <201109240945.58879.kernel@kolivas.org> <201109241214.21458.kernel@kolivas.org> <20110924073522.GV7761@one.firstfloor.org> <201109241838.06941.kernel@kolivas.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109241838.06941.kernel@kolivas.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Con,

On Sat, Sep 24, 2011 at 06:38:06PM +1000, Con Kolivas wrote:
> That's great then. I'm sure we'd explode in other weird and wonderful ways 
> before the CPU load ever got to 64k. Plus all that would happen is that it 
> would start degenerating from O(log n) insertion to O(n) as the number way 
> surpassed 64k. The number 16 for levels was simply chosen as the one 
> originally used by William Pugh in his sample code, but seems to be ample for 
> this application.

If you're interested, during the early CFS benchmarks a few years ago, I
reworked my old binary tree code to make it kernel-compatible. By this, I
mean that it never needs to allocate memory, it's used just like rbtrees
or kernel lists, by having a node in your structure and inserting it from
the root of a tree. It offers the following features :
  - O(log(N)) insertion/lookup
  - O(1) removal
  - O(1) next/prev walk
  - 20 bytes per node on 32-bit pointers, 36-bytes on 64-bit pointers, plus
    the key
  - supports unique or multiple occurrences of the same key (walked in
    insertion order and classed in trees)
  - supports 32/64 bit signed/unsigned integers, strings and memory blocks
  - supports prefixes (eg. to insert IP addresses with masks)
  - supports lookup of greater than or equal to, less than or equal to.

I replaced the rbtree that was used in haproxy's scheduler with this new
code and measured a noticeable performance improvement, since haproxy
does insert/next/remove a lot of times a second, and not having to balance
a tree saves a huge number of cycles.

I remember having conducted some tests on CFS a log time ago with it, but
the only cases where I observed a gain was when running insane amounts of
tasks at insane context switching rates, which was biased and irrealistic.
So I stopped trying to put it into the kernel at that time.

Maybe for your usage it might bring some value. Take a look at the code
here if you want, it's not too much documented but still enough to start
with it. There are a few examples that can help get it right. I know that
a few people use it for their own projects and they did not ask for help :-)

    http://git.1wt.eu/web?p=ebtree.git;a=summary

Cheers,
Willy

