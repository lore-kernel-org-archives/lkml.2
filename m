Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab1G0UE5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 16:04:57 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59718 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955Ab1G0UEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 16:04:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110727163159.GA23785@redhat.com>
References: <20110727163159.GA23785@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 27 Jul 2011 12:39:00 -0700
Message-ID: <CA+55aFy83CAZ+AVZNtYZc=NnOzaxsQxksuspqBHGVwLx4hvMCg@mail.gmail.com>
Subject: Re: [PATCH 0/8] make vfork killable/restartable/traceable
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@hack.frob.com>, Tejun Heo <tj@kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Matt Fleming <matt.fleming@linux.intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 27, 2011 at 9:31 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>
> CLONE_VFORK sleeps in TASK_INTERRUPTIBLE until the child exits/execs.
> This is obviously not good, it is sooo simple to create the task which
> doesn't react to SIGKILL/SIGSTOP.

Well, I don't know how bad that is. You just kill the child instead.
That's how vfork has always worked, not just on Linux.

And quite frankly, I think your patches 1-3 are unbelievably ugly. If
it was some simple and straightforward "use
wait_for_completion_killable() instead", I wouldn't mind it. But I
think you made a simple and clean sequence convoluted and annoying.

I *suspect* that the killable() thing could be done more nicely by
moving the vfork_completion into the parent instead, and maybe the
vfork cleanup could just use
"complete(&task->parent->vfork_completion);" instead (so if the parent
goes away, it completes some irrelevant init case instead).

So *if* this can be done while still having straightforward code, I
think it might be worth doing. But patches 1-3 just make me go "not
worth the ugliness, especially since it's not a real problem".

                               Linus
