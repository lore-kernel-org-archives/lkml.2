Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1DLWuO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 18:50:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42598 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754870Ab1DLWuL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 18:50:11 -0400
Date: Tue, 12 Apr 2011 15:49:06 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Changli Gao <xiaosuo@gmail.com>,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Jiri Slaby <jslaby@suse.cz>, azurIt <azurit@pobox.sk>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Regression from 2.6.36
Message-Id: <20110412154906.70829d60.akpm@linux-foundation.org>
In-Reply-To: <1302190586.3357.45.camel@edumazet-laptop>
References: <20110315132527.130FB80018F1@mail1005.cent>
	<20110317001519.GB18911@kroah.com>
	<20110407120112.E08DCA03@pobox.sk>
	<4D9D8FAA.9080405@suse.cz>
	<BANLkTinnTnjZvQ9S1AmudZcZBokMy8-93w@mail.gmail.com>
	<1302177428.3357.25.camel@edumazet-laptop>
	<1302178426.3357.34.camel@edumazet-laptop>
	<BANLkTikxWy-Pw1PrcAJMHs2R7JKksyQzMQ@mail.gmail.com>
	<1302190586.3357.45.camel@edumazet-laptop>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Apr 2011 17:36:26 +0200
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> Le jeudi 07 avril 2011 __ 23:27 +0800, Changli Gao a __crit :
> 
> > azurlt, would you please test the patch attached? Thanks.
> > 
> 
> Yes of course, I meant to reverse the patch
> 
> (use kmalloc() under PAGE_SIZE, vmalloc() for 'big' allocs)
> 
> 
> Dont fallback to vmalloc if kmalloc() fails.
> 
> 
> if (size <= PAGE_SIZE)
> 	return kmalloc(size, GFP_KERNEL);
> else
> 	return vmalloc(size);
> 

It's somewhat unclear (to me) what caused this regression.

Is it because the kernel is now doing large kmalloc()s for the fdtable,
and this makes the page allocator go nuts trying to satisfy high-order
page allocation requests?

Is it because the kernel now will usually free the fdtable
synchronously within the rcu callback, rather than deferring this to a
workqueue?

The latter seems unlikely, so I'm thinking this was a case of
high-order-allocations-considered-harmful?

