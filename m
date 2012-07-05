Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2GESTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 14:19:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38688 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab2GESTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 14:19:09 -0400
MIME-Version: 1.0
In-Reply-To: <1341511933-11169-3-git-send-email-tytso@mit.edu>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu> <1341511933-11169-3-git-send-email-tytso@mit.edu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jul 2012 11:18:47 -0700
X-Google-Sender-Auth: 68oy7NlUmL24MFACJrzfSRO-WII
Message-ID: <CA+55aFxifcNv+XfUcTu-+aznqC_tB2C+17qDEaAWKZOyoc8mGg@mail.gmail.com>
Subject: Re: [PATCH 02/10] random: use lockless techniques when mixing entropy pools
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>, w@1wt.eu,
        ewust@umich.edu, zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
        nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
        davem@davemloft.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 11:12 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Also, we will use a trylock when trying to increase then entropy
> accounting during the interrupt path to avoid taking a spinlock there;
> if there is contention, we will simply not credit the entropy count,
> thus failing safe.  Thanks to Dan Carpenter for suggesting this
> approach.

Actually, I hate that. If the *only* thing the spinlock protects is
that entropy count, then use one single cmpxchg() for that field
instead.

The trylock means that now you need to disable interrupts etc. Just
don't do it. Do things entirely locklessly, and minimizing atomics.
Quite frankly, I think that protecting the entropy count is completely
idiotic, since it's not "real" in any form anyway, but if you
absolutely have to, a single cmpxchg is much better than playing games
with spinlocks and interrupt disables.

                      Linus
