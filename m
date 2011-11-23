Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755560Ab1KWRxr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:53:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:59660 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117Ab1KWRxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:53:46 -0500
Date: Wed, 23 Nov 2011 17:53:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rabin Vincent <rabin@rab.in>
Cc: Jason Baron <jbaron@redhat.com>, Stephen Boyd <sboyd@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: add jump label support
Message-ID: <20111123175321.GI9581@n2100.arm.linux.org.uk>
References: <1321888429-3519-1-git-send-email-rabin@rab.in> <1321888429-3519-4-git-send-email-rabin@rab.in> <20111122194213.GC9581@n2100.arm.linux.org.uk> <4ECC2A07.8050701@codeaurora.org> <20111122233949.GA24453@redhat.com> <20111122235041.GB24453@redhat.com> <20111123145509.GA4973@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123145509.GA4973@debian>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 08:25:09PM +0530, Rabin Vincent wrote:
> Here's a patch.  Atleast on MIPS %c means something else so I had to
> ifdef it for ARM:
> 
> 8<----------------------------
> >From ea211ce77e0ea9c5b8cd32b99bfb24e0140f0068 Mon Sep 17 00:00:00 2001
> From: Rabin Vincent <rabin@rab.in>
> Date: Wed, 23 Nov 2011 20:05:09 +0530
> Subject: [PATCH] jump label: detect %c support for ARM
> 
> Some versions of ARM GCC don't support the %c specifier fully, but do
> support asm goto.  Since we need the %c to support jump labels on ARM,
> detect that too in the asm goto detection script to avoid build errors
> with these versions.
> 
> http://gcc.gnu.org/bugzilla/show_bug.cgi?id=48637
> 
> Signed-off-by: Rabin Vincent <rabin@rab.in>
> ---
>  scripts/gcc-goto.sh |   18 +++++++++++++++++-
>  1 files changed, 17 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/gcc-goto.sh b/scripts/gcc-goto.sh
> index 98cffcb..9b744de 100644
> --- a/scripts/gcc-goto.sh
> +++ b/scripts/gcc-goto.sh
> @@ -2,4 +2,20 @@
>  # Test for gcc 'asm goto' support
>  # Copyright (C) 2010, Jason Baron <jbaron@redhat.com>
>  
> -echo "int main(void) { entry: asm goto (\"\"::::entry); return 0; }" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
> +cat << "END" | $@ -x c - -c -o /dev/null >/dev/null 2>&1 && echo "y"
> +int main(void)
> +{
> +#ifdef __arm__
> +	/*
> +	 * Not related to asm goto, but used by jump label
> +	 * and broken on some ARM GCC versions (see GCC Bug 48637).
> +	 */
> +	static struct { int dummy; int state; } tp;
> +	asm ("@ %c0" :: "i" (&tp.state));
> +#endif
> +
> +entry:
> +	asm goto ("" :::: entry);
> +	return 0;
> +}
> +END

Is the presence of asm goto and %c something we want to test together or
separately?  I suspect it's something we want to do separately.
