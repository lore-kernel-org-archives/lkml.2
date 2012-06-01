Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497Ab2FALaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 07:30:09 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:53898 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab2FALaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 07:30:07 -0400
Date: Fri, 1 Jun 2012 13:29:55 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tejun Heo <tj@kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: WARNING: at block/blk-cgroup.c:867
Message-ID: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12060111-6892-0000-0000-00000201E683
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

for !CONFIG_CFQ_GROUP_IOSCHED the following warning triggered on s390:

------------[ cut here ]------------
WARNING: at block/blk-cgroup.c:867
Modules linked in:
Modules linked in:
CPU: 3 Not tainted 3.4.0-09547-gfb21aff #1
Process swapper/0 (pid: 1, task: 000000003ff80000, ksp: 000000003ff7f8b8)
Krnl PSW : 0704100180000000 00000000003d76ca (blkcg_policy_register+0xca/0xe0)
           R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
Krnl GPRS: 0000000000000000 00000000014b85ec 00000000014b85b0 0000000000000000
           000000000096fb60 0000000000000000 00000000009a8e78 0000000000000048
           000000000099c070 0000000000b6f000 0000000000000000 000000000099c0b8
           00000000014b85b0 0000000000667580 000000003ff7fd98 000000003ff7fd70
Krnl Code: 00000000003d76be: a7280001           lhi     %r2,1
           00000000003d76c2: a7f4ffdf           brc     15,3d7680
          #00000000003d76c6: a7f40001           brc     15,3d76c8
          >00000000003d76ca: a7c8ffea           lhi     %r12,-22
           00000000003d76ce: a7f4ffce           brc     15,3d766a
           00000000003d76d2: a7f40001           brc     15,3d76d4
           00000000003d76d6: a7c80000           lhi     %r12,0
           00000000003d76da: a7f4ffc2           brc     15,3d765e
Call Trace:
([<0000000000b6f000>] initcall_debug+0x0/0x4)
 [<0000000000989e8a>] cfq_init+0x62/0xd4
 [<00000000001000ba>] do_one_initcall+0x3a/0x170
 [<000000000096fb60>] kernel_init+0x214/0x2bc
 [<0000000000623202>] kernel_thread_starter+0x6/0xc
 [<00000000006231fc>] kernel_thread_starter+0x0/0xc
no locks held by swapper/0/1.
Last Breaking-Event-Address:
 [<00000000003d76c6>] blkcg_policy_register+0xc6/0xe0
---[ end trace b8ef4903fcbf9dd3 ]---

for !CONFIG_CFQ_GROUP_IOSCHED the blkcg_policy_cfq that cfq_init() tries to
register with blkcg_policy_register() is in the bss section and therefore
initialized with 0.

So the warning in blkcg_policy_register()

	if (WARN_ON(pol->pd_size < sizeof(struct blkg_policy_data)))
		return -EINVAL;

will trigger since pd_size == 0.

