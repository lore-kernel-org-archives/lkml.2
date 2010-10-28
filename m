Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758077Ab0J1WWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 18:22:30 -0400
Received: from smtp-out.google.com ([74.125.121.35]:30587 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755493Ab0J1WWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 18:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bjrklQyQ6GWbd5YdERSIZg00UKywVRtyIymTrxxaWJiQYB07SkZst3RwtR/cndCNK4
         3VP7DHTSK1JQ6dpNM0rQ==
MIME-Version: 1.0
In-Reply-To: <4CC99A65.9050706@sssup.it>
References: <4CC99A65.9050706@sssup.it>
Date: Thu, 28 Oct 2010 15:22:20 -0700
Message-ID: <AANLkTinkrVG2fTpPDC1DpcC+CiYWjXdYdqTMO5Tv7Swt@mail.gmail.com>
Subject: Re: Understanding cgroups
From: Paul Menage <menage@google.com>
To: Tommaso Cucinotta <tommaso.cucinotta@sssup.it>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Linux Containers <containers@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 8:44 AM, Tommaso Cucinotta
<tommaso.cucinotta@sssup.it> wrote:
> a) why doesn't a cgroup object directly point to a css_set one, but to a
> list of them (via cg_cgroup_list elements) ?

Each task is in one cgroup per mounted hierarchy. There's no
requirement that different hierarchies have isomorphic partitions of
tasks (in fact that would somewhat defeat the point of mounting
separate hierarchies). So even though all the tasks in a cgroup share
css pointers for the subsystems attached to that cgroup's hierarchy,
in general they will have different total sets of css pointers. Hence
the multiple css_set objects associated with a cgroup.

>    it seems that a cgroup object may be associated to multiple css_set
> objects, which in turn contain vectors of
>    cgroup_subsys_state;
> b) however, cgroup.subsys[] would point to a single cgroup_subsys_state
> object per subsys_id,

No, it points to a single cgroup_subsys_state for each subsys that's
bound to the cgroup's hierarchy, and NULL for all others.

> so, what is the
>    difference between cgroup.subsys[] and css_set.subsys[] ? (or, are these
> all redundant pointers and point
>    to the same cgroup_subsys_state objects ?)

css_set.subsys is the union of all the (disjoint) sets of subsys
pointers in the cgroups that a task is a member of (one cgroup per
hierarchy).

Yes, the pointers in the css_set are redundant in that they could be
determined by following more pointers, but for efficiency they're all
available directly in the css_set. (Also this typically allows a
single refcount inc/dec in the task fork/exit case)

> c) is css_set.cg_links used to point to (the head of) a list of
> cg_cgroup_link objects,

Yes. It's the head of a list of cg_cgroup_link objects, each of which
has a pointer to this css_set and a pointer to a cgroup of which this
css_set represents membership. (One per hierarchy)

> or is it used to link multiple css_set objects into
> a list ?

In a way this is also true, but only indirectly - the cg_cgroup_link
objects form a two-dimensional doubly-linked list lattice that
represents the many:many relationship between cgroup and css_set. One
dimension's linked lists are headed by css_set objects, the other
dimension is headed by cgroups.

Paul
