Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751971Ab1AYBBU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:01:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42726 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab1AYBBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 20:01:19 -0500
Date: Mon, 24 Jan 2011 17:01:10 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, torvalds@linux-foundation.org,
        San Mehat <san@google.com>, Aaron Durbin <adurbin@google.com>,
        Duncan Laurie <dlaurie@google.com>, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 5/6] Allow prepending to the dmesg
Message-Id: <20110124170110.d204c0e9.akpm@linux-foundation.org>
In-Reply-To: <20110125002459.12637.56291.stgit@mike.mtv.corp.google.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
	<20110125002459.12637.56291.stgit@mike.mtv.corp.google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Jan 2011 16:25:00 -0800
Mike Waychison <mikew@google.com> wrote:

> The next patch in this series (Memory Console driver) would like to
> prepend firmware messages to the kernel logs.

I went to the changelog for "Memory Console driver" to work out why it
wants to do prepending, but it didn't tell me.

> Instead of exposing all the nitty gritty lock details of the kernel's
> printk system to the entire kernel, expose a "prepend_to_dmesg()" that
> attempts to rewrite the in-memory dmesg to inject pre-kernel messages.
> 
> This function only prepends if the start of the kernel's messages are
> still in the ring and there is still room for messages (without losing
> the current tail of the message log).  We determine this by checking out
> whether the bufer has yet been cleared (indicated by a new flag:
> buffer_has_cleared), and by checking whether the buffer is less than
> full (which would indicate that it had wrapped).
> 
> If there is enough room to prepend data, we simply shift the existing
> log contents down and copy into the buffer the tail of the prepended
> data that fits.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  include/linux/printk.h |    5 ++++
>  kernel/printk.c        |   55 +++++++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 59 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/printk.h b/include/linux/printk.h
> index ee048e7..df89965 100644
> --- a/include/linux/printk.h
> +++ b/include/linux/printk.h
> @@ -113,6 +113,7 @@ extern int dmesg_restrict;
>  extern int kptr_restrict;
>  
>  void log_buf_kexec_setup(void);
> +void prepend_to_dmesg(const char *buffer, size_t length);

Should have the __init tag in the declaration (can fix link problems on
weird architectures).

>  #else
>  static inline __attribute__ ((format (printf, 1, 0)))
>  int vprintk(const char *s, va_list args)
> @@ -137,6 +138,10 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
>  static inline void log_buf_kexec_setup(void)
>  {
>  }
> +
> +void prepend_to_dmesg(const char *buffer, size_t length)
> +{
> +}

Didn't this cause the linker to detect multiple definitions of
prepend_to_dmesg()?

Should be static inline void, or __init and not-inlined in a .c file.

>  #endif
>  
> ...
