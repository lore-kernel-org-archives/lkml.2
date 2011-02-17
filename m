Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab1BQVAl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:00:41 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33202
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781Ab1BQVAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:00:39 -0500
Date: Thu, 17 Feb 2011 13:01:15 -0800 (PST)
Message-Id: <20110217.130115.71101941.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTi=bgmRwGXEE_wriYo-5gmyaB43pMUzHf7idiK0k@mail.gmail.com>
References: <AANLkTikGVS9EM=7uhwYfXrGHg9yzes7m0pxAinRxivPC@mail.gmail.com>
	<20110217180042.GA30530@dtor-ws.eng.vmware.com>
	<AANLkTi=bgmRwGXEE_wriYo-5gmyaB43pMUzHf7idiK0k@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 10:06:40 -0800

> David, why are you saying that regular "just mark the structure
> alignment correctly" doesn't work?

Because it's been proven to not work:

http://marc.info/?l=linux-kernel&m=129674396021733&w=2
http://marc.info/?l=linux-kernel&m=129674399621795&w=2
http://marc.info/?l=linux-kernel&m=129674396121739&w=2
http://marc.info/?l=linux-kernel&m=129674396021735&w=2

GCC is very clever with "static" objects these days.

It thinks that, because you mark something "static", it can align it
any way it wants because it controls the domain in which the object
exists.  It "knows" that the object can't be part of an array, and
therefore no external entity can be concerned about the true "size" of
the object (specifically wrt. side effects of the alignment of the
object).

In these cases it takes the explicit alignment attribute as a minimum,
not as an absolute requirement.

But we lie to the compiler, we mark things static then put them into a
special a special section, then try to iterate over those objects
globally as an array and expect the compiler to lay them all out
with identical alignments and sizes everywhere.

And this doesn't work.
