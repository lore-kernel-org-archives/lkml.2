Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276Ab1BQSvi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:51:38 -0500
Received: from relay3.sgi.com ([192.48.152.1]:46743 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751728Ab1BQSvf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:51:35 -0500
Message-Id: <20110217185131.960038922@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Feb 2011 12:51:31 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] init: Shrink early messages to prevent overflowing the kernel log buffer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


v2: updated to apply to x86-tip

On larger systems, information in the kernel log is lost because
there is so much early text printed, that it overflows the static
log buffer before the log_buf_len kernel parameter can be processed,
and a bigger log buffer allocated.

Distros are relunctant to increase memory usage by increasing the
size of the static log buffer, so minimize the problem by allocating
the new log buffer as early as possible, and reducing the amount
of characters those early messages generate.

Some stats from testing these changes on our current lab UV systems.
(Both of these systems lost all of the e820 and EFI memmap ranges
before the changes.)

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
