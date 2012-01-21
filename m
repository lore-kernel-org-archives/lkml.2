Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751784Ab2AUTSc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 14:18:32 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41849 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2AUTSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 14:18:09 -0500
Date: Sat, 21 Jan 2012 19:18:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Szymon Janc <szymon@janc.net.pl>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_misc: Fix compilation error in parse_command()
Message-ID: <20120121191806.GD23916@ZenIV.linux.org.uk>
References: <1327172558-19180-1-git-send-email-szymon@janc.net.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327172558-19180-1-git-send-email-szymon@janc.net.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 08:02:37PM +0100, Szymon Janc wrote:
> This fix compilation error with CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
> enabled. It looks like gcc 4.6.2 is not able to prove that count
> is within sizeof(s) bounds (although it is).
> 
>   CC [M]  fs/binfmt_misc.o
> In file included from arch/x86/include/asm/uaccess.h:573:0,
>                  from include/linux/uaccess.h:5,
>                  from include/linux/highmem.h:7,
>                  from include/linux/pagemap.h:10,
>                  from fs/binfmt_misc.c:26:
> In function ???copy_from_user???,
>     inlined from ???parse_command.part.1??? at fs/binfmt_misc.c:421:20:
> arch/x86/include/asm/uaccess_32.h:211:26: error: call to ???copy_from_user_overflow??? declared with attribute error: copy_from_user() buffer size is not provably correct
> make[1]: *** [fs/binfmt_misc.o] Error 1
> make: *** [fs] Error 2
> 
> Signed-off-by: Szymon Janc <szymon@janc.net.pl>
> ---
>  fs/binfmt_misc.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index a9198df..4879d35 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -418,7 +418,7 @@ static int parse_command(const char __user *buffer, size_t count)
>  		return 0;
>  	if (count > 3)
>  		return -EINVAL;
> -	if (copy_from_user(s, buffer, count))
> +	if (copy_from_user(s, buffer, min(count, sizeof(s))))

File a report in gcc bugzilla.  Note that
	* count is size_t and thus unsigned
	* sizeof(s) is 4
IOW, min(count, sizeof(s)) should do no better (or worse) than count here.
If gcc is unable to prove that, it really needs to be fixed...
