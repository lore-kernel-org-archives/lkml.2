Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2IBVeS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 17:34:18 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65319 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755151Ab2IBVdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 17:33:08 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>
Subject: [PATCH 5/7] x86, xsave: keep __user annotation in casts
Date: Sun,  2 Sep 2012 23:31:44 +0200
Message-Id: <1346621506-30857-6-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
References: <1346621506-30857-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't remove the __user annotation of the fpstate pointer, but drop the
superfluous void * cast instead.

This fixes the following sparse warnings:

xsave.c:135:15: warning: cast removes address space of expression
xsave.c:135:15: warning: incorrect type in argument 1 (different address spaces)
xsave.c:135:15:    expected void const volatile [noderef] <asn:1>*<noident>
xsave.c:135:15:    got unsigned int [usertype] *<noident>
xsave.c:135:15: warning: cast removes address space of expression
xsave.c:135:15: warning: cast removes address space of expression
xsave.c:135:15: warning: cast removes address space of expression
xsave.c:135:15: warning: cast removes address space of expression
xsave.c:135:15: warning: cast removes address space of expression
xsave.c:135:15: warning: cast removes address space of expression

Signed-off-by: Mathias Krause <minipli@googlemail.com>
---
 arch/x86/kernel/xsave.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/xsave.c b/arch/x86/kernel/xsave.c
index 3d3e207..9e1a8a7 100644
--- a/arch/x86/kernel/xsave.c
+++ b/arch/x86/kernel/xsave.c
@@ -132,9 +132,9 @@ int check_for_xstate(struct i387_fxsave_struct __user *buf,
 	    fx_sw_user->xstate_size > fx_sw_user->extended_size)
 		return -EINVAL;
 
-	err = __get_user(magic2, (__u32 *) (((void *)fpstate) +
-					    fx_sw_user->extended_size -
-					    FP_XSTATE_MAGIC2_SIZE));
+	err = __get_user(magic2, (__u32 __user *) (fpstate +
+						   fx_sw_user->extended_size -
+						   FP_XSTATE_MAGIC2_SIZE));
 	if (err)
 		return err;
 	/*
-- 
1.7.10.4

