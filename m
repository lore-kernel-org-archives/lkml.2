Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0JDLA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:00:26 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:60438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754467Ab0JDLAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:00:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
Date: Mon, 4 Oct 2010 13:00:14 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010041300.15234.arnd@arndb.de>
X-Provags-ID: V02:K0:KiI878lOVxXHWayDmDkSszpX0YixcJzq2JYcrlVWmQt
 AazVFD7wmCloUv/9JkZA64KMqGuJB2ddI0FRmZGbjzFbnWgbvj
 Ux7s2XaPJs0xC9YSpDFzbP9zoelhiRZnaxVDDYmmGhYwl8cd1t
 OTz2qWvcs7gIjN5q1TQp/eaer0PIu+xBSbsrvAw4+7W1uyUHlo
 Yw/ydm3QgH59yZWzWugXw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 October 2010, Thomas Gleixner wrote:
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

BKL hasn't been in this code path since before git.

I think this relatively recent change caused module_finalize to be
called without module_mutex held:

commit 75676500f8298f0ee89db12db97294883c4b768e
Author: Rusty Russell <rusty@rustcorp.com.au>
Date:   Sat Jun 5 11:17:36 2010 -0600

    module: make locking more fine-grained.
    
    Kay Sievers <kay.sievers@vrfy.org> reports that we still have some
    contention over module loading which is slowing boot.
    
    Linus also disliked a previous "drop lock and regrab" patch to fix the
    bne2 "gave up waiting for init of module libcrc32c" message.
    
    This is more ambitious: we only grab the lock where we need it.
    
    Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
    Cc: Brandon Philips <brandon@ifup.org>
    Cc: Kay Sievers <kay.sievers@vrfy.org>
    Cc: Linus Torvalds <torvalds@linux-foundation.org>

	Arnd
