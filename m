Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759668Ab2FAM1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 08:27:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25328 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933018Ab2FAM1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 08:27:35 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338552870.2760.1512.camel@edumazet-glaptop>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338552870.2760.1512.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Jun 2012 13:26:26 +0100
Message-ID: <1338553586.2708.27.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2012-06-01 at 14:14 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-01 at 14:10 +0200, Eric Dumazet wrote:
> > On Fri, 2012-06-01 at 11:39 +0100, Steven Whitehouse wrote:
> > > I've just been taking a look at the seq_read() code, since we've noticed
> > > that dumping files with large numbers of records can take some
> > > considerable time. This is due to seq_read() using a buffer which, at
> > > most is a single page in size, and that it has to find its place again
> > > on every call to seq_read(). That makes it rather inefficient.
> > > 
> > > As an example, I created a GFS2 filesystem with 100k inodes in it, and
> > > then ran ls -l to get a decent number of cached inodes. This result in
> > > there being approx 400k lines in the debugfs file containing GFS2's
> > > glocks. I then timed how long it takes to read this file:
> > > 
> > > [root@chywoon mnt]# time dd if=/sys/kernel/debug/gfs2/unity\:myfs/glocks
> > > of=/dev/null bs=1M
> > > 0+5769 records in
> > > 0+5769 records out
> > > 23273958 bytes (23 MB) copied, 63.3681 s, 367 kB/s
> > 
> > What time do you get if you do
> > 
> > time dd if=/sys/kernel/debug/gfs2/unity\:myfs/glocks of=/dev/null bs=4k
> > 
> > This patch seems the wrong way to me.
> > 
> > seq_read(size = 1MB) should perform many copy_to_user() calls instead of a single one.
> > 
> > Instead of doing kmalloc(m->size <<= 1, GFP_KERNEL) each time we overflow the buffer,
> > we should flush its content to user space.
> > 
> > 
> 
> by the way, is the following command even working ?
> 
> time dd if=/sys/kernel/debug/gfs2/unity\:myfs/glocks of=/dev/null bs=16M
> 
> I guess not, it probably returns -ENOMEM
> 
> 
> 

Why would it return -ENOMEM? It works for me, at worst it will fall back
to a single page buffer size unless we are really stuck for memory, and
in that case, all bets are off,

Steve.


