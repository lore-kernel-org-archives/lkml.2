Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0JTWsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 18:48:18 -0400
Received: from mx2.netapp.com ([216.240.18.37]:40479 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab0JTWsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 18:48:15 -0400
X-IronPort-AV: E=Sophos;i="4.57,357,1283756400"; 
   d="scan'208";a="470581252"
Subject: Re: [PATCH 5/6] IMA: use rbtree instead of radix tree for inode
 information cache
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, Peter Zijlstra <peterz@infradead.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        jmorris@namei.org, kyle@mcmartin.ca, hpa@zytor.com,
        akpm@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <AANLkTikoPoV=OYjzX9+Rd5tWERS+n8sFejJuot7++ONP@mail.gmail.com>
References: <20101019225813.12396.2564.stgit@paris.rdu.redhat.com>
	 <20101019225839.12396.92630.stgit@paris.rdu.redhat.com>
	 <20101019231747.GC12506@dastard> <1287574269.3488.11.camel@twins>
	 <20101020220557.GN32255@dastard>
	 <AANLkTikoPoV=OYjzX9+Rd5tWERS+n8sFejJuot7++ONP@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Wed, 20 Oct 2010 18:47:55 -0400
Message-ID: <1287614875.23812.7.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
X-OriginalArrivalTime: 20 Oct 2010 22:47:59.0431 (UTC) FILETIME=[D8343D70:01CB70A8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-20 at 15:22 -0700, Linus Torvalds wrote:
> On Wed, Oct 20, 2010 at 3:05 PM, Dave Chinner <david@fromorbit.com> wrote:
> >
> > /me wanders off to look at converting the xfs buffer cache rbtrees
> > to RCU....
> 
> Look out for livelocks, though. And yes, they can happen.
> 
> So rather than a loop, one option is to do basically
> 
>   rcu_read_lock();
>   seq = read_seqbegin();
> 
>   .. do lookup ..
> 
>   need_lock = read_seqretry(seq);
>   rcu_read_unlock();
> 
>   if (need_lock) {
>     get_real_lock();
> 
>     .. do lookup ..
> 
>     drop_real_lock();
>  }
> 
> which just falls back to a locked access if the rcu model doesn't work.
> 
>                              Linus

That is a really interesting alternative to traditional locking. Could
we perhaps document it in Documentation/rbtree.txt?

Cheers
   Trond

