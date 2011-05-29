Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1E2AjC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 20:39:02 -0400
Received: from mx.treblig.org ([80.68.94.177]:39238 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754463Ab1E2Ai7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 20:38:59 -0400
Date: Sun, 29 May 2011 01:38:57 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: kosaki.motohiro@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Subject: sparse build breakage with 903c0c7cdc21f2ccb7562a7bbc70289c0c2b16ad
Message-ID: <20110529003857.GA9898@gallifrey>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 01:18:08 up 100 days,  1:50,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kosaki,
  I'm getting a problem when running the current (5dbe0af47f8a8f968bac2991c3ec974c6e3eaabc)
kernel tree through sparse, and I think it's down to an
interaction between your commit

903c0c7cdc21f2ccb7562a7bbc70289c0c2b16ad sparse: define dummy BUILD_BUG_ON definition for sparse

and the __module_param_call code in moduleparam.h

The error is:
init/main.c:643:1: error: Syntax error in unary expression

core_param(initcall_debug, initcall_debug, bool, 0644);

this calls __module_param_call which is defined as:


#define __module_param_call(prefix, name, ops, arg, isbool, perm)       \
        /* Default value instead of permissions? */                     \
        static int __param_perm_check_##name __attribute__((unused)) =  \
        BUILD_BUG_ON_ZERO((perm) < 0 || (perm) > 0777 || ((perm) & 2))  \
        + BUILD_BUG_ON_ZERO(sizeof(""prefix) > MAX_PARAM_PREFIX_LEN);   \
        static const char __param_str_##name[] = prefix #name;          \
        static struct kernel_param __moduleparam_const __param_##name   \
        __used                                                          \
    __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) \
        = { __param_str_##name, ops, perm, isbool ? KPARAM_ISBOOL : 0,  \
            { arg } }

which ends up with a postprocessed line of:

static inline void __check_initcall_debug(void) {; }; static int __param_perm_check_initcall_debug __attribute__((unused)) = +; static const char __param_str_initcall_debug[] = "" "initcall_debug"; static struct kernel_param const __param_initcall_debug __attribute__((__used__)) __attribute__ ((unused,__section__ ("__param"),aligned(sizeof(void *)))) = { __param_str_initcall_debug, &param_ops_bool, 0644, __builtin_types_compatible_p(typeof(initcall_debug), typeof(bool)) ? 2 : 0, { &initcall_debug } };

Note the '+;' being assigned to __param_perm_check_initcall_debug

So I think your dummy BUILD_BUG_ON_ZERO's needs to have a value:

The following diff seems to fix it, but I've not let
a fuller sparse run complete yet:

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fb0e732..953352a 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -671,8 +671,8 @@ struct sysinfo {
 
 #ifdef __CHECKER__
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)
-#define BUILD_BUG_ON_ZERO(e)
-#define BUILD_BUG_ON_NULL(e)
+#define BUILD_BUG_ON_ZERO(e) (0)
+#define BUILD_BUG_ON_NULL(e) ((void*)0)
 #define BUILD_BUG_ON(condition)
 #else /* __CHECKER__ */
 




-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
