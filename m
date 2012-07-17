Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420Ab2GQR4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 13:56:33 -0400
Received: from exprod7og101.obsmtp.com ([64.18.2.155]:39744 "EHLO
	exprod7og101.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab2GQR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 13:56:31 -0400
Message-ID: <5005A73B.2010901@genband.com>
Date: Tue, 17 Jul 2012 11:56:11 -0600
From: Chris Friesen <chris.friesen@genband.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Avi Kivity <avi@redhat.com>, Gleb Natapov <gleb@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: CFS vs. cpufreq/cstates vs. latency
References: <50057565.7030405@redhat.com>
In-Reply-To: <50057565.7030405@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Jul 2012 17:56:12.0883 (UTC) FILETIME=[74360230:01CD6445]
X-TM-AS-Product-Ver: SMEX-8.0.0.4160-6.500.1024-19046.004
X-TM-AS-Result: No--11.139600-8.000000-31
X-TM-AS-User-Approved-Sender: No
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/17/2012 08:23 AM, Rik van Riel wrote:

> Specifically, waking up some process requires that the CPU
> which is running the wakeup is already in C0 state. If the
> CPU on which the to-be-woken task ran last is in a deep C
> state, it may make sense to simply run the woken up task
> on the local CPU, not the CPU where it was originally.

While it sounds interesting, I can see possible issues with this:

1) If we're using NUMA there will be additional cost to running a task with memory on a remote node.  It might make sense to try and run the task on a CPU on that node if possible.
2) It might not make sense to migrate if the local cpu is close to capacity.

Presumably the scheduler could take into account the expected delay for coming out of the C state (which we should know) as well as the expected cost of migrating the task to the running CPU and the expected run-length of the task in order to decide if this makes sense or not.

> I seem to remember some scheduling code that (for power
> saving reasons) tried running all the tasks on one CPU,
> until that CPU got busy, and then spilled over onto other
> CPUs.

I suspect you're thinking of

/sys/devices/system/cpu/sched_mc_power_savings
/sys/devices/system/cpu/sched_smt_power_savings 

> I do not seem to be able to find that code in recent kernels,
> but I have the feeling that a policy like that (related to
> WAKE_AFFINE scheduling?) could improve this issue.

Looks like it was removed in 8e7fbcb because it was broken.

Chris
