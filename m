Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab0F1PN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 11:13:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:60740 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752953Ab0F1PNz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 11:13:55 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <4C262949.3030804@linux.vnet.ibm.com>
References: <20100624142804.431553874@chello.nl>
	 <4C262949.3030804@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Jun 2010 17:13:29 +0200
Message-ID: <1277738009.3561.129.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-26 at 09:22 -0700, Corey Ashford wrote:

> These patches look like they are really taking us in the right 
> direction.  Thanks for all your effort on this!

Yeah, although I seem to have managed to wreck all architectures tested
so far (I found some iffy on x86 too), I guess I need to carefully look
at things.

> As for the "hardware write batching", can you describe a bit more about 
> what you have in mind there?  I wonder if this might have something to 
> do with accounting for PMU hardware which is slow to access, for 
> example, via I2C via an internal bridge.

Right, so the write batching is basically delaying writing out the PMU
state to hardware until pmu::pmu_enable() time. It avoids having to
re-program the hardware when, due to a scheduling constraint, we have to
move counters around.

So say, we context switch a task, and remove the old events and add the
new ones under a single pmu::pmu_disable()/::pmu_enable() pair, we will
only hit the hardware twice (once to disable, once to enable), instead
of for each individual ::del()/::add().

For this to work we need to have an association between a context and a
pmu, otherwise its very hard to know what pmu to disable/enable; the
alternative is all of them which isn't very attractive.

Then again, it doesn't make sense to have task-counters on an I2C
attached PMU simply because writing to the PMU could cause context
switches.


