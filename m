Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661Ab2D0Paa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:30:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:42953 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760484Ab2D0Pa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:30:28 -0400
Message-ID: <4F9ABA74.8040404@linux.vnet.ibm.com>
Date: Fri, 27 Apr 2012 08:25:40 -0700
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/3] fadvise: Add _VOLATILE,_ISVOLATILE, and _NONVOLATILE
 flags
References: <1335289787-11089-1-git-send-email-john.stultz@linaro.org> <1335289787-11089-3-git-send-email-john.stultz@linaro.org> <20120427003953.GC9541@dastard>
In-Reply-To: <20120427003953.GC9541@dastard>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12042715-6078-0000-0000-00000A71C259
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2012 05:39 PM, Dave Chinner wrote:
> As it is, I'm still not sold on these being an fadvise() interface
> because all it really is a delayed hole punching interface whose
> functionailty is currently specific to tmpfs. The behaviour cannot
> be implemented sanely by anything else at this point.
...
> IOWs, the specification you are describing means that FADV_VOLATILE
> could be correctly implemented as an immediate hole punch by every
> filesystem that supports hole punching.

Ahhh, I think I see where you're going with this.

1. Data written to a file somehow (mmap(), write()) and is on disk
2. mmap() the data, and fault it in
3. Do a small write to it
4. set FADV_VOLATILE on it

Now we've got a dirty page which can theoretically be tossed out.  But,
we've got old data on the disk and no real way to tell that it was old
if it got faulted in again.  It's a much cleaner situation to just drop
that data off the disk (hole punch) than to leave it around.  Is that
the concern?

But, we have other APIs that act this way, tossing out dirty data
without reflecting that on-disk (MADV_DONTNEED at least).  Is it really
a stretch to define the FADV_VOLATILE to behave the same way?  IOW,
Should the behavior _really_ be hole punching?  That'll cost us I/O to
throw away data during memory reclaim since we have to go write the
information about the hole.  Seems like a much more appropriate thing to
just toss the data out since the app can handle it.

