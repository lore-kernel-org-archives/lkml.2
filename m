Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052Ab2GPJsX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 05:48:23 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:25621 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542Ab2GPJsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 05:48:19 -0400
Message-ID: <1342432094.7659.39.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <mgalbraith@novell.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Mon, 16 Jul 2012 11:48:14 +0200
In-Reply-To: <alpine.LFD.2.02.1207161058550.32033@ionos>
References: <20120711133735.GA8122@quack.suse.cz>
	  <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	  <20120711201601.GB9779@quack.suse.cz>
	  <alpine.LFD.2.02.1207121552111.32033@ionos>
	  <20120713123318.GB20361@quack.suse.cz>
	  <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	  <alpine.LFD.2.02.1207151057010.32033@ionos>
	  <1342343673.28142.2.camel@marge.simpson.net>
	 <1342405366.7659.35.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161058550.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 10:59 +0200, Thomas Gleixner wrote: 
> On Mon, 16 Jul 2012, Mike Galbraith wrote:
> > On Sun, 2012-07-15 at 11:14 +0200, Mike Galbraith wrote: 
> > > On Sun, 2012-07-15 at 10:59 +0200, Thomas Gleixner wrote: 
> > 
> > > > Can you figure out on which lock the stuck thread which did not unplug
> > > > due to tsk_is_pi_blocked was blocked?
> > > 
> > > I'll take a peek.
> > 
> > Sorry for late reply, took a half day away from box.  Jan had already
> > done the full ext3 IO deadlock analysis:
> > 
> > Again kjournald is waiting for buffer IO on block 4367635 (sector
> > 78364838) to finish.  Now it is dbench thread 0xffff88026f330e70 which
> > has submitted this buffer for IO and is still holding this buffer behind
> > its plug (request for sector 78364822..78364846). The dbench thread is
> > waiting on j_checkpoint mutex (apparently it has successfully got the
> > mutex in the past, checkpointed some buffers, released the mutex and
> > hung when trying to acquire it again in the next loop of
> > __log_wait_for_space()). 
> 
> And what's holding j_checkpoint mutex and not making progress?

Waiting for wakeup from kjournald.

crash> bt 0xffff880189dd9560
PID: 33382  TASK: ffff880189dd9560  CPU: 3   COMMAND: "dbench"
#0 [ffff880274b61898] schedule at ffffffff8145178e
#1 [ffff880274b61a00] log_wait_commit at ffffffffa0174205 [jbd]
#2 [ffff880274b61a80] __process_buffer at ffffffffa017291b [jbd]
#3 [ffff880274b61ab0] log_do_checkpoint at ffffffffa0172bba [jbd]
#4 [ffff880274b61d20] __log_wait_for_space at ffffffffa0172dcf [jbd]
#5 [ffff880274b61d70] start_this_handle at ffffffffa016ebdf [jbd]
#6 [ffff880274b61e10] journal_start at ffffffffa016f11e [jbd]
#7 [ffff880274b61e40] ext3_unlink at ffffffffa01af757 [ext3]
#8 [ffff880274b61e80] vfs_unlink at ffffffff8115febc
#9 [ffff880274b61ea0] do_unlinkat at ffffffff811645ad
#10 [ffff880274b61f80] system_call_fastpath at ffffffff8145ad92
    RIP: 00007f811338dc37  RSP: 00007fffe247ef78  RFLAGS: 00010216
    RAX: 0000000000000057  RBX: ffffffff8145ad92  RCX: 000000000000000a
    RDX: 0000000000000000  RSI: 00007fffe247eef0  RDI: 0000000000608a10
    RBP: 00007fffe247f830   R8: 0000000000000006   R9: 0000000000000010
    R10: 0000000000000000  R11: 0000000000000206  R12: 00007f811384fc70
    R13: 00007fffe247f17c  R14: 0000000000608a10  R15: 0000000000000000
    ORIG_RAX: 0000000000000057  CS: 0033  SS: 002b


