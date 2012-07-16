Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2GPCWx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 22:22:53 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:50695 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2GPCWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 22:22:51 -0400
Message-ID: <1342405366.7659.35.camel@marge.simpson.net>
Subject: Re: Deadlocks due to per-process plugging
From: Mike Galbraith <mgalbraith@novell.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jan Kara <jack@suse.cz>, Jeff Moyer <jmoyer@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>,
        mgalbraith@suse.com
Date: Mon, 16 Jul 2012 04:22:46 +0200
In-Reply-To: <1342343673.28142.2.camel@marge.simpson.net>
References: <20120711133735.GA8122@quack.suse.cz>
	 <x49ehoii8ps.fsf@segfault.boston.devel.redhat.com>
	 <20120711201601.GB9779@quack.suse.cz>
	 <alpine.LFD.2.02.1207121552111.32033@ionos>
	 <20120713123318.GB20361@quack.suse.cz>
	 <alpine.LFD.2.02.1207131444490.32033@ionos>
	 <20120713144622.GB28715@quack.suse.cz>
	 <alpine.LFD.2.02.1207151057010.32033@ionos>
	 <1342343673.28142.2.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-07-15 at 11:14 +0200, Mike Galbraith wrote: 
> On Sun, 2012-07-15 at 10:59 +0200, Thomas Gleixner wrote: 

> > Can you figure out on which lock the stuck thread which did not unplug
> > due to tsk_is_pi_blocked was blocked?
> 
> I'll take a peek.

Sorry for late reply, took a half day away from box.  Jan had already
done the full ext3 IO deadlock analysis:

Again kjournald is waiting for buffer IO on block 4367635 (sector
78364838) to finish.  Now it is dbench thread 0xffff88026f330e70 which
has submitted this buffer for IO and is still holding this buffer behind
its plug (request for sector 78364822..78364846). The dbench thread is
waiting on j_checkpoint mutex (apparently it has successfully got the
mutex in the past, checkpointed some buffers, released the mutex and
hung when trying to acquire it again in the next loop of
__log_wait_for_space()). 

-Mike

