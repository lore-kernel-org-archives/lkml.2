Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596Ab0JGGcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 02:32:08 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60049 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab0JGGcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 02:32:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4CAD6943.2020805@jp.fujitsu.com>
Date: Thu, 07 Oct 2010 15:31:31 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] HWPOISON: Copy si_addr_lsb to user
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org> <1286398141-13749-3-git-send-email-andi@firstfloor.org>
In-Reply-To: <1286398141-13749-3-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/10/07 5:48), Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The original hwpoison code added a new siginfo field si_addr_lsb to
> pass the granuality of the fault address to user space. Unfortunately
> this field was never copied to user space. Fix this here.
> 
> I added explicit checks for the MCEERR codes to avoid having
> to patch all potential callers to initialize the field.

Now QEMU uses signalfd to catch the SIGBUS delivered to the
main thread, so I think similar fix to copy lsb to user is
required for signalfd too. 


Thanks,
H.Seto

=====

From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Subject: [PATCH] signalfd: add support addr_lsb

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 fs/signalfd.c            |   10 ++++++++++
 include/linux/signalfd.h |    3 ++-
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/fs/signalfd.c b/fs/signalfd.c
index 1c5a6ad..3e28173 100644
--- a/fs/signalfd.c
+++ b/fs/signalfd.c
@@ -99,6 +99,16 @@ static int signalfd_copyinfo(struct signalfd_siginfo __user *uinfo,
 #ifdef __ARCH_SI_TRAPNO
 		err |= __put_user(kinfo->si_trapno, &uinfo->ssi_trapno);
 #endif
+#ifdef BUS_MCEERR_AO
+		/* 
+		 * Other callers might not initialize the si_lsb field,
+		 * so check explicitely for the right codes here.
+		 */
+		if (kinfo->si_code == BUS_MCEERR_AR ||
+		    kinfo->si_code == BUS_MCEERR_AO)
+			err |= __put_user((short) kinfo->si_addr_lsb,
+					  &uinfo->ssi_addr_lsb);
+#endif
 		break;
 	case __SI_CHLD:
 		err |= __put_user(kinfo->si_pid, &uinfo->ssi_pid);
diff --git a/include/linux/signalfd.h b/include/linux/signalfd.h
index b363b91..3ff4961 100644
--- a/include/linux/signalfd.h
+++ b/include/linux/signalfd.h
@@ -33,6 +33,7 @@ struct signalfd_siginfo {
 	__u64 ssi_utime;
 	__u64 ssi_stime;
 	__u64 ssi_addr;
+	__u16 ssi_addr_lsb;
 
 	/*
 	 * Pad strcture to 128 bytes. Remember to update the
@@ -43,7 +44,7 @@ struct signalfd_siginfo {
 	 * comes out of a read(2) and we really don't want to have
 	 * a compat on read(2).
 	 */
-	__u8 __pad[48];
+	__u8 __pad[46];
 };
 
 
-- 
1.7.3.1

