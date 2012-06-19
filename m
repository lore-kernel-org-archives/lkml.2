Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2FSVJe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 17:09:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab2FSVJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 17:09:32 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Wanpeng Li <liwp.linux@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gavin Shan <shangw@linux.vnet.ibm.com>
Subject: Re: [PATCH V2] writeback: fix hung_task alarm when sync block
References: <1339562553-10035-1-git-send-email-liwp.linux@gmail.com>
	<x49txyf8exl.fsf@segfault.boston.devel.redhat.com>
	<20120613144840.GA3055@localhost>
	<x49lijr8bur.fsf@segfault.boston.devel.redhat.com>
	<20120614133600.GB14883@localhost>
	<x491ulbjbzb.fsf@segfault.boston.devel.redhat.com>
	<20120619210212.GN25389@dastard>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 19 Jun 2012 17:09:22 -0400
In-Reply-To: <20120619210212.GN25389@dastard> (Dave Chinner's message of "Wed,
	20 Jun 2012 07:02:12 +1000")
Message-ID: <x49vcinhuv1.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Chinner <david@fromorbit.com> writes:

> On Tue, Jun 19, 2012 at 04:14:16PM -0400, Jeff Moyer wrote:
>> Fengguang Wu <fengguang.wu@intel.com> writes:
>> 
>> > Good idea! Yes we can do some estimation and adaptively extend the
>> > hang timeout for the current writeback_inodes_sb_nr()/sync_inodes_sb()
>> > call.
>> >
>> > Note that it's not going to reliably get rid of false warnings due to
>> > estimation errors, which could be pretty large and unavoidable on
>> > change of workload. But still, it would be a net improvement and
>> > perhaps enough to get rid of most false warnings, while still being
>> > able to catch livelock or other kind of task hang.
>> 
>> Hi, Fengguang,
>> 
>> I didn't see a patch from you for this, so I went ahead and threw
>> something together.  Let me know what you think of it.  I wasn't sure
>> how to estimate the total I/O that will be issued for syncing out an
>> entire superblock, though, so I didn't do that part.
>
> As I said to the original patch - having a hang check timeout on a
> system that is overloaded w.r.t. IO is an important piece of
> information when it comes to debugging problems. Often the hangcheck
> timer is the first piece of information that we will get that
> indicates a problem somewhere in a production system.

So, you believe that we should always check at 2 minute intervals (or
whatever is configured), even if we know there is more than that much
I/O queued?  In case there is any confusion, here, the patch I posted
ensured that we would eventually spew a warning, but only if the process
was blocked for longer than we (the kernel) expected.

> Removing it does not magically fix the underlying problem - it
> simply means that we don't hear about them until someone complains
> that unmount is taking hours....

There isn't necessarily an underlying problem.  This is very much a gray
area, Dave.  We get plenty of false positives in this code.  I was
trying to reduce *that* problem.  Do you have a better idea on how to
address the issue?

Maybe this discussion requires looking at specific instances of the
problem so we're all on the same page.  What do you think is the best
way forward, here?

Cheers,
Jeff
