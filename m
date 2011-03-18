Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756329Ab1CRHM6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 03:12:58 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54451 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab1CRHMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 03:12:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=IiCnbsY4+U22vjpCDmCoWYOoyD+ql/Vj9PZTN9PdjSEsCjkLgLlL/l+MTlDGRnZeqG
         IwOG3790Q6T5od7YqDI27PYdU3DPEhmJUcqX+HEq7uO2D5Xg22PziWT6pYZI+z7ScuBV
         pduk4QIzh2hPBTumTwfO+d98AROqx6r4v9mFw=
Date: Fri, 18 Mar 2011 10:12:38 +0300
From: Dan Carpenter <error27@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mike Waychison <mikew@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch 2/2] efivars: handle errors from register_efivars()
Message-ID: <20110318071238.GW2008@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Mike Waychison <mikew@google.com>,
	Chris Wright <chrisw@sous-sol.org>, Tejun Heo <tj@kernel.org>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We should unwind and return an error if register_efivars() fails.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index ff2fe40..5d1ec68 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -803,6 +803,8 @@ efivars_init(void)
 	ops.set_variable = efi.set_variable;
 	ops.get_next_variable = efi.get_next_variable;
 	error = register_efivars(&__efivars, &ops, efi_kobj);
+	if (error)
+		goto err_put;
 
 	/* Don't forget the systab entry */
 	error = sysfs_create_group(efi_kobj, &efi_subsys_attr_group);
@@ -810,10 +812,15 @@ efivars_init(void)
 		printk(KERN_ERR
 		       "efivars: Sysfs attribute export failed with error %d.\n",
 		       error);
-		unregister_efivars(&__efivars);
-		kobject_put(efi_kobj);
+		goto err_unregister;
 	}
 
+	return 0;
+
+err_unregister:
+	unregister_efivars(&__efivars);
+err_put:
+	kobject_put(efi_kobj);
 	return error;
 }
 
