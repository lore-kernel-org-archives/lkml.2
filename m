Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0KBA4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 20:56:47 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:22613 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752137Ab0KBA4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 20:56:45 -0400
Date: Mon, 1 Nov 2010 20:55:11 -0400
From: Chris Mason <chris.mason@oracle.com>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Calvin Walton <calvin.walton@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-btrfs@vger.kernel.org
Subject: Re: Horrible btrfs performance due to fragmentation
Message-ID: <20101102005511.GA7188@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Felipe Contreras <felipe.contreras@gmail.com>,
	Calvin Walton <calvin.walton@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-btrfs@vger.kernel.org
References: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinWT9OyicLfdeY+AvWs=5vb5z8skZ3t6keYjk9j@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ resend, sorry if anyone sees this twice ]

On Sun, Oct 31, 2010 at 09:58:18PM +0200, Felipe Contreras wrote:
> On Mon, Oct 11, 2010 at 6:46 PM, Calvin Walton <calvin.walton@gmail.com> wrote:
> > On Mon, 2010-10-11 at 03:30 +0300, Felipe Contreras wrote:
> >> I use btrfs on most of my volumes on my laptop, and I've always felt
> >> booting was very slow, but definitely sure is slow, is starting up
> >> Google Chrome:
> >>
> >> encrypted ext4: ~20s
> >> btrfs: ~2:11s
> >>
> >> I have tried different things to find out exactly what is the issue,
> >> but haven't quite found it yet.
> >
> > If you've been using this volume for a while, it could just have become
> > badly fragmented. You could try btrfs's fancy online defragmentation
> > abilities to see if that'll give you an improvement:
> >
> > # btrfs filesystem defragment /mountpoint/of/volume
> >
> > Let us know if that helps, of course :)
> 
> I finally managed to track down this issue. Indeed the fragmentation
> is horrible, and 'btrfs filesystem defragment' doesn't help:

So there are two different issues, and you'll need sysrq-w to see which
one you're really hitting.  The first is fragmentation, where you'll
want to defrag a given file with btrfs filesystem defrag <filename>

The second is that when we first mount a filesystem, we have to spend a
long time building up the index of which blocks are free.  Josef has
fixed this for the 2.6.37-rc1, and Linus' current tree has his changes.

You can also pull from the btrfs-unstable master branch and get his
changes against 2.6.36.

To use the new code, mount -o space_cache.  You only need to do this
once.

The first mount will be slow, but once we've read in the block groups
for the first mount, later mounts will be much faster.

-chris
