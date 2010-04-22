Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab0DVKGB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 06:06:01 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:54924 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab0DVKF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 06:05:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=QY/n2PfonkBM4U1fNh/I8q4jE2eUaYtvEdPwbFAdNr0Zk+jEd012lF13/tS58qm1hC
         lKuQUub10+TRq0CbU3S4CqUIcoAisFZgnJgwyoAPjh3kIvK8Yg9dhpmKgaJplECnUylo
         S4rSZ9KJVjwWripQ0PJBZGVI36Onq0rbEny+w=
Date: Thu, 22 Apr 2010 12:05:35 +0200
From: Dan Carpenter <error27@gmail.com>
To: James Morris <jmorris@namei.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: [patch] security: testing the wrong variable in create_by_name()
Message-ID: <20100422100506.GU29647@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	linux-security-module@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a typo here.  We should be testing "*dentry" instead of
"dentry".  If "*dentry" is an ERR_PTR, it gets dereferenced in either
mkdir() or create() which would cause an OOPs.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/security/inode.c b/security/inode.c
index c3a7938..1c812e8 100644
--- a/security/inode.c
+++ b/security/inode.c
@@ -161,13 +161,13 @@ static int create_by_name(const char *name, mode_t mode,
 
 	mutex_lock(&parent->d_inode->i_mutex);
 	*dentry = lookup_one_len(name, parent, strlen(name));
-	if (!IS_ERR(dentry)) {
+	if (!IS_ERR(*dentry)) {
 		if ((mode & S_IFMT) == S_IFDIR)
 			error = mkdir(parent->d_inode, *dentry, mode);
 		else
 			error = create(parent->d_inode, *dentry, mode);
 	} else
-		error = PTR_ERR(dentry);
+		error = PTR_ERR(*dentry);
 	mutex_unlock(&parent->d_inode->i_mutex);
 
 	return error;
