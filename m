Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2HMUc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 16:32:26 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:56731 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2HMUYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 16:24:20 -0400
From: "Eric W. Biederman" <ebiederm@xmission.com>
To: <netdev@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        David Miller <davem@davemloft.net>, Serge Hallyn <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Maxim Krasnyansky <maxk@qualcomm.com>
Date: Mon, 13 Aug 2012 13:18:35 -0700
Message-Id: <1344889115-21610-21-git-send-email-ebiederm@xmission.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
References: <87ehnav9n5.fsf@xmission.com>
 <1344889115-21610-1-git-send-email-ebiederm@xmission.com>
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19XEGjw5z/mlS5mrbmrFIGPspyPQhP32AY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  2.2 XMSubMetaSxObfu_03 Obfuscated Sexy Noun-People
	*  1.6 XMSubMetaSx_00 1+ Sexy Words
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;<netdev@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: [PATCH 21/21] userns: Convert tun/tap to use kuid and kgid where appropriate
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Eric W. Biederman" <ebiederm@xmission.com>

Cc: Maxim Krasnyansky <maxk@qualcomm.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/net/tun.c |   46 ++++++++++++++++++++++++++++++++--------------
 init/Kconfig      |    1 -
 2 files changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 926d4db..a9bd9f3 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -120,8 +120,8 @@ struct tun_sock;
 struct tun_struct {
 	struct tun_file		*tfile;
 	unsigned int 		flags;
-	uid_t			owner;
-	gid_t			group;
+	kuid_t			owner;
+	kgid_t			group;
 
 	struct net_device	*dev;
 	netdev_features_t	set_features;
@@ -1032,8 +1032,8 @@ static void tun_setup(struct net_device *dev)
 {
 	struct tun_struct *tun = netdev_priv(dev);
 
-	tun->owner = -1;
-	tun->group = -1;
+	tun->owner = INVALID_UID;
+	tun->group = INVALID_GID;
 
 	dev->ethtool_ops = &tun_ethtool_ops;
 	dev->destructor = tun_free_netdev;
@@ -1156,14 +1156,20 @@ static ssize_t tun_show_owner(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
-	return sprintf(buf, "%d\n", tun->owner);
+	return uid_valid(tun->owner)?
+		sprintf(buf, "%u\n",
+			from_kuid_munged(current_user_ns(), tun->owner)):
+		sprintf(buf, "-1\n");
 }
 
 static ssize_t tun_show_group(struct device *dev, struct device_attribute *attr,
 			      char *buf)
 {
 	struct tun_struct *tun = netdev_priv(to_net_dev(dev));
-	return sprintf(buf, "%d\n", tun->group);
+	return gid_valid(tun->group) ?
+		sprintf(buf, "%u\n",
+			from_kgid_munged(current_user_ns(), tun->group)):
+		sprintf(buf, "-1\n");
 }
 
 static DEVICE_ATTR(tun_flags, 0444, tun_show_flags, NULL);
@@ -1190,8 +1196,8 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		else
 			return -EINVAL;
 
-		if (((tun->owner != -1 && cred->euid != tun->owner) ||
-		     (tun->group != -1 && !in_egroup_p(tun->group))) &&
+		if (((uid_valid(tun->owner) && !uid_eq(cred->euid, tun->owner)) ||
+		     (gid_valid(tun->group) && !in_egroup_p(tun->group))) &&
 		    !capable(CAP_NET_ADMIN))
 			return -EPERM;
 		err = security_tun_dev_attach(tun->socket.sk);
@@ -1375,6 +1381,8 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 	void __user* argp = (void __user*)arg;
 	struct sock_fprog fprog;
 	struct ifreq ifr;
+	kuid_t owner;
+	kgid_t group;
 	int sndbuf;
 	int vnet_hdr_sz;
 	int ret;
@@ -1448,16 +1456,26 @@ static long __tun_chr_ioctl(struct file *file, unsigned int cmd,
 
 	case TUNSETOWNER:
 		/* Set owner of the device */
-		tun->owner = (uid_t) arg;
-
-		tun_debug(KERN_INFO, tun, "owner set to %d\n", tun->owner);
+		owner = make_kuid(current_user_ns(), arg);
+		if (!uid_valid(owner)) {
+			ret = -EINVAL;
+			break;
+		}
+		tun->owner = owner;
+		tun_debug(KERN_INFO, tun, "owner set to %d\n",
+			  from_kuid(&init_user_ns, tun->owner));
 		break;
 
 	case TUNSETGROUP:
 		/* Set group of the device */
-		tun->group= (gid_t) arg;
-
-		tun_debug(KERN_INFO, tun, "group set to %d\n", tun->group);
+		group = make_kgid(current_user_ns(), arg);
+		if (!gid_valid(group)) {
+			ret = -EINVAL;
+			break;
+		}
+		tun->group = group;
+		tun_debug(KERN_INFO, tun, "group set to %d\n",
+			  from_kgid(&init_user_ns, tun->group));
 		break;
 
 	case TUNSETLINK:
diff --git a/init/Kconfig b/init/Kconfig
index eac23a6..b445d6f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1003,7 +1003,6 @@ config UIDGID_CONVERTED
 	depends on !UML || HOSTFS = n
 
 	# The rare drivers that won't build
-	depends on TUN = n
 	depends on INFINIBAND_QIB = n
 	depends on BLK_DEV_LOOP = n
 	depends on ANDROID_BINDER_IPC = n
-- 
1.7.5.4

