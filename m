Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2FNKIA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:08:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2FNKH5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:07:57 -0400
Date: Thu, 14 Jun 2012 03:07:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] msync: start async writeout when MS_ASYNC
Message-Id: <20120614030753.048eec9a.akpm@linux-foundation.org>
In-Reply-To: <4FD9A88A.8040701@redhat.com>
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com>
	<1338497035-13014-3-git-send-email-pbonzini@redhat.com>
	<20120613142949.734818a8.akpm@linux-foundation.org>
	<4FD9A88A.8040701@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012 11:02:02 +0200 Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 13/06/2012 23:29, Andrew Morton ha scritto:
> > > If the application does not want to start I/O, it can simply call msync
> > > with flags equal to MS_INVALIDATE.  This one remains a no-op, as it should
> > > be on a reasonable implementation.
> > 
> > Means that people will find that their msync(MS_ASYNC) call will newly
> > start IO.  This may well be undesirable for some.
> 
> If they knew it was a no-op, and relying on it, they might as well not
> have called it at all and save a syscall.

Nope.  Back in the day (3+ years ago?), msync(MS_ASYNC) would flush
pte-dirty bits into page->flags:PG_Dirty.  So it was used to make the
filesystem aware that userspace had modified some MAP_SHARED memory. 
The fs would then perform writeback within (typically) 30 seconds.  So
a legitimate use would be for the app to periodically run
msync(MS_ASYNC) to avoid having modified data floating about
un-written-back for arbitrarily long periods.

Nowadays we mark the pte's read-only and take a fault on first write,
and mark the page dirty at that time.

So it wasn't a no-op, and with this patch, such applications will newly
find themselves to be starting I/O within the msync() call.

