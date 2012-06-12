Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752299Ab2FLIt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 04:49:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:37267 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2FLIt4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 04:49:56 -0400
Message-ID: <1339490988.31548.40.camel@twins>
Subject: Re: Kernel panic - not syncing: Attempted to kill the idle task!
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Zhouping Liu <zliu@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>, hi3766691@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 12 Jun 2012 10:49:48 +0200
In-Reply-To: <4FD6BD72.2070808@redhat.com>
References: <cfc29313-7fe7-4140-b9e6-053d925b4897@zmail13.collab.prod.int.phx2.redhat.com>
	 <1339421268.30462.15.camel@twins> <4FD6BD72.2070808@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-12 at 11:54 +0800, Zhouping Liu wrote:
> On 06/11/2012 09:27 PM, Peter Zijlstra wrote:
> > On Fri, 2012-06-08 at 21:38 -0400, Zhouping Liu wrote:
> >> # cat /sys/devices/system/node/node*/distance
> >> 10 17 17 24 24 24 30 30
> >> 18 10 30 18 18 24 24 24
> >> 18 24 10 24 24 17 30 30
> >> 24 18 23 10 24 17 17 30
> >> 24 17 24 24 10 18 30 18
> >> 31 24 17 18 18 10 24 24
> >> 30 24 30 17 24 24 10 18
> >> 30 24 30 24 17 24 17 10
> > You have to be kidding me right? That thing is a complete trainwreck,
> > what idiot vendor did this?
> 
> it's a HP's machine.
> If I understand correctly, you meant the hardware has a bad configuration,
> just serious :) could you explain  the reason? (you can ignore it if 
> it's a stupid question) 

Not only a weird hardware setup (although if we go by this SLIT table,
then that too).

The table itself has various problems:

 1) the table isn't symmetric; T(i,j) != T(j,i), for instance, the
distance from 0->1 is different from 1->0 (17 vs 18).

 2) 4 nodes have 2 connections, 4 nodes have 3 connections. Which have 2
connections seems completely without pattern, see 4).

 3) if we read it like: 10 (self), {17,18} 1 hop, {23,24} 2 hops,
{30,31} 3 hops, its still obviously wrong, see 1->2 and 2->1 (this goes
back to point 1 as well). 1->2 takes 3 hops while 2->1 takes 2 hops.
Going by the 1 hop connections (which aside from the 17 vs 18 mess) are
symmetric, both these should be 2 hops (1<->0<->2 in fact). There's
multiple such 'mistakes'.

 4) take a piece of paper and draw a cube, mark each corner as a node,
then high-light the single hop edges and be awestruck by the creative
wiring.

This is by far the most 'creative' SLIT table I have ever seen and of
course its HP again.. those guys have the most shitty BIOS record ever.

Now we could 'fix' up this table by doing a min-symmetry filter over it,
but I'm tempted to just give up and do a single machine wide fall-back
domain when we find crappy tables like this.
