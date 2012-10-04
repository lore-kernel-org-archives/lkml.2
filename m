Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933098Ab2JDVS6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:18:58 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:49290 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932858Ab2JDVSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:18:53 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        James Morris <james.l.morris@oracle.com>
Subject: [ 43/56] Yama: handle 32-bit userspace prctl
Date: Thu,  4 Oct 2012 14:16:04 -0700
Message-Id: <20121004211157.030832992@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121004211152.101901246@linuxfoundation.org>
References: <20121004211152.101901246@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <keescook@chromium.org>

commit 2e4930eb7c8fb20a39dfb5f8a8f80402710dcea8 upstream.

When running a 64-bit kernel and receiving prctls from a 32-bit
userspace, the "-1" used as an unsigned long will end up being
misdetected. The kernel is looking for 0xffffffffffffffff instead of
0xffffffff. Since prctl lacks a distinct compat interface, Yama needs
to handle this translation itself. As such, support either value as
meaning PR_SET_PTRACER_ANY, to avoid breaking the ABI for 64-bit.

Signed-off-by: Kees Cook <keescook@chromium.org>
Acked-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: James Morris <james.l.morris@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 security/yama/yama_lsm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -143,7 +143,7 @@ static int yama_task_prctl(int option, u
 		if (arg2 == 0) {
 			yama_ptracer_del(NULL, myself);
 			rc = 0;
-		} else if (arg2 == PR_SET_PTRACER_ANY) {
+		} else if (arg2 == PR_SET_PTRACER_ANY || (int)arg2 == -1) {
 			rc = yama_ptracer_add(NULL, myself);
 		} else {
 			struct task_struct *tracer;


