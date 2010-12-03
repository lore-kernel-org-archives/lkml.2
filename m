Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab0LCWv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 17:51:56 -0500
Received: from smtp-out.google.com ([74.125.121.35]:33809 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab0LCWvy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 17:51:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iNI3lxxMyDH8Wz8FRvDWCVltEXasQs3DMBHoEQjK879TJS5zhyT3x0qYYsXz+et3HS
         f/g63BJHs36rO46ZvVag==
MIME-Version: 1.0
In-Reply-To: <1291416070.2032.92.camel@laptop>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	<1291335412-16231-7-git-send-email-walken@google.com>
	<1291416070.2032.92.camel@laptop>
Date: Fri, 3 Dec 2010 14:51:50 -0800
Message-ID: <AANLkTikqTV3qD=BPb4ApAfbLOVDO9cCqoYCot9yTkb30@mail.gmail.com>
Subject: Re: [PATCH 6/6] x86 rwsem: more precise rwsem_is_contended() implementation
From: Michel Lespinasse <walken@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 3, 2010 at 2:41 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2010-12-02 at 16:16 -0800, Michel Lespinasse wrote:
>> We would like rwsem_is_contended() to return true only once a contending
>> writer has had a chance to insert itself onto the rwsem wait queue.
>> To that end, we need to differenciate between active and queued writers.
>
> So you're only considering writer-writer contention? Not writer-reader
> and reader-writer contention?
>
> I'd argue rwsem_is_contended() should return true if there is _any_
> blocked task, be it a read or a writer.
>
> If you want something else call it something else, like
> rwsem_is_write_contended() (there's a pending writer), or
> rwsem_is_read_contended() (there's a pending reader).

I said 'a contending writer' because in my use case, the rwsem was
being held for read, and other readers would get admitted in (so they
don't count as contention).

The code as written will work in the more general case - it tells if
there is another thread queued waiting for the rwsem to be released.
It can't tell you however if that thread is a reader or a writer (but
if mmap_sem is already held for read, then the contending thread must
be a writer).

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
