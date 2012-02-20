Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753425Ab2BTO4t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 09:56:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57372 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2BTO4s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 09:56:48 -0500
Message-ID: <1329749790.2293.354.camel@twins>
Subject: Re: sched: Performance of Trade workload running inside VM
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: mingo@elte.hu, pjt@google.com, efault@gmx.de, venki@google.com,
        suresh.b.siddha@intel.com, linux-kernel@vger.kernel.org,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Date: Mon, 20 Feb 2012 15:56:30 +0100
In-Reply-To: <20120218074127.GA9077@linux.vnet.ibm.com>
References: <20120214112827.GA22653@linux.vnet.ibm.com>
	 <1329307161.2293.66.camel@twins> <20120215171032.GB9918@linux.vnet.ibm.com>
	 <1329326651.2293.151.camel@twins>
	 <20120215173817.GD9918@linux.vnet.ibm.com>
	 <1329327902.2293.168.camel@twins>
	 <20120218074127.GA9077@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-18 at 13:11 +0530, Srivatsa Vaddagiri wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2012-02-15 18:45:02]:

> > why does your patch sort it etc.
> 
> The patch does result in a hunt for "least" busy cpu when the target cpu
> returned by select_idle_sibling() is not idle - thus resulting in better
> scheduling latencies for the task (and in turn better benchmark scores).
> 
> Another variant of the patch could be to have select_idle_sibling() look
> for any idle cpu that is in same cache domain (rather than looking for a
> whole group of cpus to be idle)?

Right, so I looked over select_idle_sibling() again and it made my head
hurt :/ I can't immediately tell if its actually doing the right thing
or not (it _should_ try and avoid using SMT siblings if possible).

It would be very nice not to have both select_idle_sibling() and
SD_BALANCE_WAKE iterate the domain tree. So merging them if at all
possible would be goodness I think.

We'd have WAKE_AFFINE to decide which cache domain etc to stuff the task
on and then use select_idle_sibling() to find the most appropriate cpu
within that cache domain.

There was talk of modifying select_idle_sibling() to also consider the
C-state the cpu was in, preferring shallower over deeper C-states where
there's choice, this is very similar to what you propose, taking the
least loaded cpu when there isn't a proper idle one around.


