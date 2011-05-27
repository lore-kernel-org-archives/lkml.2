Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758721Ab1E0DMf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 23:12:35 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34138 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab1E0DMe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 23:12:34 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 27 May 2011 12:05:39 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Ying Han <yinghan@google.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH v3 0/10] memcg async reclaim
Message-Id: <20110527120539.91778598.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110527114837.8fae7f00.kamezawa.hiroyu@jp.fujitsu.com>
References: <20110526141047.dc828124.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTikcdOGkJWxS0Sey8C1ereVk8ucvQQ@mail.gmail.com>
	<20110527114837.8fae7f00.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 May 2011 11:48:37 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Thu, 26 May 2011 18:49:26 -0700
> Ying Han <yinghan@google.com> wrote:
 
> > Hmm.. I noticed a very strange behavior on a simple test w/ the patch set.
> > 
> > Test:
> > I created a 4g memcg and start doing cat. Then the memcg being OOM
> > killed as soon as it reaches its hard_limit. We shouldn't hit OOM even
> > w/o async-reclaim.
> > 
> > Again, I will read through the patch. But like to post the test result first.
> > 
> > $ echo $$ >/dev/cgroup/memory/A/tasks
> > $ cat /dev/cgroup/memory/A/memory.limit_in_bytes
> > 4294967296
> > 
> > $ time cat /export/hdc3/dd_A/tf0 > /dev/zero
> > Killed
> > 
> > real	0m53.565s
> > user	0m0.061s
> > sys	0m4.814s
> > 
> 
> Hmm, what I see is
> ==
> root@bluextal kamezawa]# ls -l test/1G
> -rw-rw-r--. 1 kamezawa kamezawa 1053261824 May 13 13:58 test/1G
> [root@bluextal kamezawa]# mkdir /cgroup/memory/A
> [root@bluextal kamezawa]# echo 0 > /cgroup/memory/A/tasks
> [root@bluextal kamezawa]# echo 300M > /cgroup/memory/A/memory.limit_in_bytes
> [root@bluextal kamezawa]# echo 1 > /cgroup/memory/A/memory.async_control
> [root@bluextal kamezawa]# cat test/1G > /dev/null
> [root@bluextal kamezawa]# cat /cgroup/memory/A/memory.reclaim_stat
> recent_scan_success_ratio 83
> limit_scan_pages 82
> limit_freed_pages 49
> limit_elapsed_ns 242507
> soft_scan_pages 0
> soft_freed_pages 0
> soft_elapsed_ns 0
> margin_scan_pages 218630
> margin_freed_pages 181598
> margin_elapsed_ns 117466604
> [root@bluextal kamezawa]#
> ==
> 
> I'll turn off swapaccount and try again.
> 

A bug found....I added memory.async_control file to memsw.....file set by mistake.
Then, async_control cannot be enabled when swapaccount=0. I'll fix that.

So, how do you enabled async_control ?

Thanks,
-Kame



