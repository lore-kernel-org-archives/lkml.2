Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751490Ab1GMUIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 16:08:41 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:54259 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177Ab1GMUIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 16:08:40 -0400
Date: Wed, 13 Jul 2011 22:08:13 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH] kconfig: Only generate config_is_xxx for bool and
	tristate options
Message-ID: <20110713200813.GA11538@merkur.ravnborg.org>
References: <1305646532-29114-1-git-send-email-mmarek@suse.cz> <20110517195310.GA17003@merkur.ravnborg.org> <BANLkTikmO7D3kUgU62d4_VC2ZPZCnSEqKA@mail.gmail.com> <4E1D9C25.8080300@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1D9C25.8080300@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 03:22:45PM +0200, Michal Marek wrote:
> On 18.5.2011 08:23, Arnaud Lacombe wrote:
>> Hi,
>>
>> [added Valdis.Kletnieks@vt.edu to CC:]
>>
>> On Tue, May 17, 2011 at 3:53 PM, Sam Ravnborg<sam@ravnborg.org>  wrote:
>>> On Tue, May 17, 2011 at 05:35:32PM +0200, Michal Marek wrote:
>>>> For strings and integers, the config_is_xxx macros are useless and
>>>> sometimes misleading:
>>>>
>>>>    #define CONFIG_INITRAMFS_SOURCE ""
>>>>    #define config_is_initramfs_source() 1
>>>
>>> I'm late with this comment....
>>> Could we introduce "config_is_foo" using a syntax that
>>> does not break grepability?
>>>
>>> Maybe a syntax like this?
>>>
>>>     #ifdef CONFIG_FOO
>>>
>>> and
>>>
>>>     if (KCONFIG_FOO())
>>>
>>> Grepping for the use of a symbol is a very typical thing,
>>> so we should try to keep this.
>>> And with the suggested syntax above I expect fixdep to
>>> catch up both usage types.
>>>
>> Actually, there is already an issue, on a much smaller scale, in the
>> current tree with NUMA_BUILD and COMPACTION_BUILD. The real way to fix
>> this would be to always defines CONFIG_FOO, its value being 1 or 0
>> depending on whether or not the symbol is selected. This is a
>> +35k/-35k change.
>>
>> Also, I find KCONFIG_FOO() is too specific to be in the kernel source,
>> and redundant with CONFIG_FOO.
>>
>> I've been playing a bit with the preprocessor, and reached that point:
>>
>> #define EXPAND(x)       __ ## x
>> #define CONFIGURED(x)   \
>>          ({  int __1 __maybe_unused = 1;         \
>>              int __ ## x __maybe_unused = 0;     \
>>              EXPAND(x); })
>>
>> I am not specifically proud of that, use case would be:
>>
>> extern func(void);
>> int fn()
>> {
>>          if(CONFIGURED(CONFIG_FOO))
>>                  func();
>> }
>
> I finally got round to revisit this. Your approach inspired me to a much  
> simpler scheme: Instead of generating the config_is_xxx macros for  
> direct use in the code, name them __enabled_CONFIG_XXX or similar and  
> have a macro that expands given CONFIG_XXX symbol to the other form:

But then we clutter the namesapce with another set of variables that will
be misued. If not in the kernel then by other kconfig users.

Arnaud approach is nice as it does not require any additional
symbols to be generated.
We can always discuss tha naming - but the approach looks good.

To look at actual usage first:

int foo()
{
	if (KCONFIG(CONFIG_FOO)) {
		// this should be true for both module and non-module case
	}

	if (KCONFIG_NOT_MODULE(CONFIG_FOO)) {
		// this should be true only if this is not a module
	}



	if (KCONFIG_MODULE(CONFIG_FOO)) {
		// this should only be true for the module case
	}

}

Using the above even the naive reader is aware this is a kconfig generate
symbol.
Using "KCONFIG" in the name gives a stong hint that this is a kconfig thing.

We could stuff it all into a kconfig.h header like the attached (not tested)
but based on Arnauds sketch above - so creadits goes to him.

	Sam

diff --git a/include/linux/kconfig.h b/include/linux/kconfig.h
new file mode 100644
index 0000000..3ccdd73
--- /dev/null
+++ b/include/linux/kconfig.h
@@ -0,0 +1,30 @@
+#ifndef _LINUX_KCONFIG_H
+#define _LINUX_KCONFIG_H
+
+/*
+ * Helper macros for dealing with kconfig symbols
+ */
+
+#include <linux/compiler.h>
+
+#define __symbol_value(sym)       __ ## x
+#define __symbol_module(sym)      __symbol_value(__ ## sym ## _MODULE)
+
+/* return 1 if x is defined and not a module */
+#define KCONFIG_NON_MODULE(sym)					\
+	({ int __1 __maybe_unused = 1;				\
+	   int __ ## sym __maybe_unused = 0;			\
+	   __symbol_value(sym); })
+
+/* return 1 if sym is a module symbol */
+#define KCONFIG_MODULE(sym)					\
+	({ int __1 __maybe_unused = 1;				\
+	   int __ ## sym ## _MODULE __maybe_unused = 0;	\
+	   __symbol_value(sym); })
+
+/* return 1 if sym is defined - module or not */
+#define KCONFIG(sym) (KCONFIG_NON_MODULE(sym) || KCONFIG_MODULE(sym))
+
+#undef __symbol_value
+#undef __symbol_module
+#endif
