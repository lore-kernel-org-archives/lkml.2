Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab0LTPFr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 10:05:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1465 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757693Ab0LTPFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 10:05:46 -0500
Date: Mon, 20 Dec 2010 15:58:15 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: roland@redhat.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org, rjw@sisk.pl,
        jan.kratochvil@redhat.com
Subject: Re: [PATCH 02/16] signal: fix CLD_CONTINUED notification target
Message-ID: <20101220145815.GA11583@redhat.com>
References: <1291654624-6230-1-git-send-email-tj@kernel.org> <1291654624-6230-3-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291654624-6230-3-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Tejun Heo wrote:
>
> CLD_CONTINUED notification code calls do_notify_parent_cldstop() with
> its group_leader; however, do_notify_parent_cldstop() already uses the
> group_leader for non-ptraced notifications.

Yes,

> The duplicate
> ->group_leader dereferencing is unnecessary and leads to incorrectly
> notifying the group_leader's ptracer of CLD_CONTINUED from a different
> task in the group.  Fix it.

I do not really agree this is wrong, group_leader was used intentionally
for ptrace case.

There is no "correct" thread who should report CLD_CONTINUED, a random
thread wins and notifies its ->real_parent or debugger. If we always
choose ->group_leader, we always knows what happens. With this patch
we can't predict where does this notification go.

> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -1867,7 +1867,7 @@ relock:
>
>  		if (why) {
>  			read_lock(&tasklist_lock);
> -			do_notify_parent_cldstop(current->group_leader, why);
> +			do_notify_parent_cldstop(current, why);

OTOH, I see nothing really wrong with this change, and this all will
be reworked by the next patches anyway.

Oleg.

