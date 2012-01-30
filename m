Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437Ab2A3QSs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:18:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:62700 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754411Ab2A3QSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:18:44 -0500
From: Andy Lutomirski <luto@amacapital.net>
To: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org
Cc: Casey Schaufler <casey@schaufler-ca.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jamie Lokier <jamie@shareable.org>, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com, corbet@lwn.net,
        alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v3 3/4] Allow unprivileged CLONE_NEWUTS and CLONE_NEWIPC with no_new_privs
Date: Mon, 30 Jan 2012 08:17:28 -0800
Message-Id: <9a520b74ad5dc14a3d6950b6d63a64714adbdd7d.1327858005.git.luto@amacapital.net>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
In-Reply-To: <cover.1327858005.git.luto@amacapital.net>
References: <cover.1327858005.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are normally disallowed because they could be used to subvert
setuid programs.  But if setuid is disabled, then they are safe.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 kernel/nsproxy.c |    8 +++++++-
 1 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index b576f7f..47cf873 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -191,7 +191,13 @@ int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 			       CLONE_NEWNET)))
 		return 0;
 
-	if (!capable(CAP_SYS_ADMIN))
+	/* We require either no_new_privs or CAP_SYS_ADMIN for all modes */
+	if (!current->no_new_privs && !capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	/* NEWNS and NEWNET always require CAP_SYS_ADMIN. */
+	if ((unshare_flags & (CLONE_NEWNS | CLONE_NEWNET)) &&
+	    !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	*new_nsp = create_new_namespaces(unshare_flags, current,
-- 
1.7.7.6

