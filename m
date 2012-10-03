Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab2JCAUg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 20:20:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:45493 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2JCAUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 20:20:33 -0400
Date: Tue, 2 Oct 2012 17:20:29 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>, Zach Brown <zab@zabbo.net>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com, pjt@google.com
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121003002029.GY26488@google.com>
References: <20121001222341.GF26488@google.com>
 <x49zk44ojpe.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49zk44ojpe.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:41:17PM -0400, Jeff Moyer wrote:
> Kent Overstreet <koverstreet@google.com> writes:
> 
> > So, I and other people keep running into things where we really need to
> > add an interface to pass some auxiliary... stuff along with a pread() or
> > pwrite().
> >
> > A few examples:
> >
> > * IO scheduler hints. Some userspace program wants to, per IO, specify
> > either priorities or a cgroup - by specifying a cgroup you can have a
> > fileserver in userspace that makes use of cfq's per cgroup bandwidth
> > quotas.
> 
> You can do this today by splitting I/O between processes and placing
> those processes in different cgroups.  For io priority, there is
> ioprio_set, which incurs an extra system call, but can be used.  Not
> elegant, but possible.

Yes - those are things I'm trying to replace. Doing it that way is a
real pain, both as it's a lousy interface for this and it does impact
performance (ioprio_set doesn't really work too well with aio, too).

> > * Cache hints. For bcache and other things, userspace may want to specify
> > "this data should be cached", "this data should bypass the cache", etc.
> 
> Please explain how you will differentiate this from posix_fadvise.

Oh sorry, I think about SSD caching so much I forget to say that's what
I'm talking about. posix_fadvise is for the page cache, we want
something different for an SSD cache (IMO it'd be really ugly to use it
for both, and posix_fadvise() can't really specifify everything we'd
want to for an SSD cache).

> > * Passing checksums out to userspace. We've got bio integrity, which is
> > a (somewhat) generic interface for passing data checksums between the
> > filesystem and the hardware. There are various circumstances under which
> > you may want to pass these checksums out to userspace, and if so we
> > ought to have a generic way of doing it.
> 
> Yes, that needs a new interface.
> 
> > Hence, AIO attributes.
> 
> *No.*  Start with the non-AIO case first.

Why? It is orthogonal to AIO (and I should make that clearer), but to do
it for sync IO we'd need new syscalls that take an extra argument so IMO
it's a bit easier to start with AIO.

Might be worth implementing the sync interface sooner rather than later
just to discover any potential issues, I suppose.


> > * FUTURE STUFF:
> >
> > Return values:
> >
> > Some attributes are probably going to want to return something to
> > userspace.
> >
> > If nothing else, we want this so that userspace can tell if anything
> > handled the attributes it specified - as dynamic as the io stack can be,
> > with something extensible like this there really isn't any generic way
> > of knowing ahead of time if something is going to interpret any
> > attribute - we want to return at least an error code.
> 
> Seems odd to me.  Why not expose supported attributes via some other
> call?  fcntl?

It's not possible in general - consider stacking block devices, and
attrs that are supported only by specific block drivers. I.e. if you've
got lvm on top of bcache or bcache on top of md, we can pass the attr
down with the IO but we can't determine ahead of time, in general, where
the IO is going to go.

But that probably isn't true for most attrs so it probably would be a
good idea to have an interface for querying what's supported, and even
for device specific ones you could query what a device supports.

> > One could imagine sticking the return in the attribute itself, but I
> > don't want to do this. For some things (checksums), the attribute will
> > contain a pointer to a buffer - that's fine. But I don't want the
> > attributes themselves to be writeable.
> 
> One could imagine that attributes don't return anything, because, well,
> they're properties of something else, and properties don't return
> anything.

With a strict definition of attribute, yeah. One of the real uses cases
we have for this is per IO timings, for aio - right now we've got an
interface for the kernel to tell userspace how long a syscall took
(don't think it's upstream yet - Paul's been behind that stuff), but it
only really makes sense with synchronous syscalls.

These AIO attributes would be useful for that too, but I'd _much_ prefer
if the timing information was explicitly returned instead of using a
pointer to a buffer.
