Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab0DWQy2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:54:28 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:35998 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754687Ab0DWQyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:54:25 -0400
X-Spam-Processed: digidescorp.com, Fri, 23 Apr 2010 11:54:24 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=172908d41f=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: Trying to measure performance with splice/vmsplice ....
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Rick Sherm <rick.sherm@yahoo.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
In-Reply-To: <723057.43066.qm@web114303.mail.gq1.yahoo.com>
References: <723057.43066.qm@web114303.mail.gq1.yahoo.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Fri, 23 Apr 2010 11:54:22 -0500
Message-Id: <1272041662.3109.26.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-23 at 09:07 -0700, Rick Sherm wrote:
> Hello Jens - any assistance/pointers on 1) and 2) below 
> will be great.I'm willing to test out any sample patch.

Recent mail from him has come from jens.axboe@oracle.com, I cc'd it.

> 
> Steve,
> 
> --- On Wed, 4/21/10, Steven J. Magnani <steve@digidescorp.com> wrote:
> > Hi Rick,
> > 
> > On Fri, 2010-04-16 at 10:02 -0700, Rick Sherm wrote:
> > > Q3) When using splice, even though the destination
> > file is opened in O_DIRECT mode, the data gets cached. I
> > verified it using vmstat.
> > > 
> > > r b   swpd   free   buff cache   
> > > 1 0     0 9358820 116576 2100904
> > > 
> > > ./splice_to_splice
> > > 
> > > r b swpd   free   buff cache
> > > 2 0  0 7228908 116576  4198164
> > > 
> > > I see the same caching issue even if I vmsplice
> > buffers(simple malloc'd iov) to a pipe and then splice the
> > pipe to a file. The speed is still an issue with vmsplice
> > too.
> > > 
> > 
> > One thing is that O_DIRECT is a hint; not all filesystems
> > bypass the cache. I'm pretty sure ext2 does, and I know fat doesn't. 
> > 
> > Another variable is whether (and how) your filesystem
> > implements the splice_write file operation. The generic one (pipe_to_file)
> > in fs/splice.c copies data to pagecache. The default one goes
> > out to vfs_write() and might stand more of a chance of honoring
> > O_DIRECT.
> > 
> 
> True.I guess I should have looked harder. It's xfs and xfs's->file_ops points to 'generic_file_splice_read[write]'.Last time I had to 'fdatasync' and then fadvise to mimic 'O_DIRECT'.
> 
> > > Q4) Also, using splice, you can only transfer 64K
> > worth of data(PIPE_BUFFERS*PAGE_SIZE) at a time,correct?.But
> > using stock read/write, I can go upto 1MB buffer. After that
> > I don't see any gain. But still the reduction in system/cpu
> > time is significant.
> > 
> > I'm not a splicing expert but I did spend some time
> > recently trying to
> > improve FTP reception by splicing from a TCP socket to a
> > file. I found that while splicing avoids copying packets to userland,
> > that gain is more than offset by a large increase in calls into the
> > storage stack.It's especially bad with TCP sockets because a typical
> > packet has, say,1460 bytes of data. Since splicing works on PIPE_BUFFERS
> > pages at a time, and packet pages are only about 35% utilized, each
> > cycle to userland I could only move 23 KiB of data at most. Some
> > similar effect may be in play in your case.
> > 
> 
> Agreed,increasing number of calls will offset the benefit.
> But what if:
> 1)We were to increase the PIPE_BUFFERS from '16' to '64' or 'some value'?
> What are the implications in the other parts of the kernel?

This came up recently, one problem is that there a couple of kernel
functions having up to 3 stack-based arrays of dimension PIPE_BUFFER. So
the stack cost of increasing PIPE_BUFFERS can be quite high. I've
thought it might be nice if there was some mechanism for userland apps
to be able to request larger PIPE_BUFFERS values, but I haven't pursued
this line of thought to see if it's practical.

> 2)There was a way to find out if the DMA-out/in from the initial buffer's that were passed are complete so that we are free to recycle them? Callback would be helpful.Obviously, the user-space-app will have to manage it's buffers but atleast we are guranteed that the buffers can be recycled(in other words no worrying about modifying in-flight data that is being DMA'd).

It's a neat idea, but it would probably be much easier (and less
invasive) to try this sort of pipelining in userland using a ring buffer
or ping-pong approach. I'm actually in the middle of something like this
with FTP, where I will have a reader thread that puts data from the
network into a ring buffer, from which a writer thread moves it to a
file.

------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


