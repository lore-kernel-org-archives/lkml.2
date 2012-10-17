Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab2JQQ6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 12:58:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52815 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756469Ab2JQQ6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 12:58:11 -0400
Date: Wed, 17 Oct 2012 18:59:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121017165902.GB9872@redhat.com>
References: <20121015190958.GA4799@redhat.com> <20121015191018.GA4816@redhat.com> <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwV-WOUx8MSr145f+HSrtmZ=nXHq0VLhtPyH=FNBFwmQg@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Linus Torvalds wrote:
>
> On Mon, Oct 15, 2012 at 12:10 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > This patch adds the new sleeping lock, brw_mutex. Unlike rw_semaphore
> > it allows multiple writers too, just "read" and "write" are mutually
> > exclusive.
>
> So those semantics just don't sound sane. It's also not what any kind
> of normal "rw" lock ever does.

Yes, this is not usual.

And initially I made brw_sem which allows only 1 writer, but then
I changed this patch.

> So can you explain why these particular insane semantics are useful,
> and what for?

To allow multiple uprobe_register/unregister at the same time. Mostly
to not add the "regression", currently this is possible.

It is not that I think this is terribly important, but still. And
personally I think that "multiple writers" is not necessarily insane
in general. Suppose you have the complex object/subsystem, the readers
can use a single brw_mutex to access it "lockless", start_read() is
very cheap.

But start_write() is slow. Multiple writes can use the fine-grained
inside the start_write/end_write section and do not block each other.

Oleg.

