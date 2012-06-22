Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932239Ab2FVV03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 17:26:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834Ab2FVV02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 17:26:28 -0400
Date: Fri, 22 Jun 2012 14:26:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Chris Friesen <chris.friesen@genband.com>
Subject: Re: [PATCH v2 2/2] msync: start async writeout when MS_ASYNC
Message-Id: <20120622142627.b6184eda.akpm@linux-foundation.org>
In-Reply-To: <1339773179-31210-3-git-send-email-pbonzini@redhat.com>
References: <1339773179-31210-1-git-send-email-pbonzini@redhat.com>
	<1339773179-31210-3-git-send-email-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012 17:12:59 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> msync.c says that applications had better use fsync() or fadvise(FADV_DONTNEED)
> instead of MS_ASYNC.  Both advices are really bad:
> 
> * fsync() can be a replacement for MS_SYNC, not for MS_ASYNC;
> 
> * fadvise(FADV_DONTNEED) invalidates the pages completely, which will make
>   later accesses expensive.
> 
> Even sync_file_range would not be a replacement, because the writeout is
> done synchronously and can block for an extended period of time.

This is just wrong.  sync_file_range() is, within limits, asynchronous
when SYNC_FILE_RANGE_WAIT_* are not used.

> Having the possibility to schedule a writeback immediately is an advantage
> for the applications.

Having this forced upon them is also a disadvantage.  The syscall will
now take longer, consuming more CPU: starting all that IO will add
latency.  It also moves work away from the flusher threads and into the
calling process thus increasing overall runtime and reducing SMP
utilisation.

And as bdi_wrte_congested() is a best-effort, sometime-gets-it-wrong
thing, the patch will introduce quite rare but very long delays where
msync(MS_ASYNC) waits on IO.

>  They can do the same thing that fadvise does,
> but without the invalidation part.  The implementation is also similar
> to fadvise, but with tag-and-write enabled.
> 
> One example is if you are implementing a persistent dirty bitmap.
> Whenever you set bits to 1 you need to synchronize it with MS_SYNC, so
> that dirtiness is reported properly after a host crash.  If you have set
> any bits to 0, getting them to disk is not needed for correctness, but
> it is still desirable to save some work after a host crash.  You could
> simply use MS_SYNC in a separate thread, but MS_ASYNC provides exactly
> the desired semantics and is easily done in the kernel.

This is already the case.  The current msync(MS_ASYNC) will mark the
pages for writeout within a dirty_expire_centisecs period (default 30
seconds).  This has always been why we consider the current MS_ASYNC
implementation to be standards-compliant.

If you think that some applications will *benefit* from having that 30
seconds changed to zero seconds under their feet then please describe
the reasoning.

> If the application does not want to start I/O, it can simply call msync
> with flags equal to MS_INVALIDATE.  This one remains a no-op, as it should
> be on a reasonable implementation.

Using MS_INVALIDATE is a bit of a hack.


I'm just not seeing it, sorry.  The change has risks and downsides and
forces the application to do things which it could already have done,
had it so chosen.

