Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2D0P5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:57:06 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34978 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754820Ab2D0P5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:57:04 -0400
Date: Fri, 27 Apr 2012 11:57:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tejun Heo <tj@kernel.org>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
In-Reply-To: <20120426221753.GF27486@google.com>
Message-ID: <Pine.LNX.4.44L0.1204271147330.1690-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012, Tejun Heo wrote:

> On Thu, Apr 26, 2012 at 02:14:30PM -0400, Alan Stern wrote:
> > > > Hmmm.... This happens because, by default, sysfs_dirents for the same
> > > > attr share the same lockdep key.  This happens from
> > > > sysfs_dirent_init_lockdep().  Hmm.... we can,
> > > >
> > > > * Somehow assign different keys to sysfs_dirents for the specific
> > > >   attr.  Use array of attrs indexed by bus depth?
> > > 
> > > Possible with sysfs_attr_init but pretty ugly.  Especially since it
> > > sounds like this is a situation that does not presuppose a maximum
> > > depth.  I do remember that the lockdep keys must be statically allocated
> > > which makes this a challenge.
> 
> The depth is limited by USB spec.
> 
> > I agree; this doesn't seem like a good approach.
> 
> It sure isn't pretty but probably best matches the situation in the
> sense that lockdep would actually be able to know about the nesting
> going on.

By the way, do you know why attribute structures allow for dynamic keys 
as well as static keys?  I see dynamic keys are used by attribute 
containers, but I don't understand why.

> > Another idea is to have A's method temporarily drop the sysfs readlock.  
> > Of course that would put the onus on the USB core of guaranteeing that
> > A cannot be removed while this happens, but we can handle that.
> 
> Yeah, that's an easier way out.  Please make it a proper sysfs API
> call tho so that people working on sysfs later can know of the special
> case.

I will.

Would it be better to release just the lockdep annotation while
continuing to hold the actual lock, or to really drop the lock?

Alan Stern

