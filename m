Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753476Ab1ERUgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:36:14 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:61856 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab1ERUgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:36:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=rtF0QE3N65NW6yO4K6oSMe/33o9psDqkLw6Tcf3kc1XXnx3CzxDe1Ud4RunDAmuPwG
         W/6CCgx97JgznwfirI6873y7Pko8EnK1SqxgQJi2pSMOk8tmTsd/Gkn1dGNGwLqPEJRm
         FTHvf0n+mVnICSgsT0uUVf9RJTCVn+hLV2o24=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Greg KH <greg@kroah.com>, Anders Kaseorg <andersk@ksplice.com>,
        Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>,
        Christoph Hellwig <hch@infradead.org>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: [PATCH] module: Use binary search in lookup_symbol()
Date: Wed, 18 May 2011 22:35:59 +0200
Message-Id: <1305750959-3018-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <BANLkTim2DBkrFbdR=0a=wGqFPX1O7d+C7g@mail.gmail.com>
References: <BANLkTim2DBkrFbdR=0a=wGqFPX1O7d+C7g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is_exported() with its helper function lookup_symbol() are used to
verify if a provided symbol is effectively exported by the kernel or by the
modules. Now that both have their symbols sorted we can replace a linear search
with a binary search which provide a considerably speed-up.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/module.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 1e2b657..795bdc7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2055,11 +2055,8 @@ static const struct kernel_symbol *lookup_symbol(const char *name,
 	const struct kernel_symbol *start,
 	const struct kernel_symbol *stop)
 {
-	const struct kernel_symbol *ks = start;
-	for (; ks < stop; ks++)
-		if (strcmp(ks->name, name) == 0)
-			return ks;
-	return NULL;
+	return bsearch(name, start, stop - start,
+			sizeof(struct kernel_symbol), cmp_name);
 }
 
 static int is_exported(const char *name, unsigned long value,
-- 
1.7.4.1

