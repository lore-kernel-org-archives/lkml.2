Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712Ab0LNPoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:44:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52769 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754034Ab0LNPoI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <20101213170526.3b010058.akpm@linux-foundation.org>
References: <1291335412-16231-1-git-send-email-walken@google.com>
 <1291335412-16231-2-git-send-email-walken@google.com> <20101208152740.ac449c3d.akpm@linux-foundation.org>
 <AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
 <AANLkTinY0pcTcd+OxPLyvsJgHgh=cTaB1-8VbEA2tstb@mail.gmail.com>
 <20101214005140.GA29904@google.com> <20101213170526.3b010058.akpm@linux-foundation.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 14 Dec 2010 07:43:46 -0800
Message-ID: <AANLkTim-sV6JO5apPdd9oG23q3THaZ1FazfF1nqUfs6C@mail.gmail.com>
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
 faulting in pages
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michel Lespinasse <walken@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 13, 2010 at 5:05 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Reading 1024 pages can still take a long time.  I can't immediately
> think of a better approach though.

I don't see the need for _any_ of this.

Guys, we used to hold the damn thing for writing the *WHOLE*DAMN*TIME*.

Without _any_ at all of the crappy "rwsem_contended()" or the stupid
constants, we hold it only for reading, _and_ we drop it for any
actual IO. So the semaphore is held only for actual CPU intensive
cases. We're talking a reduction from minutes to milliseconds.

So stop this insanity. Do neither the rwsem contention checking _nor_
the "do things in batches".

Really.

The thing is, afte six months of doing the simple and straightforward
and _obvious_ parts, if people still think it's a real problem, at
that point I'm going to be interested in hearing about trying to be
clever. But when the semaphore hold times have gone down by four
orders of magnitude, I simply think it's fundamentally wrong to dick
around with some stupid detail. Certainly not in the same patch
series.

"Keep It Simple, Stupid".

So don't even _try_ to send me a series that does all of this. I'm not
going to take it. Do a series that fixes the _problem_. No more.

And btw, read the paper "Worse is better".

                                   Linus
