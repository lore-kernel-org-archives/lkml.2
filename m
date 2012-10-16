Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870Ab2JPSxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 14:53:09 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:42589 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755773Ab2JPSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 14:53:08 -0400
Date: Tue, 16 Oct 2012 18:53:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Andi Kleen <andi@firstfloor.org>, Ezequiel Garcia <elezegarcia@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Tim Bird <tim.bird@am.sony.com>,
        celinux-dev@lists.celinuxforum.org
Subject: Re: [Q] Default SLAB allocator
In-Reply-To: <alpine.DEB.2.00.1210151743130.31712@chino.kir.corp.google.com>
Message-ID: <0000013a6aec10e3-304d4336-6d62-4b0f-9d06-e2ca4c6d8dcf-000000@email.amazonses.com>
References: <CALF0-+XGn5=QSE0bpa4RTag9CAJ63MKz1kvaYbpw34qUhViaZA@mail.gmail.com> <m27gqwtyu9.fsf@firstfloor.org> <alpine.DEB.2.00.1210111558290.6409@chino.kir.corp.google.com> <m2391ktxjj.fsf@firstfloor.org> <alpine.DEB.2.00.1210130249070.7462@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1210151743130.31712@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Oct 2012, David Rientjes wrote:

> This type of workload that really exhibits the problem with remote freeing
> would suggest that the design of slub itself is the problem here.

There is a tradeoff here between spatial data locality and temporal
locality. Slub always frees to the queue associated with the slab page
that the object originated from and therefore restores spatial data
locality. It will always serve all objects available in a slab page
before moving onto the next. Within a slab page it can consider temporal
locality.

Slab considers temporal locatlity more important and will not return
objects to the originating slab pages until they are no longer in use. It
(ideally) will serve objects in the order they were freed. This breaks
down in the NUMA case and the allocator got into a pretty bizarre queueing
configuration (with lots and lots of queues) as a result of our attempt to
preverse the free/alloc order per NUMA node (look at the alien caches
f.e.). Slub is an alternative to that approach.

Slab also has the problem of queue handling overhead due to the attempt to
throw objects out of the queues that are likely no more cache hot. Every
few seconds it needs to run queue cleaning through all queues that exists
on the system. How accurate it tracks the actual cache hotness of objects
is not clear.

