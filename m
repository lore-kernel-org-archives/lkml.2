Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab2DSVbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:31:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59578 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab2DSVbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:31:33 -0400
Date: Thu, 19 Apr 2012 14:31:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Chinner <david@fromorbit.com>
Cc: Andi Kleen <andi@firstfloor.org>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/13] XFS: Fix lock ASSERT on UP
Message-Id: <20120419143131.651abe44.akpm@linux-foundation.org>
In-Reply-To: <20120330041348.GF18323@dastard>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
	<1332895637-32572-6-git-send-email-andi@firstfloor.org>
	<20120329232114.GA26342@infradead.org>
	<20120329235201.GF17822@one.firstfloor.org>
	<20120330041348.GF18323@dastard>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012 15:13:48 +1100
Dave Chinner <david@fromorbit.com> wrote:

> On Fri, Mar 30, 2012 at 01:52:01AM +0200, Andi Kleen wrote:
> > On Thu, Mar 29, 2012 at 07:21:14PM -0400, Christoph Hellwig wrote:
> > > On Tue, Mar 27, 2012 at 05:47:09PM -0700, Andi Kleen wrote:
> > > > From: Andi Kleen <ak@linux.intel.com>
> > > > 
> > > > ASSERT(!spin_is_locked()) doesn't work on UP builds. Replace with a standard
> > > > lockdep_assert_held()
> > > 
> > > The "standard" is assert_spin_locked() - which not only is much cheaper
> > > but also has the advantage of working in non-lockdep builds.
> > 
> > But then you have it unconditional, not just on debug builds.
> 
> And the problem with that is what? There is so little overhead to the
> check it doesn't matter that it is enabled in production kernels...
> 

(old thread)

Perhaps assert_spin_locked() would be better - any advantages of
lockdep_assert_held() don't seem to outweigh the cost of using a new
interface.

And I'm not sure that I buy the performance argument - if an assertion
is in such a hot path, just remove the dang thing.


OTOH, one argument in favour of using lockdep_assert_held() is that
(afaict) it applies to spinlocks and to mutexes and to rw_semaphores. 
Not sure about rwlocks?

Now, having an API which can apply to different types is a bit
unpleasant - this ain't C++.  I think we should overlay
lockdep_assert_held() with a properly-typed API written in C and slap
the lockdep guys.  But the fact that this mechanism applies to all(?)
lock types is attractive.

Anyway, these patches are still floating around in my tree so please
let's finish this off one way or another.

