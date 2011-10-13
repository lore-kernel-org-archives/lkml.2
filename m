Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab1JMHyr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 03:54:47 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:34538 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab1JMHyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 03:54:45 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: David Miller <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Jay Vosburgh <fubar@us.ibm.com>, Andy Gospodarek <andy@greyhouse.net>
References: <m1hb3dbae5.fsf@fess.ebiederm.org>
	<m1wrc99vjx.fsf@fess.ebiederm.org>
Date: Thu, 13 Oct 2011 00:55:08 -0700
In-Reply-To: <m1wrc99vjx.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Thu, 13 Oct 2011 00:53:38 -0700")
Message-ID: <m1sjmx9vhf.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+xm4QTL7zKOc/xAsNvau73wdg++SnDtpw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1]
	*  0.8 RDNS_NONE Delivered to internal network by a host with no rDNS
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: **
Subject: [PATCH 2/5] class: Implement support for class attrs in tagged sysfs directories.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 drivers/base/class.c   |   17 +++++++++++++++--
 include/linux/device.h |    2 ++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/base/class.c b/drivers/base/class.c
index 4f1df2e..b80d91c 100644
--- a/drivers/base/class.c
+++ b/drivers/base/class.c
@@ -47,6 +47,18 @@ static ssize_t class_attr_store(struct kobject *kobj, struct attribute *attr,
 	return ret;
 }
 
+static const void *class_attr_namespace(struct kobject *kobj,
+					const struct attribute *attr)
+{
+	struct class_attribute *class_attr = to_class_attr(attr);
+	struct subsys_private *cp = to_subsys_private(kobj);
+	const void *ns = NULL;
+
+	if (class_attr->namespace)
+		ns = class_attr->namespace(cp->class, class_attr);
+	return ns;
+}
+
 static void class_release(struct kobject *kobj)
 {
 	struct subsys_private *cp = to_subsys_private(kobj);
@@ -72,8 +84,9 @@ static const struct kobj_ns_type_operations *class_child_ns_type(struct kobject
 }
 
 static const struct sysfs_ops class_sysfs_ops = {
-	.show	= class_attr_show,
-	.store	= class_attr_store,
+	.show	   = class_attr_show,
+	.store	   = class_attr_store,
+	.namespace = class_attr_namespace,
 };
 
 static struct kobj_type class_ktype = {
diff --git a/include/linux/device.h b/include/linux/device.h
index c20dfbf..ea70bb2 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -350,6 +350,8 @@ struct class_attribute {
 			char *buf);
 	ssize_t (*store)(struct class *class, struct class_attribute *attr,
 			const char *buf, size_t count);
+	const void *(*namespace)(struct class *class,
+				 const struct class_attribute *attr);
 };
 
 #define CLASS_ATTR(_name, _mode, _show, _store)			\
-- 
1.7.2.5

