Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab0KHUeR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:34:17 -0500
Received: from smtp-out.google.com ([74.125.121.35]:3983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0KHUeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:34:13 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=mmr9QnHytL8ukJSLakWnAMqCGtBdLXWpRm0vNJhTitVaFiakBFIV6lmfxoZ2S29Wi
	H2YvYmCAEZY7bWPiVwWAQ==
Subject: [PATCH v2 22/23] netoops: Add one-shot mode
To: simon.kagstrom@netinsight.net, davem@davemloft.net, nhorman@tuxdriver.com,
        Matt Mackall <mpm@selenic.com>
From: Mike Waychison <mikew@google.com>
Cc: adurbin@google.com, linux-kernel@vger.kernel.org, chavey@google.com,
        Greg KH <greg@kroah.com>,
        =?utf-8?q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
        akpm@linux-foundation.org, linux-api@vger.kernel.org
Date: Mon, 08 Nov 2010 12:33:47 -0800
Message-ID: <20101108203346.22479.10201.stgit@crlf.mtv.corp.google.com>
In-Reply-To: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
References: <20101108203120.22479.19708.stgit@crlf.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it is possible to have a kernel crashing that continuously
Oopses.  In this case, we do not want the network dumper get called over
and over again, as we may only be interested in the first Oops that a
kernel emits (especially in cases where we panic_on_oops).

In order to support this dumping policy, this commit introduces a file
call /proc/sys/kernel/net_dump_one_shot that contains a boolean as to
whether or not the netoops driver will operate in one-shot mode.

Note that 'soft' dumps do not disable the netoops driver when one-shot
mode is enabled.

Signed-off-by: Mike Waychison <mikew@google.com>
---
TODO: ABI needs a better home.
---
 drivers/net/netoops.c |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/drivers/net/netoops.c b/drivers/net/netoops.c
index 5cbb732..1ffd0f0 100644
--- a/drivers/net/netoops.c
+++ b/drivers/net/netoops.c
@@ -97,6 +97,8 @@ struct netoops_msg {
 } __attribute__ ((packed));
 
 static struct netoops_msg msg;
+static int network_dumper_one_shot = 1;
+static int network_dumper_disabled;
 
 static char netoops_fw_version[80];
 static char netoops_board_name[80];
@@ -221,6 +223,10 @@ static void netoops(struct kmsg_dumper *dumper, enum kmsg_dump_reason reason,
 		netoops_send_segment(packet_count_2, s1, l1);
 	}
 
+	/* Should we disable ourselves now? */
+	if (!soft_dump && network_dumper_one_shot)
+		network_dumper_disabled = 1;
+
 	spin_unlock_irqrestore(&targets.lock, flags);
 }
 
@@ -282,6 +288,28 @@ static struct kmsg_dumper netoops_dumper = {
 	.dump = netoops,
 };
 
+static struct ctl_table kern_table[] = {
+	{
+		.procname       = "net_dump_one_shot",
+		.data           = &network_dumper_one_shot,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = &proc_dointvec,
+	},
+	{},
+};
+
+static struct ctl_table root_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= kern_table,
+	},
+	{}
+};
+
+static struct ctl_table_header *proc_table_header;
+
 static int __init netoops_init(void)
 {
 	int retval = -EINVAL;
@@ -309,7 +337,15 @@ static int __init netoops_init(void)
 	if (retval)
 		goto out_sysfs_group;
 
+	proc_table_header = register_sysctl_table(root_table);
+	if (!proc_table_header) {
+		retval = -EINVAL;
+		goto out_kmsg_dump;
+	}
+
 	return 0;
+out_kmsg_dump:
+	kmsg_dump_unregister(&netoops_dumper);
 out_sysfs_group:
 	sysfs_remove_group(netoops_kobj, &attr_group);
 out_kobj:
@@ -322,6 +358,7 @@ out:
 
 static void __exit netoops_exit(void)
 {
+	unregister_sysctl_table(proc_table_header);
 	kmsg_dump_unregister(&netoops_dumper);
 	sysfs_remove_group(netoops_kobj, &attr_group);
 	kobject_put(netoops_kobj);

