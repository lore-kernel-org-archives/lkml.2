Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0LIDfk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 22:35:40 -0500
Received: from imp02.mtu.ru ([62.5.255.19]:42552 "EHLO imp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752536Ab0LIDfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 22:35:39 -0500
Message-ID: <4D004E42.7000807@pavlinux.ru>
Date: Thu, 09 Dec 2010 06:34:26 +0300
From: Pavel Vasilyev <pavel@pavlinux.ru>
Reply-To: pavel@pavlinux.ru
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] Sysctl interface to UNIX_INFLIGHT_TRIGGER_GC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Spam-Flag: NO
X-Spam-Yversion: Spamooborona-3.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convenient for testing.
Maybe something to add in Documentation/kernel-parameters.txt ?

--- cut ---

diff --git a/include/net/af_unix.h b/include/net/af_unix.h
index 18e5c3f..ea580e4 100644
--- a/include/net/af_unix.h
+++ b/include/net/af_unix.h
@@ -15,6 +15,7 @@ extern struct sock *unix_get_socket(struct file *filp);
 #define UNIX_HASH_SIZE 256

 extern unsigned int unix_tot_inflight;
+extern unsigned int sysctl_inflight_trigger_gc;

 struct unix_address {
        atomic_t        refcnt;
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index f89f83b..c646c6b 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -94,7 +94,7 @@ static DEFINE_SPINLOCK(unix_gc_lock);
 static DECLARE_WAIT_QUEUE_HEAD(unix_gc_wait);

 unsigned int unix_tot_inflight;
-
+unsigned int sysctl_inflight_trigger_gc = 16000;

 struct sock *unix_get_socket(struct file *filp)
 {
@@ -259,7 +259,6 @@ static void inc_inflight_move_tail(struct unix_sock *u)
 }

 static bool gc_in_progress = false;
-#define UNIX_INFLIGHT_TRIGGER_GC 16000

 void wait_for_unix_gc(void)
 {
@@ -267,7 +266,7 @@ void wait_for_unix_gc(void)
         * If number of inflight sockets is insane,
         * force a garbage collect right now.
         */
-       if (unix_tot_inflight > UNIX_INFLIGHT_TRIGGER_GC && !gc_in_progress)
+       if (unix_tot_inflight > sysctl_inflight_trigger_gc &&
!gc_in_progress)
                unix_gc();
        wait_event(unix_gc_wait, gc_in_progress == false);
 }
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 397cffe..c807235 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -23,6 +23,13 @@ static ctl_table unix_table[] = {
                .mode           = 0644,
                .proc_handler   = proc_dointvec
        },
+       {
+               .procname       = "inflight_trigger_gc",
+               .data           = &sysctl_inflight_trigger_gc,
+               .maxlen         = sizeof(int),
+               .mode           = 0644,
+               .proc_handler   = proc_dointvec
+       },
        { }
 };

@@ -41,6 +48,8 @@ int __net_init unix_sysctl_register(struct net *net)
                goto err_alloc;

        table[0].data = &net->unx.sysctl_max_dgram_qlen;
+       table[1].data = &sysctl_inflight_trigger_gc;
+
        net->unx.ctl = register_net_sysctl_table(net, unix_path, table);
        if (net->unx.ctl == NULL)
                goto err_reg;

--- end of cut ---

