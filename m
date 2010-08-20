Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab0HTRr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 13:47:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab0HTRry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 13:47:54 -0400
Subject: Re: struct fanotify_event_metadata
From: Eric Paris <eparis@redhat.com>
To: Andreas Schwab <schwab@redhat.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
        Andreas Gruenbacher <agruen@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282317570.15124.20.camel@dhcp231-77.rdu.redhat.com>
References: <m21va1ozqx.fsf@igel.home>
	 <201008191644.29299.tvrtko.ursulin@sophos.com>
	 <1282240426.21419.1716.camel@acb20005.ipt.aol.com>
	 <201008201002.16235.tvrtko.ursulin@sophos.com> <m3pqxd7ift.fsf@hase.home>
	 <1282310016.21419.2161.camel@acb20005.ipt.aol.com>
	 <m339u976sx.fsf@hase.home>
	 <1282317570.15124.20.camel@dhcp231-77.rdu.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 13:47:47 -0400
Message-ID: <1282326467.2652.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-08-20 at 11:19 -0400, Eric Paris wrote:
> On Fri, 2010-08-20 at 15:27 +0200, Andreas Schwab wrote:
> > Eric Paris <eparis@redhat.com> writes:
> > 
> > > Can you help me understand the packed attribute and why it hurts in this
> > > case?
> > 
> > It changes the alignment of all applicable objects to 1 which means that
> > the compiler cannot assume _any_ aligment.  Thus on STRICT_ALIGNMENT
> > targets it has to use more expensive access methods to avoid generating
> > unaligned loads and stores (unless it can infer proper alignment from
> > the context).
> 
> Andreas suggested (I accidentally dropped the list when I ask him) I use
> natural alignment and explicit padding rather than ((packed))

What would anyone think of this patch (which is on top of Tvrtko's
reordering)?

>From 9629f0435bdd00b8338ab41bd078b3c625fd8804 Mon Sep 17 00:00:00 2001
From: Eric Paris <eparis@redhat.com>
Date: Fri, 20 Aug 2010 13:33:27 -0400
Subject: [PATCH] fanotify: drops the packed attribute from userspace event metadata

The userspace event metadata structure was packed so when sent from a kernel
with a certain set of alignment rules to a userspace listener with a different
set of alignment rules the userspace process would be able to use the
structure.  On some arches just using packed, even if it doesn't do anything
to the alignment can cause a severe performance hit.  From now on we are
not going to set the packed attribute and will just need to be very careful
to make sure the structure is naturally aligned and that explicit padding is
used when necessary.  To make sure noone gets this wrong in the future, we
enforce this fact, at build time, using a similar structure that is packed
and comparing their sizes.

Signed-off-by: Eric Paris <eparis@redhat.com>
---
 fs/notify/fanotify/fanotify_user.c |    2 ++
 include/linux/fanotify.h           |   22 ++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
index b966b72..c3a5742 100644
--- a/fs/notify/fanotify/fanotify_user.c
+++ b/fs/notify/fanotify/fanotify_user.c
@@ -778,6 +778,8 @@ SYSCALL_ALIAS(sys_fanotify_mark, SyS_fanotify_mark);
  */
 static int __init fanotify_user_setup(void)
 {
+	BUILD_BUG_ON(sizeof(struct fanotify_event_metadata) !=
+		     sizeof(struct fan_event_meta_packed));
 	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
 	fanotify_response_event_cache = KMEM_CACHE(fanotify_response_event,
 						   SLAB_PANIC);
diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 0535461..3d7a9b5 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -66,14 +66,21 @@
 				 FAN_Q_OVERFLOW)
 
 #define FANOTIFY_METADATA_VERSION	1
-
+/*
+ * This structue must be naturally aligned so that a 32 bit userspace process
+ * will find the offsets the same as a 64bit process.  If there would be padding
+ * in the structure it must be added explictly by hand.  Please note that
+ * anything added to this structure must also be added to the fan_event_meta_packed
+ * struct, which is used to enforce the alignment and padding rules at build
+ * time.
+ */
 struct fanotify_event_metadata {
 	__u32 event_len;
 	__u32 vers;
 	__u64 mask;
 	__s32 fd;
 	__s32 pid;
-} __attribute__ ((packed));
+};
 
 struct fanotify_response {
 	__s32 fd;
@@ -95,4 +102,15 @@ struct fanotify_response {
 				(long)(meta)->event_len >= (long)FAN_EVENT_METADATA_LEN && \
 				(long)(meta)->event_len <= (long)(len))
 
+#ifdef __KERNEL__
+/* see struct fanotify_event_metadata for the reason this exists */
+struct fan_event_meta_packed {
+	__u32 event_len;
+	__u32 vers;
+	__u64 mask;
+	__s32 fd;
+	__s32 pid;
+} __attribute__ ((packed));
+
+#endif /* __KERNEL__ */
 #endif /* _LINUX_FANOTIFY_H */
-- 
1.6.5.3



