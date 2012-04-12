Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339Ab2DLJaa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 05:30:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47937 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762337Ab2DLJa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 05:30:28 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20120412024825.GB17984@redhat.com>
References: <20120412024825.GB17984@redhat.com> <20120412024751.GA17561@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Smith <dsmith@redhat.com>, "Frank Ch. Eigler" <fche@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] cred: change keyctl_session_to_parent() to use task_work_queue()
Date: Thu, 12 Apr 2012 10:29:55 +0100
Message-ID: <9202.1334222995@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> Change keyctl_session_to_parent() to use task_work_queue() and
> move key_replace_session_keyring() logic into task_work->func().

I'm generally okay with this, but there are a couple of issues with the patch.

> +static void replace_session_keyring(struct task_work *twork)

Can you keep this in process_keys.c please?  Then everything that actually
updates a process's keyrings is done there.  Admittedly, on that basis, you
can argue that I should move a chunk of keyctl_session_to_parent() there too.

And, also, can you please keep the "key_" on the front of the name?

>  long keyctl_session_to_parent(void)
>  {
> -#ifdef TIF_NOTIFY_RESUME

Unless TIF_NOTIFY_RESUME is defined, this operation cannot be performed and
should generate an error.  I don't see how this happens now.

> +	if (!task_work_queue(parent, newwork))

I hate this type of construct.  "if not function()" indicating the function
succeeded.  Can you make it "== 0" instead?  Also, shouldn't we tell the user
that it failed?

David
