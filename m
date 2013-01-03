Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3ACXeS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 18:34:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:34605 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753847Ab3ACXeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 18:34:16 -0500
Date: Thu, 3 Jan 2013 15:34:14 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 25/32] aio: use xchg() instead of completion_lock
Message-Id: <20130103153414.23b0b913.akpm@linux-foundation.org>
In-Reply-To: <1356573611-18590-28-git-send-email-koverstreet@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
	<1356573611-18590-28-git-send-email-koverstreet@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012 18:00:04 -0800
Kent Overstreet <koverstreet@google.com> wrote:

> So, for sticking kiocb completions on the kioctx ringbuffer, we need a
> lock - it unfortunately can't be lockless.
> 
> When the kioctx is shared between threads on different cpus and the rate
> of completions is high, this lock sees quite a bit of contention - in
> terms of cacheline contention it's the hottest thing in the aio
> subsystem.
> 
> That means, with a regular spinlock, we're going to take a cache miss
> to grab the lock, then another cache miss when we touch the data the
> lock protects - if it's on the same cacheline as the lock, other cpus
> spinning on the lock are going to be pulling it out from under us as
> we're using it.
> 
> So, we use an old trick to get rid of this second forced cache miss -
> make the data the lock protects be the lock itself, so we grab them both
> at once.

Boy I hope you got that right.

Did you consider using bit_spin_lock() on the upper bit of `tail'? 
We've done that in other places and we at least know that it works. 
And it has the optimisations for CONFIG_SMP=n, understands
CONFIG_DEBUG_SPINLOCK, has arch-specific optimisations, etc.
