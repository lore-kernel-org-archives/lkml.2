Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759990Ab2EVSGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:06:32 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53729 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928Ab2EVSGa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:06:30 -0400
MIME-Version: 1.0
In-Reply-To: <1337696279-8994-3-git-send-email-anton.vorontsov@linaro.org>
References: <20120522141717.GA31574@lizard>
	<1337696279-8994-3-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 22 May 2012 11:06:29 -0700
X-Google-Sender-Auth: FKa3h0RumqOvrZfV_jRBKCTqfiI
Message-ID: <CAMbhsRQPYzXregvvgQZD1dV_m4tgx0hQqnYPyaO3mV0hRpc5JQ@mail.gmail.com>
Subject: Re: [PATCH 03/16] pstore/ram_core: Do not reset restored zone's
 position and size
From: Colin Cross <ccross@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
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
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 7:17 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Otherwise, the files will survive just one reboot, and on a subsequent
> boot they will disappear.
>
> Also, as noticed by Colin Cross, this also causes an interesting behavior
> change in the console logging. Before this change, the console log would
> show only the messages from the last reboot.  After this change, the
> console log will have logs from multiple boots appended to each other.
>
> Now to get the only most recent messages we can do:
>
>        tac ramoops-console | sed '/^Linux version.*(.*@.*)/ q' | tac

Lots of problems with this.
"Linux version ..." is not the first line in the console log on my
devices, there are messages before it that shouldn't be dropped by
automated logs collectors using this regexp.
There is a timestamp before "Linux version", so the regexp never matches.
There is often no newline at the end of the old log, so if "Linux
version" was the first line in the log, it would still not get
matched.

Relying on the first line in the log to not change seems likely to
cause problems for scripts in the future.  Why not separate them where
the code knows for sure that the old log is ending and the new log is
starting?

> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  fs/pstore/ram_core.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index 235513c..f6650d1 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -406,6 +406,7 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
>                                " size %zu, start %zu\n",
>                               buffer_size(prz), buffer_start(prz));
>                        persistent_ram_save_old(prz);
> +                       return 0;
>                }
>        } else {
>                pr_info("persistent_ram: no valid data in buffer"
> --
> 1.7.9.2
>
