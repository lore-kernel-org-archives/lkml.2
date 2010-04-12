Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab0DLXFG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 19:05:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40987 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754006Ab0DLXFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 19:05:03 -0400
Date: Mon, 12 Apr 2010 16:03:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Eric B Munson <ebmunson@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
       rolandd@cisco.com, peterz@infradead.org, pavel@ucw.cz, mingo@elte.hu
Subject: Re: [PATCH] ummunotify: Userspace support for MMU notifications
Message-Id: <20100412160359.1d9074dc.akpm@linux-foundation.org>
In-Reply-To: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
References: <1271053337-7121-1-git-send-email-ebmunson@us.ibm.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Apr 2010 07:22:17 +0100
Eric B Munson <ebmunson@us.ibm.com> wrote:

> Andrew,
> 
> I am resubmitting this patch because I believe that the discussion
> has shown this to be an acceptable solution.

To whom?  Some acked-by's would clarify.

>  I have fixed the 32 bit
> build errors, but other than that change, the code is the same as
> Roland's V3 patch.
> 
> From: Roland Dreier <rolandd@cisco.com>
> 
> As discussed in <http://article.gmane.org/gmane.linux.drivers.openib/61925>
> and follow-up messages, libraries using RDMA would like to track
> precisely when application code changes memory mapping via free(),
> munmap(), etc.  Current pure-userspace solutions using malloc hooks
> and other tricks are not robust, and the feeling among experts is that
> the issue is unfixable without kernel help.

But this info could be reassembled by tracking syscall activity, yes? 
Perhaps some discussion here explaining why the (possibly enhanced)
ptrace, audit, etc interfaces are unsuitable.

> We solve this not by implementing the full API proposed in the email
> linked above but rather with a simpler and more generic interface,
> which may be useful in other contexts.  Specifically, we implement a
> new character device driver, ummunotify, that creates a /dev/ummunotify
> node.  A userspace process can open this node read-only and use the fd
> as follows:
> 
>  1. ioctl() to register/unregister an address range to watch in the
>     kernel (cf struct ummunotify_register_ioctl in <linux/ummunotify.h>).
> 
>  2. read() to retrieve events generated when a mapping in a watched
>     address range is invalidated (cf struct ummunotify_event in
>     <linux/ummunotify.h>).  select()/poll()/epoll() and SIGIO are
>     handled for this IO.
> 
>  3. mmap() one page at offset 0 to map a kernel page that contains a
>     generation counter that is incremented each time an event is
>     generated.  This allows userspace to have a fast path that checks
>     that no events have occurred without a system call.

OK, what's missing from this whole description and from ummunotify.txt
is: how does one specify the target process?  Does /dev/ummunotify
implicitly attach to current->mm?  If so, why, and what are the
implications of this?

If instead it is possible to attach to some other process's mmu
activity (/proc/<pid>/ummunotity?) then how is that done and what are
the security/permissions implications?

Also, the whole thing is obviously racy: by the time userspace finds
out that something has happened, it might have changed.  This
inevitably reduces the applicability/usefulness of the whole thing as
compared to some synchronous mechanism which halts the monitored thread
until the request has been processed and acked.  All this should (IMO)
be explored, explained and justified.

Also, what prevents the obvious DoS which occurs when I register for
events and just let them queue up until the kernel runs out of memory? 
presumably events get dropped - what are the reliability implications
of this and how is the max queue length managed?

Also, ioctls are unpopular.  Were other intefaces considered?

