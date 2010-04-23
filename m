Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab0DWRGC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 13:06:02 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39697 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347Ab0DWRF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 13:05:56 -0400
Date: Fri, 23 Apr 2010 19:05:54 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Rick Sherm <rick.sherm@yahoo.com>, linux-kernel@vger.kernel.org
Subject: Re: Trying to measure performance with splice/vmsplice ....
Message-ID: <20100423170554.GS27497@kernel.dk>
References: <723057.43066.qm@web114303.mail.gq1.yahoo.com> <1272041662.3109.26.camel@iscandar.digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272041662.3109.26.camel@iscandar.digidescorp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23 2010, Steven J. Magnani wrote:
> On Fri, 2010-04-23 at 09:07 -0700, Rick Sherm wrote:
> > Hello Jens - any assistance/pointers on 1) and 2) below 
> > will be great.I'm willing to test out any sample patch.
> 
> Recent mail from him has come from jens.axboe@oracle.com, I cc'd it.

Goes to the same inbox in the end, so no difference :-)

> > > On Fri, 2010-04-16 at 10:02 -0700, Rick Sherm wrote:
> > > > Q3) When using splice, even though the destination
> > > file is opened in O_DIRECT mode, the data gets cached. I
> > > verified it using vmstat.
> > > > 
> > > > r b   swpd   free   buff cache   
> > > > 1 0     0 9358820 116576 2100904
> > > > 
> > > > ./splice_to_splice
> > > > 
> > > > r b swpd   free   buff cache
> > > > 2 0  0 7228908 116576  4198164
> > > > 
> > > > I see the same caching issue even if I vmsplice
> > > buffers(simple malloc'd iov) to a pipe and then splice the
> > > pipe to a file. The speed is still an issue with vmsplice
> > > too.
> > > > 
> > > 
> > > One thing is that O_DIRECT is a hint; not all filesystems
> > > bypass the cache. I'm pretty sure ext2 does, and I know fat doesn't. 
> > > 
> > > Another variable is whether (and how) your filesystem
> > > implements the splice_write file operation. The generic one (pipe_to_file)
> > > in fs/splice.c copies data to pagecache. The default one goes
> > > out to vfs_write() and might stand more of a chance of honoring
> > > O_DIRECT.
> > > 
> > 
> > True.I guess I should have looked harder. It's xfs and xfs's->file_ops points to 'generic_file_splice_read[write]'.Last time I had to 'fdatasync' and then fadvise to mimic 'O_DIRECT'.
> > 
> > > > Q4) Also, using splice, you can only transfer 64K
> > > worth of data(PIPE_BUFFERS*PAGE_SIZE) at a time,correct?.But
> > > using stock read/write, I can go upto 1MB buffer. After that
> > > I don't see any gain. But still the reduction in system/cpu
> > > time is significant.
> > > 
> > > I'm not a splicing expert but I did spend some time
> > > recently trying to
> > > improve FTP reception by splicing from a TCP socket to a
> > > file. I found that while splicing avoids copying packets to userland,
> > > that gain is more than offset by a large increase in calls into the
> > > storage stack.It's especially bad with TCP sockets because a typical
> > > packet has, say,1460 bytes of data. Since splicing works on PIPE_BUFFERS
> > > pages at a time, and packet pages are only about 35% utilized, each
> > > cycle to userland I could only move 23 KiB of data at most. Some
> > > similar effect may be in play in your case.
> > > 
> > 
> > Agreed,increasing number of calls will offset the benefit.
> > But what if:
> > 1)We were to increase the PIPE_BUFFERS from '16' to '64' or 'some value'?
> > What are the implications in the other parts of the kernel?
> 
> This came up recently, one problem is that there a couple of kernel
> functions having up to 3 stack-based arrays of dimension PIPE_BUFFER. So
> the stack cost of increasing PIPE_BUFFERS can be quite high. I've
> thought it might be nice if there was some mechanism for userland apps
> to be able to request larger PIPE_BUFFERS values, but I haven't pursued
> this line of thought to see if it's practical.

I still have patches pending for this, making the pipe buffer count
settable form user space:

http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=24547ac4d97bebb58caf9ce58bd507a95c812a3f

Let me know if you want to give it a spin on a recent kernel, and I'll
update it.

> > 2)There was a way to find out if the DMA-out/in from the initial buffer's that were passed are complete so that we are free to recycle them? Callback would be helpful.Obviously, the user-space-app will have to manage it's buffers but atleast we are guranteed that the buffers can be recycled(in other words no worrying about modifying in-flight data that is being DMA'd).
> 
> It's a neat idea, but it would probably be much easier (and less
> invasive) to try this sort of pipelining in userland using a ring buffer
> or ping-pong approach. I'm actually in the middle of something like this
> with FTP, where I will have a reader thread that puts data from the
> network into a ring buffer, from which a writer thread moves it to a
> file.

See vmsplice.c from the splice test tools:

http://brick.kernel.dk/snaps/splice-git-latest.tar.gz

-- 
Jens Axboe

