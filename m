Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932341Ab2DJBGQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 21:06:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26789 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab2DJBGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 21:06:14 -0400
Date: Tue, 10 Apr 2012 03:05:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>
Subject: [RFC PATCH 0/1] task_work_queue: add generic process-context
	callbacks
Message-ID: <20120410010547.GA18358@redhat.com>
References: <20120409190323.GA14712@redhat.com> <20120409190350.GA14716@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120409190350.GA14716@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I didn't read the "v3.4-rc2 out-of-memory problems" thread yet, but
I noticed how much Linus loves the
yet-another-random-notifier-for-some-random-reason idea.

Yet I am going to suggest another one, please see the patch.

But. To defence this change, please note that de-facto the notifier
is already here.

On 04/09, Oleg Nesterov wrote:
>
> Note: initially this was 1/2. The usage of >replacement_session_keyring
> is racy, although the problem is minor. I think that instead of fixing
> a lot of key_replace_session_keyring's callers in arch/ we can add the
> simple abstraction layer and kill ->replacement_session_keyring. I'll
> try to send the patches tomorrow.

Yes. the callers of key_replace_session_keyring() and
keyctl_session_to_parent() lack the barriers and can race with each other.
And keyctl_session_to_parent() probably needs kick_process(). Yes, the
problem is minor, but still.

To me, the main problem is task->->replacement_session_keyring itself.
I mean, imho it should not be that limited, we should generalize this
logic.

And potentially (I hope) it can have more users besides
KEYCTL_SESSION_TO_PARENT. Say, we can remove do_exit()->exit_irq_thread()
and task->irq_thread. The creator of irq thread can do
task_queue_work(exit_irq_thread).

What do you think?

Oleg.

