Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767Ab0IYRAU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 13:00:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51361 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751254Ab0IYRAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 13:00:19 -0400
MIME-Version: 1.0
In-Reply-To: <4C9DD2D5.8090807@fusionio.com>
References: <4C9DD2D5.8090807@fusionio.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 25 Sep 2010 09:59:28 -0700
Message-ID: <AANLkTikcR8fu11jyLcD3Fuvm4TPxU=46jLcpsYryHONP@mail.gmail.com>
Subject: Re: [GIT PULL] One important block fix for 2.6.36-rc
To: Jens Axboe <jaxboe@fusionio.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 25, 2010 at 3:45 AM, Jens Axboe <jaxboe@fusionio.com> wrote:
>
> Please pull asap, thanks.

Pulled, but I _really_ wish you started looking at cleanliness issues,
even with bug-reports.

That's a singularly stupid and unreadable way of testing "do those
flags match". It is quite possible that the compiler fixes up the
stupidity, but that doesn't make it much better.

Here's how things like this _should_ be tested:

   #define REQ_FLAGS_MUST_MATCH (REQ_SECURE | REQ_DISCARD)

   ...
   /* Check that flags match in the required bits */
   if ((req->cmd_flags ^ next->cmd_flags) & REQ_FLAGS_MUST_MATCH)
      return 0;
   ...

which is (a) smaller (b) easier and clearer to add flags as needed and
(c) actually more readable due to not having duplicated logic (not
just one if-statement, but one mask too).

And yes, I think you'd want to add a few flags there. Looking at the
REQ_xyz flags, I suspect most o them should really really match for
requests to be mergeable. Wouldn't it be better to think of it in
terms of "do we really allow different cmd_flags requests to merge"
than adding one bit ad-hoc at a time?

                           Linus
