Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab1HGRsd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Aug 2011 13:48:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:44164 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291Ab1HGRsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Aug 2011 13:48:31 -0400
Date: Sun, 7 Aug 2011 18:48:29 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Steve French <smfrench@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Subject: Re: new sparse warning fs/cifs/cifsfs.c:168:15: warning: dereference
 of noderef expression fs/cifs/cifsfs.c:542:15: warning: dereference of
 noderef expression
Message-ID: <20110807174829.GY2203@ZenIV.linux.org.uk>
References: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH2r5mszsiu2Gm-DPbfT8UReT=eBTf4Du4eyEapG8Ayn7UN1pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 07, 2011 at 11:22:51AM -0500, Steve French wrote:
> I noticed a series of sparse warnings (on all calls to cifs's GetXid
> after building on a newly install fc15 system (yum installed a sparse
> binary dated June 23).
> 
> fs/cifs/cifsfs.c:168:15: warning: dereference of noderef expression
> fs/cifs/cifsfs.c:542:15: warning: dereference of noderef expression
> 
> Has sparse changed to add a new warning - I see (from quick search)
> others getting this on other modules years ago, but I didn't see
> anything obvious wrong with the definition of the function, and I
> hadn't noticed sparse complaining about it before, and would like to
> remove the 50+ new messages as they clutter the build output.

It's not sparse change - the whinge comes from current_fsuid(), i.e. direct
read of current->cred, even though it's declared with __rcu.  The thing is,
current->cred does *not* need rcu_dereference() - only the task itself
can change it.  Easily fixed...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/include/linux/cred.h b/include/linux/cred.h
index 48e82af..98f46ef 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -265,10 +265,11 @@ static inline void put_cred(const struct cred *_cred)
 /**
  * current_cred - Access the current task's subjective credentials
  *
- * Access the subjective credentials of the current task.
+ * Access the subjective credentials of the current task.  RCU-safe,
+ * since nobody else can modify it.
  */
 #define current_cred() \
-	(current->cred)
+	(*(__force struct cred **)&current->cred)
 
 /**
  * __task_cred - Access a task's objective credentials
@@ -307,7 +308,7 @@ static inline void put_cred(const struct cred *_cred)
 ({							\
 	struct user_struct *__u;			\
 	struct cred *__cred;				\
-	__cred = (struct cred *) current_cred();	\
+	__cred = current_cred();			\
 	__u = get_uid(__cred->user);			\
 	__u;						\
 })
@@ -322,7 +323,7 @@ static inline void put_cred(const struct cred *_cred)
 ({							\
 	struct group_info *__groups;			\
 	struct cred *__cred;				\
-	__cred = (struct cred *) current_cred();	\
+	__cred = current_cred();			\
 	__groups = get_group_info(__cred->group_info);	\
 	__groups;					\
 })
@@ -341,7 +342,7 @@ static inline void put_cred(const struct cred *_cred)
 
 #define current_cred_xxx(xxx)			\
 ({						\
-	current->cred->xxx;			\
+	current_cred()->xxx;			\
 })
 
 #define current_uid()		(current_cred_xxx(uid))
