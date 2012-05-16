Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965067Ab2EPTmj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 15:42:39 -0400
Received: from mga11.intel.com ([192.55.52.93]:38413 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964799Ab2EPTmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 15:42:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167254650"
Date: Wed, 16 May 2012 15:43:32 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: chetan loke <loke.chetan@gmail.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-scsi@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: SCSI RAM driver ported to 3.3 kernel for file system and I/O
 testing
Message-ID: <20120516194332.GN22985@linux.intel.com>
References: <1337188023.3796.130.camel@schen9-DESK>
 <CAAsGZS6KJ6jN+0B2Q06gXivaWfMVKX9t-yCYNwZDZ_jzUopviw@mail.gmail.com>
 <20120516193506.GM22985@linux.intel.com>
 <CAAsGZS5wivyHUGNtHuTNCQQnnqZ=qt-7uSZjbE-7_KC+L-Yoaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAsGZS5wivyHUGNtHuTNCQQnnqZ=qt-7uSZjbE-7_KC+L-Yoaw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 03:37:56PM -0400, chetan loke wrote:
> On Wed, May 16, 2012 at 3:35 PM, Matthew Wilcox <willy@linux.intel.com> wrote:
> > On Wed, May 16, 2012 at 03:31:55PM -0400, chetan loke wrote:
> >> > +               if (list_empty(&ram_device->commands))
> >> > +                       wake_up_process(ram_device->thread);
> >>
> >> Didn't look in detail but if the queue is empty then why would you
> >> want to wake up the kthread? What if you just wake_up after
> >> list_add_tail below?
> >
> > If the list is non-empty, then the kthread has already been woken up
> > and doesn't need to be woken again.
> 
> Sorry, not able to follow. wait_even_interruptible will put kthread to
> sleep. So how will it be already awake?

Consider the following:

CPU 0			CPU 1
->queuecommand
lock
wakes kthread
queues command 1
unlock

->queuecommand
lock
			kthread wakes
			lock
queues command 2
unlock
			dequeues command 1
			dequeues command 2
			unlock


See?  No need to wake the kthread *if there's already something on the
queue*, because you know it was already woken by whoever put the first
command on the queue.
