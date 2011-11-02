Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932797Ab1KBPMz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:12:55 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:34542 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755735Ab1KBPMy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:12:54 -0400
MIME-Version: 1.0
Message-ID: <785a9dc0-2f15-40bf-b9a8-e3ab28e650bd@default>
Date: Wed, 2 Nov 2011 08:12:01 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        levinsasha928@gmail.com, Chris Mason <chris.mason@oracle.com>,
        JBeulich@novell.com, Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Neo Jia <cyclonusj@gmail.com>
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
 <20111031171321.097a166c.kamezawa.hiroyu@jp.fujitsu.com>
 <ef778e79-72d0-4c58-99e8-3b36d85fa30d@default>
 <20111101095038.30289914.kamezawa.hiroyu@jp.fujitsu.com>
 <f62e02cd-fa41-44e8-8090-efe2ef052f64@default
 20111102101414.457e0a08.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20111102101414.457e0a08.kamezawa.hiroyu@jp.fujitsu.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EB15DC8.0133,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: KAMEZAWA Hiroyuki [mailto:kamezawa.hiroyu@jp.fujitsu.com]

Hi Kame --

> > By the way, what your fujitsu user support guy suggests is
> > exactly what zram does.  The author of zram (Nitin Gupta)
> > agrees that frontswap has many advantages over zram,
> > see https://lkml.org/lkml/2011/10/28/8 and he supports
> > merging frontswap.  And Ed Tomlinson, a current user
> > of zram says that he would use frontswap instead of
> > zram: https://lkml.org/lkml/2011/10/29/53
> >
> > Kame, can I add you to the list of people who support
> > merging frontswap, assuming more good performance numbers
> > are posted?
> >
> Before answer, let me explain my attitude to this project.
> 
> As hobby, I like this kind of work which allows me to imagine what kind
> of new fancy features it will allow us. Then, I reviewed patches.
> 
> As people who sells enterprise system and support, I can't recommend this
> to our customers. IIUC, cleancache/frontswap/zcache hides its avaiable
> resources from user's view and making the system performance unvisible and
> not-predictable. That's one of the reason why I asksed whether or not
> you have plans to make frontswap(cleancache) cgroup aware.
> (Hmm, but at making a product which offers best-effort-performance to customers,
>  this project may make sense. But I am not very interested in best-effort
>  service very much.)

I agree that zcache is not a good choice for enterprise customers
trying to achieve predictable QoS.  Tmem works to improve
memory efficiency (with zcache backend) and/or take advantage
of statistical variations in working sets across multiple virtual
(Xen backend and KVM work-in-progress backend) or physical
(RAMster backend) machines so, you are correct, there will
be some non-visible and non-predictable effects of tmem.

In a strict QoS environment, the data center must ensure that all
resources are overprovisioned, including RAM.  RAM on each machine
must exceed the peak working set on that machine or QoS guarantees
won't be met.  Tmem has no value when RAM is "infinite", that is,
when RAM can be increased arbitrarily to ensure that it always exceeds
the peak working set.  Tmem has great value when RAM is sometimes less
than the working set.  This is most obvious today in consolidated
virtualization environments, but (as shown in my presentations)
is increasingly a system topology.  For example:

Resource optimization across a broad set of users with unknown and
time-varying workloads (and thus working sets) is necessary for
"cloud providers" to profit.  In many such environments,
RAM is becoming the bottleneck and cloud providers can't
ensure that RAM is "infinite".  Cloud users that require absolute
control over their performance are instructed to pay a much
higher price to "rent" a physical server.

In some parts of the US (and I think in other countries as well),
electricity providers offer a discount to customers that are willing
to allow the provider to remotely disable their air conditioning
units when electricity demand peaks across the entire grid.
Tmem allows cloud providers to offer a similar feature to
their users.  This is neither guaranteed-QoS nor "best effort"
but allows the provider to expand the capabilities of their
data center as needed, rather than predict peak demand and
pre-provision for it.

I agree, IMHO, zcache is more for small single machines (possibly
mobile units) where RAM is limited or at capacity and the workload
is bumping into that limit (resulting in swapping).  Ed Tomlinson
presents a good example: https://lkml.org/lkml/2011/10/29/53 
But IBM seems to be _very_ interested in zcache and is not
in the desktop business, so probably is working on some cool
use model for servers that I've never thought of.

> I wonder if there are 'static size simple victim cache per cgroup' project
> under frontswap/cleancache and it helps all user's workload isolation
> even if there is no VM or zcache, tmem.  It sounds wonderful.
> 
> So, I'd like to ask whether you have any enhancement plans in future ?
> rather than 'current' peformance. The reason I hesitate to say "Okay!",
> is that I can't see enterprise usage of this, a feature which cannot
> be controlled by admins and make perfomrance prediction difficult in busy system.

Personally, my only enhancement plan is to work on RAMster
until it is ready for the staging tree.  But once the
foundations of tmem (frontswap and cleanache) are in-tree,
I hope that you and other developers will find other clever
ways to exploit it.  For example, Larry Bassel's postings on
linux-mm uncovered a new use for cleancache that I had not
considered (so I think cleancache now has five users).

> > Kame, can I add you to the list of people who support
> > merging frontswap, assuming more good performance numbers
> > are posted?

So I'm not asking you if Fujitsu enterprise QoS-guarantee
customers will use zcache.... Andrew said yesterday:

"At kernel summit there was discussion and overall agreement
 that we've been paying insufficient attention to the
 big-picture "should we include this feature at all" issues.
 We resolved to look more intensely and critically at new
 features with a view to deciding whether their usefulness
 justified their maintenance burden."

I am asking you, who are an open source Linux developer and
a respected -mm developer, do you think the usefulness
of frontswap justifies the maintenance burden, and frontswap
should be merged?

Dan
