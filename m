Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab1HEUJu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 16:09:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:33044 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753845Ab1HEUJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 16:09:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,325,1309762800"; 
   d="scan'208";a="38334001"
Date: Fri, 5 Aug 2011 13:09:45 -0700
From: Andi Kleen <andi@firstfloor.org>
To: luto@mit.edu, x86@kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Cc: lueckintel@yahoo.com, kimwooyoung@gmail.com
Subject: New vsyscall emulation breaks JITs
Message-ID: <20110805200945.GA14014@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Andy,

We found that your new vsyscall emulation in

commit 5cec93c216db77c45f7ce970d46283bcb1933884
Author: Andy Lutomirski <luto@MIT.EDU>
Date:   Sun Jun 5 13:50:24 2011 -0400

    x86-64: Emulate legacy vsyscalls

breaks JITs that execute x86 code and use the legacy vsyscalls.

The problem is that the JIT translates the vsyscall page into
its code buffer and executes the "int 0xcc" there. Then 
when the kernel gets the interrupt it doesn't see the vsyscall
page as the source and crashes the program.

For some reason several modern executables also seem
to still use the old vsyscall page, so this problem can be hit
quickly.

This happened with pin (http://www.pintool.org/), however
I expect it will affect all user space x86 JITs (valgrind, 
dynamo, qemu-user, etc.)

What to do? Right now this broke existing setups.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
