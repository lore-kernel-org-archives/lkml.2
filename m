Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2AaNZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 08:25:35 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64347 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2AaNZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 08:25:34 -0500
Message-ID: <4F27EBBF.6040103@gmail.com>
Date: Tue, 31 Jan 2012 21:25:19 +0800
From: Cong Wang <xiyou.wangcong@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <greg@kroah.com>
Subject: Re: [Patch] lkdtm: avoid calling lkdtm_do_action() with spin lock
 held
References: <1327755168-12240-1-git-send-email-xiyou.wangcong@gmail.com> <20120130125429.56f6f7d0.akpm@linux-foundation.org>
In-Reply-To: <20120130125429.56f6f7d0.akpm@linux-foundation.org>
Content-Type: multipart/mixed;
 boundary="------------080100000505010100000006"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080100000505010100000006
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 01/31/2012 04:54 AM, Andrew Morton wrote:
>
> lkdtm_handler() can be called from module IRQ handlers, so perhaps the
> same problems can still happen.  The patch does improve things though ;)
>

Yeah, what do you think about patch below (untested)?

---

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

--------------080100000505010100000006
Content-Type: text/x-patch;
 name="lkdtm-2.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="lkdtm-2.diff"

diff --git a/drivers/misc/lkdtm.c b/drivers/misc/lkdtm.c
index 28adefe..5cbd740 100644
--- a/drivers/misc/lkdtm.c
+++ b/drivers/misc/lkdtm.c
@@ -315,7 +315,7 @@ static void lkdtm_do_action(enum ctype which)
 	}
 	case CT_OVERWRITE_ALLOCATION: {
 		size_t len = 1020;
-		u32 *data = kmalloc(len, GFP_KERNEL);
+		u32 *data = kmalloc(len, GFP_ATOMIC);
 
 		data[1024 / sizeof(u32)] = 0x12345678;
 		kfree(data);
@@ -323,14 +323,16 @@ static void lkdtm_do_action(enum ctype which)
 	}
 	case CT_WRITE_AFTER_FREE: {
 		size_t len = 1024;
-		u32 *data = kmalloc(len, GFP_KERNEL);
+		u32 *data = kmalloc(len, GFP_ATOMIC);
 
 		kfree(data);
-		schedule();
+		udelay(100);
 		memset(data, 0x78, len);
 		break;
 	}
 	case CT_SOFTLOCKUP:
+		if (in_interrupt())
+			break;
 		preempt_disable();
 		for (;;)
 			cpu_relax();
@@ -341,6 +343,8 @@ static void lkdtm_do_action(enum ctype which)
 			cpu_relax();
 		break;
 	case CT_HUNG_TASK:
+		if (in_interrupt())
+			break;
 		set_current_state(TASK_UNINTERRUPTIBLE);
 		schedule();
 		break;

--------------080100000505010100000006--
