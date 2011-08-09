Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab1HIO2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 10:28:12 -0400
Received: from DMZ-MAILSEC-SCANNER-3.MIT.EDU ([18.9.25.14]:54318 "EHLO
	dmz-mailsec-scanner-3.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750824Ab1HIO2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 10:28:10 -0400
X-AuditID: 1209190e-b7c22ae000000a2c-92-4e41438d499a
From: Andy Lutomirski <luto@MIT.EDU>
To: x86@kernel.org
Cc: Andy Lutomirski <luto@MIT.EDU>, "H. Peter Anvin" <hpa@zytor.com>,
        Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, lueckintel@yahoo.com,
        kimwooyoung@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 0/4] vsyscall tweaks
Date: Tue,  9 Aug 2011 10:27:46 -0400
Message-Id: <cover.1312899174.git.luto@mit.edu>
X-Mailer: git-send-email 1.7.6
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOIsWRmVeSWpSXmKPExsUixG6nrtvr7Ohn8PIbm0XflaPsFkeufWe3
	+LzhH5vFtI3iFq/+lFtc3jWHzWLF+U5Wiy2Xmlkt/jXdYrF41PeW3eLHhsesDtwe31v7WDxu
	tf1h9pi/8yOjx85Zd9k9Fu95yeSxaVUnm8eJGb9ZPD5vkvOYNeswk8eJli+sAVxRXDYpqTmZ
	ZalF+nYJXBnP9t5jLHgoVLF4+V62BsbtfF2MnBwSAiYSW1seMUHYYhIX7q1n62Lk4hAS2Mco
	8fnSJShnPaNE+/5PjBDOUyaJ57+nsoK0sAmoSHQsfQDUzsEhIiAksfRuHUgNM0hN85zdzCA1
	wkA1y3+vA1vBIqAqsXrpGRYQm1dAX2LhmlusEKvlJI5cfs40gZFnASPDKkbZlNwq3dzEzJzi
	1GTd4uTEvLzUIl1jvdzMEr3UlNJNjKAw5ZTk28H49aDSIUYBDkYlHl5Ofgc/IdbEsuLK3EOM
	khxMSqK8ZsAgF+JLyk+pzEgszogvKs1JLT7EKMHBrCTCm64BlONNSaysSi3Kh0lJc7AoifOu
	3gE0SSA9sSQ1OzW1ILUIJivDwaEkwesHMlSwKDU9tSItM6cEIc3EwQkynAdoeJUTyPDigsTc
	4sx0iPwpRl2OtR8/HmUUYsnLz0uVEucVBxkkAFKUUZoHNweWXl4xigO9JcyrD1LFA0xNcJNe
	AS1hAlpSf8cBZElJIkJKqoFR6YyqW3+5VedHJaNvDD8/hP5uvupyz/zYjNaY5wc2mEy/Far7
	eYm7e3bXBuUb011/BZkfPmzjwHPhCOupz2qOQXkfkqwdTSbcP7l7ZvC21v8CbGf8OxonmxSv
	+7PV53571IcFFlKce9vD+9hssxn+31M+WhfGsccj/Mbmqd7bLp2X12ye4PNSiaU4I9FQi7mo
	OBEA1I/q1goDAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new vsyscall emulation code, int 0xcc's behavior depends on
where it is called from.  A few dynamic instrumentation tools cleverly
copy the instruction out of the vsyscall page and execute it, resulting
in a segfault.  This is nothing new: sysenter would die in a similar way
(unless the code got lucky).  The only examples I know of are pin and
DynamoRIO -- valgrind is already smart enough not to recompile vsyscalls
0 and 1 and "smart" enough to crash unconditionally on vsyscall 2.  I
can't test pin because it refuses to run on newfangled things like Linux
3.0+ (and I don't want to muck with my kernel version to run a program
that's broken anyway).  Patch 1 in this series fixes DynamoRIO in
limited testing.

Bug reports against valgrind and DynamoRIO exist, and I haven't managed
to get permission to post to pin's message board yet.

The other three patches are minor.  Patch 2 removes compile flags that
are now unnecessary because vsyscall_64.c does not get called in user
mode.  Patch 3 wires up the getcpu syscall on x86-64 as further
encouragement to stop using the vsyscall.  Patch 4 adds a
feature-removal-schedule.txt entry suggesting that vsyscalls might be
disabled in some configurations some day.

x86 maintainers / Linus: feel free to drop any of patches 2-4.  I think
the getcpu syscall should be added, though, since it's rather odd to
have a "syscall" in the vdso and the vsyscall page that can't be called
the old-fashioned way.

Changes from RFC v2:
 - Fix some more int 0xcc references.
 - Add patches 2-4.

Andy Lutomirski (4):
  x86-64: Allow emulated vsyscalls from user addresses
  x86: Remove unnecessary compile flag tweaks for vsyscall code
  x86-64: Wire up getcpu syscall
  Add vsyscalls to feature-removal-schedule.txt

 Documentation/feature-removal-schedule.txt |   14 +++
 arch/x86/include/asm/irq_vectors.h         |   11 ++-
 arch/x86/include/asm/traps.h               |    8 ++-
 arch/x86/include/asm/unistd_64.h           |    2 +
 arch/x86/kernel/Makefile                   |   13 ---
 arch/x86/kernel/entry_64.S                 |    4 +-
 arch/x86/kernel/traps.c                    |   14 +++-
 arch/x86/kernel/vsyscall_64.c              |  131 ++++++++++++++--------------
 arch/x86/kernel/vsyscall_emu_64.S          |    6 +-
 9 files changed, 111 insertions(+), 92 deletions(-)

-- 
1.7.6

