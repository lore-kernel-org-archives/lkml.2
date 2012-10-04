Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab2JDTiG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:38:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41847 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756606Ab2JDTiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:38:03 -0400
Date: Thu, 4 Oct 2012 12:37:59 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com, pjt@google.com
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121004193759.GZ26488@google.com>
References: <20121001222341.GF26488@google.com>
 <x49zk44ojpe.fsf@segfault.boston.devel.redhat.com>
 <20121003002029.GY26488@google.com>
 <x49sj9vtlip.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49sj9vtlip.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 03:15:26PM -0400, Jeff Moyer wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> 
> > On Tue, Oct 02, 2012 at 01:41:17PM -0400, Jeff Moyer wrote:
> >> Kent Overstreet <koverstreet@google.com> writes:
> >> 
> >> > So, I and other people keep running into things where we really need to
> >> > add an interface to pass some auxiliary... stuff along with a pread() or
> >> > pwrite().
> >> >
> >> > A few examples:
> >> >
> >> > * IO scheduler hints. Some userspace program wants to, per IO, specify
> >> > either priorities or a cgroup - by specifying a cgroup you can have a
> >> > fileserver in userspace that makes use of cfq's per cgroup bandwidth
> >> > quotas.
> >> 
> >> You can do this today by splitting I/O between processes and placing
> >> those processes in different cgroups.  For io priority, there is
> >> ioprio_set, which incurs an extra system call, but can be used.  Not
> >> elegant, but possible.
> >
> > Yes - those are things I'm trying to replace. Doing it that way is a
> > real pain, both as it's a lousy interface for this and it does impact
> > performance (ioprio_set doesn't really work too well with aio, too).
> 
> ioprio_set works fine with aio, since the I/O is issued in the caller's
> context.  Perhaps you're thinking of writeback I/O?

Until you want to issue different IOs with different priorities...

> >> > * Cache hints. For bcache and other things, userspace may want to specify
> >> > "this data should be cached", "this data should bypass the cache", etc.
> >> 
> >> Please explain how you will differentiate this from posix_fadvise.
> >
> > Oh sorry, I think about SSD caching so much I forget to say that's what
> > I'm talking about. posix_fadvise is for the page cache, we want
> > something different for an SSD cache (IMO it'd be really ugly to use it
> > for both, and posix_fadvise() can't really specifify everything we'd
> > want to for an SSD cache).
> 
> DESCRIPTION
>        Programs can use posix_fadvise() to announce an intention to
>        access file data in a specific pattern in the future, thus
>        allowing the kernel to perform appropriate optimizations.
> 
> That description seems broad enough to include disk caches as well.  You
> haven't exactly stated what's missing.

It _could_ work for SSD caches, but that doesn't mean you'd want it to -
it doesn't have any way of specifying which cache you want the hint to
apply to, and there are certainly circumstances under which you
_wouldn't_ want it to apply to both.

And making it apply to SSD caches would be silently changing the
behavior, and also like I mentioned it's not sufficient for SSD caches.

> >> > Hence, AIO attributes.
> >> 
> >> *No.*  Start with the non-AIO case first.
> >
> > Why? It is orthogonal to AIO (and I should make that clearer), but to do
> > it for sync IO we'd need new syscalls that take an extra argument so IMO
> > it's a bit easier to start with AIO.
> >
> > Might be worth implementing the sync interface sooner rather than later
> > just to discover any potential issues, I suppose.
> 
> Looking back to preadv and pwritev, it was wrong to only add them to
> libaio (and that later got corrected).  I'd just like to see things
> start out with the sync interfaces, since you'll get more eyes on the
> code (not everyone cares about aio) and that helps to work out any
> interface issues.

I agree we don't want to leave out sync versions, but honestly this
stuff is more useful with AIO and that's the easier place to start.

> > It's not possible in general - consider stacking block devices, and
> > attrs that are supported only by specific block drivers. I.e. if you've
> > got lvm on top of bcache or bcache on top of md, we can pass the attr
> > down with the IO but we can't determine ahead of time, in general, where
> > the IO is going to go.
> 
> If the io stack is static (meaning you setup a device once, then open it
> and do io to it, and it doesn't change while you're doing io), how would
> you not know where the IO is going to go?

With something like dm, md or bcache - you've got multiple underlying
devices, and of those underlying devices which one the IO goes to is not
something you can in general predict ahead of time.

> > But that probably isn't true for most attrs so it probably would be a
> > good idea to have an interface for querying what's supported, and even
> > for device specific ones you could query what a device supports.
> 
> OK.
> 
> >> > One could imagine sticking the return in the attribute itself, but I
> >> > don't want to do this. For some things (checksums), the attribute will
> >> > contain a pointer to a buffer - that's fine. But I don't want the
> >> > attributes themselves to be writeable.
> >> 
> >> One could imagine that attributes don't return anything, because, well,
> >> they're properties of something else, and properties don't return
> >> anything.
> >
> > With a strict definition of attribute, yeah. One of the real uses cases
> > we have for this is per IO timings, for aio - right now we've got an
> > interface for the kernel to tell userspace how long a syscall took
> > (don't think it's upstream yet - Paul's been behind that stuff), but it
> > only really makes sense with synchronous syscalls.
> 
> Something beyond recording the time spent in the kernel?  Paul who?  I
> agree the per io timing for aio may be coarse-grained today (you can
> time the difference between io_submit returning and the event being
> returned by io_getevents, but that says nothing of when the io was
> issued to the block layer).  I'm curious to know exactly what
> granularity you want here, and what an application would do with that
> information.  You can currently access a whole lot of detail of the io
> path through blktrace, but that is not easily done from within an
> application.

Paul Turner, scheduler guy. 

Believe it's both syscall time and IO time (i.e. what you'd get from
blktrace). It's basically used for visibility in filesystem type stuff,
for monitoring latency - rpc latency isn't enough, you really need to
know why things are slow and that could be as simple as a disk going
bad.
