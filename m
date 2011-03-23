Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493Ab1CWEal (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 00:30:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52218 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab1CWEak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 00:30:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 23 Mar 2011 13:23:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "rientjes@google.com" <rientjes@google.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "minchan.kim@gmail.com" <minchan.kim@gmail.com>, avagin@openvz.org,
        kirill@shutemov.name
Subject: [RFC][PATCH 0/3] A forkbomb killer and mm tracking system
Message-Id: <20110323132323.f223fc6d.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a new one. All design was changed.

While testing Andrey's case, I confirmed I need to reboot the system by
power off when I ran a fork-bomb. The speed of fork() is much faster
than some smart killing as pkill(1) and oom-killer cannot reach the speed.
I wonder it's better to have a fork-bomb killer.


In previous version, the kernel finds guilty processes(forkbomb) by chasing
task's process tree chain. But, it cannot kill a famous forkbomb

# forkbomb(){ forkbomb|forkbomb & } ; forkbomb
(see wikipedia.)

To kill this bomb, we need to track dead processes. This version uses
a mm_struct tracking system. All mm_structs are recorded with its
parent-chidlren, start_time information. (A periodic work will erase
that information.) And forkbomb killer kills tasks by using the map
of relationship among mm_structs.

I tested with
# forkbomb(){ forkbomb|forkbomb & } ; forkbomb
# make -j Kernel
# Andrey's case

and all bombs are removed by ForkBomb Killer. 
Maybe more tests and development will be required.

(If there is swap, it's hard to kill bombs automatically....I used Sysrq.)

Any comments are welcome.

Thanks,
-Kame











