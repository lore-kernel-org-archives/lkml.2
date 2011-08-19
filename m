Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756727Ab1HSUlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 16:41:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755633Ab1HSUlM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 16:41:12 -0400
Message-ID: <4E4ECA5D.1020907@redhat.com>
Date: Fri, 19 Aug 2011 22:41:01 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: device-mapper development <dm-devel@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "David S. Miller" <davem@davemloft.net>, containers@lists.osdl.org
Subject: Re: [dm-devel] clone() with CLONE_NEWNET breaks kobject_uevent_env()
References: <4E4CDF44.5080109@redhat.com> <m17h69sr03.fsf@fess.ebiederm.org> <4E4E395B.7070106@redhat.com> <m1liup4oes.fsf@fess.ebiederm.org> <4E4E503B.3050406@redhat.com> <m1vctt2qlj.fsf@fess.ebiederm.org>
In-Reply-To: <m1vctt2qlj.fsf@fess.ebiederm.org>
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2011 08:39 PM, Eric W. Biederman wrote:

> But Kay's suggestion to use netlink_has_listeners() seems like good
> idea. IOW if there is no listener, it should skip quietly and not
> fail the whole call...
> In the case of ESRCH I completely agree.
>
> We are currently ignoring errors in the semantically more interesting
> case when netlink_broadcast does not deliver the packet to one of the
> listening netlink sockets.
>
> How does this patch look?
Well, your version still returns -ESRCH, so it is not helping much :-)
If you meant to handle it like I fixed in patch below (ignore ESRCH)
then I am ok with that approach, patch below fixes the problem
we have.

Thanks,
Milan

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index 70af0a7..04b2ed2 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -139,6 +139,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	u64 seq;
 	int i = 0;
 	int retval = 0;
+	bool delivery_failure;
 #ifdef CONFIG_NET
 	struct uevent_sock *ue_sk;
 #endif
@@ -251,6 +252,7 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	if (retval)
 		goto exit;
 
+	delivery_failure = false;
 #if defined(CONFIG_NET)
 	/* send netlink message */
 	mutex_lock(&uevent_sock_mutex);
@@ -281,14 +283,17 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 							    0, 1, GFP_KERNEL,
 							    kobj_bcast_filter,
 							    kobj);
-			/* ENOBUFS should be handled in userspace */
-			if (retval == -ENOBUFS)
+			if (retval == -ESRCH)
 				retval = 0;
+			else if (retval)
+				delivery_failure = true;
 		} else
-			retval = -ENOMEM;
+			delivery_failure = true;
 	}
 	mutex_unlock(&uevent_sock_mutex);
 #endif
+	if (delivery_failure)
+		retval = -ENOBUFS;
 
 	/* call uevent_helper, usually only enabled during early boot */
 	if (uevent_helper[0] && !kobj_usermode_filter(kobj)) {


