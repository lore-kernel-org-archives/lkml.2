Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab0LJGje (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 01:39:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:53193 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab0LJGjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 01:39:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=wGvb0Ltdw9CJWiKCwxXN9ZUpOcRgzMNJUBC/liq+0j9nROX5n0jLk8l0pIRqhHkUFX
         seU8OMKM9Rvg2LmCMYjw==
MIME-Version: 1.0
In-Reply-To: <AANLkTinY0pcTcd+OxPLyvsJgHgh=cTaB1-8VbEA2tstb@mail.gmail.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	<1291335412-16231-2-git-send-email-walken@google.com>
	<20101208152740.ac449c3d.akpm@linux-foundation.org>
	<AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
	<AANLkTinY0pcTcd+OxPLyvsJgHgh=cTaB1-8VbEA2tstb@mail.gmail.com>
Date: Thu, 9 Dec 2010 22:39:29 -0800
Message-ID: <AANLkTikXx4MgdPYWYNVj8cMOSHTHJEUHqKZ_q-P4jFYp@mail.gmail.com>
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
 faulting in pages
From: Michel Lespinasse <walken@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 9, 2010 at 10:11 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wednesday, December 8, 2010, Michel Lespinasse <walken@google.com> wrote:
>> Yes, patch 1/6 changes the long hold time to be in read mode instead
>> of write mode, which is only a band-aid. But, this prepares for patch
>> 5/6, which releases mmap_sem whenever there is contention on it or
>> when blocking on disk reads.
>
> I have to say that I'm not a huge fan of that horribly kludgy
> contention check case.
>
> The "move page-in to read-locked sequence" and the changes to
> get_user_pages look fine, but the contention thing is just disgusting.
> I'd really like to see some other approach if at all possible.

Are you OK with the part of patch 5/6 that drops mmap_sem when
blocking on disk ?

This by itself brings mmap_sem hold time down to a few seconds. Plus,
I could add something to limit the interval passed to
__mlock_vma_pages_range to a thousand pages or so, so that the hold
time would then be bounded by that constant.

I think rwsem_is_contended() actually sounds better than fiddling with
constants, but OTOH maybe the mlock use case is not significant enough
to justify introducing that new API.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
