Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751898Ab1BJHil (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 02:38:41 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:49933 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab1BJHil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 02:38:41 -0500
X-Greylist: delayed 377 seconds by postgrey-1.27 at vger.kernel.org; Thu, 10 Feb 2011 02:38:40 EST
X-Spam-ASN: 
From: "Nikita V. Youshchenko" <nyoushchenko@mvista.com>
To: linux-kernel@vger.kernel.org
Subject: Likely race between sys_rt_sigtimedwait() and complete_signal()
Date: Thu, 10 Feb 2011 10:32:16 +0300
User-Agent: KMail/1.9.9
Cc: Alexander Kaliadin <akaliadin@mvista.com>, oishi.y@sys.yzk.co.jp
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201102101032.16401@blacky.localdomain>
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello linux-kernel.

Within project we are working on, we are facing a "rare" situation when 
setitimer() / sigwait() - based periodic task execution hangs. "Rare" 
means once per several hours for 1000 Hz timer.

For hanged thread, cat /proc/pid/status shows

...
State:	S (sleeping)
...
SigPnd:	0000000000000000
ShdPnd:	0000000000002000
SigBlk:	0000000000000000
...

and SysRq - T shows

[<c015b1b0>] (__schedule+0x2fc/0x37c) from [<c015b7b8>] 
(schedule+0x1c/0x30)
[<c015b7b8>] (schedule+0x1c/0x30) from [<c015b8c4>] 
(schedule_timeout+0x18/0x1dc)
[<c015b8c4>] (schedule_timeout+0x18/0x1dc) from [<c004a084>] 
(sys_rt_sigtimedwait+0x1b4/0x288)
[<c004a084>] (sys_rt_sigtimedwait+0x1b4/0x288) from [<c001cf00>] 
(ret_fast_syscall+0x0/0x28)

All other threads have SIGALRM blocked as they should, looking 
through /proc/X/status proves this.

So for some reason, SIGALRM was successfully delivered by timer, bit was 
set in ShdPnd [I guess at the bottom of __send_signal()], but that still 
resulted somehow in thread going to schedule() and not waking.

I guess this is some sort of race between sys_rt_sigtimedwait() and 
complete_signal().

This is on embedded system running vendor 2.6.31-based kernel, moving 
forward is unfortunately impossible because of hardware support issues. 
However I've looked through

git log -p HEAD..linus/master -- kernel/signal.c

and did not notice anything that could be related.

Unfortunately we don't currently have resources for futher analysis - 
especially with simple workarounds existing, such as switch to 
timerfd-based periodic execution (which looks working without hangs).

However I guess the race we faced still exists in the current upstream 
kernel, so maybe somebody on this mailing list could be interested into 
looking at this?

Nikita
