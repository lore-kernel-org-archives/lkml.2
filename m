Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757580Ab1FPKKG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 06:10:06 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55872 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757534Ab1FPKKE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 06:10:04 -0400
Date: Thu, 16 Jun 2011 12:09:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "bsingharora@gmail.com" <bsingharora@gmail.com>,
        "hannes@cmpxchg.org" <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Ying Han <yinghan@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [-git build bug, PATCH] Re: [BUGFIX][PATCH 2/5] memcg: fix
 init_page_cgroup nid with sparsemem
Message-ID: <20110616100937.GA12317@elte.hu>
References: <20110613120054.3336e997.kamezawa.hiroyu@jp.fujitsu.com>
 <20110613120608.d5243bc9.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110613120608.d5243bc9.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> Date: Mon, 13 Jun 2011 10:09:17 +0900
> Subject: [PATCH 2/5] [BUGFIX] memcg: fix init_page_cgroup nid with sparsemem

This fresh upstream commit commit:

  37573e8c7182: memcg: fix init_page_cgroup nid with sparsemem

is causing widespread build failures on latest -git, on x86:

  mm/page_cgroup.c:308:3: error: implicit declaration of function ‘node_start_pfn’ [-Werror=implicit-function-declaration]
  mm/page_cgroup.c:309:3: error: implicit declaration of function ‘node_end_pfn’ [-Werror=implicit-function-declaration]

On any config that has CONFIG_CGROUP_MEM_RES_CTLR=y enabled but 
CONFIG_NUMA disabled.

For now i've worked it around with the patch below, but the real 
solution would be to make the page_cgroup.c code not depend on NUMA.

Thanks,

	Ingo

diff --git a/init/Kconfig b/init/Kconfig
index 412c21b..1593be9 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -639,6 +639,7 @@ config RESOURCE_COUNTERS
 config CGROUP_MEM_RES_CTLR
 	bool "Memory Resource Controller for Control Groups"
 	depends on RESOURCE_COUNTERS
+	depends on NUMA
 	select MM_OWNER
 	help
 	  Provides a memory resource controller that manages both anonymous
