Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271Ab1HCXhl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 19:37:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33966 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932155Ab1HCX3h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 19:29:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Aug  3 15:12:49 2011
Message-Id: <20110803221249.617723345@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 03 Aug 2011 15:01:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Huang Ying <ying.huang@intel.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [056/102] kexec, x86: Fix incorrect jump back address if not preserving context
In-Reply-To: <20110803221345.GA10346@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Huang Ying <ying.huang@intel.com>

commit 050438ed5a05b25cdf287f5691e56a58c2606997 upstream.

In kexec jump support, jump back address passed to the kexeced
kernel via function calling ABI, that is, the function call
return address is the jump back entry.

Furthermore, jump back entry == 0 should be used to signal that
the jump back or preserve context is not enabled in the original
kernel.

But in the current implementation the stack position used for
function call return address is not cleared context
preservation is disabled. The patch fixes this bug.

Reported-and-tested-by: Yin Kangkai <kangkai.yin@intel.com>
Signed-off-by: Huang Ying <ying.huang@intel.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Link: http://lkml.kernel.org/r/1310607277-25029-1-git-send-email-ying.huang@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/relocate_kernel_32.S |    2 ++
 arch/x86/kernel/relocate_kernel_64.S |    2 ++
 2 files changed, 4 insertions(+)

--- a/arch/x86/kernel/relocate_kernel_32.S
+++ b/arch/x86/kernel/relocate_kernel_32.S
@@ -97,6 +97,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushl	$0
 	/* store the start address on the stack */
 	pushl   %edx
 
--- a/arch/x86/kernel/relocate_kernel_64.S
+++ b/arch/x86/kernel/relocate_kernel_64.S
@@ -100,6 +100,8 @@ relocate_kernel:
 	ret
 
 identity_mapped:
+	/* set return address to 0 if not preserving context */
+	pushq	$0
 	/* store the start address on the stack */
 	pushq   %rdx
 


