Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab1EQMpg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:45:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58621 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab1EQMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:45:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MYLV3Hr48ZFV8JkP1UQ5rB87Sz9vXP3OQA5/YT1VfFVaKPIStvwBkIXG9JGjnz2TJ5
         bnQaGnnZoUINKKDUxR95GR3ezCltxSqcyny5KoGa2YY7hKE/PVsULYSObUvnoq4VNZcY
         D4TmcDV5R6TVMt3suZ9zwM5n1X2E32PwNENAY=
Date: Tue, 17 May 2011 14:45:28 +0200
From: Tejun Heo <tj@kernel.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "cl@linux.com" <cl@linux.com>, "npiggin@kernel.dk" <npiggin@kernel.dk>
Subject: Re: [patch V3] percpu_counter: scalability works
Message-ID: <20110517124528.GN20624@htj.dyndns.org>
References: <1305538504.2898.33.camel@edumazet-laptop>
 <1305555736.2898.46.camel@edumazet-laptop>
 <1305593751.2375.69.camel@sli10-conroe>
 <1305608212.9466.45.camel@edumazet-laptop>
 <1305609768.2375.84.camel@sli10-conroe>
 <1305622861.2850.21.camel@edumazet-laptop>
 <20110517091102.GE20624@htj.dyndns.org>
 <1305625541.2850.29.camel@edumazet-laptop>
 <20110517095001.GF20624@htj.dyndns.org>
 <1305634807.2850.89.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305634807.2850.89.camel@edumazet-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On Tue, May 17, 2011 at 02:20:07PM +0200, Eric Dumazet wrote:
> Spikes are expected and have no effect by design.
> 
> batch value is chosen so that granularity of the percpu_counter
> (batch*num_online_cpus()) is the spike factor, and thats pretty
> difficult when number of cpus is high.
> 
> In Shaohua workload, 'amount' for a 128Mbyte mapping is 32768, while the
> batch value is 48. 48*24 = 1152.
> So the percpu s32 being in [-47 .. 47] range would not change the
> accuracy of the _sum() function [ if it was eventually called, but its
> not ]
> 
> No drift in the counter is the only thing we care - and _read() being
> not too far away from the _sum() value, in particular if the
> percpu_counter is used to check a limit that happens to be low (against
> granularity of the percpu_counter : batch*num_online_cpus()).
> 
> I claim extra care is not needed. This might give the false impression
> to reader/user that percpu_counter object can replace a plain
> atomic64_t.

We already had this discussion.  Sure, we can argue about it again all
day but I just don't think it's a necessary compromise and really
makes _sum() quite dubious.  It's not about strict correctness, it
can't be, but if I spent the overhead to walk all the different percpu
counters, I'd like to have a rather exact number if there's nothing
much going on (freeblock count, for example).  Also, I want to be able
to use large @batch if the situation allows for it without worrying
about _sum() accuracy.

Given that _sum() is super-slow path and we have a lot of latitude
there, this should be possible without resorting to heavy handed
approach like lglock.  I was hoping that someone would come up with a
better solution, which didn't seem to have happened.  Maybe I was
wrong, I don't know.  I'll give it a shot.

But, anyways, here's my position regarding the issue.

* If we're gonna just fix up the slow path, I don't want to make
  _sum() less useful by making its accuracy dependent upon @batch.

* If somebody is interested, it would be worthwhile to see whether we
  can integrate vmstat and percpu counters so that its deviation is
  automatically regulated and we don't have to think about all this
  anymore.

I'll see if I can come up with something.

Thank you.

-- 
tejun
