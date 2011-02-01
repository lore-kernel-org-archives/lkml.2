Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab1BAINY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 03:13:24 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36867 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751553Ab1BAINX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 03:13:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=D7bSWIIUUPpk17ImNvhxauNRLxx6dxGTs/LRdr3PYzh7o0bkxZjHonj6YgwcjwxgmN
         NIBs2zsgE2x8IO4hJRv3yX4Tr5At9O3er4VEptVHa/CT+Wfc9JXKP0d4WgxFyN0LcC34
         mnDhS4zPVMezJmaJgHu8+YCubpyVtpp79ZVS0=
Date: Tue, 1 Feb 2011 16:13:13 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Vivek Goyal <vgoyal@redhat.com>, kosaki.motohiro@jp.fujitsu.com,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jarod Wilson <jwilson@redhat.com>, akpm@linux-foundation.org
Subject: [Patch] kexec: remove KMSG_DUMP_KEXEC (was Re: Query about kdump_msg
 hook into crash_kexec())
Message-ID: <20110201081313.GC21239@cr0.nay.redhat.com>
References: <20110131225939.GH11974@redhat.com>
 <20110201071933.GA21239@cr0.nay.redhat.com>
 <m1hbcous3o.fsf@fess.ebiederm.org>
 <20110201073853.GB21239@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110201073853.GB21239@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 03:38:53PM +0800, Américo Wang wrote:
>On Mon, Jan 31, 2011 at 11:33:15PM -0800, Eric W. Biederman wrote:
>>The issue is the inane call inside crash_kexec.
>>
>>It requires both a kexec kernel to be loaded and it requires you to be
>>crashing.  Given that when I audited the kmsg_dump handlers they really
>>weren't safe in a crash dump scenario we should just remove it.
>>
>
>Probably, I think we need to get rid of KMSG_DUMP_KEXEC.
>

Here we go.

--------->

KMSG_DUMP_KEXEC is useless because we already save kernel messages
inside /proc/vmcore, and it is unsafe to allow modules to do
other stuffs in a crash dump scenario.

Reported-by: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>


---
diff --git a/drivers/char/ramoops.c b/drivers/char/ramoops.c
index 1a9f5f6..8653ba4 100644
--- a/drivers/char/ramoops.c
+++ b/drivers/char/ramoops.c
@@ -69,8 +69,7 @@ static void ramoops_do_dump(struct kmsg_dumper *dumper,
 	struct timeval timestamp;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC &&
-	    reason != KMSG_DUMP_KEXEC)
+	    reason != KMSG_DUMP_PANIC)
 		return;
 
 	/* Only dump oopses if dump_oops is set */
diff --git a/drivers/mtd/mtdoops.c b/drivers/mtd/mtdoops.c
index e3e40f4..56eac4e 100644
--- a/drivers/mtd/mtdoops.c
+++ b/drivers/mtd/mtdoops.c
@@ -308,8 +308,7 @@ static void mtdoops_do_dump(struct kmsg_dumper *dumper,
 	char *dst;
 
 	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC &&
-	    reason != KMSG_DUMP_KEXEC)
+	    reason != KMSG_DUMP_PANIC)
 		return;
 
 	/* Only dump oopses if dump_oops is set */
diff --git a/include/linux/kmsg_dump.h b/include/linux/kmsg_dump.h
index 2a0d7d6..05fa2a9 100644
--- a/include/linux/kmsg_dump.h
+++ b/include/linux/kmsg_dump.h
@@ -17,7 +17,6 @@
 enum kmsg_dump_reason {
 	KMSG_DUMP_OOPS,
 	KMSG_DUMP_PANIC,
-	KMSG_DUMP_KEXEC,
 	KMSG_DUMP_RESTART,
 	KMSG_DUMP_HALT,
 	KMSG_DUMP_POWEROFF,
diff --git a/kernel/kexec.c b/kernel/kexec.c
index ec19b92..3ac0218 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -32,7 +32,6 @@
 #include <linux/console.h>
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
-#include <linux/kmsg_dump.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -1078,8 +1077,6 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			kmsg_dump(KMSG_DUMP_KEXEC);
-
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
