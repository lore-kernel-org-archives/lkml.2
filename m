Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab2HIJ2d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 05:28:33 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:57543 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab2HIJ2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 05:28:31 -0400
MIME-Version: 1.0
In-Reply-To: <1343447832-7182-1-git-send-email-john.stultz@linaro.org>
References: <1343447832-7182-1-git-send-email-john.stultz@linaro.org>
Date: Thu, 9 Aug 2012 02:28:30 -0700
Message-ID: <CANN689FzQSLAFw0tNmdiOQ0PwV1nN8FaL0LNkkDMEB10k0jmwA@mail.gmail.com>
Subject: Re: [PATCH 0/5][RFC] Fallocate Volatile Ranges v6
From: Michel Lespinasse <walken@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Dave Chinner <david@fromorbit.com>, Neil Brown <neilb@suse.de>,
        Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Mike Hommey <mh@glandium.org>, Jan Kara <jack@suse.cz>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Fri, Jul 27, 2012 at 8:57 PM, John Stultz <john.stultz@linaro.org> wrote:
> So after not getting too much positive feedback on my last
> attempt at trying to use a non-shrinker method for managing
> & purging volatile ranges, I decided I'd go ahead and try
> to implement something along Minchan's ERECLAIM LRU list
> idea.

Agree that there hasn't been much feedback from MM folks yet - sorry
about that :/

I think one issue might be that most people don't have a good
background on how the feature is intended to be used, and it is very
difficult to comment meaningfully without that.

As for myself, I have been wondering:

- Why the feature needs to be on a per-range basis, rather than
per-file. Is this simply to make it easier to transition the android
use case from whatever they are doing right now, or is it that the
object boundaries within a file can't be known in advance, and thus
one wouldn't know how to split objects accross different files ? Or
could it be that some of the objects would be small (less than a page)
so space use would be inefficient if they were placed in different
files ? Or just that there would be too many files for efficient
management ?

- What are the desired semantics for the volatile objects. Can the
objects be accessed while they are marked as volatile, or do they have
to get unmarked first ? Is it really the case that we always want to
reclaim from volatile objects first, before any other kind of caches
we might have ? This sounds like a very strong hint, and I think I
would be more comfortable with something more subtle if that's
possible. Also, if we have several volatile objects to reclaim from,
is it desirable to reclaim from the one that's been marked volatile
the longest or does it make no difference ? When an object is marked
volatile, would it be sufficient to ensure it gets placed on the
inactive list (maybe with the referenced bit cleared) and let the
normal reclaim algorithm get to it, or is that an insufficiently
strong hint somehow ?

Basically, having some background information of how android would be
using the feature would help us better understand the design decision
here, I think.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
