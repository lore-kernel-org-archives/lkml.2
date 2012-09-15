Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab2IOCt2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 22:49:28 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:60863 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab2IOCt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 22:49:26 -0400
Subject: Re: [RFC,PATCH v2] efi: Add support for a UEFI variable filesystem
From: joeyli <jlee@suse.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, jeremy.kerr@canonical.com,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        Matt Domsch <Matt_Domsch@Dell.com>, glin@suse.com
In-Reply-To: <5052B576.8010500@zytor.com>
References: <1346910035.47691.188651047712.1.gpush@pecola>
	 <CAGLnvc9BXAW8F8WWyDxuF1_J+0np3uqUBmknuJewOJHhe-mxvw@mail.gmail.com>
	 <1347523843.596.30.camel@linux-s257.site>
	 <1347544333.6707.1.camel@eddie.install.bos.redhat.com>
	 <1347594342.705.33.camel@linux-s257.site>  <5052B576.8010500@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 15 Sep 2012 10:44:11 +0800
Message-ID: <1347677051.705.59.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2012-09-13 於 21:41 -0700，H. Peter Anvin 提到：
> On 09/13/2012 08:45 PM, joeyli wrote:
> > Hi Peter,
> >
> > 於 四，2012-09-13 於 09:52 -0400，Peter Jones 提到：
> >> On Thu, 2012-09-13 at 16:10 +0800, joeyli wrote:
> >>
> >>> Do we have plan to create a new kobject add to /sys/firmware/efi for
> >>> provide a fixed mount point to efivars fs?
> >>> e.g. /sys/firmware/efi/efivars
> >>>
> >>> Or we just direct reuse current /sys/firmeware/efi/vars? But, that means
> >>> we need think for the backward compatibility if choice reuse vars
> >>> folder.
> >>
> >> I'm not sure that's a terribly large concern - if you haven't updated
> >> your tools to use the new efivars, don't mount the new efivars.
> >>
> >
> > Thanks for your comment!
> >
> 
> I think it is wrong.  The new API should have a different path.
> 
> 	-hpa
> 

OK, so, if still keep the old API and have new mount point for UEFI
variable filesystem. Then how about add this simple patch for create new
mount point to /sys/firmware/efi/efivars.


Thanks a lot!
Joey Lee


>From 5e64382a9a4ad538dd5ca94072d19c7a70e4c650 Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@suse.com>
Date: Sat, 15 Sep 2012 10:33:46 +0800
Subject: [PATCH] efi: add efivars kobject to efi sysfs folder

UEFI variable filesystem need a new mount point, so this patch add
efivars kobject to efi_kobj for create a /sys/firmware/efi/efivars
folder.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 drivers/firmware/efivars.c |   11 +++++++++++
 include/linux/efi.h        |    1 +
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/firmware/efivars.c b/drivers/firmware/efivars.c
index 1e1aad0..7c1234e 100644
--- a/drivers/firmware/efivars.c
+++ b/drivers/firmware/efivars.c
@@ -1487,6 +1487,7 @@ void unregister_efivars(struct efivars *efivars)
 		sysfs_remove_bin_file(&efivars->kset->kobj, efivars->del_var);
 	kfree(efivars->new_var);
 	kfree(efivars->del_var);
+	kobject_put(efivars->kobject);
 	kset_unregister(efivars->kset);
 }
 EXPORT_SYMBOL_GPL(unregister_efivars);
@@ -1518,6 +1519,13 @@ int register_efivars(struct efivars *efivars,
 		goto out;
 	}
 
+	efivars->kobject = kobject_create_and_add("efivars", parent_kobj);
+	if (!efivars->kobject) {
+		pr_err("efivars: Subsystem registration failed.\n");
+		error = -ENOMEM;
+		goto err_unreg_vars;
+	}
+
 	/*
 	 * Per EFI spec, the maximum storage allocated for both
 	 * the variable name and variable data is 1024 bytes.
@@ -1562,6 +1570,9 @@ int register_efivars(struct efivars *efivars,
 
 	register_filesystem(&efivars_fs_type);
 
+err_unreg_vars:
+	kset_unregister(efivars->kset);
+
 out:
 	kfree(variable_name);
 
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 1829a97..c993f54 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -654,6 +654,7 @@ struct efivars {
 	spinlock_t lock;
 	struct list_head list;
 	struct kset *kset;
+	struct kobject *kobject;
 	struct bin_attribute *new_var, *del_var;
 	const struct efivar_operations *ops;
 	struct efivar_entry *walk_entry;
-- 
1.7.7



