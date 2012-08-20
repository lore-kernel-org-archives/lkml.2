Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2HTLxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 07:53:04 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54768 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab2HTLxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 07:53:01 -0400
MIME-Version: 1.0
In-Reply-To: <50321CD3.5050501@redhat.com>
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu>
	<502D42E5.7090403@redhat.com>
	<20120818000312.GA4262@evergreen.ssec.wisc.edu>
	<502F100A.1080401@redhat.com>
	<alpine.LSU.2.00.1208200032450.24855@eggly.anvils>
	<CANN689Ej7XLh8VKuaPrTttDrtDGQbXuYJgS2uKnZL2EYVTM3Dg@mail.gmail.com>
	<50321CD3.5050501@redhat.com>
Date: Mon, 20 Aug 2012 04:53:00 -0700
Message-ID: <CANN689Hch8ao9MnV0Luk6_b0kFJtcvfZZ7jEGWyvUN41Q=FWnA@mail.gmail.com>
Subject: Re: Repeated fork() causes SLAB to grow without bound
From: Michel Lespinasse <walken@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: Hugh Dickins <hughd@google.com>,
        Daniel Forrest <dan.forrest@ssec.wisc.edu>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 4:17 AM, Rik van Riel <riel@redhat.com> wrote:
> Without the anon_vma_chains, we end up scanning every single
> one of the child processes (and the parent) for every COWed
> page, which can be a real issue when the VM runs into 1000
> such pages, for 1000 child processes.
>
> Unfortunately, we have seen this happen...

Well, it only happens if the vma is created in the parent, and the
first anon write also happens in the parent. I suppose that's a
legitimate thing to do in a forking server though - say, for an
expensive initialization stage, or precomputing some table, or
whatever.

When fork happens after the first anon page has been created, the
child VMA currently ends up being added to the parent's anon_vma -
even if the child might never create new anon pages into that VMA.

I wonder if it might help to add the child VMA onto the parent's
anon_vma only at the first child COW event. That way it would at least
be possible (with userspace changes) for any forking servers to
separate the areas they want to write into from the parent (such as
things that need expensive initialization), from the ones that they
want to write into from the child, and have none of the anon_vma lists
grow too large.

This might still be impractical if one has too many such workloads to
care about. I'm just not sure how prevalent the problem workloads are.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
