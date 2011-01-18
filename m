Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1ARXjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 18:39:52 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:36323 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1ARXjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 18:39:51 -0500
Subject: Re: [PATCH] ocfs2: Make OCFS2_FS depend on CONFIGFS_FS
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Joel Becker <jlbec@evilplan.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        James Bottomley <James.Bottomley@suse.de>
In-Reply-To: <20110118230936.GD13251@ZenIV.linux.org.uk>
References: <1295133371-25990-1-git-send-email-nab@linux-iscsi.org>
	 <1295133371-25990-4-git-send-email-nab@linux-iscsi.org>
	 <20110118230936.GD13251@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 18 Jan 2011 15:39:46 -0800
Message-Id: <1295393986.22813.482.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-18 at 23:09 +0000, Joel Becker wrote:
> On Sat, Jan 15, 2011 at 03:16:10PM -0800, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch fixes the following kconfig error after changing
> > CONFIGFS_FS -> select SYSFS:
> > 
> > fs/sysfs/Kconfig:1:error: recursive dependency detected!
> > fs/sysfs/Kconfig:1:	symbol SYSFS is selected by CONFIGFS_FS
> > fs/configfs/Kconfig:1:	symbol CONFIGFS_FS is selected by OCFS2_FS
> > fs/ocfs2/Kconfig:1:	symbol OCFS2_FS depends on SYSFS
> 
> <snip>
> 
> > diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
> > index ab152c0..77a8de5 100644
> > --- a/fs/ocfs2/Kconfig
> > +++ b/fs/ocfs2/Kconfig
> > @@ -1,7 +1,6 @@
> >  config OCFS2_FS
> >  	tristate "OCFS2 file system support"
> > -	depends on NET && SYSFS
> > -	select CONFIGFS_FS
> > +	depends on NET && SYSFS && CONFIGFS_FS
> 
> 	Isn't this exactly what Linus just said not to do?  I don't want
> to know that I need to select configfs.  Shouldn't it instead just be:
> 
> 	select NET
> 	select CONFIGFS_FS
> 

Sorry, your are completely correct here.  The following three patches
have been commited to lio-core-2-6.git/linus-38-rc1 to change
NETCONSOLE_DYNAMIC, DLM, and OCFS2_FS from:
	
	'depends ... && SYSFS && CONFIGFS'

to:

	'select CONFIGFS'

and queued into scsi-post-merge-2.6.git/for-linus to fix this in
mainline.  Linus, please review and pull:

git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-linus

Thanks,

Nicholas Bellinger (3):
  net: Make NETCONSOLE_DYNAMIC use select CONFIGFS_FS
  dlm: Make DLM use select CONFIGFS_FS
  ocfs2: Make OCFS2_FS use select CONFIGFS_FS

 drivers/net/Kconfig |    3 ++-
 fs/dlm/Kconfig      |    4 ++--
 fs/ocfs2/Kconfig    |    3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

--------------------------------------------------------------------

[PATCH 1/3] net: Make NETCONSOLE_DYNAMIC use select CONFIGFS_FS

Convert 'depends && SYSFS && CONFIGFS_FS' to 'select CONFIGFS_FS'

Reported-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit ee09e61057145bb2389c26632cf3dc2a50f19f69)
---
 drivers/net/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index 16fe4f9..d573029 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -3389,7 +3389,8 @@ config NETCONSOLE

 config NETCONSOLE_DYNAMIC
        bool "Dynamic reconfiguration of logging targets"
-       depends on NETCONSOLE && SYSFS && CONFIGFS_FS
+       depends on NETCONSOLE
+       select CONFIGFS_FS
        help
          This option enables the ability to dynamically reconfigure target
          parameters (interface, IP addresses, port numbers, MAC addresses)
-- 
1.7.3.5

-------------------------------------------------------------------

[PATCH 2/3] dlm: Make DLM use select CONFIGFS_FS

Convert 'depends && SYSFS && CONFIGFS_FS' to 'select CONFIGFS_FS'

Reported-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit 5eae59520b635dc8bc181acd7234736543841bb7)
---
 fs/dlm/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/Kconfig b/fs/dlm/Kconfig
index 1897eb1..4f65a50 100644
--- a/fs/dlm/Kconfig
+++ b/fs/dlm/Kconfig
@@ -1,7 +1,7 @@
 menuconfig DLM
        tristate "Distributed Lock Manager (DLM)"
-       depends on EXPERIMENTAL && INET
-       depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
+       depends on EXPERIMENTAL && INET && (IPV6 || IPV6=n)
+       select CONFIGFS_FS
        select IP_SCTP
        help
        A general purpose distributed lock manager for kernel or userspace
-- 
1.7.3.5

--------------------------------------------------------------------

[PATCH 3/3] ocfs2: Make OCFS2_FS use select CONFIGFS_FS

Convert 'depends && SYSFS && CONFIGFS_FS' to 'select CONFIGFS_FS'

Reported-by: Joel Becker <jlbec@evilplan.org>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit c424fe33d264fa6f30b55435975ee52a5a165d75)
---
 fs/ocfs2/Kconfig |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/fs/ocfs2/Kconfig b/fs/ocfs2/Kconfig
index 77a8de5..bb03131 100644
--- a/fs/ocfs2/Kconfig
+++ b/fs/ocfs2/Kconfig
@@ -1,6 +1,7 @@
 config OCFS2_FS
        tristate "OCFS2 file system support"
-       depends on NET && SYSFS && CONFIGFS_FS
+       depends on NET
+       select CONFIGFS_FS
        select JBD2
        select CRC32
        select QUOTA
-- 
1.7.3.5