> Thanks to Jason Gunthorpe <jgunthorpe <at> obsidianresearch.com> for
> suggestions on the interface design.  Also thanks to Jeff Squyres
> <jsquyres <at> cisco.com> for prototyping support for this in Open MPI, which
> helped find several bugs during development.
> 
> Signed-off-by: Roland Dreier <rolandd@cisco.com>
> Signed-off-by: Eric B Munson <ebmunson@us.ibm.com>
> 
> ---
> 
> Changes since v3:
>  - Fixed replaced [get|put] user with copy_[from|to]_user to fix x86
>    builds
> ---
>  Documentation/Makefile                  |    3 +-
>  Documentation/ummunotify/Makefile       |    7 +
>  Documentation/ummunotify/ummunotify.txt |  150 ++++++++
>  Documentation/ummunotify/umn-test.c     |  200 +++++++++++
>  drivers/char/Kconfig                    |   12 +
>  drivers/char/Makefile                   |    1 +
>  drivers/char/ummunotify.c               |  567 +++++++++++++++++++++++++++++++
>  include/linux/ummunotify.h              |  121 +++++++
>  8 files changed, 1060 insertions(+), 1 deletions(-)
>  create mode 100644 Documentation/ummunotify/Makefile
>  create mode 100644 Documentation/ummunotify/ummunotify.txt
>  create mode 100644 Documentation/ummunotify/umn-test.c
>  create mode 100644 drivers/char/ummunotify.c
>  create mode 100644 include/linux/ummunotify.h
> 
> diff --git a/Documentation/Makefile b/Documentation/Makefile
> index 6fc7ea1..27ba76a 100644
> --- a/Documentation/Makefile
> +++ b/Documentation/Makefile
> @@ -1,3 +1,4 @@
>  obj-m := DocBook/ accounting/ auxdisplay/ connector/ \
>  	filesystems/ filesystems/configfs/ ia64/ laptops/ networking/ \
> -	pcmcia/ spi/ timers/ video4linux/ vm/ watchdog/src/
> +	pcmcia/ spi/ timers/ video4linux/ vm/ ummunotify/ \
> +	watchdog/src/
> diff --git a/Documentation/ummunotify/Makefile b/Documentation/ummunotify/Makefile
> new file mode 100644
> index 0000000..89f31a0
> --- /dev/null
> +++ b/Documentation/ummunotify/Makefile
> @@ -0,0 +1,7 @@
> +# List of programs to build
> +hostprogs-y := umn-test
> +
> +# Tell kbuild to always build the programs
> +always := $(hostprogs-y)
> +
> +HOSTCFLAGS_umn-test.o += -I$(objtree)/usr/include
> diff --git a/Documentation/ummunotify/ummunotify.txt b/Documentation/ummunotify/ummunotify.txt
> new file mode 100644
> index 0000000..78a79c2
> --- /dev/null
> +++ b/Documentation/ummunotify/ummunotify.txt
> @@ -0,0 +1,150 @@
> +UMMUNOTIFY
> +
> +  Ummunotify relays MMU notifier events to userspace.  This is useful
> +  for libraries that need to track the memory mapping of applications;
> +  for example, MPI implementations using RDMA want to cache memory
> +  registrations for performance, but tracking all possible crazy cases
> +  such as when, say, the FORTRAN runtime frees memory is impossible
> +  without kernel help.
> +
> +Basic Model
> +
> +  A userspace process uses it by opening /dev/ummunotify, which
> +  returns a file descriptor.  Interest in address ranges is registered
> +  using ioctl() and MMU notifier events are retrieved using read(), as
> +  described in more detail below.  Userspace can register multiple
> +  address ranges to watch, and can unregister individual ranges.
> +
> +  Userspace can also mmap() a single read-only page at offset 0 on
> +  this file descriptor.  This page contains (at offest 0) a single
> +  64-bit generation counter that the kernel increments each time an
> +  MMU notifier event occurs.  Userspace can use this to very quickly
> +  check if there are any events to retrieve without needing to do a
> +  system call.
> +
> +Control
> +
> +  To start using ummunotify, a process opens /dev/ummunotify in
> +  read-only mode.  Control from userspace is done via ioctl(); the
> +  defined ioctls are:
> +
> +    UMMUNOTIFY_EXCHANGE_FEATURES: This ioctl takes a single 32-bit
> +      word of feature flags as input, and the kernel updates the
> +      features flags word to contain only features requested by
> +      userspace and also supported by the kernel.
> +
> +      This ioctl is only included for forward compatibility; no
> +      feature flags are currently defined, and the kernel will simply
> +      update any requested feature mask to 0.  The kernel will always
> +      default to a feature mask of 0 if this ioctl is not used, so
> +      current userspace does not need to perform this ioctl.
> +
> +    UMMUNOTIFY_REGISTER_REGION: Userspace uses this ioctl to tell the
> +      kernel to start delivering events for an address range.  The
> +      range is described using struct ummunotify_register_ioctl:
> +
> +	struct ummunotify_register_ioctl {
> +		__u64	start;
> +		__u64	end;
> +		__u64	user_cookie;
> +		__u32	flags;
> +		__u32	reserved;
> +	};
> +
> +      start and end give the range of userspace virtual addresses;
> +      start is included in the range and end is not, so an example of
> +      a 4 KB range would be start=0x1000, end=0x2000.
> +
> +      user_cookie is an opaque 64-bit quantity that is returned by the
> +      kernel in events involving the range, and used by userspace to
> +      stop watching the range.  Each registered address range must
> +      have a distinct user_cookie.
> +
> +      It is fine with the kernel if userspace registers multiple
> +      overlapping or even duplicate address ranges, as long as a
> +      different cookie is used for each registration.
> +
> +      flags and reserved are included for forward compatibility;
> +      userspace should simply set them to 0 for the current interface.
> +
> +    UMMUNOTIFY_UNREGISTER_REGION: Userspace passes in the 64-bit
> +      user_cookie used to register a range to tell the kernel to stop
> +      watching an address range.  Once this ioctl completes, the
> +      kernel will not deliver any further events for the range that is
> +      unregistered.

What happens if I register two regions with the same cookie?  Will
UMMUNOTIFY_UNREGISTER_REGION unregister both, or did I cause a kernel
leak?

If it's possible to register for events from a different process then
how does the lifetime management happen?  What happens when the target
process exits?

What happens if I close() the fd when there are outstanding events? 

What happens if I close() the fd when there are still-registered
regions?

