Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab2GWPwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 11:52:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10679 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab2GWPwd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 11:52:33 -0400
Date: Mon, 23 Jul 2012 17:49:27 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Djalal Harouni <tixxdz@opendz.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Solar Designer <solar@openwall.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] proc: do not allow negative offsets on
	/proc/<pid>/environ
Message-ID: <20120723154927.GA17439@redhat.com>
References: <1342974959-2748-1-git-send-email-tixxdz@opendz.org> <20120722200049.GA29222@redhat.com> <20120723010447.GA23410@dztty>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120723010447.GA23410@dztty>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Djalal,

On 07/23, Djalal Harouni wrote:
>
> Hi Oleg,
>
> On Sun, Jul 22, 2012 at 10:00:49PM +0200, Oleg Nesterov wrote:
> >
> > Probablt the patch makes sense, but I can't understand the changelog...
> >
> > > Allowing negative offsets on /proc/<pid>/environ can turn it to act like
> > > /proc/<pid>/mem. A negative offset will pass the
> > > fs/read_write.c:lseek_execute() and the environ_read() checks and will
> > > point to another VMA.
> >
> > which VMA?
> It depends on the offset. Please see below.
>
> > environ_read() can only read the memory from [env_start, env_end], and
> > it should check *ppos anyway to ensure it doesn't read something else.
> Yes I agree, but currently that's not the case, there are no checks on *ppos.
                                                  ^^^^^^^^^^^^^^^^^^^
There is, unless I missed something, just it is buggy, no?

> So if you pass a negative offset you will be able to read from an arbitrary
> address.
>
> [...snip...]
>
>   inside environ_read() there is only a one check:
>
>   int this_len = mm->env_end - (mm->env_start + src);
>
>   if (this_len <= 0)
>     break;
>
>
>   Here 'src' is 'src = *ppos' the negative offset converted to unsigned long
>   and (mm->env_start + src) can overflow and point to another VMA.
>
>   int this_len = mm->env_end - (mm->env_start + src)
>
>   'this_len' will be positive and we pass that check.

OK, thanks, but doesn't this mean that this check should be fixed
to avoid the overflow, no matter what *ppos is?

With or without FMODE_UNSIGNED_OFFSET change. And perhaps it is
possible to trigger the overflow even with the positive *ppos,
because:

> I also don't like the truncation of the result to 'int this_len'

Yes.

> BTW should I resend the patch with a better changelog entry ?

Up to you, but I think this makes sense ;)

> I'll also add another patch to check the offsets inside environ_read().

Yes, agreed, but please see above.

Please correct me, but afaics this patch should come 1st and fix the bug.
FMODE_UNSIGNED_OFFSET change can be considered as a cleanup after that.

What do you think?

Oleg.

