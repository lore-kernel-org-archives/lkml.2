Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab2FMV3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:29:51 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51675 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab2FMV3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:29:50 -0400
Date: Wed, 13 Jun 2012 14:29:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] msync: start async writeout when MS_ASYNC
Message-Id: <20120613142949.734818a8.akpm@linux-foundation.org>
In-Reply-To: <1338497035-13014-3-git-send-email-pbonzini@redhat.com>
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
	<1338497035-13014-3-git-send-email-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 May 2012 22:43:55 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> msync.c says that applications had better use fsync() or fadvise(FADV_DONTNEED)
> instead of MS_ASYNC.  Both advices are really bad:
> 
> * fsync() can be a replacement for MS_SYNC, not for MS_ASYNC;
> 
> * fadvise(FADV_DONTNEED) invalidates the pages completely, which will make
>   later accesses expensive.
> 
> Having the possibility to schedule a writeback immediately is an advantage
> for the applications.  They can do the same thing that fadvise does,
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
> 
> If the application does not want to start I/O, it can simply call msync
> with flags equal to MS_INVALIDATE.  This one remains a no-op, as it should
> be on a reasonable implementation.

Means that people will find that their msync(MS_ASYNC) call will newly
start IO.  This may well be undesirable for some.

Also, it hardwires into the kernel behaviour which userspace itself
could have initiated, with sync_file_range().  ie: reduced flexibility.

Perhaps we can update the msync.c code comments to direct people to
sync_file_range()?


One wonders how msync() works with nonlinear mappings.  I guess
"badly".  I think this was all discussed when we merged
remap_file_pages() (what a mistake that was) and we decided "too hard".

