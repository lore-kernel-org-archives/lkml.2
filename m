Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751Ab2DJN2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 09:28:14 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:31131 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840Ab2DJN2N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 09:28:13 -0400
Message-ID: <4F843553.3090004@parallels.com>
Date: Tue, 10 Apr 2012 17:27:47 +0400
From: Stanislav Kinsbursky <skinsbursky@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Lightning/1.0b2 Thunderbird/3.1.20
MIME-Version: 1.0
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>,
        "serge.hallyn@canonical.com" <serge.hallyn@canonical.com>,
        "criu@openvz.org" <criu@openvz.org>, "arnd@arndb.de" <arnd@arndb.de>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>
Subject: [CRIU] [PATCH v2 2/4] ipc: move all checkpoint-restore code under
 appropriate define
References: <20120409175309.8358.21631.stgit@localhost6.localdomain6> <20120409175404.8358.32321.stgit@localhost6.localdomain6> <4F833CDF.4080300@parallels.com>
In-Reply-To: <4F833CDF.4080300@parallels.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2: added dummy compat_do_msg_peek_all() and do_msg_peek_all() functions used in 
case of CONFIG_CHECKPOINT_RESTORE is not defined.

All new checkpoint/restore code parts are now covered with
CONFIG_CHECKPOINT_RESTORE macro. So it would be easy to remove them, in case
the whole project fails.

---
  ipc/compat.c |    8 +++++++-
  ipc/msg.c    |   15 +++++++++++++++
  2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/ipc/compat.c b/ipc/compat.c
index 96cb9db..87317ff 100644
--- a/ipc/compat.c
+++ b/ipc/compat.c
@@ -334,7 +334,7 @@ long compat_sys_msgsnd(int first, int second, int third, 
void __user *uptr)
         return do_msgsnd(first, type, up->mtext, second, third);
  }

-
+#ifdef CONFIG_CHECKPOINT_RESTORE
  static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, 
size_t bufsz)
  {
         struct compat_msgbuf_a __user *msgp = dest;
@@ -354,6 +354,12 @@ static long compat_do_msg_peek_all(void __user *dest, 
struct msg_msg *msg, size_
                 return -EFAULT;
         return msgsz;
  }
+#else
+static long compat_do_msg_peek_all(void __user *dest, struct msg_msg *msg, 
size_t bufsz)
+{
+       return -EINVAL;
+}
+#endif

  long compat_do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
  {
diff --git a/ipc/msg.c b/ipc/msg.c
index 017bf0b..af08fe6 100644
--- a/ipc/msg.c
+++ b/ipc/msg.c
@@ -762,6 +762,7 @@ static inline int convert_mode(long *msgtyp, int msgflg)
         return SEARCH_EQUAL;
  }

+#ifdef CONFIG_CHECKPOINT_RESTORE
  static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
  {
         struct msgbuf_a __user *msgp = dest;
@@ -788,6 +789,12 @@ static long do_msg_peek_all(void __user *dest, struct 
msg_msg *msg, size_t bufsz
                 return -EFAULT;
         return msgsz;
  }
+#else
+static long do_msg_peek_all(void __user *dest, struct msg_msg *msg, size_t bufsz)
+{
+       return -EINVAL;
+}
+#endif

  static long do_msg_fill(void __user *dest, struct msg_msg *msg, size_t bufsz)
  {
@@ -811,7 +818,9 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, 
long msgtyp,
         struct msg_msg *msg;
         int mode;
         struct ipc_namespace *ns;
+#ifdef CONFIG_CHECKPOINT_RESTORE
         size_t arrsz = bufsz;
+#endif

         if (msqid < 0 || (long) bufsz < 0)
                 return -EINVAL;
@@ -845,6 +854,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, 
long msgtyp,
                                                 walk_msg->m_type != 1) {
                                         msg = walk_msg;
                                         msgtyp = walk_msg->m_type - 1;
+#ifdef CONFIG_CHECKPOINT_RESTORE
                                 } else if (msgflg & MSG_PEEK_ALL) {
                                         long ret;

@@ -855,6 +865,7 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, 
long msgtyp,
                                         }
                                         buf += ret;
                                         arrsz -= ret;
+#endif
                                 } else {
                                         msg = walk_msg;
                                         break;
@@ -863,8 +874,10 @@ long do_msgrcv(int msqid, void __user *buf, size_t bufsz, 
long msgtyp,
                         tmp = tmp->next;
                 }
                 if (!IS_ERR(msg)) {
+#ifdef CONFIG_CHECKPOINT_RESTORE
                         if (msgflg & MSG_PEEK_ALL)
                                 goto out_unlock;
+#endif
                         /*
                          * Found a suitable message.
                          * Unlink it from the queue.
@@ -959,8 +972,10 @@ out_unlock:
         if (IS_ERR(msg))
                 return PTR_ERR(msg);

+#ifdef CONFIG_CHECKPOINT_RESTORE
         if (msgflg & MSG_PEEK_ALL)
                 return bufsz - arrsz;
+#endif

         bufsz = msg_fill(buf, msg, bufsz);
         free_msg(msg);
