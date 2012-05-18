Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946229Ab2ERXmI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:42:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56929 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030314Ab2ERXmF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:42:05 -0400
MIME-Version: 1.0
In-Reply-To: <20120518222426.GC23089@lizard>
References: <20120518222314.GA9425@lizard>
	<20120518222426.GC23089@lizard>
Date: Fri, 18 May 2012 16:42:03 -0700
X-Google-Sender-Auth: pSuPXSvTbPtxEXnMjygyZwStTd0
Message-ID: <CAMbhsRRTFY-U7e4ifoDKjgy9mQj+p79aa52U=PoOmwBxjpLXNg@mail.gmail.com>
Subject: Re: [PATCH 03/14] pstore/ram_core: Do not reset restored zone's
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

On Fri, May 18, 2012 at 3:24 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Otherwise, the files will survive just one reboot, and on a subsequent
> boot they will disappear.
>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  fs/pstore/ram_core.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
> index 849a542..dff5127 100644
> --- a/fs/pstore/ram_core.c
> +++ b/fs/pstore/ram_core.c
> @@ -422,6 +422,7 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
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

This causes an interesting behavior change in the console logging.
Before this change, the console log would show only the messages from
the last reboot.  After this change, the console log will have logs
from multiple boots appended to each other.  I can think of some
places where that could very handy, so I'm not against the change, but
as is it makes reading the logs much harder - the first oops you see
while skimming the log may not be from the last reboot.

One possibility would be to insert an obvious (and script parseable)
header during probe to separate the boots.  Another option would be to
expand the ringbuffer metadata to contain duplicate start and size
fields that only cover the most recent reboot, and export two files,
console-ramoops that contains the last log, and console-all-ramoops
that contains all the logs.  Or you could just zap the console buffer
at boot to keep the old behavior.
