Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3ADV3G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 16:29:06 -0500
Received: from mail-gh0-f202.google.com ([209.85.160.202]:34824 "EHLO
	mail-gh0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab3ADV3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 16:29:03 -0500
From: Greg Thelen <gthelen@google.com>
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Thelen <gthelen@google.com>
Subject: [PATCH 2/2] cgroups: fix cgroup_event_listener error handling
Date: Fri,  4 Jan 2013 13:05:18 -0800
Message-Id: <1357333518-28899-2-git-send-email-gthelen@google.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1357333518-28899-1-git-send-email-gthelen@google.com>
References: <1357333518-28899-1-git-send-email-gthelen@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the <absolute-path-to-control-file> command line parameter cannot
be opened, then cgroup_event_listener prints an error message and
tries to return an error.  However, due to an uninitialized variable
the return value was undefined.

With this patch such failures always return non-zero error.

Compiler warning found this:
  $ gcc -Wall -O2 cgroup_event_listener.c
  cgroup_event_listener.c: In function ‘main’:
  cgroup_event_listener.c:109:2: warning: ‘ret’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 tools/cgroup/cgroup_event_listener.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/cgroup/cgroup_event_listener.c b/tools/cgroup/cgroup_event_listener.c
index 3e082f9..a70f00c 100644
--- a/tools/cgroup/cgroup_event_listener.c
+++ b/tools/cgroup/cgroup_event_listener.c
@@ -35,7 +35,7 @@ int main(int argc, char **argv)
 	if (cfd == -1) {
 		fprintf(stderr, "Cannot open %s: %s\n", argv[1],
 				strerror(errno));
-		goto out;
+		return 1;
 	}
 
 	ret = snprintf(event_control_path, PATH_MAX, "%s/cgroup.event_control",
-- 
1.7.7.3

