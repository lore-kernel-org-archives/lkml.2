Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1GZDpg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 23:45:36 -0400
Received: from mail.perches.com ([173.55.12.10]:4274 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801Ab1GZDpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 23:45:34 -0400
Subject: Re: [PATCH 24/25] dynamic_debug: drop pr_fmt() from
 dynamic_pr_debug
From: Joe Perches <joe@perches.com>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, bvanassche@acm.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, gnb@fmeh.org
In-Reply-To: <1311630170-26057-25-git-send-email-jim.cromie@gmail.com>
References: <1311630170-26057-1-git-send-email-jim.cromie@gmail.com>
	 <1311630170-26057-25-git-send-email-jim.cromie@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 20:45:32 -0700
Message-ID: <1311651932.24377.15.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 15:42 -0600, Jim Cromie wrote:
> dynamic_pr_debug can add module, function, file, and line selectively,
> theres no need to also add them via macro.  Moreover, adding them
> via the macro, which is useful for pr_info and friends, causes
> pr_debug to double-print those fields added by the flag-settings.
[]
> -		__dynamic_pr_debug(&descriptor, pr_fmt(fmt), ##__VA_ARGS__);\
> +		__dynamic_pr_debug(&descriptor, fmt, ##__VA_ARGS__);	\

Hey Jim.

Thinking about a bit more, maybe it's possible to use
another test to see if the current pr_fmt is:

#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

and not add pr_fmt when appropriate.

I tried this once.  I recall it worked without adding any
new string dependencies.   It did depend on __builtin_strcmp.

+#define _first_macro_arg(arg1, args...) arg1
+#define first_macro_arg(arg1, args...) _first_macro_arg(arg1)
+
+#define define_kernel_printk_level(level, fmt, ...)                    \
+do {                                                                   \
+       if (__builtin_strcmp(first_macro_arg(pr_fmt(fmt)),              \
+                            KBUILD_MODNAME ": " fmt))                  \
+               printk(level pr_fmt(fmt), ##__VA_ARGS__);               \
+       else                                                            \
+               printk(level fmt, ##__VA_ARGS__);                       \
+} while (0)



