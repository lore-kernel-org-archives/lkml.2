Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1HUP3a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 11:29:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25696 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751880Ab1HUP33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 11:29:29 -0400
Date: Sun, 21 Aug 2011 17:25:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: bookjovi@gmail.com
Cc: dhowells@redhat.com, nhorman@tuxdriver.com, roland@redhat.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] coredump: fix pipe coredump when core limit is 0
Message-ID: <20110821152545.GA30955@redhat.com>
References: <1313925904-5935-1-git-send-email-bookjovi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313925904-5935-1-git-send-email-bookjovi@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21, bookjovi@gmail.com wrote:
>
> From: Jovi Zhang <bookjovi@gmail.com>
>
> Regressing from 2.6.35

Hmm. Thanks Jovi.

> In pipe coredump case, normally core limits are irrelevant,
> since we're not writing to the file system, but core limit 0
> is a special value, kernel should skip the dump when limit is 0.

Hmm. probably yes... although I'd say I do not really know. iirc,
previously RLIMIT_CORE was simply ignored if ispipe. But then we
changed the rules many time.

Yes. See 725eae32df7754044809973034429a47e6035158. This is where
we changed the "limit == 0 && ispipe" behaviour.

> This error intruduced by commit c71354 in 2.6.35, that commit put
> core limit zero check into non-pipe code branch.
>
>     commit c713541125002b8bc9e681af3b09118e771e2d8a
>     Author: Oleg Nesterov <oleg@redhat.com>
>     Date:   Wed May 26 14:43:05 2010 -0700
>
>     coredump: factor out the not-ispipe file checks

Cough. I don't think so ;)

Yes, that patch moves the check, but please note that before the patch
we did

	if ((!ispipe) && (cprm.limit < binfmt->min_coredump))
		goto fail;

so I do not think this patch can make any difference.

I think this was changed by 898b374af6f71041bd3bceebe257e564f3f1d458.

> For non-pipe case, limit 0 also means drop the coredump, so just put
> the zero limit check at do_coredump function begining.

Neil, what do you think? Should we change the code or the comment?


As for the patch, it is not exactly right in any case,

> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2119,6 +2119,10 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	if (!__get_dumpable(cprm.mm_flags))
>  		goto fail;
>
> +	/* Core limit as 0 should skip the dump */
> +	if (cprm.limit == 0)
> +		goto fail;

Even if we do not dump, we should kill all tasks/threads which use
this ->mm. We shouldn't miss coredump_wait().

To clarify, I don't really know _why_, and probably it makes sense
to change this behaviour. But this needs a separate patch plus
discussion.

Oleg.

