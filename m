Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754412Ab2DUKAR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2012 06:00:17 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:39982 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2DUKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2012 06:00:15 -0400
Subject: [PATCH 3/4][Trivial] lib/kobject.c : Check ktype in
 kobject_add_internal
From: yan <clouds.yan@gmail.com>
To: greg <gregkh@linuxfoundation.org>
Cc: kernel <linux-kernel@vger.kernel.org>, message <message.get@gmail.com>
Date: Sat, 21 Apr 2012 17:58:31 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1335002414.2188.27.camel@yan>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If someone calls kobject_init with null kobj_type, kobject_init can 
detect it. But it does not have a return value, it just dumps stack.
In this case, a kobject_add after that will result in:
   -->kobject_add_varg
    -->kobject_add_internal
     -->create_dir
      -->sysfs_create_dir
       -->sysfs_read_ns_type
        -->kobj_child_ns_ops
In the end, it will call ->ktype->child_ns_type directly and we have
an oops.

Check ktype before really add a kobject.

Signed-off-by: Yan Hong <clouds.yan@gmail.com>
---
 lib/kobject.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/lib/kobject.c b/lib/kobject.c
index 85d5e9b..3ba6216 100644
--- a/lib/kobject.c
+++ b/lib/kobject.c
@@ -164,6 +164,9 @@ static int kobject_add_internal(struct kobject *kobj)
 	if (!kobj)
 		return -ENOENT;
 
+	if (!kobj->ktype)
+		return -EINVAL;
+
 	if (!kobj->name || !kobj->name[0]) {
 		WARN(1, "kobject: (%p): attempted to be registered with empty "
 			 "name!\n", kobj);
-- 
1.7.5.1







