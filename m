Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab1BEOW4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:22:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753564Ab1BEOWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:22:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kF/vuagotjiLg+muIzZbc60b2nY6nfA+YyjJg0aix+31IcMjaICjyQTJM89YWZtHTe
         38DuzzxWHyDceOLofAuRQRHlxHTwoSIzPJ18KZFm3t+bn/cK7+K2cuISZHuQ97hMI+GR
         EzKK0MZtNtaS1K5utV3fD+OxqPMMu85IfHfAM=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 44/52] kstrtox: convert net/
Date: Sat,  5 Feb 2011 16:20:47 +0200
Message-Id: <1296915654-7458-44-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 net/batman-adv/bat_sysfs.c      |   69 ++++++++++++++++++++-------------------
 net/batman-adv/gateway_common.c |    4 +-
 net/bluetooth/hci_sysfs.c       |   16 ++++----
 net/dns_resolver/dns_key.c      |    5 ++-
 net/mac80211/debugfs.c          |   10 ++---
 net/rfkill/core.c               |   11 +++---
 net/sunrpc/addr.c               |   18 ++++------
 net/sunrpc/auth.c               |    6 ++--
 net/sunrpc/xprtsock.c           |    8 +++--
 9 files changed, 72 insertions(+), 75 deletions(-)

