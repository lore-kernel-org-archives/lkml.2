Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab1BSCrh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 21:47:37 -0500
Received: from relay2.sgi.com ([192.48.179.30]:44384 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753073Ab1BSCrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 21:47:11 -0500
Message-Id: <20110219024705.308511527@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 18 Feb 2011 20:47:05 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jack Steiner <steiner@sgi.com>, Robin Holt <holt@sgi.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/6] init: Shrink early messages to prevent overflowing the kernel log buffer
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
