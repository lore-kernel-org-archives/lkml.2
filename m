Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab0FVCSW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:18:22 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47419 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab0FVCSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:18:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Edward Allcutt <edward@allcutt.me.uk>
Subject: Re: [PATCH] fs: limit maximum concurrent coredumps
Cc: kosaki.motohiro@jp.fujitsu.com, Alexander Viro <viro@zeniv.linux.org.uk>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Oleg Nesterov <oleg@redhat.com>,
       Neil Horman <nhorman@tuxdriver.com>, Roland McGrath <roland@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
References: <1277164737-30055-1-git-send-email-edward@allcutt.me.uk>
Message-Id: <20100622110342.B54E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 22 Jun 2010 11:18:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A moderately large number of large core files being dumped simultaneously
> can impose severe latency penalties on other processes due to IO load.
> 
> For example, a common configuration for PHP web-servers includes apache's
> prefork MPM, mod_php and a PHP opcode cache utilizing shared memory. In
> certain failure modes, all requests serviced by PHP result in a segfault.
> Enabling coredumps might lead to 10-20 coredumps per second, all attempting
> to write a 150-200MB core file. This leads to the whole system becoming
> entirely unresponsive for many minutes.
> 
> The ability to limit concurrent coredumps allows dumping core to be safely
> enabled in these situations without affecting responsiveness of the system
> as a whole.
> 
> I have several servers running with this patch applied (actually backported
> to v2.6.26) and it has allowed me to deal successfully with the situation
> described above.
> 
> In do_coredump I have pulled dump_count back out to the top-level scope
> and core_dump_count is now incremented in the normal path.
> 
> Added sysctl parameter for tuning core_max_concurrency.
> 
> checkpatch complains about "extern ... core_max_concurrency" but this seems
> to be an acceptable exception based on the preponderance of other extern
> variables in kernel/sysctl.c

To be honest, My customers have very similar problem for long time. If 
HPC MPI job or apache prefork MPM processces die, The system load to 
make large concurrent core dump I/O and consume all I/O band width. 
Eventually, all other service stall long time and HA cluster software
shutdown such node forcely.

My case used two technique, 1) limit concurrent coredump (but not skip
as sugessted Roland) 2) reduce I/O priority automatically in do_coredump().
I don't know my way was correct way. but I believe we need something case.



