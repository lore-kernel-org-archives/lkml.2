Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab2FDNXm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 09:23:42 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:40637 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932109Ab2FDNXk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 09:23:40 -0400
X-ASG-Debug-ID: 1338816219-03d6a503106fee0001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4FCCB6D1.9080708@fusionio.com>
Date: Mon, 4 Jun 2012 15:23:29 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] block: blkcg_policy_cfq shouldn't be used if !CONFIG_CFQ_GROUP_IOSCHED
References: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com> <20120604043040.GA21357@google.com> <20120604043112.GB21357@google.com>
X-ASG-Orig-Subj: Re: [PATCH 2/2] block: blkcg_policy_cfq shouldn't be used if !CONFIG_CFQ_GROUP_IOSCHED
In-Reply-To: <20120604043112.GB21357@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1338816219
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Bayes: INNOCENT GLOBAL 0.0001 1.0000 -2.0203
X-Barracuda-Spam-Score: -2.02
X-Barracuda-Spam-Status: No, SCORE=-2.02 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.98920
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2012 06:31 AM, Tejun Heo wrote:
> cfq may be built w/ or w/o blkcg support depending on
> CONFIG_CFQ_CGROUP_IOSCHED.  If blkcg support is disabled, most of
> related code is ifdef'd out but some part is left dangling -
> blkcg_policy_cfq is left zero-filled and blkcg_policy_[un]register()
> calls are made on it.
> 
> Feeding zero filled policy to blkcg_policy_register() is incorrect and
> triggers the following WARN_ON() if CONFIG_BLK_CGROUP &&
> !CONFIG_CFQ_GROUP_IOSCHED.
> 
>  ------------[ cut here ]------------
>  WARNING: at block/blk-cgroup.c:867
>  Modules linked in:
>  Modules linked in:
>  CPU: 3 Not tainted 3.4.0-09547-gfb21aff #1
>  Process swapper/0 (pid: 1, task: 000000003ff80000, ksp: 000000003ff7f8b8)
>  Krnl PSW : 0704100180000000 00000000003d76ca (blkcg_policy_register+0xca/0xe0)
> 	    R:0 T:1 IO:1 EX:1 Key:0 M:1 W:0 P:0 AS:0 CC:1 PM:0 EA:3
>  Krnl GPRS: 0000000000000000 00000000014b85ec 00000000014b85b0 0000000000000000
> 	    000000000096fb60 0000000000000000 00000000009a8e78 0000000000000048
> 	    000000000099c070 0000000000b6f000 0000000000000000 000000000099c0b8
> 	    00000000014b85b0 0000000000667580 000000003ff7fd98 000000003ff7fd70
>  Krnl Code: 00000000003d76be: a7280001           lhi     %r2,1
> 	    00000000003d76c2: a7f4ffdf           brc     15,3d7680
> 	   #00000000003d76c6: a7f40001           brc     15,3d76c8
> 	   >00000000003d76ca: a7c8ffea           lhi     %r12,-22
> 	    00000000003d76ce: a7f4ffce           brc     15,3d766a
> 	    00000000003d76d2: a7f40001           brc     15,3d76d4
> 	    00000000003d76d6: a7c80000           lhi     %r12,0
> 	    00000000003d76da: a7f4ffc2           brc     15,3d765e
>  Call Trace:
>  ([<0000000000b6f000>] initcall_debug+0x0/0x4)
>   [<0000000000989e8a>] cfq_init+0x62/0xd4
>   [<00000000001000ba>] do_one_initcall+0x3a/0x170
>   [<000000000096fb60>] kernel_init+0x214/0x2bc
>   [<0000000000623202>] kernel_thread_starter+0x6/0xc
>   [<00000000006231fc>] kernel_thread_starter+0x0/0xc
>  no locks held by swapper/0/1.
>  Last Breaking-Event-Address:
>   [<00000000003d76c6>] blkcg_policy_register+0xc6/0xe0
>  ---[ end trace b8ef4903fcbf9dd3 ]---
> 
> This patch fixes the problem by ensuring all blkcg support code is
> inside CONFIG_CFQ_GROUP_IOSCHED.
> 
> * blkcg_policy_cfq declaration and blkg_to_cfqg() definition are moved
>   inside the first CONFIG_CFQ_GROUP_IOSCHED block.  __maybe_unused is
>   dropped from blkcg_policy_cfq decl.
> 
> * blkcg_deactivate_poilcy() invocation is moved inside ifdef.  This
>   also makes the activation logic match cfq_init_queue().
> 
> * All blkcg_policy_[un]register() invocations are moved inside ifdef.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> LKML-Reference: <20120601112954.GC3535@osiris.boeblingen.de.ibm.com>

Thanks Tejun, applied this one and 1/2 as well as a standalone bug fix.

-- 
Jens Axboe

