Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab2LXIPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2012 03:15:17 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:39893 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab2LXIPL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2012 03:15:11 -0500
From: Andrey Vagin <avagin@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: criu@openvz.org, linux-fsdevel@vger.kernel.org,
        Andrey Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [PATCH 4/4] signal: allow to send any siginfo to itself
Date: Mon, 24 Dec 2012 12:13:27 +0400
Message-Id: <1356336807-5517-5-git-send-email-avagin@openvz.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1356336807-5517-1-git-send-email-avagin@openvz.org>
References: <1356336807-5517-1-git-send-email-avagin@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A kernel prevents of sending siginfo with positive si_code, because
these codes is reserved for kernel. I think we can allow to send any
siginfo to itself. This operation should not be dangerous.

This functionality is required for restoring signals.

Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Pavel Emelyanov <xemul@parallels.com>
CC: Cyrill Gorcunov <gorcunov@openvz.org>
Signed-off-by: Andrey Vagin <avagin@openvz.org>
---
 kernel/signal.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 91bb76f2..1c83c71 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2957,7 +2957,8 @@ SYSCALL_DEFINE3(rt_sigqueueinfo, pid_t, pid, int, sig,
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info.si_code >= 0 || info.si_code == SI_TKILL) {
+	if (((info.si_code >= 0 || info.si_code == SI_TKILL)) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info.si_code < 0);
 		return -EPERM;
@@ -2977,7 +2978,8 @@ long do_rt_tgsigqueueinfo(pid_t tgid, pid_t pid, int sig, siginfo_t *info)
 	/* Not even root can pretend to send signals from the kernel.
 	 * Nor can they impersonate a kill()/tgkill(), which adds source info.
 	 */
-	if (info->si_code >= 0 || info->si_code == SI_TKILL) {
+	if ((info->si_code >= 0 || info->si_code == SI_TKILL) &&
+	    (task_pid_vnr(current) != pid)) {
 		/* We used to allow any < 0 si_code */
 		WARN_ON_ONCE(info->si_code < 0);
 		return -EPERM;
-- 
1.7.11.7

