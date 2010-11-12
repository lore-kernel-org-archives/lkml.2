Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab0KLXx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 18:53:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60613 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933008Ab0KLXx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 18:53:27 -0500
MIME-Version: 1.0
In-Reply-To: <20101112230650.GA3317@amd>
References: <20101111080012.GB10210@amd> <AANLkTinAY=jbtEEFa0XgYiHs8Lj21Q58FhPpU+TOtWnf@mail.gmail.com>
 <20101112230650.GA3317@amd>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 12 Nov 2010 15:52:55 -0800
Message-ID: <AANLkTi=3xTcqasoN77o3Hk9kyfT4+MbFR7K7CZE=U36Y@mail.gmail.com>
Subject: Re: [patches] seqlock: add barrier-less special cases for seqcounts
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 3:06 PM, Nick Piggin <npiggin@kernel.dk> wrote:
. ...
> seq2 = read_seqlock_begin(&child->d_seq);
> if (read_seqcount_retry(&dentry->d_seq, seq))
>  /* bail out */

So the only issue is that this particular back-to-back sequence with
these kinds of "take one seqlock and release the previous one" where
you currently end up having basically one smp_rmb() at the end of
"read_seqlock_begin()", only to be followed immediately by another one
starting out the "read_seqcount_retry()"?

If so, I think we should make _that_ operation ("move from one seqlock
to another") be the special one, because it smells like in general,
using the special non-locking versions is going to be a very subtle
interface.

                      Linus
