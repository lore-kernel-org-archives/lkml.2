Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755118Ab0H0RzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 13:55:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:20126 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab0H0RzT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 13:55:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=r65LJTEBsoECSiKrjbK3RyNnb07sFg8vCqUwnmmUzd+jSmQ5nDxjpCXSA5NR2YhMmC
         Un+3ad/4pm2geGZh7XFQ==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1008271159160.18495@router.home>
References: <alpine.LSU.2.00.1008252305540.19107@sister.anvils>
	<20100826235052.GZ6803@random.random>
	<AANLkTimgKcP78CNakDf34NrVrd5apfXrtptNw+G6G5DK@mail.gmail.com>
	<20100827095546.GC6803@random.random>
	<AANLkTikvB1fN42A91ZdEHyEXnz2bGw9Q21dJcfa3PBP0@mail.gmail.com>
	<alpine.DEB.2.00.1008271159160.18495@router.home>
Date: Fri, 27 Aug 2010 10:55:11 -0700
Message-ID: <AANLkTi=FeHnLu4_6M5N6yUL==4YyxVXXxsccsE2kNUbm@mail.gmail.com>
Subject: Re: [PATCH] mm: fix hang on anon_vma->root->lock
From: Hugh Dickins <hughd@google.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 27, 2010 at 10:13 AM, Christoph Lameter <cl@linux.com> wrote:

> The basic problem with SLAB_DESTROY_BY_RCU is that you get a reference to
> an object that is guaranteed only to have the same type (the instance may
> fluctuate and be replaced from under you unless other measures are taken).

(I wouldn't describe that as a "problem with SLAB_DESTROY_BY_RCU":
it's precisely the nature of SLAB_DESTROY_BY_RCU, what makes it useful
in solving backward-locking problems elsewhere.)

>
> Typically one must take a lock within the memory structure to pin down
> the object (or take a refcount). Only then can you follow pointers and
> such. It is only possible to verify that the right object has been
> reached *after* locking. Following a pointer without having determined
> that we hit the right object should not occur.
>
> A solution here would be to take the anon_vma->lock (prevents the object
> switching under us) and then verify that the mapping is the one we are
> looking for and that the pointer points to the right root. Then take the
> root lock.
>
> Hughs solution takes a global spinlock which will limit scalability.

Eh?  My solution was a second page_mapped(page) test i.e. testing an atomic.

Hugh
