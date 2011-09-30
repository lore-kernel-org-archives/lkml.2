Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1I3PNh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 11:13:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53582 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137Ab1I3PNS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 11:13:18 -0400
Date: Fri, 30 Sep 2011 17:09:38 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Wilson <wilsons@start.ca>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: proc: disable mem_write after exec
Message-ID: <20110930150938.GB15556@redhat.com>
References: <20110929141706.GA17119@redhat.com> <20110930004528.GA9594@wicker.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110930004528.GA9594@wicker.gateway.2wire.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29, Stephen Wilson wrote:
>
> On Thu, Sep 29, 2011 at 04:17:06PM +0200, Oleg Nesterov wrote:
>
> > 	@@ -850,6 +850,10 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
> > 		if (check_mem_permission(task))
> > 			goto out;
> >
> > 	+	copied = -EIO;
> > 	+	if (file->private_data != (void *)((long)current->self_exec_id))
> > 	+		goto out;
> > 	+
> > 		copied = -ENOMEM;
> > 		page = (char *)__get_free_page(GFP_TEMPORARY);
> > 		if (!page)
> >
> >
> > Could you explain this? Why this is wrong from the security pov? We are
> > the tracer, this was checked by check_mem_permission(). We can modify
> > this memory even without /proc/pid/mem.
>
> As far as I understand this is really just a paranoia thing, not a
> security issue in any deep sense. If the fd is leaked across an exec()
> then the target process memory could be written to by accident. So the
> intent here was to protect against buggy userspace more than anything
> else.

Hmm. OK, in this case I won't argue.

I thought that (rightly or not) the intent was to close the known
security problem which I do not understand.

And, I do not understand security at all, but I am wondering if the
usage of ptrace_parent() in security/ is really correct, the original
attacher can do suid-exec (and loose the control, yes).  But this is
off-topic.

> > And in any case, why do we check current's self_exec_id? I'd understand
> > if mem_open/mem_read/mem_writed used task->self_exec_id, see the trivial
> > patch below. With this patch this check means: this task has changed its
> > ->mm after /proc/pid/mem was opened, abort. And perhaps this was the
> > actual intent. May be makes sense.
>
> Perhaps, but my feeling is that the tracer should be prepared to deal
> with that.  From the user perspective I think of /proc/pid/mem as being
> associated with a pid, not an mm, and I can't see the benefit of going
> thru a close()/open() cycle to deal with an event that can be detected
> using ptrace.

Yes, agreed.

In any case we can't do this change, this can break the debugger which
uses the pre-opened file after the tracer execs. I only tried to understand
what was the actual intent.

> > But the real question is, why (from the security pov) we can't simply kill
> > these self_exec_id checks?
> >
> > Not to mention, it would be nice to remove self_exec_id/parent_exec_id too.
> > Ignoring mem_open(), afaics the _only_ reason we need these id's is that
> > linux allows clone(CLONE_PARENT | SIGKILL).
>
> So I think this is just a case of weighing the costs and benefits.
> Personally, I think having /proc/pid/mem implicitly CLOEXEC is the
> "right" thing to do.  But I wouldn't argue if the checks were dropped in
> an effort to simplify code.

OK, thanks.

Oleg.

