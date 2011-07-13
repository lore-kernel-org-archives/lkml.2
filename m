Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab1GMNus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:50:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56587 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab1GMNuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:50:46 -0400
Date: Wed, 13 Jul 2011 15:50:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 5/7] cgroups: Ability to stop res charge propagation on
 bounded ancestor
Message-ID: <20110713135039.GF9201@somewhere>
References: <1310393706-321-1-git-send-email-fweisbec@gmail.com>
 <1310393706-321-6-git-send-email-fweisbec@gmail.com>
 <20110712091131.e74d18f4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110712091131.e74d18f4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 09:11:31AM +0900, KAMEZAWA Hiroyuki wrote:
> On Mon, 11 Jul 2011 16:15:04 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > Moving a task from a cgroup to another may require to substract
> > its resource charge from the old cgroup and add it to the new one.
> > 
> > For this to happen, the uncharge/charge propagation can just stop
> > when we reach the common ancestor for the two cgroups. Further
> > the performance reasons, we also want to avoid to temporarily
> > overload the common ancestors with a non-accurate resource
> > counter usage if we charge first the new cgroup and uncharge the
> > old one thereafter. This is going to be a requirement for the coming
> > max number of task subsystem.
> > 
> > To solve this, provide a pair of new API that can charge/uncharge
> > a resource counter until we reach a given ancestor.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Paul Menage <menage@google.com>
> > Cc: Li Zefan <lizf@cn.fujitsu.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Aditya Kali <adityakali@google.com>
> 
> 
> Hmm, do you have the number to show the benefit of this new function ?
> And....tasks is moving among cgroups so frequently as to show the benefit
> of this function in your environment ??

So the benefit is not really in the optimization, although that's a side effect.

Let me clarify the point in the changelog.
Imagine we have these cgroups:


                 A  (usage = 2, limit = 2)
                 |
                / \
               /   \
              /     \
             /       \
            /         \
           /           \
          B             C  (usage = 1, limit = 2)
(usage = 1, limit = 2)


The usage in A is the accumulation of the usage in B and C.
Imagine i want to move a task from C to B. This should work well.
We need to first check if we can charge B and do it, and then later
uncharge C.

But if we do:

	err = res_counter_charge(B)
	if (err)
		exit
	res_counter_uncharge(C)

it is going to fail because charging B will also charge A. And A
will refuse because it's already full. Ideally we should first uncharge
C and then charge B, so that A doesn't reject:

	res_counter_uncharge(C)
	err = res_countrer_charge(B)
	if (err)
		res_counter_charge(C)

The problem is that if charging B fails we need to rollback on C, but it might
be too late as a fork might have happen inside C since we uncharged it, so we couldn't
charge it back.

So the only solution is to first charge B but stop the charge propagation on A.
And then uncharge on C but stop uncharge on A.
