Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965080Ab2ERITa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:19:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932281Ab2ERITI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:19:08 -0400
Subject: [PATCH] cgroup: fix device deny of DEV_ALL
To: containers@lists.linux-foundation.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, lizefan@huawei.com,
        cgroups@vger.kernel.org, tj@kernel.org, serue@us.ibm.com
From: Amos Kong <akong@redhat.com>
Date: Fri, 18 May 2012 16:19:12 +0800
Message-ID: <20120518081912.16779.21065.stgit@t>
In-Reply-To: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com>
References: <CAFeW=pZ8Y7ycxjxro7zBMqdtaCOYs4RmoxtDrsN8+mqLhOL--g@mail.gmail.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@ mount -t cgroup -o devices none /cgroup
@ mkdir /cgroups/devices
@ ls -l /dev/dm-3
 brw-rw----. 1 root disk 253, 3 Oct 14 19:03 /dev/dm-3
@ echo 'b 253:3 rw' > devices.deny
but I can still write it by 'dd if=/dev/zero of=/dev/dm-3'

In devcgroup_create(), we create a new whitelist, and add first
entry which type is 'DEV_ALL'. Execute "# echo 'b 253:3 rw' >
devices.deny", dev_whitelist_rm() will update access of first
entry to 1(m), but type of first entry is still 'DEV_ALL'.

Execute dd cmd to write device, __devcgroup_inode_permission()
will be called, permission checking will pass if entry type
is 'DEV_ALL'. So write operation of 'dd' is not denied.

Currently 'access' is updated by not be used, this patch updated
the type,major,minor of first entry, then permission checking
would work.

Signed-off-by: Amos Kong <akong@redhat.com>
---
 security/device_cgroup.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index c43a332..d16b4bc 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -146,6 +146,11 @@ static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
 
 remove:
 		walk->access &= ~wh->access;
+		if (walk->type == DEV_ALL) {
+			walk->type = wh->type;
+			walk->major = wh->major;
+			walk->minor = wh->minor;
+		}
 		if (!walk->access) {
 			list_del_rcu(&walk->list);
 			kfree_rcu(walk, rcu);

