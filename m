Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964795Ab2FAOTE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:19:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932989Ab2FAOTC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:19:02 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338557229.2760.1520.camel@edumazet-glaptop>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
	 <1338554890.2760.1517.camel@edumazet-glaptop>
	 <1338556468.2708.41.camel@menhir>
	 <1338557229.2760.1520.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Jun 2012 15:18:03 +0100
Message-ID: <1338560283.2708.59.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2012-06-01 at 15:27 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-01 at 14:14 +0100, Steven Whitehouse wrote:
> 
> > Here it is (with the patch):
> > 
> > [root@chywoon mnt]# time dd if=/sys/kernel/debug/gfs2/unity\:myfs/glocks
> > of=/dev/null bs=4k
> > 0+5726 records in
> > 0+5726 records out
> > 23107575 bytes (23 MB) copied, 82.3082 s, 281 kB/s
> > 
> > real	1m22.311s
> > user	0m0.013s
> > sys	1m22.231s
> > 
> > So thats slow, as promised :-)
> > 
> > > I can't reproduce this slow behavior you have, using /proc/net seq
> > > files.
> > > 
> > > Isn't it a problem with this particular file ?
> > > 
> > Well, yes and no. The problem would affect any file with lots of records
> > in it, but there may not be many with that number of records. Do any of
> > your net files have numbers of entries in the region of hundreds of
> > thousands or more?
> > 
> > > Does it want to output a single record ( m->op->show(m, p) ) much larger
> > > than 4KB ?
> > > 
> > No. That appears to work ok, so far as I can tell, anyway. What we have
> > are lots of relatively short records. Here is an example of a few lines.
> > Each line starting G: is a new record, so this is 5 calls to ->show():
> > 
> > G:  s:SH n:5/1da5e f:Iqob t:SH d:EX/0 a:0 v:0 r:2 m:200
> >  H: s:SH f:EH e:0 p:6577 [(ended)] gfs2_inode_lookup+0x116/0x2d0 [gfs2]
> > G:  s:SH n:2/a852 f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
> >  I: n:9712/43090 t:8 f:0x00 d:0x00000000 s:0
> > G:  s:SH n:2/8bcd f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
> >  I: n:2584/35789 t:8 f:0x00 d:0x00000000 s:0
> > G:  s:SH n:2/1eea7 f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
> >  I: n:58968/126631 t:8 f:0x00 d:0x00000000 s:0
> > G:  s:SH n:2/12fbd f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
> >  I: n:11120/77757 t:8 f:0x00 d:0x00000000 s:0
> > 
> > 
> > The key here is that we have a lot of them. My example using just over
> > 400k records is in fact a fairly modest example - it is not unusual to
> > see millions of records in this file. We use it for debug purposes only,
> > and this patch was prompted by people reporting it taking a very long
> > time to dump the file.
> > 
> > The issue is not the time taken to create each record, or to copy the
> > data, but the time taken each time we have to find our place again in
> > the list of glocks (actually a hash table, but same thing applies as we
> > traverse it as a set of lists)
> > 
> > I don't think there is really much we can easily do in the case of
> > readers requesting small reads of the file. At least we can make it much
> > more efficient when they request larger reads though,
> 
> Issue is your seq_file provider has O(N^2) behavior
> 
Well that is a slight simplification. The provider has O(N) behaviour
wrt to the number of entries when streaming data, and O(N) behaviour
when seeking to a specific file offset. It is the combination of
repeated calls of the seeking function that results in O(N^2)

> We used to have same issues in network land, and we fixed this some time
> ago, and we only use 4KB as seq_file buffer, not a huge one.
> 
> Check commit a8b690f98baf9fb1 ( tcp: Fix slowness in
> read /proc/net/tcp ) for an example
> 
So far as I can tell, you are just caching the last hash bucket, but are
still seeking down each hash chain. That will only work well when the
hash buckets are reasonably empty. We can try that in GFS2, however I'm
not sure that is the whole story.

It appears that /proc/net/unix still seems to suffer from this O(N^2)
problem, even if /proc/net/tcp does not. I did a quick test using a
program to create a bunch of tcp sockets, and using my kernel patch
landed up with these results:

[root@chywoon mnt]# time dd if=/proc/net/tcp of=/dev/null bs=4k
0+1046 records in
0+1046 records out
4236300 bytes (4.2 MB) copied, 1.20739 s, 3.5 MB/s

real	0m1.310s
user	0m0.003s
sys	0m1.220s

[root@chywoon mnt]# time dd if=/proc/net/tcp of=/dev/null bs=1M
0+5 records in
0+5 records out
4236300 bytes (4.2 MB) copied, 0.331139 s, 12.8 MB/s

real	0m0.470s
user	0m0.001s
sys	0m0.374s

So even with the current tcp scheme this appears to speed things up by
nearly 3x. Also that was with only 28000 entries in the file,

Steve.


