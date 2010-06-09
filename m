Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757480Ab0FIMhL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 08:37:11 -0400
Received: from thunk.org ([69.25.196.29]:45020 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab0FIMhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 08:37:08 -0400
Date: Wed, 9 Jun 2010 08:37:04 -0400
From: tytso@mit.edu
To: Michel Lespinasse <walken@google.com>
Cc: Salman <sqazi@google.com>, peterz@infradead.org, mingo@elte.hu,
       akpm@inux-foundation.org, linux-kernel@vger.kernel.org,
       tytso@google.com
Subject: Re: [PATCH] Fix a race in pid generation that causes pids to be
 reused immediately.
Message-ID: <20100609123704.GE6529@thunk.org>
Mail-Followup-To: tytso@mit.edu, Michel Lespinasse <walken@google.com>,
	Salman <sqazi@google.com>, peterz@infradead.org, mingo@elte.hu,
	akpm@inux-foundation.org, linux-kernel@vger.kernel.org,
	tytso@google.com
References: <20100609062438.29081.91635.stgit@bumblebee1.mtv.corp.google.com>
 <20100609114903.GA9223@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100609114903.GA9223@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 09, 2010 at 04:49:03AM -0700, Michel Lespinasse wrote:
> You should make sure to handle pid wrap-around for this last/pid comparison.
> I think proper way to do that would be:

Good point!  I forgot about checking for pid wrap-around.

> The last_read == pid case is also interesting - it means another
> thread found the same pid, forked a child with that pid, and the
> child exited already (since the bitmap was cleared).  However we
> don't need to handle that case - first, that race is much less
> likely to happen, and second, the duplicate pid would be returned in
> two separate tasks - so this would not cause problems in bash as in
> your example.

In order for that to happen, all of this would have to happen between
the time that last_pid was initially sampled at the very beginning of
alloc_pidmap().  Could that happen?  I think it could, if kzalloc()
took a very long time to run, and the scheduler was _very_ unfair.  We
could try to guard against that by checking to see if last_pid has
changed after allocating map->page (in the unlikely case of !map->page
being NULL in the first place) and if so, restarting alloc_pidmap() by
jumping back to the beginning of the function.

Could that happen with bash?  I'm not as confident as you that it
could never happen.  The fact that we saw the race in the first place
in bash means that it could still happen in this case, I think.  In
any case, if we have two processes getting the same pid in the absence
of a fork, that would be a bad thing and could lead to all sorts of
confusion, so it's probably a good thing to guard against even if it
is a rare case.

BTW, Salman, I haven't seen it, but I vaguely remember in the mail
exchange with the person who reported this that we have a C/C++
reproduction case?  If it's small enough, it might be a good idea to
include it in the patch description.

						- Ted
