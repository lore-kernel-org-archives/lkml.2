Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab1J1Gxs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:53:48 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57000 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751728Ab1J1Gxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:53:47 -0400
Message-ID: <4EAA51D5.8080706@cn.fujitsu.com>
Date: Fri, 28 Oct 2011 14:55:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] tracing: fix event system memory leak
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 14:51:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2011-10-28 14:51:42,
	Serialize complete at 2011-10-28 14:51:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

system->ref_count = system->nr_events + ref_count for opening "enable"
and "filter"

so when removing a module, it's wrong to drop ref_count only when nr_events
drops to 0.

Cc: stable <stable@kernel.org>
Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/trace/trace_events.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index 581876f..281a60a 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1252,8 +1252,8 @@ static void remove_subsystem_dir(const char *name)
 			if (!--system->nr_events) {
 				debugfs_remove_recursive(system->entry);
 				list_del(&system->list);
-				__put_system(system);
 			}
+			__put_system(system);
 			break;
 		}
 	}
-- 
1.7.3.1
