Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab0IHChi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 22:37:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4598 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756040Ab0IHChg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 22:37:36 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, oss-security@lists.openwall.com,
        Solar Designer <solar@openwall.com>,
        Kees Cook <kees.cook@canonical.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-fsdevel@vger.kernel.org,
        pageexec@freemail.hu,
        "Brad Spengler <spender@grsecurity.net> Eugene Teo" 
	<eugene@redhat.com>
X-Fcc: ~/Mail/linus
In-Reply-To: Roland McGrath's message of  Tuesday, 7 September 2010 19:34:17 -0700 <20100908023417.8B055401AF@magilla.sf.frob.com>
References: <20100827220258.GF4703@outflux.net>
	<20100830005648.431B7400D9@magilla.sf.frob.com>
	<20100830032331.GA22773@openwall.com>
	<20100830100616.78971400D9@magilla.sf.frob.com>
	<20100908023417.8B055401AF@magilla.sf.frob.com>
X-Shopping-List: (1) Prosperous pincushions
   (2) Prosthetic documents
   (3) Spacious pig apparitions
   (4) Adamant hilarious paradox riots
Subject: [PATCH 2/3] execve: improve interactivity with large arguments
Message-Id: <20100908023628.A1F5A401AF@magilla.sf.frob.com>
Date: Tue,  7 Sep 2010 19:36:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a preemption point during the copying of the argument and
environment strings for execve, in copy_strings().  There is already
a preemption point in the count() loop, so this doesn't add any new
points in the abstract sense.

When the total argument+environment strings are very large, the time
spent copying them can be much more than a normal user time slice.
So this change improves the interactivity of the rest of the system
when one process is doing an execve with very large arguments.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 fs/exec.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 1b63237..6f2d777 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -419,6 +419,8 @@ static int copy_strings(int argc, const char __user *const __user *argv,
 		while (len > 0) {
 			int offset, bytes_to_copy;
 
+			cond_resched();
+
 			offset = pos % PAGE_SIZE;
 			if (offset == 0)
 				offset = PAGE_SIZE;