diff --git a/net/batman-adv/bat_sysfs.c b/net/batman-adv/bat_sysfs.c
index cd7bb51..12c8f8d 100644
--- a/net/batman-adv/bat_sysfs.c
+++ b/net/batman-adv/bat_sysfs.c
@@ -150,36 +150,36 @@ static int store_uint_attr(char *buff, size_t count,
 			   struct net_device *net_dev, char *attr_name,
 			   unsigned int min, unsigned int max, atomic_t *attr)
 {
-	unsigned long uint_val;
+	unsigned int val;
 	int ret;
 
-	ret = strict_strtoul(buff, 10, &uint_val);
-	if (ret) {
+	ret = kstrtouint(buff, 10, &val);
+	if (ret < 0) {
 		bat_info(net_dev,
 			 "%s: Invalid parameter received: %s\n",
 			 attr_name, buff);
-		return -EINVAL;
+		return ret;
 	}
 
-	if (uint_val < min) {
-		bat_info(net_dev, "%s: Value is too small: %lu min: %u\n",
-			 attr_name, uint_val, min);
+	if (val < min) {
+		bat_info(net_dev, "%s: Value is too small: %u min: %u\n",
+			 attr_name, val, min);
 		return -EINVAL;
 	}
 
-	if (uint_val > max) {
-		bat_info(net_dev, "%s: Value is too big: %lu max: %u\n",
-			 attr_name, uint_val, max);
+	if (val > max) {
+		bat_info(net_dev, "%s: Value is too big: %u max: %u\n",
+			 attr_name, val, max);
 		return -EINVAL;
 	}
 
-	if (atomic_read(attr) == uint_val)
+	if (atomic_read(attr) == val)
 		return count;
 
-	bat_info(net_dev, "%s: Changing from: %i to: %lu\n",
-		 attr_name, atomic_read(attr), uint_val);
+	bat_info(net_dev, "%s: Changing from: %i to: %u\n",
+		 attr_name, atomic_read(attr), val);
 
-	atomic_set(attr, uint_val);
+	atomic_set(attr, val);
 	return count;
 }
 
@@ -211,32 +211,33 @@ static ssize_t show_vis_mode(struct kobject *kobj, struct attribute *attr,
 }
 
 static ssize_t store_vis_mode(struct kobject *kobj, struct attribute *attr,
-			      char *buff, size_t count)
+			      char *buf, size_t count)
 {
 	struct net_device *net_dev = kobj_to_netdev(kobj);
 	struct bat_priv *bat_priv = netdev_priv(net_dev);
-	unsigned long val;
-	int ret, vis_mode_tmp = -1;
+	unsigned int vis_mode_tmp;
 
-	ret = strict_strtoul(buff, 10, &val);
+	if (count > 0 && buf[count - 1] == '\n')
+		buf[count - 1] = '\0';
 
-	if (((count == 2) && (!ret) && (val == VIS_TYPE_CLIENT_UPDATE)) ||
-	    (strncmp(buff, "client", 6) == 0) ||
-	    (strncmp(buff, "off", 3) == 0))
+	if (strcmp(buf, "client") == 0 || strcmp(buf, "off") == 0)
 		vis_mode_tmp = VIS_TYPE_CLIENT_UPDATE;
-
-	if (((count == 2) && (!ret) && (val == VIS_TYPE_SERVER_SYNC)) ||
-	    (strncmp(buff, "server", 6) == 0))
+	else if (strcmp(buf, "server") == 0)
 		vis_mode_tmp = VIS_TYPE_SERVER_SYNC;
-
-	if (vis_mode_tmp < 0) {
-		if (buff[count - 1] == '\n')
-			buff[count - 1] = '\0';
-
-		bat_info(net_dev,
-			 "Invalid parameter for 'vis mode' setting received: "
-			 "%s\n", buff);
-		return -EINVAL;
+	else {
+		unsigned int val;
+		int rv;
+
+		rv = kstrtoint(buf, 10, &val);
+		if (rv < 0)
+			return rv;
+		switch (val) {
+		case VIS_TYPE_CLIENT_UPDATE:
+		case VIS_TYPE_SERVER_SYNC:
+			vis_mode_tmp = val;
+		default:
+			return -EINVAL;
+		}
 	}
 
 	if (atomic_read(&bat_priv->vis_mode) == vis_mode_tmp)
@@ -247,7 +248,7 @@ static ssize_t store_vis_mode(struct kobject *kobj, struct attribute *attr,
 		 "client" : "server", vis_mode_tmp == VIS_TYPE_CLIENT_UPDATE ?
 		 "client" : "server");
 
-	atomic_set(&bat_priv->vis_mode, (unsigned)vis_mode_tmp);
+	atomic_set(&bat_priv->vis_mode, vis_mode_tmp);
 	return count;
 }
 
diff --git a/net/batman-adv/gateway_common.c b/net/batman-adv/gateway_common.c
index b962982..b201e41 100644
--- a/net/batman-adv/gateway_common.c
+++ b/net/batman-adv/gateway_common.c
@@ -96,7 +96,7 @@ static bool parse_gw_bandwidth(struct net_device *net_dev, char *buff,
 			*tmp_ptr = '\0';
 	}
 
-	ret = strict_strtoul(buff, 10, down);
+	ret = kstrtoul(buff, 10, down);
 	if (ret) {
 		bat_err(net_dev,
 			"Download speed of gateway mode invalid: %s\n",
@@ -121,7 +121,7 @@ static bool parse_gw_bandwidth(struct net_device *net_dev, char *buff,
 				*tmp_ptr = '\0';
 		}
 
-		ret = strict_strtoul(slash_ptr + 1, 10, up);
+		ret = kstrtoul(slash_ptr + 1, 10, up);
 		if (ret) {
 			bat_err(net_dev,
 				"Upload speed of gateway mode invalid: "
diff --git a/net/bluetooth/hci_sysfs.c b/net/bluetooth/hci_sysfs.c
index 5fce3d6..131ce95 100644
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
@@ -277,9 +277,9 @@ static ssize_t show_idle_timeout(struct device *dev, struct device_attribute *at
 static ssize_t store_idle_timeout(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct hci_dev *hdev = dev_get_drvdata(dev);
-	unsigned long val;
+	u32 val;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
+	if (kstrtou32(buf, 0, &val) < 0)
 		return -EINVAL;
 
 	if (val != 0 && (val < 500 || val > 3600000))
@@ -299,12 +299,12 @@ static ssize_t show_sniff_max_interval(struct device *dev, struct device_attribu
 static ssize_t store_sniff_max_interval(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct hci_dev *hdev = dev_get_drvdata(dev);
-	unsigned long val;
+	u16 val;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
+	if (kstrtou16(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	if (val < 0x0002 || val > 0xFFFE || val % 2)
+	if (val == 0 || val % 2)
 		return -EINVAL;
 
 	if (val < hdev->sniff_min_interval)
@@ -324,12 +324,12 @@ static ssize_t show_sniff_min_interval(struct device *dev, struct device_attribu
 static ssize_t store_sniff_min_interval(struct device *dev, struct device_attribute *attr, const char *buf, size_t count)
 {
 	struct hci_dev *hdev = dev_get_drvdata(dev);
-	unsigned long val;
+	u16 val;
 
-	if (strict_strtoul(buf, 0, &val) < 0)
+	if (kstrtou16(buf, 0, &val) < 0)
 		return -EINVAL;
 
-	if (val < 0x0002 || val > 0xFFFE || val % 2)
+	if (val == 0 || val % 2)
 		return -EINVAL;
 
 	if (val > hdev->sniff_max_interval)
diff --git a/net/dns_resolver/dns_key.c b/net/dns_resolver/dns_key.c
index 739435a..8cd5294 100644
--- a/net/dns_resolver/dns_key.c
+++ b/net/dns_resolver/dns_key.c
@@ -62,7 +62,6 @@ static int
 dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
 {
 	struct user_key_payload *upayload;
-	unsigned long derrno;
 	int ret;
 	size_t result_len = 0;
 	const char *data = _data, *end, *opt;
@@ -113,11 +112,13 @@ dns_resolver_instantiate(struct key *key, const void *_data, size_t datalen)
 			 * that's to be recorded as the result in this key */
 			if (opt_nlen == sizeof(DNS_ERRORNO_OPTION) - 1 &&
 			    memcmp(opt, DNS_ERRORNO_OPTION, opt_nlen) == 0) {
+				unsigned long derrno;
+
 				kdebug("dns error number option");
 				if (opt_vlen <= 0)
 					goto bad_option_value;
 
-				ret = strict_strtoul(eq, 10, &derrno);
+				ret = kstrtoul(eq, 10, &derrno);
 				if (ret < 0)
 					goto bad_option_value;
 
diff --git a/net/mac80211/debugfs.c b/net/mac80211/debugfs.c
index 1f02e59..81f8790 100644
--- a/net/mac80211/debugfs.c
+++ b/net/mac80211/debugfs.c
@@ -186,7 +186,7 @@ static ssize_t uapsd_queues_write(struct file *file,
 				  size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	unsigned long val;
+	unsigned int val;
 	char buf[10];
 	size_t len;
 	int ret;
@@ -196,8 +196,7 @@ static ssize_t uapsd_queues_write(struct file *file,
 		return -EFAULT;
 	buf[len] = '\0';
 
-	ret = strict_strtoul(buf, 0, &val);
-
+	ret = kstrtouint(buf, 0, &val);
 	if (ret)
 		return -EINVAL;
 
@@ -230,7 +229,7 @@ static ssize_t uapsd_max_sp_len_write(struct file *file,
 				      size_t count, loff_t *ppos)
 {
 	struct ieee80211_local *local = file->private_data;
-	unsigned long val;
+	unsigned int val;
 	char buf[10];
 	size_t len;
 	int ret;
@@ -240,8 +239,7 @@ static ssize_t uapsd_max_sp_len_write(struct file *file,
 		return -EFAULT;
 	buf[len] = '\0';
 
-	ret = strict_strtoul(buf, 0, &val);
-
+	ret = kstrtouint(buf, 0, &val);
 	if (ret)
 		return -EINVAL;
 
diff --git a/net/rfkill/core.c b/net/rfkill/core.c
index 0198191..0a69c82 100644
--- a/net/rfkill/core.c
+++ b/net/rfkill/core.c
@@ -638,17 +638,16 @@ static ssize_t rfkill_soft_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
-	unsigned long state;
+	unsigned int state;
 	int err;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = strict_strtoul(buf, 0, &state);
+	err = kstrtouint(buf, 0, &state);
 	if (err)
 		return err;
-
-	if (state > 1 )
+	if (state > 1)
 		return -EINVAL;
 
 	mutex_lock(&rfkill_global_mutex);
@@ -682,13 +681,13 @@ static ssize_t rfkill_state_store(struct device *dev,
 				  const char *buf, size_t count)
 {
 	struct rfkill *rfkill = to_rfkill(dev);
-	unsigned long state;
+	int state;
 	int err;
 
 	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
-	err = strict_strtoul(buf, 0, &state);
+	err = kstrtoint(buf, 0, &state);
 	if (err)
 		return err;
 
diff --git a/net/sunrpc/addr.c b/net/sunrpc/addr.c
index 1419d0c..36c554c 100644
--- a/net/sunrpc/addr.c
+++ b/net/sunrpc/addr.c
@@ -173,15 +173,15 @@ static int rpc_parse_scope_id(const char *buf, const size_t buflen,
 	len = (buf + buflen) - delim - 1;
 	p = kstrndup(delim + 1, len, GFP_KERNEL);
 	if (p) {
-		unsigned long scope_id = 0;
 		struct net_device *dev;
+		u32 scope_id;
 
 		dev = dev_get_by_name(&init_net, p);
 		if (dev != NULL) {
 			scope_id = dev->ifindex;
 			dev_put(dev);
 		} else {
-			if (strict_strtoul(p, 10, &scope_id) == 0) {
+			if (kstrtou32(p, 10, &scope_id) < 0) {
 				kfree(p);
 				return 0;
 			}
@@ -299,7 +299,7 @@ EXPORT_SYMBOL_GPL(rpc_sockaddr2uaddr);
  * @sap: buffer into which to plant socket address
  * @salen: size of buffer
  *
- * @uaddr does not have to be '\0'-terminated, but strict_strtoul() and
+ * @uaddr does not have to be '\0'-terminated, but kstrto*() and
  * rpc_pton() require proper string termination to be successful.
  *
  * Returns the size of the socket address if successful; otherwise
@@ -309,7 +309,7 @@ size_t rpc_uaddr2sockaddr(const char *uaddr, const size_t uaddr_len,
 			  struct sockaddr *sap, const size_t salen)
 {
 	char *c, buf[RPCBIND_MAXUADDRLEN + sizeof('\0')];
-	unsigned long portlo, porthi;
+	u8 portlo, porthi;
 	unsigned short port;
 
 	if (uaddr_len > RPCBIND_MAXUADDRLEN)
@@ -321,21 +321,17 @@ size_t rpc_uaddr2sockaddr(const char *uaddr, const size_t uaddr_len,
 	c = strrchr(buf, '.');
 	if (unlikely(c == NULL))
 		return 0;
-	if (unlikely(strict_strtoul(c + 1, 10, &portlo) != 0))
-		return 0;
-	if (unlikely(portlo > 255))
+	if (unlikely(kstrtou8(c + 1, 10, &portlo) != 0))
 		return 0;
 
 	*c = '\0';
 	c = strrchr(buf, '.');
 	if (unlikely(c == NULL))
 		return 0;
-	if (unlikely(strict_strtoul(c + 1, 10, &porthi) != 0))
-		return 0;
-	if (unlikely(porthi > 255))
+	if (unlikely(kstrtou8(c + 1, 10, &porthi) != 0))
 		return 0;
 
-	port = (unsigned short)((porthi << 8) | portlo);
+	port = (porthi << 8) | portlo;
 
 	*c = '\0';
 	if (rpc_pton(buf, strlen(buf), sap, salen) == 0)
diff --git a/net/sunrpc/auth.c b/net/sunrpc/auth.c
index 67e3127..800152f 100644
--- a/net/sunrpc/auth.c
+++ b/net/sunrpc/auth.c
@@ -47,9 +47,9 @@ static int param_set_hashtbl_sz(const char *val, const struct kernel_param *kp)
 
 	if (!val)
 		goto out_inval;
-	ret = strict_strtoul(val, 0, &num);
-	if (ret == -EINVAL)
-		goto out_inval;
+	ret = kstrtoul(val, 0, &num);
+	if (ret < 0)
+		return ret;
 	nbits = fls(num);
 	if (num > (1U << nbits))
 		nbits++;
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index c431f5a..01d15ec2 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -2499,13 +2499,15 @@ static int param_set_uint_minmax(const char *val,
 		const struct kernel_param *kp,
 		unsigned int min, unsigned int max)
 {
-	unsigned long num;
+	unsigned int num;
 	int ret;
 
 	if (!val)
 		return -EINVAL;
-	ret = strict_strtoul(val, 0, &num);
-	if (ret == -EINVAL || num < min || num > max)
+	ret = kstrtouint(val, 0, &num);
+	if (ret < 0)
+		return ret;
+	if (num < min || num > max)
 		return -EINVAL;
 	*((unsigned int *)kp->arg) = num;
 	return 0;
-- 
1.7.3.4

