Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab0EYNjd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:39:33 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:41478 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab0EYNjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:39:31 -0400
Subject: Re: Deadlock in NFSv4 in all kernels
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: Pavel Machek <pavel@ucw.cz>, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       salvet@ics.muni.cz
In-Reply-To: <20100525125833.GB9731@ics.muni.cz>
References: <20100507153920.GP28167@ics.muni.cz>
	 <20100524212422.GA1286@ucw.cz>
	 <1274790520.2949.20.camel@heimdal.trondhjem.org>
	 <20100525125833.GB9731@ics.muni.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 09:39:25 -0400
Message-ID: <1274794765.5377.43.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 (2.30.1.2-2.fc13) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 12 msgs/h 2 sum rcpts/h 19 sum msgs/h 3 total rcpts 362 max rcpts/h 20 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 9151177D26D13168E68B83BADDDFE3948CD2B20B
X-UiO-SPAM-Test: remote_host: 68.40.206.115 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 174 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 14:58 +0200, Lukas Hejtmanek wrote: 
> Hi,
> 
> On Tue, May 25, 2010 at 08:28:40AM -0400, Trond Myklebust wrote:
> > > Seems like pretty fundamental problem in nfs :-(. Limiting writeback
> > > caches for nfs, so that system has enough memory to perform rpc calls
> > > with the rest might do the trick, but...
> > > 
> > 
> > It's the same problem that you have for any file or storage system that
> > has initiators in userland. On the storage side, iSCSI in particular has
> > the same problem. On the filesystem side, CIFS, AFS, coda, .... do too.
> > The clustered filesystems can deadlock if the node that is running the
> > DLM runs out of memory...
> > 
> > A few years ago there were several people proposing various solutions
> > for allowing these daemons to run in a protected memory environment to
> > avoid deadlocks, but those efforts have since petered out. Perhaps it is
> > time to review the problem?
> 
> I saw some patches targeting 2.6.35 that should prevent some deadlocks. They
> seem to be not enough in some cases. rpc.* daemons should be mlocked for sure
> but there is a problem with libkrb that reads files using fread(). fread() uses
> anonymous mmap, under mlockall(MCL_FUTURE) this causes the anonymous map to be
> mapped instantly and it deadlocks. 
> 
> IBM GPFS also uses userspace daemon, but it seems that the deamon is mlocked
> and it does not open any files and does not create new connections. 

Doesn't matter. Just writing to a socket or pipe may trigger a kernel
memory allocation which can result in an attempt to reclaim memory.
Furthermore, there is the issue of what to do when you really are OOM,
and the kernel cannot allocate more memory for you without reclaiming
it.

The schemes I'm talking about typically had special memory pools
preallocated for use by daemons, and would label the daemons using some
equivalent of the PF_MEMALLOC flag to prevent recursion into the
filesystem.


