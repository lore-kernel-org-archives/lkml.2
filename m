Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762224Ab0HGLvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Aug 2010 07:51:19 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:45058 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab0HGLvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Aug 2010 07:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=aXSiMqQ9lGyxdrpleZh3HIG11g/t4X7ARq1UkRs5QX+czWs1SsqzvENqq9eFw5lCi0
         RH7ISfF2bA63xn3UMiVPwMMREy2ghQuhSIWBu8RAX694b77LvzAN6ISaDzqRBPO4qF2A
         ANlOxl0QcvzR+7YJwOyFu9atV6r0IiZS7g5/U=
Date: Sat, 7 Aug 2010 13:50:38 +0200
From: Dan Carpenter <error27@gmail.com>
To: John Johansen <john.johansen@canonical.com>
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] apparmor: issue with ns name without a following profile
Message-ID: <20100807110639.GY9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	John Johansen <john.johansen@canonical.com>,
	James Morris <jmorris@namei.org>,
	linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we have a ns name without a following profile then in the original
code it did "*ns_name = &name[1];".  "name" is NULL so "*ns_name" is
0x1.  That isn't useful and could cause an oops when this function is
called from aa_remove_profiles(). 

Signed-off-by: Dan Carpenter <error27@gmail.com>
---
I'm not very familiar with this code and I haven't tested my fix. 
Sorry.  Please review carefully.

diff --git a/security/apparmor/lib.c b/security/apparmor/lib.c
index 6e85cdb..da34011 100644
--- a/security/apparmor/lib.c
+++ b/security/apparmor/lib.c
@@ -44,10 +44,12 @@ char *aa_split_fqname(char *fqname, char **ns_name)
 			/* overwrite ':' with \0 */
 			*split = 0;
 			name = skip_spaces(split + 1);
-		} else
+			*ns_name = &name[1];
+		} else {
 			/* a ns name without a following profile is allowed */
+			*ns_name = &name[1];
 			name = NULL;
-		*ns_name = &name[1];
+		}
 	}
 	if (name && *name == 0)
 		name = NULL;
