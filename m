Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757307Ab0FDWQe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 18:16:34 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47248 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757133Ab0FDWQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 18:16:33 -0400
Date: Fri, 4 Jun 2010 15:16:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Weber <weber@corscience.de>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts: confdata: Fix fwrite warning
Message-Id: <20100604151613.2594bf7c.akpm@linux-foundation.org>
In-Reply-To: <1275489859-31874-1-git-send-email-weber@corscience.de>
References: <1275489859-31874-1-git-send-email-weber@corscience.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Jun 2010 16:44:19 +0200
Thomas Weber <weber@corscience.de> wrote:

> I get for:
> scripts/kconfig/confdata.c:508
> scripts/kconfig/confdata.c:759
> scripts/kconfig/confdata.c:760
> 
> warning: ignoring return value of ___fwrite___, declared with attribute warn_unused_result
> 
> So check the return value and handle the error.
> 
> Signed-off-by: Thomas Weber <weber@corscience.de>
> ---
>  scripts/kconfig/confdata.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
> index c4dec80..4741fea 100644
> --- a/scripts/kconfig/confdata.c
> +++ b/scripts/kconfig/confdata.c
> @@ -505,7 +505,10 @@ int conf_write(const char *name)
>  				while (1) {
>  					l = strcspn(str, "\"\\");
>  					if (l) {
> -						fwrite(str, l, 1, out);
> +						if (fwrite(str, l, 1, out) != 1) {
> +							fprintf(stderr, "write str failed\n");
> +							return 1;
> +						}

Missing an fclose(out), although that probably doesn't matter a lot in
practice

Also, we prefer to avoid putting `return' statements deep inside large
C functions as they can easily lead to resource leaks.  Such as
forgetting to fclose(out) ;)

>  						str += l;
>  					}
>  					if (!*str)
> @@ -756,8 +759,14 @@ int conf_write_autoconf(void)
>  			while (1) {
>  				l = strcspn(str, "\"\\");
>  				if (l) {
> -					fwrite(str, l, 1, out);
> -					fwrite(str, l, 1, out_h);
> +					if (fwrite(str, l, 1, out) != 1) {
> +						fprintf(stderr, "write str failed\n");
> +						return 1;
> +					}
> +					if (fwrite(str, l, 1, out_h) != 1) {
> +						fprintf(stderr, "write str failed\n");
> +						return 1;
> +					}

Dittoes.

Also, this patch would be neater if it added a little helper function
around fwrite(), rather than triplicating the same code sequence.

