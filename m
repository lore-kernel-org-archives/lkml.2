Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380Ab2DYV7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 17:59:41 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:54118 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab2DYV7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 17:59:40 -0400
Date: Wed, 25 Apr 2012 14:59:36 -0700
From: Tejun Heo <tj@kernel.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep false positive in sysfs
Message-ID: <20120425215936.GC8989@google.com>
References: <Pine.LNX.4.44L0.1204251436140.1206-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1204251436140.1206-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alan.

On Wed, Apr 25, 2012 at 02:58:28PM -0400, Alan Stern wrote:
> Peter and Tejun:
> 
> Here's my problem, which affects several sysfs attribute methods in the 
> USB subsystem:
> 
> Sysfs attribute A is attached to a USB device D.  When the user writes
> to A, the corresponding store method unregisters D's children (it does
> not unregister D, though).
> 
> Now, some of these children may also be USB devices (i.e., if D is a
> hub), and therefore may have the same set of sysfs attributes.  As a
> result, A's store method for D will end up removing the A attribute for
> device E, where E is a child of D.
> 
> This causes lockdep to complain.  When A's method is called, sysfs
> tells lockdep that it holds a readlock for the s_active "rwsem"
> associated with the A attribute for D.  However the sysfs routine that
> removes attributes tells lockdep that it is going to get a writelock
> for the s_active associated with the A attribute for E, which is in the
> same lockdep class since it belongs to the same attribute.

Hmmm.... This happens because, by default, sysfs_dirents for the same
attr share the same lockdep key.  This happens from
sysfs_dirent_init_lockdep().  Hmm.... we can,

* Somehow assign different keys to sysfs_dirents for the specific
  attr.  Use array of attrs indexed by bus depth?

* Add a flag / whatever to attr indicating that the files of the
  attribute may be removed recursively (lockdep-wise) and update
  either read or write path to use subclass.

Any better ideas?

Thanks.

-- 
tejun
