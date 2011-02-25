Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932665Ab1BYSGl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:06:41 -0500
Received: from relay2.sgi.com ([192.48.179.30]:42327 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756237Ab1BYSGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:06:38 -0500
Message-Id: <20110225180633.857892225@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 25 Feb 2011 12:06:33 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: David Rientjes <rientjes@google.com>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Len Brown <len.brown@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] init: Shrink early messages to prevent overflowing the kernel log buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On larger systems, information in the kernel log is lost because
there is so much early text printed, that it overflows the static
log buffer before the log_buf_len kernel parameter can be processed,
and a bigger log buffer allocated.

Distros are relunctant to increase memory usage by increasing the
size of the static log buffer, so minimize the problem by allocating
the new log buffer as early as possible.  Unfortunately allocating
early does not recover all the early messages, so we also need to
reduce the amount of characters those early messages generate.

Here are the stats testing on a system with 248 nodes, 606 EFI
mem ranges, 1984 cores

after get_log_buff_early:  (17% overflow)

	[    0.000000] early log_buf free: -45723/262183(-17%)
	[    0.000000] first line: : mem339: type=7, attr=0xf, range=[0x00000e6000000000-0x00000e6fff000000) (6552

Here I enabled some cores that were disabled so now the system
has 248 nodes, 606 EFI mem ranges, 2368 cores.

after minimize-time-zero-msgs:  (5% overflow)

[0] early log_buf free: -15184/262172(-5%)
[0] first line: [0x000000007226e000-0x0000000072271000) (0MB) <6>[0] EFI: mem67: type=3, attr=0

after minimize-srat-msgs.v2: (28% free)

[0] early log_buf free: 73556/188616(28%)
[0] first line: <6>[0] Initializing cgroup subsys cpuset <6>[0] Initializing cgroup subsys cpu

Some previous stats from testing these changes on our current lab
UV systems.  (Both of these systems lost all of the e820 and EFI
memmap ranges before the changes.)

System X:
	8,793,945,145,344 bytes of system memory
	256 nodes
	599 EFI Mem ranges
	4096 cpu_ids
	43% of static log buffer unused

System Y:
	11,779,115,188,224 bytes of system memory
	492 Nodes
	976 EFI Mem ranges
	1968 cpu_ids
	17% of static log buffer unused

The last stat is how close the static log buffer came
to overflowing.  While these resources are fairly close
to today's max limits, there is not a lot of head room
for growth.

An alternative for the future might be to create a larger
static log buffer in the __initdata section, and then
always allocate a dynamically sized log buffer to replace
it.  This would also allow shrinking the log buffer for
memory tight situations.  But it would add complexity to
the code.

-- 
