Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757926Ab1BKS1i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 13:27:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887Ab1BKS1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 13:27:37 -0500
Date: Fri, 11 Feb 2011 13:15:33 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't
 backlogged
Message-ID: <20110211181533.GG8773@redhat.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
 <20110210020946.GA27040@redhat.com>
 <AANLkTi=dZDK6VosLX8JH4gJyRQ0KXGKMA5vhJ-7D93s7@mail.gmail.com>
 <20110210035738.GC27040@redhat.com>
 <AANLkTi=J8x3cEhQ_tJJ0=YM6+y_ZNLtK_34PweQfNJL8@mail.gmail.com>
 <AANLkTimdOO2qvafZ9f6csjqhh1e5w1iOEybN+1-3G3ep@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimdOO2qvafZ9f6csjqhh1e5w1iOEybN+1-3G3ep@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 04:36:25PM -0800, Chad Talbott wrote:
> On Thu, Feb 10, 2011 at 10:57 AM, Chad Talbott <ctalbott@google.com> wrote:
> > On Wed, Feb 9, 2011 at 7:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >> If you ran different random readers in different groups of differnet
> >> weight with group_isolation=1, then there is a case of having service
> >> differentiation. In that case we will idle for 8ms on each group before
> >> we expire the group. So in these test cases are low weight groups not
> >> submitting IO with-in 8ms? Putting a random reader in separate group
> >> with think time > 8, I think is going to hurt a lot because for every
> >> single IO dispatched group is going to weight for 8ms before it is
> >> expired.
> >
> > You're right about the behavior of group_idle.  We have more
> > experience with earlier kernels (before group_idle).  With this patch
> > we are able to achieve isolation without group_idle even with these
> > large ratios.  (Without group_idle the random reader workloads will
> > get marked seeky, and idling is disabled.  Without group_idle, we have
> > to remember the vdisktime to get isolation.)
> >
> >> Can you run blktrace and verify what's happenig?
> >
> > I can run a blktrace, and I think it will show what you expect.
> 
> So, I ran the following two tests and took a blktrace.
> 
> 950 rdrand, 50 rdrand.delay10
> weight 950 random reader with low think time vs weight 50 random
> reader with 10ms think time
> 
> 950 rdrand, 50 rdrand.delay50 # 50ms think time
> weight 950 random reader with low think time vs weight 50 random
> reader with 50ms think time
> 
> I find that we are still idling for these random readers, even the one
> with 50ms think time.  group_idle is 0 according to blktrace.
> 
> With this patch, both of these cases have correct isolation.  Without
> this patch, the small weight reader is able to get more than its
> share.
> 
> I think that idling for a random reader with a 50ms think time is
> likely a bug, but a separate issue.

Thanks for checking this out. I agree that for a low weight random
reader/writer which high think time, we need to remember the vdisktime
otherwise it will showup as a fresh new candidate and get more done.

Having said that, one can say that random reader/writer doing small
amount of IO should be able to get job done really fast and the one
who are hogging the disk for long time, should get higher vdisktime.

So with this scheme, a random reader/writer shall have to be of higher
weight to get the job done fast. A low weight reader/writer will still
get higher vdisktime and get lesser share. I think it is reasonable.

And yes, even with group_idle=0 if we are idling on a 50ms thinktime
random reader it sounds like a bug.

Thanks
Vivek
