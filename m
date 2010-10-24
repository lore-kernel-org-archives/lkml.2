Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932912Ab0JXUf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 16:35:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58973 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932698Ab0JXUf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 16:35:57 -0400
MIME-Version: 1.0
In-Reply-To: <4CC49274.3030803@fusionio.com>
References: <4CC49274.3030803@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 24 Oct 2010 13:35:33 -0700
Message-ID: <AANLkTik4qAzZPLO8HHBCM34_NLEEdPj04RyXPfeR-wSv@mail.gmail.com>
Subject: Re: [GIT PULL] Revert of the IO stat fix
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 1:09 PM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> The fix for cross-partition merges screwing up disk stats turns out
> to be problematic on various levels. Lets revert this one so we have
> time to come up with a proper solution for this.

Hmm.. I think the reverted patch looks like it really is the right
thing to do, so I hate reverting it this early. What were the problems
with it?

Btw, one thing that seems to be missing in the original commit (which
is not necessarily the reason for the trouble, of course), is that
elv_rq_merge_ok() seems to not check the partition. As far as I can
tell, we should have a

    if (req->part != bio->bi_bdev->bd_part)
       return 0;

there, no? And you should _not_ set rq->part in "drive_stat_acct()",
you should set it from bio->bi_bdev->bd_part when you create the
request.

(And if it is NULL, just don't do partition accounting at all)

Hmm? What am I missing? What were the bugs?

                      Linus
