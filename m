Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230Ab2BBD00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 22:26:26 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:40528 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754885Ab2BBD0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 22:26:24 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: <linux-kernel@vger.kernel.org>
Cc: <linux-fsdevel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Lucian Adrian Grijincu <lucian.grijincu@gmail.com>,
        Damien Millescamps <damien.millescamps@6wind.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 2/4] sysctl: Correct error return from get_subdir
References: <m1pqe5ah3z.fsf@fess.ebiederm.org>
	<m139atx6bs.fsf@fess.ebiederm.org>
Date: Wed, 01 Feb 2012 19:29:07 -0800
In-Reply-To: <m139atx6bs.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Wed, 01 Feb 2012 19:27:51 -0800")
Message-ID: <m1ty39vrp8.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1zjCCkcZBABKxr81WMT5r3XVJ/vW/RTA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When insert_header fails ensure we return the proper error value
from get_subdir.  In practice nothing cares, but there is no
need to be sloppy.

Reported-by: Lucian Adrian Grijincu <lucian.grijincu@gmail.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/proc_sysctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index ebe8b30..722ec11 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -869,6 +869,7 @@ static struct ctl_dir *get_subdir(struct ctl_dir *dir,
 {
 	struct ctl_table_set *set = dir->header.set;
 	struct ctl_dir *subdir, *new = NULL;
+	int err;
 
 	spin_lock(&sysctl_lock);
 	subdir = find_subdir(dir, name, namelen);
@@ -890,7 +891,9 @@ static struct ctl_dir *get_subdir(struct ctl_dir *dir,
 	if (PTR_ERR(subdir) != -ENOENT)
 		goto failed;
 
-	if (insert_header(dir, &new->header))
+	err = insert_header(dir, &new->header);
+	subdir = ERR_PTR(err);
+	if (err)
 		goto failed;
 	subdir = new;
 found:
-- 
1.7.2.5

