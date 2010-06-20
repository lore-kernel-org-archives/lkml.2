Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab0FTUQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 16:16:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757025Ab0FTUQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 16:16:46 -0400
Date: Sun, 20 Jun 2010 22:14:54 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>,
       Pavel Emelyanov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 6/6] pidns: Support unsharing the pid namespace.
Message-ID: <20100620201454.GA6902@redhat.com>
References: <20100617212003.GA4182@redhat.com> <20100618082033.GD16877@hawkmoon.kerlabs.com> <20100618111554.GA3252@redhat.com> <20100618160849.GA7404@redhat.com> <20100618173320.GG16877@hawkmoon.kerlabs.com> <20100618175541.GA13680@redhat.com> <20100618212355.GA29478@redhat.com> <20100619190840.GA3424@redhat.com> <m1pqzmqema.fsf_-_@fess.ebiederm.org> <m1wrtuozq6.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wrtuozq6.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20, Eric W. Biederman wrote:
>
> Unsharing of the pid namespace unlike unsharing of other namespaces
> does not take affect immediately.  Instead it affects the children
> created with fork and clone.

Cough. It is too late to me to even try to understand the changelog.

Instead I tried to quickly read the patch. Most probably I missed
somthing, but still I'd like to ask the quiestion.

So. If I understand correctly, the patch is simple:

	- unshare(CLONE_NEWPID) changes current->proxy->pid_ns,
	  but do not change current->pids[] and thus it doesn't
	  change task_active_pid_ns().

	- since copy_process() uses ->proxy->pid_ns for alloc_pid()
	  the new children will fall into the new ns.

IOW, the caller becomes the "swapper" for the new namespace.

Correct?

If yes, I'm afraid nobody except you will understand this magic ;)

But what if the task T does unshare(CLONE_NEWPID) and then, say,
pthread_create() ? Unless I missed something, the new thread won't
be able to see T ?

OK, suppose it does fork() after unshare(), then another fork().
In this case the second child lives in the same namespace with
init created by the 1st fork, but it is not descendant ? This means
in particular that if the new init exits, zap_pid_ns_processes()->
do_wait() can't work.

I hope I missed something, this all is too subtle for me. And I
still do not understand 4/6 which adds ns->dead.

Oleg.

