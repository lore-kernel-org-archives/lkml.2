Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2EPQtP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 12:49:15 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42239 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811Ab2EPQtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 12:49:13 -0400
MIME-Version: 1.0
In-Reply-To: <20120516125625.GA20475@lizard>
References: <20120516125330.GA15460@lizard>
	<20120516125625.GA20475@lizard>
Date: Wed, 16 May 2012 09:49:11 -0700
X-Google-Sender-Auth: v7NLx9a1mEry6c0XL6ApxTkEZHQ
Message-ID: <CAGXu5j+oZRqow-cfEq3FgGW-NLWvsxCzjwG=SkJpaT345MM7WA@mail.gmail.com>
Subject: Re: [PATCH 1/6] pstore: Add console log messages support
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 5:56 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Pstore doesn't support logging kernel messages in run-time, it only
> dumps dmesg when kernel oopses/panics. This makes pstore useless for
> debugging hangs caused by HW issues or improper use of HW (e.g.
> weird device inserted -> driver tried to write a reserved bits ->
> SoC hanged. In that case we don't get any messages in the pstore.
>
> Therefore, let's add a runtime logging support: PSTORE_TYPE_CONSOLE.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  fs/pstore/Kconfig      |    7 +++++++
>  fs/pstore/inode.c      |    3 +++
>  fs/pstore/platform.c   |   25 +++++++++++++++++++++++++
>  include/linux/pstore.h |    1 +
>  4 files changed, 36 insertions(+)
>
> diff --git a/fs/pstore/Kconfig b/fs/pstore/Kconfig
> index 23ade26..d044de6 100644
> --- a/fs/pstore/Kconfig
> +++ b/fs/pstore/Kconfig
> @@ -12,6 +12,13 @@ config PSTORE
>           If you don't have a platform persistent store driver,
>           say N.
>
> +config PSTORE_CONSOLE
> +       bool "Log kernel console messages"
> +       depends on PSTORE
> +       help
> +         When the option is enabled, pstore will log all kernel
> +         messages, even if no oops or panic happened.
> +
>  config PSTORE_RAM
>        tristate "Log panic/oops to a RAM buffer"
>        depends on PSTORE
> diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
> index 1950788..97d35ee 100644
> --- a/fs/pstore/inode.c
> +++ b/fs/pstore/inode.c
> @@ -212,6 +212,9 @@ int pstore_mkfile(enum pstore_type_id type, char *psname, u64 id,
>        case PSTORE_TYPE_DMESG:
>                sprintf(name, "dmesg-%s-%lld", psname, id);
>                break;
> +       case PSTORE_TYPE_CONSOLE:
> +               sprintf(name, "console-%s", psname);
> +               break;
>        case PSTORE_TYPE_MCE:
>                sprintf(name, "mce-%s-%lld", psname, id);
>                break;
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 82c585f..3a384c8 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -1,6 +1,7 @@
>  /*
>  * Persistent Storage - platform driver interface parts.
>  *
> + * Copyright (C) 2007-2008 Google, Inc.
>  * Copyright (C) 2010 Intel Corporation <tony.luck@intel.com>
>  *
>  *  This program is free software; you can redistribute it and/or modify
> @@ -22,6 +23,7 @@
>  #include <linux/errno.h>
>  #include <linux/init.h>
>  #include <linux/kmsg_dump.h>
> +#include <linux/console.h>
>  #include <linux/module.h>
>  #include <linux/pstore.h>
>  #include <linux/string.h>
> @@ -156,6 +158,28 @@ static struct kmsg_dumper pstore_dumper = {
>        .dump = pstore_dump,
>  };
>
> +#ifdef CONFIG_PSTORE_CONSOLE
> +static void pstore_console_write(struct console *con, const char *s, unsigned c)
> +{
> +       strncpy(psinfo->buf, s, c);

The size of psinfo->buf needs to be the length argument to strncpy,
not the size of "s". If "s" isn't NULL terminated, then the min of c
and buf's size should be used. And if this should be NULL terminated
in buf, that needs to be added manually since strncpy won't do it if
it hits the max length argument.

-Kees

-- 
Kees Cook
Chrome OS Security
