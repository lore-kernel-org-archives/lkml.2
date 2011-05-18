Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933618Ab1ERSzs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:55:48 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42963 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933554Ab1ERSzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:55:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=iKhoGSzC99ZhSCttfaOs/0ek+rXiiwjZEzyX4ssLKxEPIByqF/+/a4Ju+nw0QRR2zj
         51KzGZPdF3Pe/d7wy1ECIQocN0rV7mfDW5QvIJLAZiD9OasM+nGqUed9deEpIt51zFZi
         tskrUv74rPvA48W7mPeryhnfrcXNZ4Hw3z+bM=
From: Alessio Igor Bogani <abogani@kernel.org>
To: Greg KH <greg@kroah.com>, Rusty Russell <rusty@rustcorp.com.au>,
        Tim Bird <tim.bird@am.sony.com>, Christoph Hellwig <hch@infradead.org>
Cc: Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>,
        Alessio Igor Bogani <abogani@kernel.org>
Subject: 
Date: Wed, 18 May 2011 20:55:25 +0200
Message-Id: <1305744925-8162-1-git-send-email-abogani@kernel.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <4DD305B3.3000707@am.sony.com>
References: <4DD305B3.3000707@am.sony.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Bird, Dear Mr. Kroah-Hartman,

Sorry for my very bad English.

2011/5/18 Tim Bird <tim.bird@am.sony.com>:
[...]
> Alessio - do you have any timings you can share for the speedup?

You can find a little benchmark using ftrace at end of this email:
https://lkml.org/lkml/2011/4/5/341

> On 05/17/2011 04:22 PM, Greg KH wrote:
>> On Tue, May 17, 2011 at 10:56:03PM +0200, Alessio Igor Bogani wrote:
>>> This work was supported by a hardware donation from the CE Linux Forum.
[...]
>> Please explain why you make a change, not just who sponsored the change,
>> that's not very interesting to developers.

You are right. I apologize.

This patch is a missing piece (not essential it is only a further little
optimization) of this little patchset:
https://lkml.org/lkml/2011/4/16/48

Unfortunately I forgot to include this patch in the series (my first error)
then I avoided explaining the changes because I had thought that those were
already enough explained in the cover-letter of the patchset (my second error).

Sorry for my mistakes.

Is this better?

Subject: [PATCH] module: Use binary search in lookup_symbol()

The function is_exported() with its helper function lookup_symbol() are used to
verify if a provided symbol is effectively exported by the kernel or by the
modules. Now that both have their symbols sorted we can replace a linear search
with a binary search which provide a considerably speed-up.

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@kernel.org>
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

Thank you very much!

Ciao,
Alessio
