Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759488Ab2EQAvq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 20:51:46 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45224 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab2EQAvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 20:51:44 -0400
Date: Wed, 16 May 2012 17:50:14 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        Arnd Bergmann <arnd@arndb.de>, patches@linaro.org,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        arve@android.com, Jesper Juhl <jj@chaosbits.net>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        Rebecca Schultz Zavin <rebecca@android.com>,
        WANG Cong <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>, kernel-team@android.com,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [PATCH 4/6] staging: android: persistent_ram: Move to
 fs/pstore/ram_core.c
Message-ID: <20120517005014.GA333@lizard>
References: <20120516124109.GA14658@lizard>
 <20120516124338.GD18345@lizard>
 <20120516150550.GA22945@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120516150550.GA22945@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 08:05:50AM -0700, Greg Kroah-Hartman wrote:
[...]
> After applying this patch, and building things, I get the following
> errors:
> 
> drivers/built-in.o: In function `ram_console_write':
> ram_console.c:(.text+0x1690b9): undefined reference to `persistent_ram_write'
> drivers/built-in.o: In function `ram_console_read_old':
> ram_console.c:(.text+0x1690f7): undefined reference to `persistent_ram_old_size'
> ram_console.c:(.text+0x169103): undefined reference to `persistent_ram_old'
> ram_console.c:(.text+0x169136): undefined reference to `persistent_ram_ecc_string'
> ram_console.c:(.text+0x169177): undefined reference to `persistent_ram_ecc_string'
> drivers/built-in.o: In function `ram_console_probe':
> ram_console.c:(.init.text+0xc9ea): undefined reference to `persistent_ram_init_ringbuffer'
> drivers/built-in.o: In function `ram_console_late_init':
> ram_console.c:(.init.text+0xca6c): undefined reference to `persistent_ram_old_size'
> ram_console.c:(.init.text+0xcaa2): undefined reference to `persistent_ram_free_old'
> ram_console.c:(.init.text+0xcab4): undefined reference to `persistent_ram_old_size'
> ram_console.c:(.init.text+0xcac3): undefined reference to `persistent_ram_ecc_string'
> make: *** [.tmp_vmlinux1] Error 1
> 
> What went wrong?

I believe that error caused by two missing bytes: '=' and 'y'. :-)
RAM_CONSOLE is a bool, so it should be enabled only when PSTORE_RAM
is also =y. (For some reason I keep foregetting that bool's 'depends on'
may be satisfied by tristates' =m option, which easily lead to the
errors above.)

Thanks for catching this!

I've applied the following hunk to this patch and will resend the left
over patches soon:

diff --git a/drivers/staging/android/Kconfig b/drivers/staging/android/Kconfig
index 4bfcceb..0e16b59 100644
--- a/drivers/staging/android/Kconfig
+++ b/drivers/staging/android/Kconfig
@@ -27,7 +27,7 @@ config ANDROID_LOGGER
 
 config ANDROID_RAM_CONSOLE
 	bool "Android RAM buffer console"
-	depends on !S390 && !UML && HAVE_MEMBLOCK && PSTORE_RAM
+	depends on !S390 && !UML && HAVE_MEMBLOCK && PSTORE_RAM=y
 	default n
 
 config ANDROID_TIMED_OUTPUT

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
