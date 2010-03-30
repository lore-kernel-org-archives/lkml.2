Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab0C3XxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:53:04 -0400
Received: from kroah.org ([198.145.64.141]:45756 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425Ab0C3XTa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:19:30 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:47:34 2010
Message-Id: <20100330224733.571179411@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:40:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [021/156] tracing: Fix warning in s_next of trace file ops
In-Reply-To: <20100330230630.GA28824@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit ac91d85456372a90af5b85eb6620fd2efb1e431b upstream.

This warning in s_next() can be triggered by lseek():
 [<c018b3f7>] ? s_next+0x77/0x80
 [<c013e3c1>] warn_slowpath_common+0x81/0xa0
 [<c018b3f7>] ? s_next+0x77/0x80
 [<c013e3fa>] warn_slowpath_null+0x1a/0x20
 [<c018b3f7>] s_next+0x77/0x80
 [<c01efa77>] traverse+0x117/0x200
 [<c01eff13>] seq_lseek+0xa3/0x120
 [<c01efe70>] ? seq_lseek+0x0/0x120
 [<c01d7081>] vfs_llseek+0x41/0x50
 [<c01d8116>] sys_llseek+0x66/0xa0
 [<c0102bd0>] sysenter_do_call+0x12/0x26

The iterator "leftover" variable is zeroed in the opening of the trace
file. But lseek can call s_start() which will call s_next() without
reseting the "leftover" variable back to zero, which might trigger
the WARN_ON_ONCE(iter->leftover) that is in s_next().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
LKML-Reference: <4B8CE06A.9090207@cn.fujitsu.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/trace/trace.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -1628,6 +1628,7 @@ static void *s_start(struct seq_file *m,
 
 		ftrace_enable_cpu();
 
+		iter->leftover = 0;
 		for (p = iter; p && l < *pos; p = s_next(m, p, &l))
 			;
 


