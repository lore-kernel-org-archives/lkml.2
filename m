Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2BDCIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 21:08:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58341 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895Ab2BDCIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 21:08:23 -0500
Date: Sat, 4 Feb 2012 11:08:17 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Avi Kivity <avi@redhat.com>, KVM list <kvm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
Message-Id: <20120204110817.30e1a4c62754f074a8a5064d@gmail.com>
In-Reply-To: <4F2B41D6.8020603@codemonkey.ws>
References: <4F2AB552.2070909@redhat.com>
	<4F2B41D6.8020603@codemonkey.ws>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hope to get comments from live migration developers,

Anthony Liguori <anthony@codemonkey.ws> wrote:

> > Guest memory management
> > -----------------------
> > Instead of managing each memory slot individually, a single API will be
> > provided that replaces the entire guest physical memory map atomically.
> > This matches the implementation (using RCU) and plugs holes in the
> > current API, where you lose the dirty log in the window between the last
> > call to KVM_GET_DIRTY_LOG and the call to KVM_SET_USER_MEMORY_REGION
> > that removes the slot.
> >
> > Slot-based dirty logging will be replaced by range-based and work-based
> > dirty logging; that is "what pages are dirty in this range, which may be
> > smaller than a slot" and "don't return more than N pages".
> >
> > We may want to place the log in user memory instead of kernel memory, to
> > reduce pinned memory and increase flexibility.
> 
> Since we really only support 64-bit hosts, what about just pointing the kernel 
> at a address/size pair and rely on userspace to mmap() the range appropriately?
> 

Seems reasonable but the real problem is not how to set up the memory:
the problem is how to set a bit in user-space.

We need two things:
	- introducing set_bit_user()
	- changing mmu_lock from spin_lock to mutex_lock
	  (mark_page_dirty() can be called with mmu_lock held)

The former is straightforward and I sent a patch last year.
The latter needs a fundamental change:  I heard (from Avi) that we can
change mmu_lock to mutex_lock if mmu_notifier becomes preemptible.

So I was planning to restart this work when Peter's
	"mm: Preemptibility"
	http://lkml.org/lkml/2011/4/1/141
gets finished.

But even if we cannot achieve "without pinned memory" we may also want
to make the user-space know how many pages are getting dirty.

For example think about the last step of live migration.  We stop the
guest and send the remaining pages.  For this we do not need to write
protect them any more, just want to know which ones are dirty.

If user-space can read the bitmap, it does not need to do GET_DIRTY_LOG
because the guest is already stopped, so we can reduce the downtime.

Is this correct?


So I think we can do this in two steps:
	1. just move the bitmap to user-space and (pin it)
	2. un-pin it when the time comes

I can start 1 after "srcu-less dirty logging" gets finished.


	Takuya
