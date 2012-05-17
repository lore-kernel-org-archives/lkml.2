Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966739Ab2EQOz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 10:55:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36830 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966713Ab2EQOzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 10:55:24 -0400
Date: Thu, 17 May 2012 07:55:19 -0700
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jiri Kosina <jkosina@suse.cz>, Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120517145519.GF21275@google.com>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz>
 <20120516170124.GA21275@google.com>
 <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
 <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
 <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
 <20120516200147.GD21275@google.com>
 <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
 <20120516202924.GE21275@google.com>
 <CA+55aFyX3OgdcWuYQO+YuS3fF_Wt1p8w-G33C5MCkiR-3ncfVA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyX3OgdcWuYQO+YuS3fF_Wt1p8w-G33C5MCkiR-3ncfVA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

On Wed, May 16, 2012 at 01:42:36PM -0700, Linus Torvalds wrote:
> On Wed, May 16, 2012 at 1:29 PM, Tejun Heo <tj@kernel.org> wrote:
> >
> > Ummm... still confused.  flush_work_sync() is fine too.  If you have
> > two, two calls to flush_work_sync() are equivalent to flushing the
> > workqueue in effect.  You just need to avoid flush_workqueue() because
> > system workqueues may be hosting work items which can run arbitrarily
> > long.
> 
> Umm. If there are abritrarily long things and these are serialized,
> then that workqueue is not good for putting floppy work on it either,
> is it? I don't think you can have it both ways.

They're not being serialized.  system_nrt_wq like any other system wqs
has 256 as max_active - so upto 256 work items per cpu can be
executing (ie. assigned to an active worker) at any given time and
because it's a large shared pool, some of them are allowed to take
long time.

> Either it's "good enough" for putting floppy_work, fd_timeout and
> fd_timer on, or it's not. If it's good enough, then flush_workqueue()
> should damn well be timely enough. And if flush_workqueue() isn't
> timely enough, then it doesn't sound like system_nrt_wq is the wrong
> choice.

So, per-work item, it's timely enough.  It shouldn't be different from
using a dedicated workqueue.  Different work items don't interact with
each other differently whether they belong to the same workqueue or
different ones as long as the workqueue's max_active limit isn't
reached.  flush_workqueue() is a different story as it forces all work
items belonging to the workqueue to be related.  That's why one of the
valid reasons to create a workqueue is to have a separate flush
(workqueue) domain - e.g. when the caller doesn't know which work
items need to be flushed because they're dynamically allocated and
freed on work item execution.

Thanks.

-- 
tejun
