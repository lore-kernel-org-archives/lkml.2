Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab2EYN3H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 09:29:07 -0400
Received: from casper.infradead.org ([85.118.1.10]:33472 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679Ab2EYN3F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 09:29:05 -0400
Subject: Re: [PATCH] tty: tty_mutex: fix lockdep warning in
 tty_lock_pair(v1)
From: Peter Zijlstra <peterz@infradead.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>
In-Reply-To: <CACVXFVP290dwgJVhgMf9girR9h0yU_mjxcN2Po0u1c1y4=QL0w@mail.gmail.com>
References: <1337651931-5301-1-git-send-email-ming.lei@canonical.com>
	 <CACVXFVP290dwgJVhgMf9girR9h0yU_mjxcN2Po0u1c1y4=QL0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 May 2012 15:28:53 +0200
Message-ID: <1337952533.9783.195.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 14:01 +0800, Ming Lei wrote:

> Even though the patch is applied, there is still one related problem about
> mixing tty_lock_pair with tty_unlock and tty_lock. If tty locks are
> held by calling
> tty_lock_pair, then deadlock warning between legacy_mutex/1 and legacy_mutex
> may be triggered if tty_unlock(tty) and tty_lock(tty) are called later
> when tty < tty2,
> see tty_ldisc_release() in tty_release().

This just gives me a head-ache instead of explaining anything.

Having looked at the source I still don't see how it could possibly
work,.. So the problem with tty_release() -> tty_ldisc_release() is that
tty_ldisc_release() does an unlock/lock of tty.

However your tty_lock_pair() can still result in tty being subclass 1,
see your else branch, nested case.

That said, how is this not a real deadlock? If you rely on tty pointer
ordering to avoid deadlocks, you always need to lock them in the same
order. The unlock+lock in ldisc_release violates that.

If we don't rely on the order, then why bother with the _pair()
primitive?

