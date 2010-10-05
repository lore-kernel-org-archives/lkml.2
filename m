Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0JEESk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 00:18:40 -0400
Received: from ozlabs.org ([203.10.76.45]:55405 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab0JEESj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 00:18:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
Date: Tue, 5 Oct 2010 14:48:34 +1030
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Adrian Bunk <bunk@stusta.de>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010051448.34984.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Oct 2010 06:21:08 am Thomas Gleixner wrote:
> Current mainline triggers a list corruption bug in
> module_bug_finalize(). dmesg excerpt below.
> 
> The corresponding code says:
> 
>         /*
>          * Strictly speaking this should have a spinlock to protect against
>          * traversals, but since we only traverse on BUG()s, a spinlock
>          * could potentially lead to deadlock and thus be counter-productive.
>          */
>         list_add(&mod->bug_list, &module_bug_list);
> 
> I can see the traversal problem vs. BUG(), but what's protecting the
> list_add() ? BKL probably did, but is that true anymore ?

I've never even *seen* this code before :(

Looks like it went through Adrian Bunk to Andrew, but despite the fact that
it (foolishly) doesn't touch kernel/module.c, it's generic code and I should
have seen it.  It did change the linux/module.h header.

So, it used to be protected by module_mutex, but Linus and I cleaned that up.

So, we need a lock around this list for adding and removal.  I'd use
list_add_rcu to try to help the lockless traversal too...

And moving it from all the archs into kernel/module.c would be a nice bonus.

Nice catch!
Rusty.
