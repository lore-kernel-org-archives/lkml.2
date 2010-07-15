Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab0GOMZN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 08:25:13 -0400
Received: from mx4.sophos.com ([74.202.89.161]:56710 "EHLO mx4.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab0GOMZK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 08:25:10 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: James Morris <jmorris@namei.org>
Subject: [PATCH][securityfs][2.6.34] Drop dentry reference count when mknod fails
Date: Thu, 15 Jul 2010 13:25:06 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
CC: "greg@kroah.com" <greg@kroah.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-security-module@vger.kernel.org>
MIME-Version: 1.0
Message-ID: <201007151325.06942.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 15/07/2010 13:25:07,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 15/07/2010 13:25:07,
	Serialize complete at 15/07/2010 13:25:07
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


lookup_one_len increments dentry reference count which is not decremented
when the create operation fails. This can cause a kernel BUG at
fs/dcache.c:676 at unmount time. Also error code returned when new_inode()
fails was replaced with more appropriate -ENOMEM.


Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
---
 inode.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff -upr linux-2.6.34/security/inode.c linux-2.6.34-new/security/inode.c
--- linux-2.6.34/security/inode.c       2010-05-16 22:17:36.000000000 +0100
+++ linux-2.6.34-new/security/inode.c   2010-07-15 13:20:38.133783253 +0100
@@ -86,7 +86,7 @@ static int mknod(struct inode *dir, stru
                         int mode, dev_t dev)
 {
        struct inode *inode;
-       int error = -EPERM;
+       int error = -ENOMEM;

        if (dentry->d_inode)
                return -EEXIST;
@@ -166,6 +166,8 @@ static int create_by_name(const char *na
                        error = mkdir(parent->d_inode, *dentry, mode);
                else
                        error = create(parent->d_inode, *dentry, mode);
+               if (error)
+                       dput(dentry);
        } else
                error = PTR_ERR(*dentry);
        mutex_unlock(&parent->d_inode->i_mutex);



Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
