Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab2FKSKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:10:47 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:57760 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab2FKSKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:10:46 -0400
Message-ID: <1339438242.7358.62.camel@marge.simpson.net>
Subject: Re: rcu: endless stalls
From: Mike Galbraith <mgalbraith@novell.com>
To: paulmck@linux.vnet.ibm.com
Cc: LKML <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@suse.cz>
Date: Mon, 11 Jun 2012 20:10:42 +0200
In-Reply-To: <20120611180112.GD2521@linux.vnet.ibm.com>
References: <1339409176.7350.26.camel@marge.simpson.net>
	 <20120611133953.GI2425@linux.vnet.ibm.com>
	 <1339424543.7350.101.camel@marge.simpson.net>
	 <1339435214.7358.43.camel@marge.simpson.net>
	 <20120611180112.GD2521@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 11:01 -0700, Paul E. McKenney wrote: 
> On Mon, Jun 11, 2012 at 07:20:14PM +0200, Mike Galbraith wrote:
> > On Mon, 2012-06-11 at 16:22 +0200, Mike Galbraith wrote: 
> > > On Mon, 2012-06-11 at 06:39 -0700, Paul E. McKenney wrote: 
> > > > On Mon, Jun 11, 2012 at 12:06:16PM +0200, Mike Galbraith wrote:
> > > > > Greetings,
> > > > > 
> > > > > I received a report of a 48 core UV box hitting a gripe, taking longer
> > > > > than timeout to emit same, so box griped endlessly, forcing reboot.
> > > > 
> > > > So it took minutes to print an RCU CPU stall warning?  On only 48 CPUs?
> > > > 
> > > > If so, yow!!!
> > > 
> > > The report was a tad fuzzy on details, but serial console can take a
> > > while at low baud rate, and the box was apparently perma-stalled.
> > 
> > Gee, no wonder it took a while to emit the gripe, there were a few more
> > than 48 CPUs actually.. 4048 more to be precise.
> > 
> > 4096 tasks on 4096 CPUs all hammering wait_lock at once r!pretty.
> 
> That would be bad...
> 
> BTW, one other thing on the patch -- it needs to use a separate flag,
> otherwise there are races with sysfs and panic() updates to the flag.
> 
> > 2aa15890 - mm: prevent concurrent unmap_mapping_range() on the same inode
> 
> I confess, you lost me on this one.  You believe that this commit is
> the cause of the RCU CPU stall warnings?

4096 tasks on 4096 CPUs exit (well, try to) simultaneously.

Call Trace:
                __mutex_lock_slowpath+0x94/0x150
                mutex_lock+0x1a/0x40
                unlink_file_vma+0x3f/0xf0
                free_pgtables+0x40/0x100
                exit_mmap+0xb0/0x120
                mmput+0x49/0x120
                exit_mm+0x122/0x160
                do_exit+0x179/0x8d0
                do_group_exit+0x3d/0xb0
                sys_exit_group+0x12/0x20

Monster box dies screaming.

-Mike

