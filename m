Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1DVAYO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:24:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:11164 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754082Ab1DVAYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:24:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,252,1301900400"; 
   d="scan'208";a="423604379"
From: Andi Kleen <andi@firstfloor.org>
To: linux-fsdevel@vger.kernel.org
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, npiggin@kernel.dk, shaohua.li@intel.com,
        sds@tycho.nsa.gov, jmorris@namei.org,
        linux-security-module@vger.kernel.org
Subject: Make RCU dcache work with CONFIG_SECURITY=y
Date: Thu, 21 Apr 2011 17:23:18 -0700
Message-Id: <1303431801-10540-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We found that all .38+ kernels with CONFIG_SECURITY just enables -- but
not even any security module active -- are slower than .37. And also
they don't really scale on larger machines. CONFIG_SECURITY
is a quite common configuration, so this was seen multiple times.

The problem is that with CONFIG_SECURITY every directory permission
check will drop out of the RCU walk and redo a bunch of work
(and not scale of course), just in case the security module
cannot handle it.

This patchkit tries to address this. First it moves the check for 
RCU walks into the low level security module, so for the 
CONFIG_SECURITY=y selinux=0 at runtime case you always get full
performance. This is an independent patch.

Then it turned out that the two security modules who use the
inode_exec_permission hook that impacts dcache walking -- SMACK
and selinux -- already use RCU internally. So I added two
followon patches that make them not drop out of the RCU walk,
as long as they stay in their RCU "fast" path. For selinux
this means a cache hit only and no audit event. For smack
it means any check as long as auditing is disabled.

I didn't find good test suites for the security modules, so
there wasn't a lot of testing on this unfortunately
(the selinux one for LTP doesn't seem to work). Some close
review of these changes is needed.

On the other hand the VFS changes itself are very straight forward
and the 1/1 patch is very straight forward (and a win in itself)

The bottom line is with this patchkit a CONFIG_SECURITY=y
kernel has as good VFS performance as a kernel with CONFIG_SECURITY
disabled.

-Andi


