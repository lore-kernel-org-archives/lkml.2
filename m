Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756683Ab2ADSNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 13:13:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:53273 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754503Ab2ADSNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 13:13:42 -0500
Date: Wed, 4 Jan 2012 13:13:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
        Eric Biederman <ebiederm@xmission.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Sysfs attributes racing with unregistration
In-Reply-To: <20120104171842.GN31746@google.com>
Message-ID: <Pine.LNX.4.44L0.1201041300130.1505-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jan 2012, Tejun Heo wrote:

> Hello, Alan.
> 
> On Wed, Jan 04, 2012 at 11:52:20AM -0500, Alan Stern wrote:
> > Can you explain the current situation regarding access to sysfs
> > attributes and possible races with kobject removal?  I have two
> > questions in particular:
> 
> Heh, I haven't looked at sysfs code seriously for years now and my
> memory sucks to begin with, so please take whatever I say with a
> gigantic grain of salt.  Eric has been looking at sysfs a lot lately
> so he probably can answer these best.  Adding him, Greg and Kay - hi!
> guys.
> 
> > 	What happens if one thread calls an attribute's show or
> > 	store method concurrently with another thread unregistering
> > 	the underlying kobject?
> 
> sysfs nodes have two reference counts - one for object lifespan and
> the other for active usage.  The latter is called active and acquired
> and released using sysfs_get/put_active().  Any callback invocation
> should be performed while holding an active reference.  On removal,
> sysfs_deactivate() marks the active reference count for deactivation
> so that no new active reference is given out and waits for the
> in-flight ones to drain.  IOW, removal makes sure new invocations of
> callbacks fail and waits for in-progress ones to finish before
> proceeding with removal.
> 
> > 	What happens if a thread continues to hold an open fd 
> > 	reference to a sysfs attribute file after the kobject is
> > 	unregistered, and then tries to read or write that fd?
> 
> Active reference is held only for the duration of each callback
> invocation.  Userland can't prolong the existence of active reference.
> The duration of callback execution is the only deciding factor.
> 
> Someone (I think Eric, right?) was trying to generalize the semantics
> to vfs layer so that severance/revocation capability is generally
> available.  IIRC, it didn't get through tho.

That's great; it's just what I wanted to know.  Thanks.

Now, looking through the code, I wonder why sysfs_{get,put}_active() 
and sysfs_deactivate() don't use a real rwsem.  Why go to all the 
effort of imitating one?  Is it just to save space?

Alan Stern

