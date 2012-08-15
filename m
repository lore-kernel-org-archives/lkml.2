Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205Ab2HOOUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:20:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:32811 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab2HOOUV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:20:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,773,1336374000"; 
   d="scan'208";a="186737751"
Message-ID: <502BB000.60502@linux.intel.com>
Date: Wed, 15 Aug 2012 07:19:44 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        vincent.guittot@linaro.org, svaidy@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Paul Turner <pjt@google.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in
 scheduler
References: <5028F12C.7080405@intel.com> <1345028738.31459.82.camel@twins>
In-Reply-To: <1345028738.31459.82.camel@twins>
X-Enigmail-Version: 1.4.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/15/2012 4:05 AM, Peter Zijlstra wrote:
> I'm not sure this is a valid assumption. I've had it explained to me by
> various people that race-to-idle isn't always the best thing. 

it's not so much race to idle (which is more about frequency than anything else)

it's about the situation that in order 0 approximation, the first (logical) CPU
you bring out of idle is the least efficient one, or rather, all consecutive CPUs that
you add cost less incremental power than this first one.
Keeping this first one on longer (versus parallelism) is a bad trade off.

in an order 1 approximation you are absolutely correct. If the other task will only run briefly,
moving it (and thus waking a core up) is a loss due to transition costs.

The whole situation hinges on what is "briefly" (or "long enough" in other words).

for a typical Intel or AMD based cpu, the tipping point will likely be somewhere between 100 usec and 300 usec,
but this is obviously somewhat CPU and architecture specific.

Interrupts usually are well below that (hopefully ;-).
Very short tasks, that just get a disk IO completion to then schedule the next IO... will be too.

Ideally the scheduler builds up some history of the typical run duration of the task (with a bias to more recent runs).
But... even then, the past is only a poor predictor for the future.



