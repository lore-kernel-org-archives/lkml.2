Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751963Ab2GPKNL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 06:13:11 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:45516 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab2GPKNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 06:13:10 -0400
Message-ID: <1342433585.7659.46.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <mgalbraith@novell.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Mon, 16 Jul 2012 12:13:05 +0200
In-Reply-To: <alpine.LFD.2.02.1207161157510.32033@ionos>
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
	 <1342432094.7659.39.camel@marge.simpson.net>
	 <alpine.LFD.2.02.1207161157510.32033@ionos>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 11:59 +0200, Thomas Gleixner wrote: 
> On Mon, 16 Jul 2012, Mike Galbraith wrote:
> > On Mon, 2012-07-16 at 10:59 +0200, Thomas Gleixner wrote: 
> > > On Mon, 16 Jul 2012, Mike Galbraith wrote:
> > > > On Sun, 2012-07-15 at 11:14 +0200, Mike Galbraith wrote: 
> > > > > On Sun, 2012-07-15 at 10:59 +0200, Thomas Gleixner wrote: 
> > > > 
> > > > > > Can you figure out on which lock the stuck thread which did not unplug
> > > > > > due to tsk_is_pi_blocked was blocked?
> > > > > 
> > > > > I'll take a peek.
> > > > 
> > > > Sorry for late reply, took a half day away from box.  Jan had already
> > > > done the full ext3 IO deadlock analysis:
> > > > 
> > > > Again kjournald is waiting for buffer IO on block 4367635 (sector
> > > > 78364838) to finish.  Now it is dbench thread 0xffff88026f330e70 which
> > > > has submitted this buffer for IO and is still holding this buffer behind
> > > > its plug (request for sector 78364822..78364846). The dbench thread is
> > > > waiting on j_checkpoint mutex (apparently it has successfully got the
> > > > mutex in the past, checkpointed some buffers, released the mutex and
> > > > hung when trying to acquire it again in the next loop of
> > > > __log_wait_for_space()). 
> > > 
> > > And what's holding j_checkpoint mutex and not making progress?
> > 
> > Waiting for wakeup from kjournald.
> 
> So kicking the io in __log_wait_for_space()
> 
>                 spin_unlock(&journal->j_state_lock);
> 
> 		--> HERE
> 
>                 mutex_lock(&journal->j_checkpoint_mutex);
> 
> should fix the issue, right ?

Should for this scenario.  Jan said he could think of ways to likely
make the same happen in xfs.

-Mike

