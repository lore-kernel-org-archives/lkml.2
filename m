Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794Ab3AGQAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 11:00:46 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35702 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753064Ab3AGQAo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 11:00:44 -0500
Date: Mon, 7 Jan 2013 17:00:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 14/31] x86, boot: move checking of cmd_line_ptr out
 of common path
Message-ID: <20130107160042.GG29449@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-15-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1357260531-11115-15-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:34PM -0800, Yinghai Lu wrote:
> cmdline.c::__cmdline_find_option... are shared between 16-bit setup code
> and 32/64 bit decompressor code.
> 
> for 32/64 only path via kexec, we should not check if ptr is less 1M.
> as those cmdline could be put above 1M, or even 4G.
> 
> Move out accessible checking out of __cmdline_find_option()
> So decompressor in misc.c can parse cmdline correctly.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> ---
>  arch/x86/boot/boot.h    |   14 ++++++++++++--
>  arch/x86/boot/cmdline.c |    8 ++++----
>  2 files changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
> index 18997e5..7fadf80 100644
> --- a/arch/x86/boot/boot.h
> +++ b/arch/x86/boot/boot.h
> @@ -289,12 +289,22 @@ int __cmdline_find_option(u32 cmdline_ptr, const char *option, char *buffer, int
>  int __cmdline_find_option_bool(u32 cmdline_ptr, const char *option);
>  static inline int cmdline_find_option(const char *option, char *buffer, int bufsize)
>  {
> -	return __cmdline_find_option(boot_params.hdr.cmd_line_ptr, option, buffer, bufsize);
> +	u32 cmd_line_ptr = boot_params.hdr.cmd_line_ptr;

This check could very well use a comment for why we're checking it to be
under 1Mb, no matter that the original code didn't have it.

> +	if (cmd_line_ptr >= 0x100000)
> +		return -1;      /* inaccessible */
> +
> +	return __cmdline_find_option(cmd_line_ptr, option, buffer, bufsize);
>  }

[ … ]

Thanks.

-- 
Regards/Gruss,
Boris.
