Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378Ab2FMEcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:32:18 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:60311 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab2FMEcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:32:16 -0400
Date: Tue, 12 Jun 2012 21:31:45 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Mike Galbraith <efault@gmx.de>
cc: paulmck@linux.vnet.ibm.com, LKML <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>
Subject: Re: rcu: endless stalls
In-Reply-To: <1339558508.7472.26.camel@marge.simpson.net>
Message-ID: <alpine.LSU.2.00.1206122120460.5221@eggly.anvils>
References: <1339409176.7350.26.camel@marge.simpson.net> <20120611133953.GI2425@linux.vnet.ibm.com> <1339424543.7350.101.camel@marge.simpson.net> <1339435214.7358.43.camel@marge.simpson.net> <20120611180112.GD2521@linux.vnet.ibm.com> <1339438242.7358.62.camel@marge.simpson.net>
 <1339558508.7472.26.camel@marge.simpson.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2012, Mike Galbraith wrote:
> On Mon, 2012-06-11 at 20:10 +0200, Mike Galbraith wrote: 
> > On Mon, 2012-06-11 at 11:01 -0700, Paul E. McKenney wrote: 
> 
> > > > 2aa15890 - mm: prevent concurrent unmap_mapping_range() on the same inode
> > > 
> > > I confess, you lost me on this one.  You believe that this commit is
> > > the cause of the RCU CPU stall warnings?
> > 
> > 4096 tasks on 4096 CPUs exit (well, try to) simultaneously.
> > 
> > Call Trace:
> >                 __mutex_lock_slowpath+0x94/0x150
> >                 mutex_lock+0x1a/0x40
> >                 unlink_file_vma+0x3f/0xf0
> >                 free_pgtables+0x40/0x100
> >                 exit_mmap+0xb0/0x120
> >                 mmput+0x49/0x120
> >                 exit_mm+0x122/0x160
> >                 do_exit+0x179/0x8d0
> >                 do_group_exit+0x3d/0xb0
> >                 sys_exit_group+0x12/0x20
> > 
> > Monster box dies screaming.
> 
> That commit landed in stable, box with way too many cores (NR_CPUS=0!!)
> chokes instantly with loads of spinners.  Ok, so zillion CPUs grabbing a
> mutex in lockstep is a bad idea (_having_ zillion?), but is there pilot
> error involved in a logjam like this?

Surely some mistake...

I can't find any mention of which kernel release you're talking about.

But Miklos's 2aa15890 unmap_mutex was introduced in 2.6.38 and removed
in 3.0, when PeterZ converted i_mmap_lock to i_mmap_mutex, and removed
the need for the additional unmap_mutex.

The unmap_mutex would never have been taken in unlink_file_vma(),
shown in your stacktrace above: it was for truncation and invalidation.

The likely mutex in unlink_file_vma() would be the i_mmap_mutex.
So I expect you're talking about a 3.0 or later kernel.

But then why would someone "backport" Miklos's patch to stable for it?

You lost me too!

Hugh
