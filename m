Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0KQF3b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 00:29:31 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:51123 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0KQF3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 00:29:30 -0500
Date: Wed, 17 Nov 2010 16:29:22 +1100
From: Anton Blanchard <anton@au1.ibm.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
        tj@kernel.org
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101117162922.0f874a8e@kryten>
In-Reply-To: <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Grant,

> This patch has far reaching changes which quite frankly scare me;
> primarily because c/r changes many long-held assumptions about how
> Linux processes work.  It needs to track a large amount of state with
> lots of corner cases, and the Linux process model is already quite
> complex.  I know this is a fluffy hand-waving critique, but without
> being convinced of a strong general-purpose use-case, it is hard to
> get excited about a solution that touches large amounts of common
> code.
> 
> c/r of desktop processes doesn't seem interesting other that as a test
> case, but I can possibly be convinced about HPC, embedded, industrial,
> or telecom use-cases, but for custom/specific-purpose applications the
> question must be asked if a fully user space or joint user/kernel
> method would better solve the problem.

It seems like there are a number of questions around the utility of
C/R so I'd like to take a step back from the technical discussion
around implementation and hopefully convince you, Tejun (and anyone
else interested) that C/R is something we want to solve in Linux.

Here at IBM we are working on the next generation of HPC systems. One
example of this will be the NCSA Bluewaters supercomputer:

http://www.ncsa.illinois.edu/BlueWaters/

The aim is not to build yet another linpack special, but a supercomputer
that achieves more than 1 petaflop sustained on a wide range of
applications. There is also a strong focus on improving the
productivity and reliability of the cluster.

There are two usage scenarios for C/R in this environment:

1. Resource management. Any large HPC cluster should be 100% busy and
as such you will often fill in the gaps with low priority jobs which
may need to be preempted. These low priority jobs need to give up their
resources (memory, interconnect resources etc) whenever something
important comes in.

2. Fault tolerance. Failures are a fact of life for any decent sized
cluster. As the cluster gets larger these failures become very common.
Speaking from an industry perspective, MTBF rates measured in the order
of several hours for large commodity clusters are not surprising. We at
IBM improve on that with hardware and system design, but there is only
so much you can do. The failures also happen at the Linux kernel level
so even if we had 100% reliable systems we would still have issues.

Now this is the pointy end of HPC, but similar issues are happening in
the meat of the HPC market. One area we are seeing a lot of C/R
interest is the EDA space. As ICs become more and more complex the
amount of cluster compute power it takes to route, check, create masks
etc grows so large that system reliability becomes an issue. Some tool
vendors write their own application C/R, but there are a multitude of
in house applications that have no C/R capability today.

You could argue that we should just add C/R capability to every HPC
application and library people care about or rework them to be
fault tolerant in software. Unfortunately I don't see either as being
viable. There are so many applications, libraries and even programming
languages in use for HPC that it would be a losing battle. If we
did go down this route we would also be unable to leverage C/R for
anything else. I can understand the concern around finding a general
purpose case, but I do believe many other solid uses for C/R outside of
HPC will emerge. For example, there was interest from the embedded guys
during the KS discussion and I can easily imagine using C/R to bring up
firefox faster on a TV.

The problems found in HPC often turn into more general problems down
the track. I think back to the heated discussions we had around SMP back
in the early 2000s when we had 32 core POWER4s and SGI had similar sized
machines. Now a 24 core machine fits in 1U and can be purchased for
under $5k. NUMA support, CPU affinity and multi queue scheduling are
other areas that initially had a very small user base but have since
become important features for many users.

Anton
