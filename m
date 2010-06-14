Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755895Ab0FNPQi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 11:16:38 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:60060 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755790Ab0FNPQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 11:16:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=risOOBdT4HULu0khVH3vSNWHov2GW3+Dx4xR13T9vCYXLxczXY3lzscOjU23ixIApn
         IWQendPsbM4Trm1dRk2F1nKCiykko6wfU7lZWZZvUgU8zFjQ5oGqoCDfNesh1aprc6NQ
         cGWwz29uGeu2bjSlyfzdDuopwwQ/tRurNkXR8=
MIME-Version: 1.0
Date: Mon, 14 Jun 2010 16:16:34 +0100
Message-ID: <AANLkTimDcTnyEPmt2ZcCM1UWtn4AYKotiqyjobJApkO7@mail.gmail.com>
Subject: [2.6.35-rc3] reboot mutex 'bug'...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When halting 2.6.35-rc3 compiled on ARM with debugging, the kernel
warns [1] about the reboot_mutex being taken at kernel/sys.c:392 [2]
and held across do_exit() since kernel_power_off() doesn't necessarily
stop execution.

Does it make sense to annotate the reboot_mutex lock or is another
approach suggested?

Daniel

--- [1]

=====================================
[ BUG: lock held at task exit time! ]
-------------------------------------
halt/3874 is exiting with locks still held!
1 lock held by halt/3874:
 #0:  (reboot_mutex){+.+...}, at: [<c0070424>] sys_reboot+0x98/0x1c4

stack backtrace:
[<c003ab58>] (unwind_backtrace+0x0/0xe8) from [<c04ba3f0>]
(dump_stack+0x18/0x1c)
[<c04ba3f0>] (dump_stack+0x18/0x1c) from [<c008aea8>]
(debug_check_no_locks_held+0x74/)
[<c008aea8>] (debug_check_no_locks_held+0x74/0x90) from [<c0063dfc>]
(do_exit+0x570/0x)
[<c0063dfc>] (do_exit+0x570/0x5ec) from [<c00704a8>] (sys_reboot+0x11c/0x1c4)
[<c00704a8>] (sys_reboot+0x11c/0x1c4) from [<c0036040>]
(ret_fast_syscall+0x0/0x3c)

--- [2] kernel/sys.c

SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
                void __user *, arg)
{
...
        mutex_lock(&reboot_mutex);
...
        case LINUX_REBOOT_CMD_POWER_OFF:
                kernel_power_off();
                do_exit(0);
                break;
...
        mutex_unlock(&reboot_mutex);
...
}
-- 
Daniel J Blueman
