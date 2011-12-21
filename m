Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117Ab1LUVcj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 16:32:39 -0500
Received: from smtpauth03.mfg.siteprotect.com ([64.26.60.137]:42124 "EHLO
	smtpauth03.mfg.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848Ab1LUVch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 16:32:37 -0500
Date: Wed, 21 Dec 2011 16:32:35 -0500 (EST)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Vince Weaver <vweaver1@eecs.utk.edu>, mingo@elte.hu,
        William Cohen <wcohen@redhat.com>,
        Stephane Eranian <eranian@google.com>, Arun Sharma <asharma@fb.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 0/6] perf: x86 RDPMC and RDTSC support
In-Reply-To: <alpine.DEB.2.02.1112210959540.10098@pianoman.cluster.toy>
Message-ID: <alpine.DEB.2.02.1112211622560.16411@pianoman.cluster.toy>
References: <20111121145114.049265181@chello.nl>  <alpine.DEB.2.00.1112161731570.6060@cl320.eecs.utk.edu> <1324472337.10752.11.camel@twins> <alpine.DEB.2.02.1112210959540.10098@pianoman.cluster.toy>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Vince Weaver wrote:
> 
> currently when I tried doing a start ioctl then an immediate read, the 
> counter values returned were a very high value.  So unless I did two 
> rdpmcs and subtracted, the results made no sense.

I've added two rdpmc() tests to my perf_event_test suite.  A few comments.

* One, is it possible to detect at runtime that rdpmc() is supported?  
  Maybe a field in the mmap'd buffer that can be read?

  Otherwise if you try to do a rdpmc() on an unpatched kernel you get a 
  general protection error and a segfault.  This makes it tricky to have 
  nice code that tries rdpmc() and falls back to read() if it is 
  unavailable.

* Second, if I try a start / run 100M instructions / read
  and measure retired instructions I get:
      281474977711543 instructions
  This is 0x10000000f45b7 which is 1<<48 + 100M.  I guess an artifact
  of how the counters are set up?  Is it possible to have this start
  at 0?  

  Otherwise you need to always do two reads and a subtract  to get good 
  values.

Thanks,

Vince


(below are the results from the rdpmc_validation test)


This test checks if userspace rdpmc() style reads work.

total start/work/read/stop latency: 646001 cycles
	Event 0 -- count: 281474977711543 running: 320324
	Event 1 -- count: 281474977712320 running: 320939
total start/read/work/read/stop latency: 653451 cycles
	Event 0 -- count: 1000828 running: 321985
	Event 1 -- count: 1000108 running: 321195

   Expected: 1000000
   High: 1000828   Low:  1000828   Average:  1000828
   ( note, a small value above 1000000 may be expected due
     to overhead and interrupt noise, among other reasons)
   Average Error = 0.08%
Testing if userspace rdpmc reads give expected results...    PASSED

