Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754232Ab2DQQgx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 12:36:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10557 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753996Ab2DQQgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 12:36:52 -0400
Date: Tue, 17 Apr 2012 18:36:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 3/3] cred: change keyctl_session_to_parent() to use
	task_work_add()
Message-ID: <20120417163606.GC14527@redhat.com>
References: <20120414021252.GC23393@redhat.com> <20120414021201.GA23385@redhat.com> <27037.1334672580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27037.1334672580@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17, David Howells wrote:
>
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > -	int ret;
> > +	struct cred *cred;
> > +	int err;
>
> There's no need to change ret to be err.  It produces slightly less churn if
> you don't.

OK, I'll change it back.

>
> > +	err = -ENOMEM;
> > +	newwork = kmalloc(sizeof(struct task_work), GFP_KERNEL);
> > +	if (!newwork)
> > +		goto error_keyring;
>
> This passes unnecessarily through kfree(newwork).

but harmless, newwork == NULL in this case,

> Please add a new goto label
> and go to that.

OK, probably this is more clear, will do.

> > -/*
> > - * Replace a process's session keyring on behalf of one of its children when
> > - * the target  process is about to resume userspace execution.
> > - */
>
> Please don't delete the banner comment saying what the function does.

OOPS, sorry, this was unintentional.

> > -void key_replace_session_keyring(void)
> > +void key_change_session_keyring(struct task_work *twork)
>
> There's no particular need to change the name of the function.

There is.

Until we cleanup arch/* do_notify_resume() still does

	if (current->replacement_session_keyring)
		key_replace_session_keyring();

Oleg.

