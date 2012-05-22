Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759600Ab2EVPmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:42:11 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:62530 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757122Ab2EVPmI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:42:08 -0400
MIME-Version: 1.0
In-Reply-To: <1337696279-8994-16-git-send-email-anton.vorontsov@linaro.org>
References: <20120522141717.GA31574@lizard>
	<1337696279-8994-16-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 22 May 2012 08:42:06 -0700
X-Google-Sender-Auth: 18vuIcOTGzgheXERWc-dwEBe_mY
Message-ID: <CAGXu5jK9xL57zaqYfFDiBY7t+8MCSsQSvv8E4J7u-Rhtb-xKag@mail.gmail.com>
Subject: Re: [PATCH 16/16] pstore/platform: Disable automatic updates by default
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

On Tue, May 22, 2012 at 7:17 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Having automatic updates seems pointless for production system, and
> even dangerous and thus counter-productive:
>
> 1. If we can mount pstore, or read files, we can as well read
>   /proc/kmsg. So, there's little point in duplicating the
>   functionality and present the same information but via another
>   userland ABI;
>
> 2. Expecting the kernel to behave sanely after oops/panic is naive.
>   It might work, but you'd rather not try it. Screwed up kernel
>   can do rather bad things, like recursive faults[1]; and pstore
>   rather provoking bad things to happen. It uses:
>
>   1. Timers (assumes sane interrupts state);
>   2. Workqueues and mutexes (assumes scheduler in a sane state);
>   3. kzalloc (a working slab allocator);
>
>   That's too much for a dead kernel, so the debugging facility
>   itself might just make debugging harder, which is not what
>   we want.
>
> Maybe for non-oops message types it would make sense to re-enable
> automatic updates, but so far I don't see any use case for this.
> Even for tracing, it has its own run-time/normal ABI, so we're
> only interested in pstore upon next boot, to retrieve what has
> gone wrong with HW or SW.
>
> So, let's disable the updates by default.

I'll let Tony ack this, but I'm fine with it -- making this
configurable is sufficient for my needs. :)

> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index 4f49bb4..1dbf49d 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -41,10 +41,11 @@
>  * whether the system is actually still running well enough
>  * to let someone see the entry
>  */
> -static int pstore_update_ms = 60000;
> +static int pstore_update_ms = -1;
>  module_param_named(update_ms, pstore_update_ms, int, 0600);
>  MODULE_PARM_DESC(update_ms, "milliseconds before pstore updates its content "
> -                "(default is 60000; -1 means runtime updates are disabled)");
> +                "(default is -1, which means runtime updates are disabled; "
> +                "enabling this option is not safe)");

Perhaps "enabling this option may lead to further corruption on
Oopses" or something more specific?

-Kees

-- 
Kees Cook
Chrome OS Security
