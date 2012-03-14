Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab2CNTBB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 15:01:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51561 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab2CNTA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 15:00:59 -0400
Message-ID: <1331758844.3723.3.camel@lappy>
Subject: vfs: chmod: Hung task after calling chmod()
From: Sasha Levin <levinsasha928@gmail.com>
To: Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Dave Jones <davej@redhat.com>
Date: Wed, 14 Mar 2012 17:00:44 -0400
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've found the following backtrace after running the trinity fuzzer in a KVM guest using the latest linux-next. Unfortunately I don't have full logs for this, so I can't tell exactly which parameters were passed to chmod().

[  241.469508] INFO: task trinity:3058 blocked for more than 120 seconds.
[  241.471949] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  241.476626] trinity         D 0000000000000000  4544  3058      1 0x00000000
[  241.480595]  ffff880035f29d98 0000000000000082 ffff880035f29d28 ffff880035f29fd8
[  241.483212]  00000000001d4340 ffff880035f28000 00000000001d4340 00000000001d4340
[  241.487158]  00000000001d4340 00000000001d4340 ffff880035f29fd8 00000000001d4340
[  241.490875] Call Trace:
[  241.492186]  [<ffffffff826edfc4>] schedule+0x24/0x70
[  241.493132]  [<ffffffff826ee023>] schedule_preempt_disabled+0x13/0x20
[  241.493878]  [<ffffffff826ec79f>] __mutex_lock_common+0x1ff/0x5a0
[  241.494683]  [<ffffffff811dbe4a>] ? chmod_common+0x5a/0xc0
[  241.495357]  [<ffffffff811ea22e>] ? putname+0x2e/0x40
[  241.495946]  [<ffffffff811dbe4a>] ? chmod_common+0x5a/0xc0
[  241.496669]  [<ffffffff826ecb80>] mutex_lock_nested+0x40/0x50
[  241.497388]  [<ffffffff811dbe4a>] chmod_common+0x5a/0xc0
[  241.498033]  [<ffffffff811e079c>] ? __fput+0x1cc/0x300
[  241.498656]  [<ffffffff826f0da9>] ? sysret_check+0x22/0x5d
[  241.499480]  [<ffffffff811dc964>] sys_fchmodat+0x34/0x50
[  241.500350]  [<ffffffff811dc994>] sys_chmod+0x14/0x20
[  241.500952]  [<ffffffff826f0d7d>] system_call_fastpath+0x1a/0x1f
[  241.501671] 1 lock held by trinity/3058:
[  241.502142]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811dbe4a>] chmod_common+0x5a/0xc0
[  241.503314] Kernel panic - not syncing: hung_task: blocked tasks

-- 

Sasha.

