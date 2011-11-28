Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab1K1VfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 16:35:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51443 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1K1VfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 16:35:22 -0500
Date: Mon, 28 Nov 2011 13:35:17 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Dave Young <dyoung@redhat.com>,
        Bob Liu <lliubbo@gmail.com>
Subject: [GIT PULL] percpu fixes for 3.2-rc3
Message-ID: <20111128213517.GB3858@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Each percpu chunk contains units for each CPU which can be offset by
arbitrary amount (usually determined by how early mem gets allocated
for static percpu areas).

Way back, the offsets were always monotonically increasing and
first/last units were assumed to have the lowest and highest offsets.
These were used to determine cache flush ranges and map percpu to
physical addresses.

However, with embedded first chunk allocation, the assumption is no
longer true.  There's no relation between unit number and its offset,
which broke percpu -> physical translation.  The bug is rather serious
as it has remote chance of causing extremely obscure and difficult to
reproduce problems on archs which require vmalloc area flushing.

This pull includes fix for the above problem, a patch explaining why
phys addr translation is done the way it's done, and a trivial percpu
internal function rename patch which was sitting in my queue for too
long.

Please pull from the following git branch,

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/percpu.git for-3.2-fixes

Bob Liu (1):
      percpu: rename pcpu_mem_alloc to pcpu_mem_zalloc

Dave Young (1):
      percpu: explain why per_cpu_ptr_to_phys() is more complicated than necessary

Tejun Heo (1):
      percpu: fix chunk range calculation

 mm/percpu-vm.c |   17 +++++++--------
 mm/percpu.c    |   62 ++++++++++++++++++++++++++++++++++++-------------------
 2 files changed, 48 insertions(+), 31 deletions(-)

Thanks.

--
tejun
