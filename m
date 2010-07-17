Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966278Ab0GQAtq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 20:49:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:55520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759576Ab0GQAtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 20:49:05 -0400
Date: Sat, 17 Jul 2010 00:48:46 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, suresh.b.siddha@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <4C3EB22B.3000701@kernel.org>
References: <4C3EB22B.3000701@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Fix x2apic preenabled system with kexec
Message-ID: <tip-fd19dce7ac07973f700b0f13fb7f94b951414a4c@git.kernel.org>
Git-Commit-ID: fd19dce7ac07973f700b0f13fb7f94b951414a4c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 17 Jul 2010 00:48:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd19dce7ac07973f700b0f13fb7f94b951414a4c
Gitweb:     http://git.kernel.org/tip/fd19dce7ac07973f700b0f13fb7f94b951414a4c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 15 Jul 2010 00:00:59 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 16 Jul 2010 16:49:41 -0700

x86: Fix x2apic preenabled system with kexec

Found one x2apic system kexec loop test failed
when CONFIG_NMI_WATCHDOG=y (old) or CONFIG_LOCKUP_DETECTOR=y (current tip)

first kernel can kexec second kernel, but second kernel can not kexec third one.

it can be duplicated on another system with BIOS preenabled x2apic.
First kernel can not kexec second kernel.

It turns out, when kernel boot with pre-enabled x2apic, it will not execute
disable_local_APIC on shutdown path.

when init_apic_mappings() is called in setup_arch, it will skip setting of
apic_phys when x2apic_mode is set. ( x2apic_mode is much early check_x2apic())
Then later, disable_local_APIC() will bail out early because !apic_phys.

So check !x2apic_mode in x2apic_mode in disable_local_APIC with !apic_phys.

another solution could be updating init_apic_mappings() to set apic_phys even
for preenabled x2apic system. Actually even for x2apic system, that lapic
address is mapped already in early stage.

BTW: is there any x2apic preenabled system with apicid of boot cpu > 255?

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
LKML-Reference: <4C3EB22B.3000701@kernel.org>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: stable@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/apic/apic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index c02cc69..a96489e 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -921,7 +921,7 @@ void disable_local_APIC(void)
 	unsigned int value;
 
 	/* APIC hasn't been mapped yet */
-	if (!apic_phys)
+	if (!x2apic_mode && !apic_phys)
 		return;
 
 	clear_local_APIC();
