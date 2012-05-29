Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab2E2Q3C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 12:29:02 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57956 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab2E2Q27 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 12:28:59 -0400
MIME-Version: 1.0
In-Reply-To: <1338039549-24498-2-git-send-email-anton.vorontsov@linaro.org>
References: <20120526133412.GA18001@lizard>
	<1338039549-24498-2-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 29 May 2012 09:28:57 -0700
X-Google-Sender-Auth: NlqBP_gFOJCJITBxSfE1WXrYVUo
Message-ID: <CAGXu5jL0E7ybLPvhFdwNxiHSa==QJr+fX45A-T8Ug7iXLhtW_A@mail.gmail.com>
Subject: Re: [PATCH 2/5] pstore: Introduce write_buf backend callback
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, Shuah Khan <shuahkhan@gmail.com>,
        arve@android.com, Rebecca Schultz Zavin <rebecca@android.com>,
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

On Sat, May 26, 2012 at 6:39 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> For function tracing we need to stop using pstore.buf directly, since
> in a tracing callback we can't use spinlocks, and thus we can't safely
> use the global buffer.
>
> With write_buf callback, backends no longer need to access pstore.buf
> directly, and thus we can pass any buffers (e.g. allocated on stack).

Hrm, I thought the point of having pstore.buf pre-mapped was to allow
Oopses to be able to write directly to it without needing to hit any
additional kernel code. Maybe I'm misunderstanding this change,
though. I'd like to see Tony's opinion on it.

-Kees

> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  fs/pstore/platform.c   |   10 ++++++++++
>  include/linux/pstore.h |    4 ++++
>  2 files changed, 14 insertions(+)
>
> diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
> index be4614f..e7c0a52 100644
> --- a/fs/pstore/platform.c
> +++ b/fs/pstore/platform.c
> @@ -198,6 +198,14 @@ static void pstore_register_console(void)
>  static void pstore_register_console(void) {}
>  #endif
>
> +static int pstore_write_compat(enum pstore_type_id type,
> +                              enum kmsg_dump_reason reason,
> +                              u64 *id, unsigned int part,
> +                              size_t size, struct pstore_info *psi)
> +{
> +       return psi->write_buf(type, reason, id, part, psinfo->buf, size, psi);
> +}
> +
>  /*
>  * platform specific persistent storage driver registers with
>  * us here. If pstore is already mounted, call the platform
> @@ -222,6 +230,8 @@ int pstore_register(struct pstore_info *psi)
>                return -EINVAL;
>        }
>
> +       if (!psi->write)
> +               psi->write = pstore_write_compat;
>        psinfo = psi;
>        mutex_init(&psinfo->read_mutex);
>        spin_unlock(&pstore_lock);
> diff --git a/include/linux/pstore.h b/include/linux/pstore.h
> index 1bd014b..b107484 100644
> --- a/include/linux/pstore.h
> +++ b/include/linux/pstore.h
> @@ -48,6 +48,10 @@ struct pstore_info {
>        int             (*write)(enum pstore_type_id type,
>                        enum kmsg_dump_reason reason, u64 *id,
>                        unsigned int part, size_t size, struct pstore_info *psi);
> +       int             (*write_buf)(enum pstore_type_id type,
> +                       enum kmsg_dump_reason reason, u64 *id,
> +                       unsigned int part, const char *buf, size_t size,
> +                       struct pstore_info *psi);
>        int             (*erase)(enum pstore_type_id type, u64 id,
>                        struct pstore_info *psi);
>        void            *data;
> --
> 1.7.9.2
>



-- 
Kees Cook
Chrome OS Security
