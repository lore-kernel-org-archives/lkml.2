Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2LCCqi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:46:38 -0500
Received: from ozlabs.org ([203.10.76.45]:44953 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab2LCCoj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:44:39 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stanislaw Gruszka <sgruszka@redhat.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: linux-next: build failure after merge of the modules tree
In-Reply-To: <20121128110145.GA3701@redhat.com>
References: <20121126151046.1b5b09762b8361b1f202c6e2@canb.auug.org.au> <20121128110145.GA3701@redhat.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 03 Dec 2012 10:59:21 +1030
Message-ID: <87d2ysj7vi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Mon, Nov 26, 2012 at 03:10:46PM +1100, Stephen Rothwell wrote:
>> After merging the modules tree, today's linux-next build (x86_64
>> allmodconfig) failed like this:
>> 
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1196:1: error: invalid suffix "n_disabletype__8" on integer constant
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1196:1: error: expected identifier or '(' before numeric constant
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1198:1: error: invalid suffix "n_disable__9" on integer constant
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1198:1: error: expected identifier or '(' before numeric constant
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1263:1: error: invalid suffix "ghz_disabletype__32" on integer constant
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1263:1: error: expected identifier or '(' before numeric constant
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1264:1: error: invalid suffix "ghz_disable__33" on integer constant
>> drivers/net/wireless/iwlwifi/iwl-drv.c:1264:1: error: expected identifier or '(' before numeric constant
>> drivers/net/wireless/iwlegacy/4965-mac.c:6825:1: error: invalid suffix "n_disabletype__11" on integer constant
>> drivers/net/wireless/iwlegacy/4965-mac.c:6825:1: error: expected identifier or '(' before numeric constant
>> drivers/net/wireless/iwlegacy/4965-mac.c:6826:1: error: invalid suffix "n_disable__12" on integer constant
>> drivers/net/wireless/iwlegacy/4965-mac.c:6826:1: error: expected identifier or '(' before numeric constant
>> 
>> Presumably caused by commit 58876af0436e ("moduleparam: use __UNIQUE_ID
>> ()").  This commit removed the "__mod_" prefix that used to be added to
>> the front of the "name" passed to module_param_named().  Admittedly, the
>> documentation says that "name" must be "a valid C identifier which is the
>> parameter name", but the (ab)usage here used to work (the name starts
>> with a number).
>
> I prefer not to change module parameters name, since there are users
> who use current name in they modprobe config.
>
> Stanislaw

Yes, the names can't be changed.

Here's the patch I've applied, which fixes it:

>From 7a918c7fb6499179e14a4e23a5ccff0ab920ffe0 Mon Sep 17 00:00:00 2001
From: Rusty Russell <rusty@rustcorp.com.au>
Date: Mon, 3 Dec 2012 10:49:29 +1030
Subject: [PATCH] compiler: fix UNIQUE_ID() for non-identifier names.

Some modules have parameters starting with digits, so always prepend UNIQUE_ID_
which ensures we produce a valid identifier, plus leave a clue if you
should encounter such a symbol.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
---
 include/linux/compiler-gcc4.h |    2 +-
 include/linux/compiler.h      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler-gcc4.h b/include/linux/compiler-gcc4.h
index 8908821..56c802c 100644
--- a/include/linux/compiler-gcc4.h
+++ b/include/linux/compiler-gcc4.h
@@ -31,7 +31,7 @@
 
 #define __linktime_error(message) __attribute__((__error__(message)))
 
-#define __UNIQUE_ID(prefix) __PASTE(prefix, __PASTE(__, __COUNTER__))
+#define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
 #if __GNUC_MINOR__ >= 5
 /*
diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index c55ae87..5f45335 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -170,7 +170,7 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
 
 /* Not-quite-unique ID. */
 #ifndef __UNIQUE_ID
-# define __UNIQUE_ID(prefix) __PASTE(__PASTE(prefix, __), __LINE__)
+# define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __LINE__)
 #endif
 
 #endif /* __KERNEL__ */
-- 
1.7.10.4

