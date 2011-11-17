Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757624Ab1KQNyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 08:54:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757565Ab1KQNyE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 08:54:04 -0500
Date: Thu, 17 Nov 2011 08:53:37 -0500
From: Don Zickus <dzickus@redhat.com>
To: Tony Luck <tony.luck@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Huang Ying <ying.huang@intel.com>, Mike Waychison <mikew@google.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Seiji Aguchi <seiji.aguchi@hds.com>
Subject: Re: [PATCH v2] pstore: pass allocated memory region back to caller
Message-ID: <20111117135337.GL8685@redhat.com>
References: <20111116211329.GA8328@www.outflux.net>
 <20111116222028.GK8685@redhat.com>
 <CA+8MBb+dEz+zOD_SsOYqV3z1O-H-Q8CRyr6gPU73S34xhxDWiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+8MBb+dEz+zOD_SsOYqV3z1O-H-Q8CRyr6gPU73S34xhxDWiQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 02:45:24PM -0800, Tony Luck wrote:
> On Wed, Nov 16, 2011 at 2:20 PM, Don Zickus <dzickus@redhat.com> wrote:
> > This is an interesting approach.  But are we leaving psinfo data exposed
> > when you have a reader and writer at the same time?
> 
> I look at this as the first step in separating the read & write paths.
> 
> I started out with the (good) idea that the back end should allocate & own
> the buffer for the write path ... this means that the buffer is ready to use
> when an oops/panic happens - which is obviously a bad time to need to
> allocate memory :-)

Of course. :-)  But don't we have mechanisms which can use pre-allocated
memory?  Like the lock-less link list or the ring buffer?

Or maybe something safer, perhaps pass the backend buffer size to the
dumper routine when it registers?  That way kmsg_dump can allocate memory
at registration time which is sync'd in size with the backend.  This
allows kmsg_dump to fill the buffer and pass it directly down to the
backend (through pstore_dumper), with minimal locks, without breaking it
up again and re-copying into yet another buffer.

Thoughts?

> 
> Then I reused the same buffer for read - in hindsight this was not such a
> good idea - it led to all the discussions we've had about how to guarantee
> that the dmesg data gets saved on panic - even in the cases where we
> can't get the locks (so proposals have been made to bust the locks).
> 
> So Kees' patch is the functional equivalent of busting the spinlock.

> 
> Next step would be to look at the back end drivers to see whether
> they can handle a simultaneous read & write in a graceful way.
> 
I was just wondering if we should put a 'const' on the psinfo data being
passed to the read/write routine, otherwise a broken backend could modify
psinfo and corrupt any concurrent access, no?

> I've queued this for linux-next. Probably missed the snapshot today,
> but I expect it should show up in next-20111118

Cheers,
Don

