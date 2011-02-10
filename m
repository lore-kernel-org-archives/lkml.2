Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab1BJD5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 22:57:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550Ab1BJD5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 22:57:52 -0500
Date: Wed, 9 Feb 2011 22:57:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Chad Talbott <ctalbott@google.com>
Cc: jaxboe@fusionio.com, guijianfeng@cn.fujitsu.com, mrubin@google.com,
        teravest@google.com, jmoyer@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Avoid preferential treatment of groups that aren't
 backlogged
Message-ID: <20110210035738.GC27040@redhat.com>
References: <20110210013211.21573.69260.stgit@neat.mtv.corp.google.com>
 <20110210020946.GA27040@redhat.com>
 <AANLkTi=dZDK6VosLX8JH4gJyRQ0KXGKMA5vhJ-7D93s7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=dZDK6VosLX8JH4gJyRQ0KXGKMA5vhJ-7D93s7@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 09, 2011 at 06:45:25PM -0800, Chad Talbott wrote:
> On Wed, Feb 9, 2011 at 6:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > In upstream code once a group gets backlogged we put it at the end
> > and not at the beginning of the tree. (I am wondering are you looking
> > at the google internal code :-))
> >
> > So I don't think that issue of a low weight group getting more disk
> > time than its fair share is present in upstream kernels.
> 
> You've caught me re-using a commit description.  :)
> 
> Here's an example of the kind of tests that fail without this patch
> (run via the test that Justin and Akshay have posted):
> 
> 15:35:35 INFO ----- Running experiment 14: 950 rdrand, 50 rdrand.delay10
> 15:35:55 INFO Experiment completed in 20.4 seconds
> 15:35:55 INFO experiment 14 achieved DTFs: 886, 113
> 15:35:55 INFO experiment 14 FAILED: max observed error is 64, allowed is 50
> 
> 15:35:55 INFO ----- Running experiment 15: 950 rdrand, 50 rdrand.delay50
> 15:36:16 INFO Experiment completed in 20.5 seconds
> 15:36:16 INFO experiment 15 achieved DTFs: 891, 108
> 15:36:16 INFO experiment 15 FAILED: max observed error is 59, allowed is 50
> 
> Since this is Jens' unmodified tree, I've had to change
> BLKIO_WEIGHT_MIN to 10 to allow this test to proceed.  We typically
> run many jobs with small weights, and achieve the requested isolation:
> see below results with this patch:
> 
> 14:59:17 INFO ----- Running experiment 14: 950 rdrand, 50 rdrand.delay10
> 14:59:36 INFO Experiment completed in 19.0 seconds
> 14:59:36 INFO experiment 14 achieved DTFs: 947, 52
> 14:59:36 INFO experiment 14 PASSED: max observed error is 3, allowed is 50
> 
> 14:59:36 INFO ----- Running experiment 15: 950 rdrand, 50 rdrand.delay50
> 14:59:55 INFO Experiment completed in 18.5 seconds
> 14:59:55 INFO experiment 15 achieved DTFs: 944, 55
> 14:59:55 INFO experiment 15 PASSED: max observed error is 6, allowed is 50
> 
> As you can see, it's with seeky workloads that come and go from the
> service tree where this patch is required.

I have not look into or run the tests posted by Justin and Akshay. Can you
give more details about these tests.

Are you running with group_isolation=0 or 1. These tests seem to be random
read and if group_isolation=0 (default), then all the random read queues
should go in root group and there will be no service differentiation.

If you ran different random readers in different groups of differnet
weight with group_isolation=1, then there is a case of having service
differentiation. In that case we will idle for 8ms on each group before
we expire the group. So in these test cases are low weight groups not
submitting IO with-in 8ms? Putting a random reader in separate group
with think time > 8, I think is going to hurt a lot because for every
single IO dispatched group is going to weight for 8ms before it is
expired.

So the only case which comes to my mind where this patch can help is 
when there are lots of groups doing IO with different weights. These
groups have think time greater than 8ms and hence get deleted from
service tree. When next time a low weight group has IO, instead of being
put at the end of service tree, it might be put even farther allowing
a higher weight group to get backlogged ahead of it.

Can you run blktrace and verify what's happenig?

Thanks
Vivek
