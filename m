Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1IPR1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 13:27:37 -0400
Received: from mail.anarazel.de ([217.115.131.40]:37012 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751857Ab1IPR1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 13:27:36 -0400
From: Andres Freund <andres@anarazel.de>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Improve lseek scalability v3
Date: Fri, 16 Sep 2011 19:27:33 +0200
User-Agent: KMail/1.13.7 (Linux/3.0.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        robertmhaas@gmail.com, pgsql-hackers@postgresql.org
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <201109161616.50004.andres@anarazel.de> <20110916153620.GA9913@parisc-linux.org>
In-Reply-To: <20110916153620.GA9913@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109161927.34472.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Friday 16 Sep 2011 17:36:20 Matthew Wilcox wrote:
> On Fri, Sep 16, 2011 at 04:16:49PM +0200, Andres Freund wrote:
> > I sent an email containing benchmarks from Robert Haas regarding the
> > Subject. Looking at lkml.org I can't see it right now, Will recheck when
> > I am at home.
> > 
> > He replaced lseek(SEEK_END) with fstat() and got speedups up to 8.7 times
> > the lseek performance.
> > The workload was 64 clients hammering postgres with a simple readonly
> > workload (pgbench -S).
> Yay!  Data!

> > For reference see the thread in the postgres archives which also links to
> > performance data: http://archives.postgresql.org/message-
> > id/CA+TgmoawRfpan35wzvgHkSJ0+i-W=VkJpKnRxK2kTDR+HsanWA@mail.gmail.com
> So both fstat and lseek do more work than postgres wants.  lseek modifies
> the file pointer while fstat copies all kinds of unnecessary information
> into userspace.  I imagine this is the source of the slowdown seen in
> the 1-client case.
Yes, that was my theory as well.

> I'd like to dig into the requirement for knowing the file size a little
> better.  According to the blog entry it's used for "the query planner".
Its used for multiple things - one of which is the query planner.
The query planner needs to know how many tuples a table has to produce a 
sensible plan. For that is has stats which tell 1. how big is the table 2. how 
many tuples does the table have. Those statistics are only updated every now 
and then though.
So it uses those old stats to check how many tuples are normally stored on a 
page and then uses that to extrapolate the number of tuples from the current 
nr of pages (which is computed by lseek(SEEK_END) over the 1GB segements of a 
table).

I am not sure how interested you are on the relevant postgres internals?

> Does the query planner need to know the exact number of bytes in the file,
> or is it after an order-of-magnitude?  Or to-the-nearest-gigabyte?
It depends on where the information is used. For some of the uses it needs to 
be exact (the assumed size is rechecked after acquiring a lock preventing 
extension) at other places I guess it would be ok if the accuracy got lower 
with bigger files (those files won't ever get bigger than 1GB).
But I have a hard time seeing an implementation where the approximate size 
would be faster to get than just the filesize? 

Andres
