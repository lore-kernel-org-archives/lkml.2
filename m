Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760151Ab0I0UCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 16:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756773Ab0I0UCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 16:02:40 -0400
Date: Mon, 27 Sep 2010 16:02:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, jmoyer@redhat.com,
        jaxboe@fusionio.com, Lennart Poettering <lennart@poettering.net>
Subject: Re: Request starvation with CFQ
Message-ID: <20100927200232.GA2377@redhat.com>
References: <20100927190024.GF3610@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100927190024.GF3610@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 27, 2010 at 09:00:24PM +0200, Jan Kara wrote:
>   Hi,
> 
>   when helping Lennart with answering some questions, I've spotted the
> following problem (at least I think it's a problem ;): The thing is that
> CFQ schedules how requests should be dispatched but does not in any
> significant way limit to whom requests get allocated. Given we have a
> quite limited pool of available requests it can happen that processes
> will be actually starved not waiting for disk but waiting for requests
> getting allocated and any IO scheduling priorities or classes will not
> have serious effect.
>   A pathological example I've tried below:
> #include <fcntl.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <sys/stat.h>
> 
> int main(void)
> {
>   int fd = open("/dev/vdb", O_RDONLY);
>   int loop = 0;
> 
>   if (fd < 0) {
>     perror("open");
>     exit(1);
>   }
>   while (1) {
>     if (loop % 100 == 0)
>       printf("Loop %d\n", loop);
>     posix_fadvise(fd, (random() * 4096) % 1000204886016ULL, 4096, POSIX_FADV_WILLNEED);
>     loop++;
>   }
> }
> 
>   This program will just push as many requests as possible to the block
> layer and does not wait for any IO. Thus it will basically ignore any
> decisions about when requests get dispatched. BTW, don't get distracted
> by the fact that the program operates directly on the device, that is just
> for simplicity. Large enough file would work the same way.
>   Even though I run this program with ionice -c 3, I still see that any
> other IO to the device is basically stalled. When I look at the block
> traces, I indeed see that what happens is that the above program submits
> requests until there are no more available:
> ...
> 254,16   2      802     1.411285520  2563  Q   R 696733184 + 8 [random_read]
> 254,16   2      803     1.411314880  2563  G   R 696733184 + 8 [random_read]
> 254,16   2      804     1.411338220  2563  I   R 696733184 + 8 [random_read]
> 254,16   2      805     1.411415040  2563  Q   R 1006864600 + 8 [random_read]
> 254,16   2      806     1.411441620  2563  S   R 1006864600 + 8 [random_read]
> 
> during and after that IO happens:
> 254,16   3       31     1.417898030     0  C   R 345134640 + 8 [0]
> 254,16   3       32     1.418171910     0  D   R 1524771568 + 8 [swapper]
> 254,16   0       33     1.432317140     0  C   R 1524771568 + 8 [0]
> 254,16   0       34     1.432597000     0  D   R 1077270768 + 8 [swapper]
> ...
> 254,16   0       35     1.503238050     0  C   R 33633744 + 8 [0]
> 254,16   0       36     1.503558290     0  D   R 22178968 + 8 [swapper]
> 
> and the other program comes with IO and gets stalled:
> 254,16   1       39     1.508843180  2564  A  RM 12346 + 8 <- (254,17) 12312
> 254,16   1       40     1.508876520  2564  Q  RM 12346 + 8 [ls]
> 254,16   1       41     1.508905140  2564  S  RM 12346 + 8 [ls]
> ...
> IO is still running:
> 254,16   2      807     1.512081560     0  C   R 22178968 + 8 [0]
> 254,16   2      808     1.512365010     0  D   R 475025688 + 8 [swapper]
> 254,16   3       35     1.522113270     0  C   R 475025688 + 8 [0]
> 254,16   3       36     1.522390779     0  D   R 697010128 + 8 [swapper]
> 254,16   4       33     1.531443760     0  C   R 697010128 + 8 [0]
> ...
> random reader even gets to submitting more requests:
> 254,16   2      815     1.785734950  2563  G   R 1006864600 + 8 [random_read]
> 254,16   2      816     1.785752290  2563  I   R 1006864600 + 8 [random_read]
> 254,16   2      817     1.785825880  2563  Q   R 832683552 + 8 [random_read]
> 254,16   2      818     1.785850890  2563  G   R 832683552 + 8 [random_read]
> 254,16   2      819     1.785874610  2563  I   R 832683552 + 8 [random_read]
> ...
> and finally our program gets to adding it's request as well:
> 254,16   1       60     2.160884040  2564  G  RM 12346 + 8 [ls]
> 254,16   1       61     2.160914700  2564  I   R 12346 + 8 [ls]
> 254,16   1       62     2.161142170  2564  D   R 12346 + 8 [ls]
> 254,16   1       63     2.161233670  2564  U   N [ls] 128
> 
>   I can provide the full traces for download if someone is interested
> in some part I didn't include here. The kernel is 2.6.36-rc4.
>   Now I agree that the above program is about as bad as it can get but
> Lennart would like to implement readahead during boot on background and
> I believe that could starve other IO in a similar way. So any idea how
> to solve this? To me it seems as if we also needed to somehow limit the
> number of allocated requests per cfqq but OTOH we have to be really careful
> to not harm common workloads where we benefit from having lots of requests
> queued...

Hi Jan,

True that during request allocation, there is no consideration for ioprio.
I think the whole logic is round robin, where after getting a bunch of
request each process is put to sleep in the queue and then we do round
robin on all waiters. This should in general be an issue with request
queue and not just CFQ.

So if there are bunch of threads which are very bullish on doing IO, and 
there is a dependent reader, read latencies will shoot up.

In fact current implementation of blkio controller also suffers with this
limitation because we don't yet have per group request descriptors and
once request queue is congested, requests from one group can get stuck
behind the requests from other group.

One way forward could be to implement per cgroup request descriptors and
put this readahead thread into a separate cgroup of low weight.

Other could be to implemnet some kind of request quota per priority level.
This is similar to per cgroup quota I talked above, just one level below.

Third could be ad-hoc way of putting some limit on per cfqq. But I think a
process can easily circumvent that by forking off child which are not
sharing cfq context and then we are back to same situaiton.

A very hackish solution could be to try to increase nr_requests on the 
queue to say 1024. This will work only if you know that read-ahead process
does some limited amount of read-ahead and does not overwhelm the queue
with more than 1024 requets.  And then use ioprio with low prio for
read-ahead process.

Thanks
Vivek