> +Events
> +
> +  When an event occurs that invalidates some of a process's memory
> +  mapping in an address range being watched, ummunotify queues an
> +  event report for that address range.  If more than one event
> +  invalidates parts of the same address range before userspace
> +  retrieves the queued report, then further reports for the same range
> +  will not be queued -- when userspace does read the queue, only a
> +  single report for a given range will be returned.

So the implementation keeps track of queued events down the
operation/start-address/end-address level and, for each new event,
checks whether that event is wholly contained within one of the
preceding start-address/end-address ranges and if that queued event
"invalidated" the new event's range, the new event is suppressed?

Sounds complex and expensive.  Why was this added?  Can't competent
userspace handle this situation?

And what does "invalidate" mean?  munmap?

Methinks this paragraph needs some fleshing out.

> +  If multiple ranges being watched are invalidated by a single event
> +  (which is especially likely if userspace registers overlapping
> +  ranges), then an event report structure will be queued for each
> +  address range registration.
> +
> +  Userspace retrieves queued events via read() on the ummunotify file
> +  descriptor; a buffer that is at least as big as struct
> +  ummunotify_event should be used to retrieve event reports, and if a
> +  larger buffer is passed to read(), multiple reports will be returned
> +  (if available).

What happens if I try to read() three bytes from that fd?

> +  If the ummunotify file descriptor is in blocking mode,

Done how?  Omitting O_NONBLOCK at open() time?

> +  a read() call
> +  will wait for an event report to be available.

Under which circumstances will that read() terminate?  signals, presumably?

> +  Userspace may also
> +  set the ummunotify file descriptor to non-blocking mode and use all
> +  standard ways of waiting for data to be available on the ummunotify
> +  file descriptor, including epoll/poll()/select() and SIGIO.
> +
> +  The format of event reports is:
> +
> +	struct ummunotify_event {
> +		__u32	type;
> +		__u32	flags;
> +		__u64	hint_start;
> +		__u64	hint_end;
> +		__u64	user_cookie_counter;
> +	};
> +
> +  where the type field is either UMMUNOTIFY_EVENT_TYPE_INVAL or
> +  UMMUNOTIFY_EVENT_TYPE_LAST.  Events of type INVAL describe
> +  invalidation events as follows:

As follows where?  Confused.

> +  user_cookie_counter contains the
> +  cookie passed in when userspace registered the range that the event
> +  is for.

Why does it have "_counter" in its name?

> + hint_start and hint_end contain the start address and end
> +  address that were invalidated.
> +
> +  The flags word contains bit flags, with only UMMUNOTIFY_EVENT_FLAG_HINT
> +  defined at the moment.  If HINT is set, then the invalidation event
> +  invalidated less than the full address range and the kernel returns
> +  the exact range invalidated;

So my registration now effectively covers a shorter address range?  it
may end up being very holey?

I wish you'd told us what "invalidate" means.  If it means munmap()
then presumably the monitored target can later start to fill those
holes in again.

"hint" seems a strange name to use here.  I don't understand why it is
appropriate instead of, say, UMMUNOTIFY_EVENT_INVALIDATE.

> + if HINT is not sent then hint_start and
> +  hint_end are set to the original range registered by userspace.
> +  (HINT will not be set if, for example, multiple events invalidated
> +  disjoint parts of the range and so a single start/end pair cannot
> +  represent the parts of the range that were invalidated)
> +
> +  If the event type is LAST, then the read operation has emptied the
> +  list of invalidated regions, and the flags, hint_start and hint_end
> +  fields are not used.  user_cookie_counter holds the value of the
> +  kernel's generation counter (see below of more details) when the
> +  empty list occurred.

Ah.  So user_cookie_counter is a union.  C has support for unions - why
not use one??

> +Generation Count
> +
> +  Userspace may mmap() a page on a ummunotify file descriptor via
> +
> +	mmap(NULL, sizeof (__u64), PROT_READ, MAP_SHARED, ummunotify_fd, 0);
> +
> +  to get a read-only mapping of the kernel's 64-bit generation
> +  counter.  The kernel will increment this generation counter each
> +  time an event report is queued.

So we have one CPU writing a memory location and another CPU reading it
without any locking?

What are the weird-architecture memory-barrier requirements here and
how are they handled?

How does the code handle the non-atomicity of u64 writes on 32-bit CPUs?

> +  Userspace can use the generation counter as a quick check to avoid
> +  system calls; if the value read from the mapped kernel counter is
> +  still equal to the value returned in user_cookie_counter for the
> +  most recent LAST event retrieved, then no further events have been
> +  queued and there is no need to try a read() on the ummunotify file
> +  descriptor.

I _guess_ that works OK on 32-bit, as long as userspace _only_ compares
this value with some previous one.

umm, no, there's still a race I think.  If the counter increases from
0x00000000ffffffff to 0x0000000100000000 then userspace could see this
as two events when using this scheme.



I didn't get around to reading the code yet ;)
