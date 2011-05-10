Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932914Ab1EJQCP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 12:02:15 -0400
Received: from cobra.newdream.net ([66.33.216.30]:33948 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932876Ab1EJQCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 12:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=newdream.net; h=date:from:to:cc
	:subject:in-reply-to:message-id:references:mime-version:
	content-type; q=dns; s=newdream.net; b=onztyEAoj0ERpkNDC6pf0de7f
	DLBrK730xxmJpAbBoVDXEEBA+3iRCMW4BkGWWMQ/eK9nFJPvPemG7072pAWMkek4
	D+KHUKmbeXH8SCibK+GFzqaMpa+nVbP/aQMgfQvVtwrs4cJ4AHetpR9S+RKToSVg
	opCmTFXi2hv4CbV9mc=
Date: Tue, 10 May 2011 09:02:57 -0700 (PDT)
From: Sage Weil <sage@newdream.net>
To: Stefan Majer <stefan.majer@gmail.com>
cc: Yehuda Sadeh Weinraub <yehudasa@gmail.com>, linux-net@vger.kernel.org,
        linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: Kernel 2.6.38.6 page allocation failure (ixgbe)
In-Reply-To: <BANLkTi=jZ-GA30_54kay3ouoNJvkwbVQ4w@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1105100900170.4299@cobra.newdream.net>
References: <BANLkTinr34qmAE8RWVY0Wq_XMfOc0jTUzg@mail.gmail.com>
 <BANLkTi=4DNyWaqqjK5sG5O9cNdfpuAqHWA@mail.gmail.com>
 <BANLkTi=jZ-GA30_54kay3ouoNJvkwbVQ4w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Tue, 10 May 2011, Stefan Majer wrote:
> Hi,
> 
> On Tue, May 10, 2011 at 4:20 PM, Yehuda Sadeh Weinraub
> <yehudasa@gmail.com> wrote:
> > On Tue, May 10, 2011 at 7:04 AM, Stefan Majer <stefan.majer@gmail.com> wrote:
> >> Hi,
> >>
> >> im running 4 nodes with ceph on top of btrfs with a dualport Intel
> >> X520 10Gb Ethernet Card with the latest 3.3.9 ixgbe driver.
> >> during benchmarks i get the following stack.
> >> I can easily reproduce this by simply running rados bench from a fast
> >> machine using this 4 nodes as ceph cluster.
> >> We saw this with stock ixgbe driver from 2.6.38.6 and with the latest
> >> 3.3.9 ixgbe.
> >> This kernel is tainted because we use fusion-io iodrives as journal
> >> devices for btrfs.
> >>
> >> Any hints to nail this down are welcome.
> >>
> >> Greetings Stefan Majer
> >>
> >> May 10 15:26:40 os02 kernel: [ 3652.485219] cosd: page allocation
> >> failure. order:2, mode:0x4020
> >
> > It looks like the machine running the cosd is crashing, is that the case?
> 
> No the machine is still running. Even the cosd is still there.

How much memory is (was?) cosd using?  Is it possible for you to watch RSS 
under load when the errors trigger?

The osd throttles incoming client bandwidth, but it doesn't throttle 
inter-osd traffic yet because it's not obvious how to avoid deadlock.  
It's possible that one node is getting significantly behind the 
others on the replicated writes and that is blowing up its memory 
footprint.  There are a few ways we can address that, but I'd like to make 
sure we understand the problem first.

Thanks!
sage


 
> > Are you running both ceph kernel module on the same machine by any
> > chance? If not, it can be some other fs bug (e.g., the underlying
> > btrfs). Also, the stack here is quite deep, there's a chance for a
> > stack overflow.
> 
> There is only the cosd running on these machines. We have 3 seperate
> mons and clients which uses qemu-rbd.
> 
> 
> > Thanks,
> > Yehuda
> >
> 
> 
> Greetings
> -- 
> Stefan Majer
> --
> To unsubscribe from this list: send the line "unsubscribe ceph-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
