Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab2BPPLj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:11:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47099 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752636Ab2BPPLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:11:38 -0500
Date: Thu, 16 Feb 2012 16:04:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: apw@canonical.com, arjan@linux.intel.com, fhrbata@redhat.com,
        john.johansen@canonical.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rientjes@google.com, rusty@rustcorp.com.au, tj@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] kmod: make __request_module() killable
Message-ID: <20120216150429.GB11953@redhat.com>
References: <20120214164709.GA21178@redhat.com> <20120214164914.GF21185@redhat.com> <20120215123049.6e938eed.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120215123049.6e938eed.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15, Andrew Morton wrote:
>
> On Tue, 14 Feb 2012 17:49:14 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > As Tetsuo Handa pointed out, request_module() can stress the
> > system while the oom-killed caller sleeps in TASK_UNINTERRUPTIBLE.
>
> Whine.
>
> Solving this problem is the entire point of the entire patchset and you
> told us almost nothing about it.  Please, provide a complete
> description of the problem which is being solved, so we can understand
> the value of the patchset?

I did ;) from the message I sent to security list:

	Tetsuo has the test-cases, but the problem (well, one of the problems) is
	simple.

	The task T uses "almost all" memory, then it does something which triggers
	request_module(). Say, it can simply call sys_socket(). This in turn needs
	more memory and leads to OOM. oom-killer correctly chooses T and kills it,
	but this can't help because it sleeps in TASK_UNINTERRUPTIBLE and after
	that oom-killer becomes "disabled" by the TIF_MEMDIE task T.

Credits to Tetsuo.

But in fact I think this change is "obviously good" anyway. Assuming
it is correct of course. request_module() is heavy, it can take the
unpredictable amount of time/resources to finish. It is not good we
can't interrupt the task which waits for completion.

Yes, this adds some complications and initially I wasn't agree with
Tetsuo, I thought this doesn't worth the trouble. But I hope that
this code is simple/clean enough.



Btw, there is another example of "unbounded" sleep in UNINTERRUPTIBLE,
vfork. I already have the patches, will send today.

Oleg.

