Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2KTOPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:15:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156Ab2KTOO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:14:58 -0500
Date: Tue, 20 Nov 2012 12:14:39 -0200
From: Rafael Aquini <aquini@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Rik van Riel <riel@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH v12 4/7] mm: introduce compaction and migration for
 ballooned pages
Message-ID: <20121120141438.GA21672@x61.redhat.com>
References: <cover.1352656285.git.aquini@redhat.com>
 <6602296b38c073a5c6faa13ddbc74ceb1eceb2dd.1352656285.git.aquini@redhat.com>
 <50A7D0FA.2080709@gmail.com>
 <20121117215434.GA23879@x61.redhat.com>
 <CA+1xoqfbxL-mL3XRDXxnuv0R6b9w6qxU7t+8U3FwS2eK5Sf0OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+1xoqfbxL-mL3XRDXxnuv0R6b9w6qxU7t+8U3FwS2eK5Sf0OA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 18, 2012 at 09:59:47AM -0500, Sasha Levin wrote:
> On Sat, Nov 17, 2012 at 4:54 PM, Rafael Aquini <aquini@redhat.com> wrote:
> > On Sat, Nov 17, 2012 at 01:01:30PM -0500, Sasha Levin wrote:
> >>
> >> I'm getting the following while fuzzing using trinity inside a KVM tools guest,
> >> on latest -next:
> >>
> >> [ 1642.783728] BUG: unable to handle kernel NULL pointer dereference at 0000000000000194
> >> [ 1642.785083] IP: [<ffffffff8122b354>] isolate_migratepages_range+0x344/0x7b0
> >>
> >> My guess is that we see those because of a race during the check in
> >> isolate_migratepages_range().
> >>
> >>
> >> Thanks,
> >> Sasha
> >
> > Sasha, could you share your .config and steps you did used with trinity? So I
> > can attempt to reproduce this issue you reported.
> 
> Basically try running trinity (with ./trinity -m --quiet --dangerous
> -l off) inside a disposable guest as root.
> 
> I manage to hit that every couple of hours.
> 
> Config attached.
> 

Howdy Sasha,

After several hours since last Sunday running trinity tests on a traditional
KVM-QEMU guest as well as running it on a lkvm guest (both running
next-20121115) I couldn't hit a single time the crash you've reported,
(un)fortunately.

Also, the .config you gave me, applied on top of next-20121115, haven't produced
the same bin you've running and hitting the mentioned bug, apparently.

Here's the RIP for your crash:
[ 1642.783728] BUG: unable to handle kernel NULL pointer dereference at
0000000000000194
[ 1642.785083] IP: [<ffffffff8122b354>] isolate_migratepages_range+0x344/0x7b0


And here's the symbol address for the next-20121115 with your .config I've been
running tests on:
[raquini@x61 linux]$ nm -n vmlinux | grep isolate_migratepages_range 
ffffffff8122d890 T isolate_migratepages_range

Also, it seems quite clear I'm missing something from your tree, as applying the
RIP displacement (0x344) to my local isolate_migratepages_range sym addr leads
me to the _middle_ of a instruction opcode that does not dereference any
pointers at all.

So, if you're consistently reproducing the same crash, consider to share with us
a disassembled dump from the isolate_migratepages_range() you're running along
with the crash stack-dump, please.

Cheers!
-- Rafael

