Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab1JMQCU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:02:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59542 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753443Ab1JMQCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:02:19 -0400
Date: Thu, 13 Oct 2011 12:00:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "krzf83@gmail.com " <krzf83@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Morton Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cgroup blkio bug/feedback
Message-ID: <20111013160041.GC25588@redhat.com>
References: <CAJ1PRSnQgaCr4s+JwmB3r_J9de5MHJKVwrxGnderYGqyVVMG3Q@mail.gmail.com>
 <20111012193551.GH12845@redhat.com>
 <CAJ1PRS=jPU07GjGMecyS=iMhWpfUYe-WO4ntBd=qZ0V0qnK-ow@mail.gmail.com>
 <20111013145231.GB25588@redhat.com>
 <CAJ1PRSkCw9D78ODk2YrgR8TVvdLZ6vqBtksAPZUDL-MvEdeUdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ1PRSkCw9D78ODk2YrgR8TVvdLZ6vqBtksAPZUDL-MvEdeUdQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Please don't top post. Respond inline ]

On Thu, Oct 13, 2011 at 05:37:33PM +0200, krzf83@gmail.com  wrote:
> Rsync iops limiting thing was that I've tried limiting when rsync-ing
> from /dev/sdc (mounted as /ssd) to /home/ssd-copy (/home is /dev/md2).
> During that usage I've encountred overloads and system unresponsivness
> even greater than when not using limiting at all.

Ok, so you have your /home on md target and rsyncing from ssd to home and
hence trying to limit the impact of writes on /home by limiting write
rate on /home disk.

What's the file system you are using on /home ? I will try to do
something similar on local system and see if I can reproduce the
issue.

> 
> I've also tried to limit iops for every "normal" user (not deamon
> running users) in the system for /home (/dev/md2). I've writen script
> that initialy assings pids to cgroups and initializes cgrulesengd so
> spawned apllications in the future will be in proper croups. I've
> encountred system overloads (hard reboot required) every 5-20 hours.
> That is also when I specifilcy did not limit tasks that were spawned
> by webserver (which are fastcgi php tasks and some passenger tasks).

So if you just put processes in a blkio cgroup but not specify any
limits, load average is fine? It is only when you specify some limits
load average goes up?

I am still scratching my head that how does that happen. Is it that
some application is forking more processes if sufficient IO is not
making progress due to throttling or what.

> 
> Anyway as for my other tests with blkio memory limits
> (memory.limit_in_bytes)

A minor clarification. memory.limit_in_bytes is provided by memory controller
and not by blkio controller.

> I also got huge system overloads when tasks
> were killed. However this were probably due to websever spawning those
> again and again imideatly (mainly phusion passenger tasks). I've tried
> separating process-es that were spawned by webserver to other, not
> limited, cgroup, but as I recall (I've done it about 1,5 month ago)
> something were also causing overloads and constatant
> kill/respawn/kill/respawn in my production webserver.

Looks like you need to give more memory to this cgroup.

> 
> As for blkio blkio.weight this would be fine thing, however  it causes
> loadavg to spike like hell when limiting one process.

Are you using CFQ on your md raid component disks? What's the mdraid
configuraiton. Again, I might give it a shot here. Have not seen
anything like what you are explaining.

When this load average increases, can you capture "vmstat 2" output.
I am also curious to know who is forking off these extra processes
in the system. (may be some "ps" can help).

Thanks
Vivek
