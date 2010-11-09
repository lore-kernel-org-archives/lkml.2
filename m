Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab0KIJeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:34:15 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49189 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752337Ab0KIJeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:34:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Mb8wNHqX5tmbjF+0+URzq+vwbJU/q/+c1Vq+behtFLaCAA+UVWdIdM0aqBoLGgbCOO
         Przbj5aclPhUZnUkAerRoMGKSw80Cyr0bgYqTb++xkVhesU4SRBVdKqeefZeZS3k1efJ
         liKMlnguOwL/8Qa5mshaXNMKZZ6Jk2gvBhygY=
Date: Tue, 9 Nov 2010 17:38:43 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Mike Waychison <mikew@google.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>, adurbin@google.com,
        linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>, akpm@linux-foundation.org,
        linux-api@vger.kernel.org
Subject: [RFC PATCH] configfs: make it not be a module any more
Message-ID: <20101109093843.GH5220@cr0.nay.redhat.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
 <20101108203246.22479.60118.stgit@crlf.mtv.corp.google.com>
 <20101109033024.GA5220@cr0.nay.redhat.com>
 <20101109042732.GC5220@cr0.nay.redhat.com>
 <AANLkTingq8R8bc-4fwhBQomdhTgff+fN_vE-pc5zofKX@mail.gmail.com>
 <20101109090645.GG5220@cr0.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101109090645.GG5220@cr0.nay.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:06:45PM +0800, Américo Wang wrote:
>On Tue, Nov 09, 2010 at 12:34:24AM -0800, Mike Waychison wrote:
>>On Mon, Nov 8, 2010 at 8:27 PM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>>> On Tue, Nov 09, 2010 at 11:30:24AM +0800, Américo Wang wrote:
>>>>
>>> ....
>>>>
>>>>So, either we need to de-modulize configfs or replace configfs API
>>>>with sysfs API. Personally, I prefer the former one, I don't think
>>>>configfs should be a module as long as it can provide API's
>>>>for other subsystems, like debugfs.
>>>>
>>>
>>> To clarify, I meant "as long as the API it provides can be used by
>>> other core subsystems".
>>>
>>
>>Ya, I see the problem with it being a tristate.
>>
>>Why not just make netconsole support being compiled in force configfs
>>to be compiled in?  Or does that just set bad precedent?
>
>That is what netconsole does now, and this is fine, since netconsole is
>a module too, however, after you move that code into netpoll, then netpoll
>will have a dependence on it, we will have problems.
>
>I think we can let NETPOLL_TARGET depend on CONFIGFS_FS=y, but I still
>see no reason why CONFIGFS_FS should be a module.
>

Okay, here we go.

------------------>

Netpoll will use configfs API's to provide generic
netpoll target support. These API's provided by
configfs could also be used by other core subsystems.
So, make configfs not a module any more, like debugfs.

Signed-off-by: WANG Cong <xiyou.wangcong@gmail.com>

---
diff --git a/fs/configfs/Kconfig b/fs/configfs/Kconfig
index 13587cc..4bdfe1e 100644
--- a/fs/configfs/Kconfig
+++ b/fs/configfs/Kconfig
@@ -1,5 +1,5 @@
 config CONFIGFS_FS
-	tristate "Userspace-driven configuration filesystem"
+	bool "Userspace-driven configuration filesystem"
 	depends on SYSFS
 	help
 	  configfs is a ram-based filesystem that provides the converse
diff --git a/fs/configfs/configfs_internal.h b/fs/configfs/configfs_internal.h
index da6061a..714a192 100644
--- a/fs/configfs/configfs_internal.h
+++ b/fs/configfs/configfs_internal.h
@@ -66,7 +66,6 @@ extern int configfs_is_root(struct config_item *item);
 extern struct inode * configfs_new_inode(mode_t mode, struct configfs_dirent *);
 extern int configfs_create(struct dentry *, int mode, int (*init)(struct inode *));
 extern int configfs_inode_init(void);
-extern void configfs_inode_exit(void);
 
 extern int configfs_create_file(struct config_item *, const struct configfs_attribute *);
 extern int configfs_make_dirent(struct configfs_dirent *,
diff --git a/fs/configfs/inode.c b/fs/configfs/inode.c
index 253476d..3508bc1 100644
--- a/fs/configfs/inode.c
+++ b/fs/configfs/inode.c
@@ -295,7 +295,3 @@ int __init configfs_inode_init(void)
 	return bdi_init(&configfs_backing_dev_info);
 }
 
-void __exit configfs_inode_exit(void)
-{
-	bdi_destroy(&configfs_backing_dev_info);
-}
diff --git a/fs/configfs/mount.c b/fs/configfs/mount.c
index 7d3607f..1cf57b3 100644
--- a/fs/configfs/mount.c
+++ b/fs/configfs/mount.c
@@ -111,7 +111,6 @@ static struct dentry *configfs_do_mount(struct file_system_type *fs_type,
 }
 
 static struct file_system_type configfs_fs_type = {
-	.owner		= THIS_MODULE,
 	.name		= "configfs",
 	.mount		= configfs_do_mount,
 	.kill_sb	= kill_litter_super,
@@ -167,20 +166,5 @@ static int __init configfs_init(void)
 out:
 	return err;
 }
+core_initcall(configfs_init);
 
-static void __exit configfs_exit(void)
-{
-	unregister_filesystem(&configfs_fs_type);
-	kobject_put(config_kobj);
-	kmem_cache_destroy(configfs_dir_cachep);
-	configfs_dir_cachep = NULL;
-	configfs_inode_exit();
-}
-
-MODULE_AUTHOR("Oracle");
-MODULE_LICENSE("GPL");
-MODULE_VERSION("0.0.2");
-MODULE_DESCRIPTION("Simple RAM filesystem for user driven kernel subsystem configuration.");
-
-module_init(configfs_init);
-module_exit(configfs_exit);

