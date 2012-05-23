Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933465Ab2EWChA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:37:00 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54424 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933426Ab2EWCgz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:36:55 -0400
Date: Tue, 22 May 2012 19:35:16 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Colin Cross <ccross@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH/RFC] Make sure linux_banner is the first message in log_buf
Message-ID: <20120523023513.GA22235@lizard>
References: <20120522141717.GA31574@lizard>
 <1337696279-8994-3-git-send-email-anton.vorontsov@linaro.org>
 <CAMbhsRQPYzXregvvgQZD1dV_m4tgx0hQqnYPyaO3mV0hRpc5JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMbhsRQPYzXregvvgQZD1dV_m4tgx0hQqnYPyaO3mV0hRpc5JQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For scripting it is important to have a consistent header that tells
where the kernel log starts. At least to me it always seemed that
linux_banner served this purpose.

Though, an early kernel code may print things before the Linux banner.
When we parse logs from multiple boots grabbed from serial or pstore
consoles, we might miss these messages.

The only bulletproof, arch-independent and whatnot way to ensure that
we have the banner printed first is to print it from the printk itself.
The resulting code looks quite obvious.

Sure, this doesn't address bootloader or low-level very early arch-
dependent console output that goes to the HW directly, but there's
nothing we can do about it (in pstore console we don't see them anyway).

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---

On Tue, May 22, 2012 at 11:06:29AM -0700, Colin Cross wrote:
> >
> > Now to get the only most recent messages we can do:
> >
> >        tac ramoops-console | sed '/^Linux version.*(.*@.*)/ q' | tac
> 
> Lots of problems with this.
> "Linux version ..." is not the first line in the console log on my
> devices, there are messages before it that shouldn't be dropped by
> automated logs collectors using this regexp.

Ouch. This seems not right. And the same issue exist if we collect
logs from e.g. serial console, there (unlike to just reading /proc/kmsg)
we don't know where current kernel's messages start, and more than
that, in serial console case we don't know where the messages end
(unlike to pstore).

So it's a general problem, not only related to pstore.

But we can fix this. How about the patch below?

> There is a timestamp before "Linux version", so the regexp never matches.

This is also fixable.

tac ramoops-console | sed '/\(^\|] \)Linux version.*(.*@.*)/ q' | tac

> There is often no newline at the end of the old log, so if "Linux
> version" was the first line in the log, it would still not get
> matched.

Yeah, true. We will have to add at least a new line in pstore.

> Relying on the first line in the log to not change seems likely to
> cause problems for scripts in the future.  Why not separate them where
> the code knows for sure that the old log is ending and the new log is
> starting?

I'm not opposed to a header (or a footer) at all, and you're right,
one of them is obviously needed.

I just don't like introducing yet another ad-hoc header format that
we will only use for pstore/console. We have "start of the Linux
kernel log" header, so let's try to use it?..

If it is not suitable for us today, let's think how to fix that, and
if anything, we can fall-back to your plan, i.e. adding our own footer
(or zapping prz) at boot time.

But so far I can see this solution:

1. Make sure we printk linux_banner as the first string in the
   log_buf (this patch). This is an improvement not only for pstore;

2. In pstore, add a newline to previous' boot log (we'll add it
   unconditinally, so that it we won't loose the information about
   the last new line :-).

 init/main.c     |    1 -
 kernel/printk.c |    3 +++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/init/main.c b/init/main.c
index 44b2433..df3711d 100644
--- a/init/main.c
+++ b/init/main.c
@@ -492,7 +492,6 @@ asmlinkage void __init start_kernel(void)
 	tick_init();
 	boot_cpu_init();
 	page_address_init();
-	printk(KERN_NOTICE "%s", linux_banner);
 	setup_arch(&command_line);
 	mm_init_owner(&init_mm, &init_task);
 	mm_init_cpumask(&init_mm);
diff --git a/kernel/printk.c b/kernel/printk.c
index b663c2c..1e1461b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -749,6 +749,9 @@ asmlinkage int printk(const char *fmt, ...)
 	va_list args;
 	int r;
 
+	/* Make sure linux_banner is kernel's first message. */
+	printk_once(KERN_NOTICE "%s", linux_banner);
+
 #ifdef CONFIG_KGDB_KDB
 	if (unlikely(kdb_trap_printk)) {
 		va_start(args, fmt);
-- 
1.7.9.2

