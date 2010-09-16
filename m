Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0IPOA6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 10:00:58 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:44655 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755092Ab0IPOA4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 10:00:56 -0400
Date: Thu, 16 Sep 2010 23:30:45 +0930
From: Christopher Yeoh <cyeoh@au1.ibm.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: linux-kernel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] Cross Memory Attach
Message-ID: <20100916233045.73aecc26@lilo>
In-Reply-To: <4C91E01E.4070209@inria.fr>
References: <20100915104855.41de3ebf@lilo>
	<4C90A6C7.9050607@redhat.com>
	<20100916001232.0c496b02@lilo>
	<4C91B9E9.4020701@ens-lyon.org>
	<4C91E01E.4070209@inria.fr>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 11:15:10 +0200
Brice Goglin <Brice.Goglin@inria.fr> wrote:

> Le 16/09/2010 08:32, Brice Goglin a écrit :
> > I am the guy doing KNEM so I can comment on this. The I/OAT part of
> > KNEM was mostly a research topic, it's mostly useless on current
> > machines since the memcpy performance is much larger than I/OAT DMA
> > Engine. We also have an offload model with a kernel thread, but it
> > wasn't used a lot so far. These features can be ignored for the
> > current discussion.
> 
> I've just created a knem branch where I removed all the above, and
> some other stuff that are not necessary for normal users. So it just
> contains the region management code and two commands to copy between
> regions or between a region and some local iovecs.

When I did the original hpcc runs for CMA vs shared mem double copy I
also did some KNEM runs as a bit of a sanity check. The CMA OpenMPI
implementation actually uses the infrastructure KNEM put into the
OpenMPI shared mem btl - thanks for that btw it made things much easier
for me to test CMA.

Interestingly although KNEM and CMA fundamentally are doing very
similar things, at least with hpcc I didn't see as much of a gain with
KNEM as with CMA:

MB/s				
Naturally Ordered	4	8	16	32
Base	1235	935	622	419
CMA	4741	3769	1977	703
KNEM	3362	3091	1857	681
				
MB/s				
Randomly Ordered	4	8	16	32
Base	1227	947	638	412
CMA	4666	3682	1978	710
KNEM	3348	3050	1883	684
				
MB/s				
Max Ping Pong	4	8	16	32
Base	2028	1938	1928	1882
CMA	7424	7510	7598	7708
KNEM	5661	5476	6050	6290

I don't know the reason behind the difference - if its something
perculiar to hpcc,  or if there's extra overhead the way that
knem does setup for copying, or if knem wasn't configured
optimally. I haven't done any comparison IMB or NPB runs...

syscall and setup overhead does have some measurable effect - although I
don't have the numbers for it here, neither KNEM nor CMA does quite as
well with hpcc when compared against a hacked version of hpcc  where
everything is declared ahead of time as shared memory so the receiver
can just do a single copy from userspace - which I think is
representative of a theoretical maximum gain from the single copy
approach.

Chris
-- 
cyeoh@au.ibm.com
