Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab3ACRTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 12:19:31 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:44942 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753423Ab3ACRT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 12:19:28 -0500
MIME-Version: 1.0
In-Reply-To: <1357187286-18759-1-git-send-email-minchan@kernel.org>
References: <1357187286-18759-1-git-send-email-minchan@kernel.org>
From: Sanjay Ghemawat <sanjay@google.com>
Date: Thu, 3 Jan 2013 09:19:08 -0800
Message-ID: <CAOMbAgLaFR+Et=F5+A7HPY16X-Y8VPm6mY_vE9XOJm8C-8OfPg@mail.gmail.com>
Subject: Re: [RFC v5 0/8] Support volatile for anonymous range
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
        Arun Sharma <asharma@fb.com>, Paul Turner <pjt@google.com>,
        David Rientjes <rientjes@google.com>,
        John Stultz <john.stultz@linaro.org>, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 8:27 PM, Minchan Kim <minchan@kernel.org> wrote:
> This is still RFC because we need more input from user-space
> people, more stress test, design discussion about interface/reclaim

Speaking as one of the authors of tcmalloc, I don't see any particular
need for this new system call for tcmalloc.  We are fine using
madvise(MADV_DONTNEED) and don't notice any significant
performance issues caused by it.  Background: we throttle how
quickly we release memory back to the system (1-10MB/s), so
we do not call madvise() very much, and we don't end up reusing
madvise-ed away pages at a fast rate. My guess is that we won't
see large enough application-level performance improvements to
cause us to change tcmalloc to use this system call.

> - What's different with madvise(DONTNEED)?
>
>   System call semantic
>
>   DONTNEED makes sure user always can see zero-fill pages after
>   he calls madvise while mvolatile can see old data or encounter
>   SIGBUS.

Do you need a new system call for this?  Why not just a new flag to madvise
with weaker guarantees than zero-filling?  All of the implementation changes
you point out below could be triggered from that flag.
