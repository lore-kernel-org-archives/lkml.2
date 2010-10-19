Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459Ab0JSQZy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:25:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754765Ab0JSQZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:25:53 -0400
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
From: Eric Paris <eparis@redhat.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        zohar@us.ibm.com, warthog9@kernel.org, jmorris@namei.org,
        kyle@mcmartin.ca, hpa@zytor.com, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, mingo@elte.hu, viro@zeniv.linux.org.uk
In-Reply-To: <20101019073901.GB11284@dastard>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
	 <20101019013037.GA31393@infradead.org>
	 <1287454443.2530.124.camel@localhost.localdomain>
	 <20101019073901.GB11284@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Oct 2010 12:24:43 -0400
Message-ID: <1287505483.2530.174.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-10-19 at 18:39 +1100, Dave Chinner wrote:
> On Mon, Oct 18, 2010 at 10:14:03PM -0400, Eric Paris wrote:

> Eric, just to put that in context - changing the size of an inode
> needs to be conidered carefully because we cache so many of them. We
> often jump through hoops just to reduce it by 4 or 8 bytes. You are
> proposing to increase it by 24 bytes (roughly 5%) and as such that
> _should_ be considered a big deal, especially for something that is
> currently rarely used.

In my mind it's framed a little differently, my patch series is reducing
it from ~900 bytes to 24 bytes.  Even though that memory might not have
been inside struct inode if there is always a 1-1 mapping it might as
well be....   I'm going from seriously broken to a hell of a lot better.
I believe that when I resend this series I'll drop 8 more of those bytes
(open count as I think we can do without that these days).

> Personally I that adding a pointer into the struct inode is as much
> as I'd want to compromise to. Those that want to use IMA or have the
> possibility of turning it on dynamicaly can accept the additional
> overhead of another memory allocation during inode allocation as the
> cost of using this functionality.  That's the way the security
> subsystem works, so I don't see any problems with doing this for IMA
> and it turns the overhead problem into one that only affects those
> that have it both configured and enabled.  That seems like a
> reasonable compromise to me....

The problem is that this would actually waste another 8 bytes (the size
of the pointer in struct inode) since IMA is still going to need to
allocate a structure for every inode to hold the 16-24 bytes of
counters.  That 16-24 might not be in struct inode, but like I said, if
there is a 1-1 mapping between the two there is no difference.

I said that if there was a consensus that this overhead was still too
large (and it seems that may be the case) I would put looking at using a
userspace freezer to attempt to collect the information dynamically on
my todo list.  I'll gladly do that but we have a space/time tradeoff I'd
rather have a consensus on before I start.

If I go the pointer in struct inode route, I don't need to serialize
entry and removal from core of every inode if IMA is enabled (while I
add and remove it from the IMA lookup tree.)  If I don't add any fields
to struct inode I'll need to serialize while I add them to the IMA
lookup tree, but at the savings of a void * in struct inode.

My guess is that most people will say forcing users to serialize and
saving 8bytes per inode is the better choice, but I know there is
scalability work going on and I want to make sure everyone agrees that
is the right choice before we spend a lot of time on anything like
this...

-Eric

