Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754607Ab0DUSRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:17:44 -0400
Received: from mail.digidescorp.com ([66.244.163.200]:47759 "EHLO
	digidescorp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab0DUSRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:17:42 -0400
X-Spam-Processed: digidescorp.com, Wed, 21 Apr 2010 13:17:41 -0500
X-Authenticated-Sender: steve@digidescorp.com
X-Return-Path: prvs=1727ca6a1a=steve@digidescorp.com
X-Envelope-From: steve@digidescorp.com
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
Subject: Re: Trying to measure performance with splice/vmsplice ....
From: "Steven J. Magnani" <steve@digidescorp.com>
Reply-To: steve@digidescorp.com
To: Rick Sherm <rick.sherm@yahoo.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
In-Reply-To: <136370.38015.qm@web114316.mail.gq1.yahoo.com>
References: <136370.38015.qm@web114316.mail.gq1.yahoo.com>
Content-Type: text/plain
Organization: Digital Design Corporation
Date: Wed, 21 Apr 2010 13:17:36 -0500
Message-Id: <1271873856.3834.60.camel@iscandar.digidescorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rick,

On Fri, 2010-04-16 at 10:02 -0700, Rick Sherm wrote:
> Q3) When using splice, even though the destination file is opened in O_DIRECT mode, the data gets cached. I verified it using vmstat.
> 
> r  b   swpd   free   buff    cache   
> 1  0      0 9358820 116576 2100904
> 
> ./splice_to_splice
> 
> r  b   swpd   free   buff  cache
> 2  0      0 7228908 116576 4198164
> 
> I see the same caching issue even if I vmsplice buffers(simple malloc'd iov) to a pipe and then splice the pipe to a file. The speed is still an issue with vmsplice too.
> 

One thing is that O_DIRECT is a hint; not all filesystems bypass the
cache. I'm pretty sure ext2 does, and I know fat doesn't. 

Another variable is whether (and how) your filesystem implements the
splice_write file operation. The generic one (pipe_to_file) in
fs/splice.c copies data to pagecache. The default one goes out to
vfs_write() and might stand more of a chance of honoring O_DIRECT.

> Q4) Also, using splice, you can only transfer 64K worth of data(PIPE_BUFFERS*PAGE_SIZE) at a time,correct?.But using stock read/write, I can go upto 1MB buffer. After that I don't see any gain. But still the reduction in system/cpu time is significant.

I'm not a splicing expert but I did spend some time recently trying to
improve FTP reception by splicing from a TCP socket to a file. I found
that while splicing avoids copying packets to userland, that gain is
more than offset by a large increase in calls into the storage stack.
It's especially bad with TCP sockets because a typical packet has, say,
1460 bytes of data. Since splicing works on PIPE_BUFFERS pages at a
time, and packet pages are only about 35% utilized, each cycle to
userland I could only move 23 KiB of data at most. Some similar effect
may be in play in your case.

ftrace may be of some help in finding the bottleneck...

Regards,
------------------------------------------------------------------------
 Steven J. Magnani               "I claim this network for MARS!
 www.digidescorp.com              Earthling, return my space modulator!"

 #include <standard.disclaimer>


