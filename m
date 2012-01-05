Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758321Ab2AEUvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 15:51:22 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:38022 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754449Ab2AEUvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 15:51:21 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        a.p.zijlstra@chello.nl, mingo@elte.hu, xiyou.wangcong@gmail.com
Subject: Re: [PATCH] init: Warn on non-existent rdinit
References: <1325789819-30502-1-git-send-email-richard@nod.at>
Date: Thu, 05 Jan 2012 12:53:29 -0800
In-Reply-To: <1325789819-30502-1-git-send-email-richard@nod.at> (Richard
	Weinberger's message of "Thu, 5 Jan 2012 19:56:59 +0100")
Message-ID: <m14nw9c1me.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+Vv6cpAT7seSG7Dj45LvWBenfJJm194E0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger <richard@nod.at> writes:

> Such a warning would have saved me some time...
> Hopefully this printk() saves someone else's time. :-)

The warning is wrong if you are not using an initramfs or an initial
ramdisk.

I expect what you want is something like:

diff --git a/init/main.c b/init/main.c
index 217ed23..8d53d28 100644
--- a/init/main.c
+++ b/init/main.c
@@ -830,10 +830,11 @@ static int __init kernel_init(void * unused)
         * the work
         */
 
-       if (!ramdisk_execute_command)
+       if (!ramdisk_execute_command &&
+           (sys_access((const char __user *)"/init", 0) == 0))
                ramdisk_execute_command = "/init";
 
-       if (sys_access((const char __user *) ramdisk_execute_command, 0) != 0) {
+       if (!ramdisk_execute_command) {
                ramdisk_execute_command = NULL;
                prepare_namespace();
        }


That way we don't clear ramdisk_execute_command if it was set and
we complain if we attempt exec the ramdisk_execute_command.

Eric
