Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2H0SiU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:38:20 -0400
Received: from smtp.outflux.net ([198.145.64.163]:34940 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752987Ab2H0SiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:38:18 -0400
Date: Mon, 27 Aug 2012 11:38:13 -0700
From: Kees Cook <keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <james.l.morris@oracle.com>,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: [PATCH] Yama: handle 32-bit userspace prctl
Message-ID: <20120827183813.GA23991@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a 64-bit kernel and receiving prctls from a 32-bit
userspace, the "-1" used as an unsigned long will end up being
misdetected. The kernel is looking for 0xffffffffffffffff instead of
0xffffffff. Since prctl lacks a distinct compat interface, Yama needs
to handle this translation itself. As such, support either value as
meaning PR_SET_PTRACER_ANY, to avoid breaking the ABI for 64-bit.

Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
---
 security/yama/yama_lsm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index 0cc99a3..dcd6178 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -143,7 +143,7 @@ static int yama_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 		if (arg2 == 0) {
 			yama_ptracer_del(NULL, myself);
 			rc = 0;
-		} else if (arg2 == PR_SET_PTRACER_ANY) {
+		} else if (arg2 == PR_SET_PTRACER_ANY || (int)arg2 == -1) {
 			rc = yama_ptracer_add(NULL, myself);
 		} else {
 			struct task_struct *tracer;
-- 
1.7.0.4


-- 
Kees Cook
Chrome OS Security
