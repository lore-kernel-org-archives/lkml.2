Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2KWAPk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 19:15:40 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:30279 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751964Ab2KWAPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 19:15:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsgIAA6/rlB5LKAf/2dsb2JhbABEhT22MoV5F3OCHgEBBAEnExwcBwULCAMYLhQlAyETGYduBb9gFIwjHAWEIAOWAJBDgwOBTA
Date: Fri, 23 Nov 2012 11:15:35 +1100
From: Dave Chinner <david@fromorbit.com>
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm: trace filemap add and del
Message-ID: <20121123001535.GZ2591@dastard>
References: <1352404450-30100-1-git-send-email-robert.jarzmik@free.fr>
 <20121120155735.905bbf9e.akpm@linux-foundation.org>
 <20121121035924.GO2591@dastard>
 <87vccx500r.fsf@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vccx500r.fsf@free.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 12:51:00PM +0100, Robert Jarzmik wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> > We actually have an informal convention for formating filesystem
> > trace events, and that is to use the device number....
> >
> >> 
> >> > +	),
> >> > +
> >> > +	TP_printk("page=%p pfn=%lu blk=%d:%d inode+ofs=%lu+%lu",
> >
> > ... and to prefix messages like:
> >
> > 	TP_printk("dev %d:%d ino 0x%llx ....
> > 		  MAJOR(__entry->dev), MINOR(__entry->dev),
> >
> > i.e. the start of the event message has all the identifying
> > information where it is easy to grep for and get all the events for
> > a specific dev/inode combination without even having to think about
> > it.
> 
> I cross-checked your proposition.
> The "ino 0x%llx" looks wrong to me, because :
>  - i_ino is "unsigned long", not "(unsigned) long long"

I just copied it from the XFS code, where the inode number is always
64 bits, even on 32 bit platforms.

>  - triggers a printk where "ino" looks really awfull (on a 32bits LE arm)
> >  mm_filemap_add_to_page_cache: dev 0:2 ino 0xc05186e000000000 page=000a0737
> >  pfn=0 ofs=3283861504

Then use the correct format specifier for a long. i.e. 0x%lx....

>  - why print the inode number in hexadecimal format ???

Because they are fair easier to parse and correlate by eye than
large decimal numbers.  Hexadecimal is frequently used because
boundaries in kernel and filesystem code typically fall on
powers-of-2 rather than powers-of-ten and hexadecimal makes it simple
to see those power-of-2 boundaries. Decimal tends to obfuscate
those boundaries, especially for large numbers....

e.g. with XFS inode numbers I can convert the inode number in
hex directly to it's location on disk in my head. e.g. decimal inode
numbers 137438980146 and 206158719668 don't look to have any real
meaning - they just look like large numbers. Convert them to hex and
you get 0x2000006802 and 0x3000046a14 repsectively.

For me, pattern recognition kicks in immediately and tells me that
the first inode is inode #2 at block offset 0x6800 in AG 32, and the
second is inode #20 at block 0x46a00 in AG 48, and I can immediately
correlate that to the filesystem geometry and storage layout and
know physically how far apart those inodes are.

IOWs, the inode numbers in hex are way more meaningful than in
decimal, and when I'm looking for needles in a haystack of
multi-gigabyte event traces (that's something I do every day), not
having to think about the relationship between two inodes is
extremely important....

>    Doing a "ls -i" returns decimal format, "debugfs" returns decimal. What is
>    the rational behind hexadecimal ?
> 
> I'd rather have : "dev %d:%d ino %lu page=0x%p pfn=%lu ofs=%lu".

Tracing is for debugging, therefore the format should be determined
by what makes life easier for those that are using the event traces
every day for debugging. Hence for anything that has defined power
of 2 boundaries like inode numbers, file offsets in the page cache,
etc, hexadecimal is much more meaningful to a programmer for
debugging purposes....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
