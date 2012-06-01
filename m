Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759749Ab2FANP1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:15:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758182Ab2FANPZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:15:25 -0400
Subject: Re: seq_file: Use larger buffer to reduce time traversing lists
From: Steven Whitehouse <swhiteho@redhat.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, cluster-devel@redhat.com,
        Al Viro <viro@zeniv.linux.org.uk>, nstraz@redhat.com
In-Reply-To: <1338554890.2760.1517.camel@edumazet-glaptop>
References: <1338547193.2708.16.camel@menhir>
	 <1338552626.2760.1510.camel@edumazet-glaptop>
	 <1338553486.2708.25.camel@menhir>
	 <1338554890.2760.1517.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 01 Jun 2012 14:14:28 +0100
Message-ID: <1338556468.2708.41.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2012-06-01 at 14:48 +0200, Eric Dumazet wrote:
> On Fri, 2012-06-01 at 13:24 +0100, Steven Whitehouse wrote:
> 
> > Yes, you are right that it will be slow, still. But I'm not sure what we
> > can do about that. We have to find our place again on each read call, in
> > any case I think.
> 
> You dont really answer my question, I asked the exact timing...
> 
Here it is (with the patch):

[root@chywoon mnt]# time dd if=/sys/kernel/debug/gfs2/unity\:myfs/glocks
of=/dev/null bs=4k
0+5726 records in
0+5726 records out
23107575 bytes (23 MB) copied, 82.3082 s, 281 kB/s

real	1m22.311s
user	0m0.013s
sys	1m22.231s

So thats slow, as promised :-)

> I can't reproduce this slow behavior you have, using /proc/net seq
> files.
> 
> Isn't it a problem with this particular file ?
> 
Well, yes and no. The problem would affect any file with lots of records
in it, but there may not be many with that number of records. Do any of
your net files have numbers of entries in the region of hundreds of
thousands or more?

> Does it want to output a single record ( m->op->show(m, p) ) much larger
> than 4KB ?
> 
No. That appears to work ok, so far as I can tell, anyway. What we have
are lots of relatively short records. Here is an example of a few lines.
Each line starting G: is a new record, so this is 5 calls to ->show():

G:  s:SH n:5/1da5e f:Iqob t:SH d:EX/0 a:0 v:0 r:2 m:200
 H: s:SH f:EH e:0 p:6577 [(ended)] gfs2_inode_lookup+0x116/0x2d0 [gfs2]
G:  s:SH n:2/a852 f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
 I: n:9712/43090 t:8 f:0x00 d:0x00000000 s:0
G:  s:SH n:2/8bcd f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
 I: n:2584/35789 t:8 f:0x00 d:0x00000000 s:0
G:  s:SH n:2/1eea7 f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
 I: n:58968/126631 t:8 f:0x00 d:0x00000000 s:0
G:  s:SH n:2/12fbd f:IqLob t:SH d:EX/0 a:0 v:0 r:2 m:200
 I: n:11120/77757 t:8 f:0x00 d:0x00000000 s:0


The key here is that we have a lot of them. My example using just over
400k records is in fact a fairly modest example - it is not unusual to
see millions of records in this file. We use it for debug purposes only,
and this patch was prompted by people reporting it taking a very long
time to dump the file.

The issue is not the time taken to create each record, or to copy the
data, but the time taken each time we have to find our place again in
the list of glocks (actually a hash table, but same thing applies as we
traverse it as a set of lists)

I don't think there is really much we can easily do in the case of
readers requesting small reads of the file. At least we can make it much
more efficient when they request larger reads though,

Steve.


