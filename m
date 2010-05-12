Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604Ab0ELSPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 14:15:54 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:63100 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab0ELSPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 14:15:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jf6hIIMAToNJON3GqHMddpqshwsfPftFtXPGvuD7TOPH0dkscIMh6oAduDUI0dGDAb
         6DdUUljb2vH0cUbLT302SCW7xcOzRnTb2Laq+pKKkGOQdImlc2c1fsAFtD09BK9jTz2t
         lfonNRhp/uPyEWzEMysjAtXePOpveLxGYHlqM=
Date: Wed, 12 May 2010 22:15:46 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Matt Reimer <mreimer@vpop.net>, Evgeniy Polyakov <zbr@ioremap.net>,
       Tejun Heo <tj@kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: [PATCH] Introduce {sysfs,device}_create_file_mode
Message-ID: <20100512181546.GA4804@oksana.dev.rtsoft.ru>
References: <1273595926-26249-1-git-send-email-daniel@caiaq.de>
 <20100511174708.GA26777@oksana.dev.rtsoft.ru>
 <20100511175812.GH30801@buzzloop.caiaq.de>
 <20100511182347.GA31831@oksana.dev.rtsoft.ru>
 <20100511222825.GJ30801@buzzloop.caiaq.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100511222825.GJ30801@buzzloop.caiaq.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to create attributes with different modes across devices.
We can do this by modifying attr.mode between device_create_file
invocations, but that is racy in case of globally defined attrs.

Luckily, there's sysfs_add_file_mode() function that seems to do
exactly what we want, and if we use it, we don't need any locks
to avoid races. Though, it isn't exposed via device-drivers core
API.

Now that we need it, introduce sysfs_create_file_mode()
and device_create_file_mode() functions. With these, creating
attributes with different modes is a joy.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---

On Wed, May 12, 2010 at 12:28:25AM +0200, Daniel Mack wrote:
> On Tue, May 11, 2010 at 10:23:47PM +0400, Anton Vorontsov wrote:
> > Yes, power_supply_attrs is a global array, and you shouldn't change
> > it between power_supply_register() calls.
> > 
> > If you don't see why it's a bad idea in general, think about it
> > other way, a race:
> > 
> > ...someone registers psy0 with attr X marked as read-only...
> > ...code flow stops before device_create_file(psy0, global->mode)..
> > [preempt]
> > ...someone registers psy1 with attr X marked as writable...
> > ...you set up global->mode to 0644...
> > [preempt again]
> > ...we end up calling device_create_file(psy0, 0644)...
> 
> Ah, I see. But the struct passed in is just used as template, right?

In general, you can't assume that it's just a template,
otherwise 'const ptrdiff_t off = attr - power_supply_attrs;'
wouldn't work.

I.e. 'attr' points to exact attribute you specified during
registration. Weather its fields are used as a template or
not, we don't know (well, we know how the sysfs core uses them
*today*, but we don't know how sysfs will use them tomorrow).

> So
> for the particular case you outlined, a simple lock should do the trick,
> right?

Yes, for the particular case.

Still, I don't think that playing with attr->mode is a good
idea.

If we don't want to use attr->mode for mode specifier (and I
think we don't), we must implement a clean API for such a case.

Luckily, there's sysfs_add_file_mode, so if anyone will want
to change attr->mode behaviour, one will have to deal with
that function, and so we'll be safe.

And we must use that function, not just silently play
attr->mode games during registration. That also avoids
any need for locking.


Greg, does the patch look OK? If so, I'd like it to go
via battery-2.6.git tree, along with patches that need
that one.

You can see the original thread here:
http://lkml.org/lkml/2010/5/11/71

See power_supply_create_attrs(), there we'll use
device_create_file_mode() instead of messing with
power_supply_attrs[psy->properties[j]].attr.mode.

 drivers/base/core.c    |   21 +++++++++++++++++++++
 fs/sysfs/file.c        |   16 ++++++++++++++++
 include/linux/device.h |    3 +++
 include/linux/sysfs.h  |   10 ++++++++++
 4 files changed, 50 insertions(+), 0 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index b56a0ba..1bc6134 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -440,6 +440,27 @@ struct kset *devices_kset;
  * device_create_file - create sysfs attribute file for device.
  * @dev: device.
  * @attr: device attribute descriptor.
+ * @mode: file mode.
+ *
+ * This function is similar to device_create_file(), except that it
+ * doesn't use attr->mode for mode specifier.
+ */
+int device_create_file_mode(struct device *dev,
+			    const struct device_attribute *attr,
+			    mode_t mode)
+{
+	int error = 0;
+
+	if (dev)
+		error = sysfs_create_file_mode(&dev->kobj, &attr->attr, mode);
+	return error;
+}
+EXPORT_SYMBOL_GPL(device_create_file_mode);
+
+/**
+ * device_create_file - create sysfs attribute file for device.
+ * @dev: device.
+ * @attr: device attribute descriptor.
  */
 int device_create_file(struct device *dev,
 		       const struct device_attribute *attr)
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index e222b25..7bebb60 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -528,6 +528,22 @@ int sysfs_add_file(struct sysfs_dirent *dir_sd, const struct attribute *attr,
 	return sysfs_add_file_mode(dir_sd, attr, type, attr->mode);
 }
 
+/**
+ *	sysfs_create_file_mode - create an attribute file for an object.
+ *	@kobj:	object we're creating for.
+ *	@attr:	attribute descriptor.
+ *	@mode:	file mode.
+ *
+ *	This function is similar to sysfs_create_file(), except that it
+ *	doesn't use attr->mode for mode specifier.
+ */
+int sysfs_create_file_mode(struct kobject *kobj, const struct attribute *attr,
+			   mode_t mode)
+{
+	BUG_ON(!kobj || !kobj->sd || !attr);
+
+	return sysfs_add_file_mode(kobj->sd, attr, SYSFS_KOBJ_ATTR, mode);
+}
 
 /**
  *	sysfs_create_file - create an attribute file for an object.
diff --git a/include/linux/device.h b/include/linux/device.h
index 1821928..8277364 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -337,6 +337,9 @@ struct device_attribute {
 #define DEVICE_ATTR(_name, _mode, _show, _store) \
 struct device_attribute dev_attr_##_name = __ATTR(_name, _mode, _show, _store)
 
+extern int __must_check device_create_file_mode(struct device *device,
+					const struct device_attribute *entry,
+					mode_t mode);
 extern int __must_check device_create_file(struct device *device,
 					const struct device_attribute *entry);
 extern void device_remove_file(struct device *dev,
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index f0496b3..222774f 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -130,6 +130,9 @@ int __must_check sysfs_rename_dir(struct kobject *kobj, const char *new_name);
 int __must_check sysfs_move_dir(struct kobject *kobj,
 				struct kobject *new_parent_kobj);
 
+int __must_check sysfs_create_file_mode(struct kobject *kobj,
+					const struct attribute *attr,
+					mode_t mode);
 int __must_check sysfs_create_file(struct kobject *kobj,
 				   const struct attribute *attr);
 int __must_check sysfs_create_files(struct kobject *kobj,
@@ -202,6 +205,13 @@ static inline int sysfs_move_dir(struct kobject *kobj,
 	return 0;
 }
 
+static inline int sysfs_create_file_mode(struct kobject *kobj,
+					 const struct attribute *attr,
+					 mode_t mode)
+{
+	return 0;
+}
+
 static inline int sysfs_create_file(struct kobject *kobj,
 				    const struct attribute *attr)
 {
-- 
1.7.0.5

