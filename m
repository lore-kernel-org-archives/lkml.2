Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753180Ab1FZKjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 06:39:45 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49032 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753154Ab1FZKjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 06:39:40 -0400
Date: Sun, 26 Jun 2011 12:39:15 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        James Morris <jmorris@namei.org>, Namhyung Kim <namhyung@gmail.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH v2] kernel: escape non-ASCII and control characters in
 printk()
Message-ID: <20110626103915.GB11093@elte.hu>
References: <20110623152137.GA2536@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623152137.GA2536@albatros>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vasiliy Kulikov <segoon@openwall.com> wrote:

> This patch escapes control characters fed to printk() except '\n' and '\t'.
> 
> There are numerous printk() instances with user supplied input as "%s"
> data, and unprivileged user may craft log messages with substrings
> containing control characters via these printk()s.  Control characters
> might fool root viewing the logs via tty, e.g. using ^[1A to suppress
> the previous log line.
> 
> On the testing Samsung Q310 laptop there are no users of chars outside
> of the restricted charset. 
> 
> v2 - Allow chars with code >127.  Allow tabs.
> 
> Reported-by: Solar Designer <solar@openwall.com>
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
> ---
>  kernel/printk.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
> 
> ---
> diff --git a/kernel/printk.c b/kernel/printk.c
> index 3518539..727ff7d 100644
> --- a/kernel/printk.c
> +++ b/kernel/printk.c
> @@ -41,6 +41,7 @@
>  #include <linux/cpu.h>
>  #include <linux/notifier.h>
>  #include <linux/rculist.h>
> +#include <linux/ctype.h>
>  
>  #include <asm/uaccess.h>
>  
> @@ -671,6 +672,20 @@ static void emit_log_char(char c)
>  		logged_chars++;
>  }
>  
> +static void emit_log_char_escaped(char c)
> +{
> +	char buffer[8];
> +	int i, len;
> +
> +	if (!iscntrl(c) || (c == '\n') || (c == '\t'))
> +		emit_log_char(c);
> +	else {
> +		len = sprintf(buffer, "#x%02x", c);
> +		for (i = 0; i < len; i++)
> +			emit_log_char(buffer[i]);
> +	}

Nit: please use balanced curly braces.

Also, i think it would be better to make this opt-out, i.e. exclude 
the handful of control characters that are harmful (such as backline 
and console escape), instead of trying to include the known-useful 
ones.

The whole non-ASCII-languages issue would not have happened if such 
an approach was taken.

It's also the better approach for the kernel: we handle known harmful 
things and are permissive otherwise.

Thanks,

	Ingo
