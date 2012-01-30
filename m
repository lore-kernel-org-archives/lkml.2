Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2A3NJ7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 08:09:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab2A3NJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 08:09:58 -0500
Date: Mon, 30 Jan 2012 14:03:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: + kmod-avoid-deadlock-by-recursive-kmod-call.patch added to
	-mm tree
Message-ID: <20120130130335.GB11414@redhat.com>
References: <20120126175612.GA24011@redhat.com> <87ipjxdfbg.fsf@rustcorp.com.au> <20120127143234.GA13056@redhat.com> <87y5srbaf7.fsf@rustcorp.com.au> <20120129163141.GC20803@redhat.com> <87aa56qedn.fsf@rustcorp.com.au> <20120130002511.GF17211@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120130002511.GF17211@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/29, Tejun Heo wrote:
>
> BTW, why does it have to be unbound_wq?

Perhaps we can use another system_wq, but afaics WQ_UNBOUND makes sense
in this case. I mean, there is no reason to bind this work to any CPU.
See also below.

> Is it expected consume large
> amount of CPU cycles?

Currently __call_usermodehelper() does kernel_thread(), this is almost
all. But it can block waiting for kernel_execve().

Not sure this really makes sense, but if we kill khelper_wq perhaps we
can simplify this code a bit. We can change __call_usermodehelper()

		if (wait == UMH_WAIT_PROC)
	-		pid = kernel_thread(wait_for_helper, sub_info,
	-				    CLONE_FS | CLONE_FILES | SIGCHLD);
	+		wait_for_helper(...);
		else

IOW, the worker thread itself can do the UMH_WAIT_PROC work. This makes
this work really "long running", but then we can kill sub_info->complete
and use flush_work().

Oleg.

