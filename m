Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1I3Apz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 20:45:55 -0400
Received: from mout.perfora.net ([74.208.4.194]:59332 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154Ab1I3Apy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 20:45:54 -0400
Date: Thu, 29 Sep 2011 20:45:28 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: proc: disable mem_write after exec
Message-ID: <20110930004528.GA9594@wicker.gateway.2wire.net>
References: <20110929141706.GA17119@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110929141706.GA17119@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:fksj0Rwyz6G/N5c+eBvpVK9WnqftYxTHEG7yPcFLC29
 PDft4En/ArLp5XFheBl9kmPWDcdOVzMX0kX6HUgz/clG6xOb0m
 FhUW6S3SX/OYIvvNtp2blsXGx/KJDjW9GW3cbdDtFgljmLVACo
 eYWlOGtokap7TjQ48grzrGyofgbwnw1Tteq8sYhI0pxc7K5xZ2
 zu5sHjrJeb0Amoo37nBxyuAqFbl0xUDNOueJK9vbUj5lFSNXg3
 KJAG23HgL0phpsK8ICHlJfmq9rAE5++6JMm2yE+zPsjv5/GAF9
 pdEe/wUTTsUVfZs/FfyAwkXC7tBpYuIVfICeEdlWQ3WITCwSxD
 +aLNoygT8wiAjtb472K4USXdPv61xkgaIYFsVaZxi/q3+J8cYF
 I3AVukZk0236Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 04:17:06PM +0200, Oleg Nesterov wrote:
> The last question, I promise ;)

No worries :)

> 	@@ -850,6 +850,10 @@ static ssize_t mem_write(struct file * file, const char __user *buf,
> 		if (check_mem_permission(task))
> 			goto out;
> 	 
> 	+	copied = -EIO;
> 	+	if (file->private_data != (void *)((long)current->self_exec_id))
> 	+		goto out;
> 	+
> 		copied = -ENOMEM;
> 		page = (char *)__get_free_page(GFP_TEMPORARY);
> 		if (!page)
> 
> 
> Could you explain this? Why this is wrong from the security pov? We are
> the tracer, this was checked by check_mem_permission(). We can modify
> this memory even without /proc/pid/mem.

As far as I understand this is really just a paranoia thing, not a
security issue in any deep sense. If the fd is leaked across an exec()
then the target process memory could be written to by accident. So the
intent here was to protect against buggy userspace more than anything
else. 


> And in any case, why do we check current's self_exec_id? I'd understand
> if mem_open/mem_read/mem_writed used task->self_exec_id, see the trivial
> patch below. With this patch this check means: this task has changed its
> ->mm after /proc/pid/mem was opened, abort. And perhaps this was the
> actual intent. May be makes sense.

Perhaps, but my feeling is that the tracer should be prepared to deal
with that.  From the user perspective I think of /proc/pid/mem as being
associated with a pid, not an mm, and I can't see the benefit of going
thru a close()/open() cycle to deal with an event that can be detected
using ptrace.


> But the real question is, why (from the security pov) we can't simply kill
> these self_exec_id checks?
> 
> Not to mention, it would be nice to remove self_exec_id/parent_exec_id too.
> Ignoring mem_open(), afaics the _only_ reason we need these id's is that
> linux allows clone(CLONE_PARENT | SIGKILL).

So I think this is just a case of weighing the costs and benefits.
Personally, I think having /proc/pid/mem implicitly CLOEXEC is the
"right" thing to do.  But I wouldn't argue if the checks were dropped in
an effort to simplify code.



Thanks,


-- 
steve

