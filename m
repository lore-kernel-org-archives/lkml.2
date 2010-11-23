Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0KWOuS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:50:18 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53725 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754692Ab0KWOuN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:50:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TkNYRrfT5Xm5XvDjn9xI4VGOw1p9x9mbYuT1XYjrFBjlKw7dIMJhu5H88VM8OZk8fB
         81tGqObFdSLni/10SAMo1n1/8SXRXM1kypdR6niBw+14mQZzKTvixDTlA3jYVHQAD4D8
         4x5mXVT//XdVQHPB3d4Uuqo8zAxmKrF2GTNZ0=
From: Ben Gamari <bgamari.foss@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, rsync@lists.samba.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Nick Piggin <npiggin@kernel.dk>
Subject: [RFC PATCH] fadvise support in rsync
Date: Tue, 23 Nov 2010 09:49:49 -0500
Message-Id: <1290523792-6170-1-git-send-email-bgamari.foss@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20101122103756.E236.A69D9226@jp.fujitsu.com>
References: <20101122103756.E236.A69D9226@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Warning for kernel folks: I'm not much of an mm person; let me know if I got
anything horribly wrong.

Many folks use rsync in their nightly backup jobs. In these applications, speed
is of minimal concern and should be sacrificed in order to minimize the effect
of rsync on the rest of the machine. When rsync is working on a large directory
it can quickly fill the page cache with written data, displacing the rest of
the system's working set. The solution for this is to inform the kernel that
our written pages will no longer be needed and should be expelled to disk. The
POSIX interface for this, posix_fadvise, has existed for some time, but there
has been no useable implementation in any of the major operating systems.

Attempts have been made in the past[1] to use the fadvise interface, but kernel
limitations have made this quite messy. In particular, the kernel supports
FADV_DONTNEED as a single-shot hint; i.e. if the page is clean when the hint is
given it will be freed, otherwise the hint is ignored. For this reason it is
necessary to fdatasync() against dirtied pages before giving the hint. This,
however, requires that rsync do some accounting, calling fdatasync() and
fadvise() only after giving the kernel an opportunity to flush the data itself.

Moreover, fadvise(DONTNEED) frees pages regardless of whether the hinting
process is the only referrer. For this reason, the previous fadvise patch also
used mincore to identify which pages are needed by other processes. Altogether,
this makes using fadvise very expensive from a complexity standpoint. This is
very unfortunately since the interface could be quite usable with a few minor
changes.

I recently asked about this on the LKML[2], where Minchan Kim was nice enough
to put together a patch improving support for the FADV_DONTNEED hint. His patch
adds invalidated flagged pages to the inactive list. This obviates the need for
fdatasync() since the page will be reclaimed by the kernel in the standard
inactive reclaim path. Moreover, by adding hinted pages to the head of the
inactive list, other processes are given ample time to call the pages back to
the active list, eliminating the need for the previous mincore() hack.

Here is my attempt at adding fadvise support to rsync (against v3.0.7). I do
this in both the sender (hinting after match_sums()) and the receiver (hinting
after receive_data()). In principle we could get better granularity if this was
hooked up within match_sums() (or even the map_ptr() interface) and the receive
loop in receive_data(), but I wanted to keep things simple at first (any
comments on these ideas?) . At the moment is for little more than testing.
Considering the potential negative effects of using FADV_DONTNEED on older
kernels, it is likely we will want this functionality off by default with a
command line flag to enable.

Cheers,

- Ben


[1] http://insights.oetiker.ch/linux/fadvise.html
[2] http://lkml.org/lkml/2010/11/21/59

