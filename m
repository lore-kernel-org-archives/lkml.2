Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755476Ab1IMQWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 12:22:00 -0400
Received: from mail-qw0-f47.google.com ([209.85.216.47]:41037 "EHLO
	mail-qw0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755230Ab1IMQV6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 12:21:58 -0400
X-Greylist: delayed 414 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Sep 2011 12:21:58 EDT
MIME-Version: 1.0
In-Reply-To: <CAJ0pr18dn3CtBsXk9MG3Zn9zSwAiNoxB3b-62aMO3+8H+kUX3A@mail.gmail.com>
References: <1313758358-27536-1-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-2-git-send-email-per.forlin@stericsson.com>
	<1313758358-27536-3-git-send-email-per.forlin@stericsson.com>
	<CAC5umyjWx7ZvT+F_XhOZt_utr=mS-0p5tDpJ1ioWNiDAJLNXwQ@mail.gmail.com>
	<CAJ0pr18dn3CtBsXk9MG3Zn9zSwAiNoxB3b-62aMO3+8H+kUX3A@mail.gmail.com>
Date: Tue, 13 Sep 2011 18:15:03 +0200
Message-ID: <CAJ0pr1-ba0iY808igXJuEiWAX5zwhTUD6r+8MAMeBTHYFTenCg@mail.gmail.com>
Subject: Re: [PATCH v9 2/3] mmc: core: add random fault injection
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Akinobu,

On 13 September 2011 16:19, Per Forlin <per.forlin@linaro.org> wrote:
> On 13 September 2011 15:12, Akinobu Mita <akinobu.mita@gmail.com> wrote:
>> 2011/8/19 Per Forlin <per.forlin@stericsson.com>:
>>
>>> +#ifdef KERNEL
>>> +/*
>>> + * Internal function. Pass the boot param fail_mmc_request to
>>> + * the setup fault injection attributes routine.
>>> + */
>>> +static int __init setup_fail_mmc_request(char *str)
>>> +{
>>> +       return setup_fault_attr(&fail_mmc_request, str);
>>> +}
>>> +__setup("fail_mmc_request=", setup_fail_mmc_request);
>>> +#endif /* KERNEL */
>>
>> You attempt to enable __setup() only when mmc_core is built into
>> the kernel.  Does it really work? I cannot find any drivers using
>> "KERNEL" macro.
>>
> Your right it doesn't work. I think I change from ifndef MODULE to
> ifdef KERNEL at one point.
> It should be "ifndef MODULE"
>
>> You can use module_param_cb() instead of __setup() without #ifdef KERNEL.
>> When mmc_core is built into the kernel, you can specify the parameter
>> with "mmc_core.fail_mmc_request=..."
>>
I am considering using module_param() with perm = 0 (not visible in
sysfs). The purpose of the param is to set fault attributes during
kerne boot time or module load time. After the kernel boot all can be
set under debug fs, therefore no need to make the module param
visible.

What do you think about this? I have not tested it yet.
----------------------------------------------------------
+++ b/drivers/mmc/core/debugfs.c
@@ -20,6 +20,14 @@
 #include "core.h"
 #include "mmc_ops.h"

+#ifdef CONFIG_FAIL_MMC_REQUEST
+
+static DECLARE_FAULT_ATTR(fail_mmc_default_attr);
+static char *fail_mmc_request;
+module_param(fail_mmc_request, charp, 0);
+
+#endif /* CONFIG_FAIL_MMC_REQUEST */
+
 /* The debugfs functions are optimized away when CONFIG_DEBUG_FS isn't set. */
 static int mmc_ios_show(struct seq_file *s, void *data)
 {
@@ -159,23 +167,6 @@ static int mmc_clock_opt_set(void *data, u64 val)
        return 0;
 }

-#ifdef CONFIG_FAIL_MMC_REQUEST
-
-static DECLARE_FAULT_ATTR(fail_mmc_request);
-
-#ifdef KERNEL
-/*
- * Internal function. Pass the boot param fail_mmc_request to
- * the setup fault injection attributes routine.
- */
-static int __init setup_fail_mmc_request(char *str)
-{
-       return setup_fault_attr(&fail_mmc_request, str);
-}
-__setup("fail_mmc_request=", setup_fail_mmc_request);
-#endif /* KERNEL */
-#endif /* CONFIG_FAIL_MMC_REQUEST */
-
 DEFINE_SIMPLE_ATTRIBUTE(mmc_clock_fops, mmc_clock_opt_get, mmc_clock_opt_set,
        "%llu\n");

@@ -207,7 +198,9 @@ void mmc_add_host_debugfs(struct mmc_host *host)
                goto err_node;
 #endif
 #ifdef CONFIG_FAIL_MMC_REQUEST
-       host->fail_mmc_request = fail_mmc_request;
+       if (fail_mmc_request)
+               setup_fault_attr(&fail_mmc_default_attr, fail_mmc_request);
+       host->fail_mmc_request = fail_mmc_default_attr;
        if (IS_ERR(fault_create_debugfs_attr("fail_mmc_request",
                                             root,
                                             &host->fail_mmc_request)))
----------------------------------------------------------
It's only necessary to call setup_fault_attr() once for all hosts.
Here it's called one time for each host. I think it's ok since the
routine is small and used for debugging purposes.
I could use a static bool to indicate whether setup_fault_attr() has
already been issued.
+ if (fail_mmc_request && !setup_fault_attr_done)

Regards,
Per
