Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0KIVm2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:42:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53305 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659Ab0KIVmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:42:25 -0500
Date: Tue, 9 Nov 2010 13:41:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Jeff Layton <jlayton@redhat.com>,
        linux-kernel@vger.kernel.org, esandeen@redhat.com, jmoyer@redhat.com,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
Message-Id: <20101109134139.c6f9f6dc.akpm@linux-foundation.org>
In-Reply-To: <4CD9BA08.2000002@redhat.com>
References: <20101109114422.3918e7f6@annuminas.surriel.com>
	<20101109142109.224267d0@corrin.poochiereds.net>
	<4CD9A209.6070807@redhat.com>
	<20101109210715.GJ3099@thunk.org>
	<4CD9BA08.2000002@redhat.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Nov 2010 16:15:52 -0500
Rik van Riel <riel@redhat.com> wrote:

> On 11/09/2010 04:07 PM, Ted Ts'o wrote:
> > On Tue, Nov 09, 2010 at 02:33:29PM -0500, Rik van Riel wrote:
> >>
> >> There are essentially two possibilities:
> >> 1) the VM can potentially be filled up with uncleanable dirty pages, or
> >> 2) pages that hit an IO error are left in a clean state, so they can
> >>     be reclaimed under memory pressure
> >>
> >> Alternative 1 could cause the entire system to deadlock, while
> >> option 2 puts the onus on userland apps to rewrite the data
> >> from a failed msync/fsync.
> >>
> >> Currently the VM has behaviour #2 which is preserved with my
> >> patch.
> >>
> >> The only difference with my patch is, we won't keep returning
> >> -EIO on subsequent, error free, msync or fsync calls to files
> >> that had an IO error at some previous point in the past.
> >
> > Do we guarantee that the application will get EIO at least once?  I
> > thought there were issues where the error bit could get lost if the
> > page writeback was triggered by sync() run by a third-party
> > application.
> 
> There is no such guarantee in the current kernel, either
> with or without my patch.
> 
> A third application calling fsync or msync can get the
> EIO cleared, so the application that did the write does
> not see it.

yup.  It's a userspace bug, really.  Although that bug might be
expressed as "userspace didn't know about linux-specific EIO
behaviour".

> The VM could also reclaim the PageError page due to
> memory pressure, so the application calling fsync or
> msync does not see it.

That would be a kernel bug, methinks.  The page's end_io handler should
set the address_space's AS_EIO flag (see mpage_end_io_write()), to be
later returned to (and cleared by) the fsync/msync caller.

It wouldn't surprise me if lots of end_io handlers got that wrong.

> I see no good way in which we could guarantee that
> every process calling msync or fsync on a file that
> had an IO error in the past gets EIO once - at least,
> not without every one of them always getting EIO on
> the file even after the IO path is good again...

Yes, there's no obviously good design here.

And a lot of these problems also apply to ENOSPC, and an ENOSPC
condition most certainly does magically fix itself up in real time...
