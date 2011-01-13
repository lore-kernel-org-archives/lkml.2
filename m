Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580Ab1AMDz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:55:29 -0500
Received: from mx2.netapp.com ([216.240.18.37]:29262 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1AMDz1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:55:27 -0500
X-IronPort-AV: E=Sophos;i="4.60,316,1291622400"; 
   d="scan'208";a="504837226"
Subject: Re: vfs-scale, chroot
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTik-AdWpPqmR5TSCuijGwe3XLXm=HYVdUOhK3dDT@mail.gmail.com>
References: <29345.1294861630@jrobl>
	 <1294862680.2971.51.camel@heimdal.trondhjem.org>
	 <AANLkTik-AdWpPqmR5TSCuijGwe3XLXm=HYVdUOhK3dDT@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp Inc
Date: Wed, 12 Jan 2011 22:55:10 -0500
Message-ID: <1294890910.15025.75.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
X-OriginalArrivalTime: 13 Jan 2011 03:55:11.0877 (UTC) FILETIME=[AD7F4B50:01CBB2D5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 12:25 +1100, Nick Piggin wrote: 
> On Thu, Jan 13, 2011 at 7:04 AM, Trond Myklebust
> <Trond.Myklebust@netapp.com> wrote:
> 
> > BTW, Nick: Given that some filesystems such as NFS are _always_ going to
> > reject LOOKUP_RCU,
> 
> That's not very optimistic of you... why is that a given, my I ask?
> Or do you just mean as-in the current code?

In the current code, the ECHILD is unconditional, so adding the
unlikely() is clearly pre-empting the reality on the ground.

In the longer run, we can convert the NFS d_revalidate() to accept
LOOKUP_RCU in the case where we believe we can trust the cache without
having to issue an RPC call. That will mainly be in the case where we
hold an NFSv4 delegation, or where we believe the parent directory mtime
has not changed. However that is not something I'm going to have the
cycles to do in this merge window. I assume there will be other
filesystems whose maintainers have similar constraints.

However, even if we were to make these changes, then we're not going to
be accepting LOOKUP_RCU in the 99.999% case that is usually a
requirement for unlikely() to be an acceptable optimisation. For a
number of common workload, directories change all the time, and in NFS,
that inevitably means we need to revalidate their contents with an RPC
call (unless we happen to hold an NFSv4 delegation).

> > it would appear to be completely out of place to use
> > the 'unlikely()' keyword when testing the results of path_walk_rcu() and
> > friends. In particular when the kernel is running with nfsroot, we're
> > saying that 100% of all cases are 'unlikely'...
> 
> Well that _is_ an accepted use of branch annotations. For example it
> is used when scheduling realtime tasks, because even if some systems
> will do 99.9% of their scheduling on realtime tasks, it is not the common
> case.
> 
> I'm not saying that applies here, but: if path walk performance is
> important, then we should use local caching and rcu-walk. If not, then
> why do we care about slightly slower branch?
> 
> The annotations really help to reduce icache penalty of added
> complexity which is why I like them, but I'm happy to remove them
> where they don't make sense of course.

You are adding overhead to existing common paths by doubling the calls
to d_revalidate() in ways which afaics will break branch prediction
(first setting, then clearing LOOKUP_RCU). You can at least try not to
maximise that impact by adding further branch prediction impediments.

Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

