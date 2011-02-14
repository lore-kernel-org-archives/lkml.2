Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755754Ab1BNP1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 10:27:08 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49566 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754635Ab1BNP1F convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 10:27:05 -0500
MIME-Version: 1.0
In-Reply-To: <m1fwrrtc0m.fsf@fess.ebiederm.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
 <m1hbce46fw.fsf@fess.ebiederm.org> <AANLkTikJL_4-7F_2oSuefSpL7ak3+OWLk7F+bDqWT8XJ@mail.gmail.com>
 <m1bp2ly41q.fsf@fess.ebiederm.org> <AANLkTimGH5mU+OLRKb=H3WgLXPZaSc5heR+4w5gj2aD4@mail.gmail.com>
 <AANLkTikj-ZTS58uAqUmKQEWzdD3f5DJeox=gOJ9z8rSb@mail.gmail.com>
 <AANLkTinjsimbe6-YgcSK0-zqDuoZ=8xCReHnKZoG4GU9@mail.gmail.com>
 <m14o87wev8.fsf@fess.ebiederm.org> <AANLkTimO3h80Wk44OhpfkjzxpzdDKnf6emj2fNObn_jD@mail.gmail.com>
 <m1r5bbthan.fsf@fess.ebiederm.org> <m1fwrrtc0m.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Feb 2011 07:26:13 -0800
Message-ID: <AANLkTim2i1NTxLFszh7+DPWmpp35H8YEfFR+o-AWoO9D@mail.gmail.com>
Subject: Re: Heads up Linux 2.6.38-rc4 compile problems.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Alex Riesen <raa.lkml@gmail.com>, David Miller <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 13, 2011 at 9:34 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> And for completeness.  When I was rebooting v2.6.38-rc4 to start running
> 795abaf1e4e188c4171e3cd3dbb11a9fcacaf505  I hit this.

.. but this was while still running the older kernel, right?

> <2>kernel BUG at mm/filemap.c:125!

I suspect this is "normal" after page table corruption. Any page that
was mapped but overwritten by the corruption would never get unmapped
(since it can't be found in the page tables), and then you trigger the

  BUG_ON(page_mapped(page));

in __remove_from_page_cache() at umount time. Your register state
shows that %eax is 0, and that's the count that we tested
("page->_mapcount" is -1 when there are no mappings, so you have one
lost mapping reference to that page).

So that oops isn't all that interesting, I'm afraid.

                             Linus
