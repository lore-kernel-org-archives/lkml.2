Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754383Ab1I3Bnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 21:43:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44325 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346Ab1I3Bnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 21:43:45 -0400
Date: Thu, 29 Sep 2011 20:43:34 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Nelson Elhage <nelhage@nelhage.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 3.1-rc8 0/2] Two false positives from debugging tools
 (lockdep, kmemleak)
Message-ID: <20110930014334.GA2368@elie.chipublib.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Especially during the -rc period, it is nice to be able to take
advantage of lockdep and kmemleak to find bugs.  False positives make
it harder to find real problems amid the noise.

At boot time, I get:

| allocated 14680064 bytes of page_cgroup
| please try 'cgroup_disable=memory' option if you don't want memory cgroups
| kmemleak: Trying to color unknown object at 0xffff88006f500000 as Grey
| Pid: 0, comm: swapper Not tainted 3.1.0-rc8-00031-gd5767c53535a #12
| Call Trace:
|  [<ffffffff810f8637>] paint_ptr+0x56/0x8e
|  [<ffffffff812e336c>] kmemleak_not_leak+0x23/0x42
|  [<ffffffff816a00d5>] kmemleak_init+0x1db/0x23a
|  [<ffffffff81686ad2>] start_kernel+0x31c/0x3b1
|  [<ffffffff816862a8>] x86_64_start_reservations+0xaf/0xb3
|  [<ffffffff81686140>] ? early_idt_handlers+0x140/0x140
|  [<ffffffff816863ae>] x86_64_start_kernel+0x102/0x111
| kmemleak: Trying to color unknown object at 0xffff88006f600000 as Grey
[and so on, for 13 addresses in all]

Also:

| [  222.425445] systemd-logind/908 is trying to acquire lock:
| [  222.425447]  (&ep->mtx){+.+.+.}, at: [<ffffffff8112da68>] ep_scan_ready_list+0x3c/0x1a7
| [  222.425456] 
| [  222.425457] but task is already holding lock:
| [  222.425459]  (&ep->mtx){+.+.+.}, at: [<ffffffff8112dfd8>] sys_epoll_ctl+0x11d/0x520

Luckily both false positives seem to be known and well understood.
The first of the patches below (the kmemleak one) seems to have fallen
under the radar --- I can't even find it in linux-next.  The second (the
lockdep one) is taken from akpm's -mm patchset.

Thoughts?

Nelson Elhage (1):
  epoll: fix spurious lockdep warnings

Steven Rostedt (1):
  cgroup/kmemleak: Annotate alloc_page() for cgroup allocations

 fs/eventpoll.c   |   25 ++++++++++++++++++-------
 mm/page_cgroup.c |    7 +++++--
 2 files changed, 23 insertions(+), 9 deletions(-)

-- 
1.7.7.rc1

