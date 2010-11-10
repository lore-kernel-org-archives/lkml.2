Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0KJIFr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 03:05:47 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:34960 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab0KJIFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 03:05:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=m46hipVIwmH3+gTzXcDIcfibjVweEyUwDqh1SwxeeiSmJyK1tevdJNEsfHzRjX6yJo
         nBB6sYHYrDzGA3xP5ERT8OwGyEHYqeV9Qg8bCfJJjcJ9uFmSyszFleiBBF0bBTnrJp73
         yeoqA+gIoYmBx/djbeVFmGj8VPBPYm7MzvwTA=
Date: Wed, 10 Nov 2010 16:05:15 +0800
From: wzt.wzt@gmail.com
To: linux-kernel@vger.kernel.org
Cc: john.johansen@canonical.com, apparmor@lists.ubuntu.com,
        linux-security-module@vger.kernel.org
Subject: [PATCH] APPARMOR: Fix memory leak of apparmor_init()
Message-ID: <20101110080515.GA2722@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

set_init_cxt() allocted sizeof(struct aa_task_cxt) bytes for cxt, 
if register_security() failed, it will cause memory leak.

Signed-off-by: Zhitong Wang <zhitong.wangzt@alibaba-inc.com>

---
 security/apparmor/lsm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/lsm.c b/security/apparmor/lsm.c
index cf1de44..b7106f1 100644
--- a/security/apparmor/lsm.c
+++ b/security/apparmor/lsm.c
@@ -922,7 +922,7 @@ static int __init apparmor_init(void)
 	error = register_security(&apparmor_ops);
 	if (error) {
 		AA_ERROR("Unable to register AppArmor\n");
-		goto register_security_out;
+		goto set_init_cxt_out;
 	}
 
 	/* Report that AppArmor successfully initialized */
@@ -936,6 +936,9 @@ static int __init apparmor_init(void)
 
 	return error;
 
+set_init_cxt_out:
+	aa_free_task_context(current->real_cred->security);
+
 register_security_out:
 	aa_free_root_ns();
 
@@ -944,7 +947,6 @@ alloc_out:
 
 	apparmor_enabled = 0;
 	return error;
-
 }
 
 security_initcall(apparmor_init);
-- 
1.6.5.3

