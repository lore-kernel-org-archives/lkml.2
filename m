Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755092Ab0JTW1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:27:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43296 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751230Ab0JTW1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:27:50 -0400
MIME-Version: 1.0
In-Reply-To: <20101020220557.GN32255@dastard>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
 <20101019225839.12396.92630.stgit@paris.rdu.redhat.com> <20101019231747.GC12506@dastard>
 <1287574269.3488.11.camel@twins> <20101020220557.GN32255@dastard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Oct 2010 15:22:21 -0700
Message-ID: <AANLkTikoPoV=OYjzX9+Rd5tWERS+n8sFejJuot7++ONP@mail.gmail.com>
Subject: Re: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
 information cache
To: Dave Chinner <david@fromorbit.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Eric Paris <eparis@redhat.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, zohar@us.ibm.com,
        warthog9@kernel.org, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org, mingo@elte.hu,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 3:05 PM, Dave Chinner <david@fromorbit.com> wrote:
>
> /me wanders off to look at converting the xfs buffer cache rbtrees
> to RCU....

Look out for livelocks, though. And yes, they can happen.

So rather than a loop, one option is to do basically

  rcu_read_lock();
  seq = read_seqbegin();

  .. do lookup ..

  need_lock = read_seqretry(seq);
  rcu_read_unlock();

  if (need_lock) {
    get_real_lock();

    .. do lookup ..

    drop_real_lock();
 }

which just falls back to a locked access if the rcu model doesn't work.

                             Linus
