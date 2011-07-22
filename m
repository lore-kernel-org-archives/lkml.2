Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752172Ab1GVGdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 02:33:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977Ab1GVGdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 02:33:49 -0400
Date: Fri, 22 Jul 2011 16:33:35 +1000
From: NeilBrown <neilb@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: Matt Mackall <mpm@selenic.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Nanosecond fs timestamp support: sad
Message-ID: <20110722163335.2df4f6ca@notabene.brown>
In-Reply-To: <m2pql2c0qz.fsf@firstfloor.org>
References: <1311271641.14555.114.camel@calx>
	<m2pql2c0qz.fsf@firstfloor.org>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 23:01:24 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> Matt Mackall <mpm@selenic.com> writes:
> 
> 
> > This means I can touch a file something like 70k times per second and
> > get only 300 distinct timestamps on my laptop. And only 100 distinct
> > timestamps on a typical distro server kernel.
> 
> You should use the inode generation number if you really want
> to see every update.

I assume you mean i_version which gets incremented (under a spinlock) if the
filesystem asks for it.

This doesn't let you compare the ages of two files.  I wonder if that is
important.  Is it important to you Matt?


> 
> > Meanwhile, I can call gettimeofday 35M times per second and get ~1M
> > distinct responses.
> 
> They key word here is "I".
> 
> > Given that we can do gettimeofday three orders of magnitude faster than
> > we can do file transactions and it has four orders of magnitude better
> > resolution, shouldn't we be using it for filesystem time when
> > sb->s_time_gran is less than 1/HZ?
> 
> Some systems have a quite slow gettimeofday()
> That was the primary motivation for using jiffies. 
> 
> Also adding more granuality makes it more expensive,
> because there's additional work every time it changes.
> Even jiffies already caused regressions.
> 
> -Andi

I imagine a scheme where 'stat' would set a flag if it wasn't set, and
file_update_time would:
  - if the flag is set, use gettimeofday and clear the flag
  - if the flag is not set, use jiffies

so if you are looking, you will see i_mtime changing precisely but if not,
you don't pay the price.
This wouldn't allow precise ordering of distinct files either of course.

NeilBrown
