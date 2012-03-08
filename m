Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2CHBbu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:31:50 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948Ab2CHBbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:31:49 -0500
Date: Wed, 7 Mar 2012 20:32:17 -0500
From: Jason Baron <jbaron@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: mcgrathr@google.com, avi@redhat.com, linux-kernel@vger.kernel.org,
        qemu-devel@nongnu.org
Subject: Re: [PATCH 0/2] core dump: re-purpose VM_ALWAYSDUMP to user
 controlled VM_DONTDUMP
Message-ID: <20120308013217.GA2443@redhat.com>
References: <cover.1331137504.git.jbaron@redhat.com>
 <20120307143028.5dc27570.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120307143028.5dc27570.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 02:30:28PM -0800, Andrew Morton wrote:
> On Wed, 7 Mar 2012 12:00:46 -0500
> Jason Baron <jbaron@redhat.com> wrote:
> 
> > Hi,
> > 
> > The motivation for this change was that I was looking at a way for a qemu-kvm
> > process, to exclude the guest memory from its core dump, which can be quite
> > large. There are already a number of filter flags in
> > /proc/<pid>/coredump_filter, however, these allow one to specify 'types' of
> > kernel memory, not specific address ranges (which is needed in this case).
> > 
> > Since there are no more vma flags available, the first patch eliminates the
> > need for the 'VM_ALWAYSDUMP' flag. The flag is used internally by the kernel to
> > mark vdso and vsyscall pages. However, it is simple enough to check if a vma
> > covers a vdso or vsyscall page without the need for this flag.
> 
> Gee, we ran out?
> 
> That makes it pretty inevitable that we will grow the vma by four
> bytes.  Once we have done that, your always_dump_vma() trickery becomes
> unneeded and undesirable, yes?  If so, we may as well recognise reality
> and grow the vma now.
> 

We could. The reason I didn't propose increasing them was because I saw
in the archives that there was resistance when this was tried before:
http://lkml.indiana.edu/hypermail/linux/kernel/1111.1/02053.html

Also, the current use of 'VM_ALWAYSDUMP' is for vdso and gate pages
exclusively. That means that VM_ALWAYSDUMP flag is 0 the majority of the
time, and thus it probably makes sense to re-purpose it, now that we are
tight on flags.

> > The second patch then replaces the 'VM_ALWAYSDUMP' flag with a new 
> > 'VM_DONTDUMP' flag, which can be set by userspace using new madvise flags:
> > 'MADV_DONTDUMP', and unset via 'MADV_DUMP'. The core dump filters continue to
> > work the same as before unless 'MADV_DONTDUMP' is set on the region.
> > 
> > The qemu code which implements this features is at:
> > http://people.redhat.com/~jbaron/qemu-dump/qemu-dump.patch
> > 
> > In my testing the qemu core dump shrunk from 383MB -> 13MB with this patch.
> > 
> > I also believe that the 'MADV_DONTDUMP' flag might be useful for security
> > sensitive apps, which might want to select which areas are dumped.
> > 
> 
> Is there any way for userspace to query the state of the flag?  
> 

A place for that might be /proc/<pid>/maps, but I don't think any of
the other vm flags are exposed.

Thanks,

-Jason
