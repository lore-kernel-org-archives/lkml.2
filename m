Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844Ab3AGP4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:56:22 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33344 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab3AGP4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:56:20 -0500
Date: Mon, 7 Jan 2013 16:56:17 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Gokul Caushik <caushik1@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>
Subject: Re: [PATCH v7u1 13/31] x86, boot: add get_cmd_line_ptr()
Message-ID: <20130107155617.GF29449@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org, Gokul Caushik <caushik1@gmail.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Joe Millenbach <jmillenbach@gmail.com>,
	Alexander Duyck <alexander.h.duyck@intel.com>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-14-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1357260531-11115-14-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 04:48:33PM -0800, Yinghai Lu wrote:
> later will check ext_cmd_line_ptr at the same time.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> Cc: Gokul Caushik <caushik1@gmail.com>
> Cc: Josh Triplett <josh@joshtriplett.org>
> Cc: Joe Millenbach <jmillenbach@gmail.com>
> Cc: Alexander Duyck <alexander.h.duyck@intel.com>
> ---
>  arch/x86/boot/compressed/cmdline.c |   10 ++++++++--
>  arch/x86/kernel/head64.c           |   13 +++++++++++--
>  2 files changed, 19 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/boot/compressed/cmdline.c b/arch/x86/boot/compressed/cmdline.c
> index 10f6b11..b4c913c 100644
> --- a/arch/x86/boot/compressed/cmdline.c
> +++ b/arch/x86/boot/compressed/cmdline.c
> @@ -13,13 +13,19 @@ static inline char rdfs8(addr_t addr)
>  	return *((char *)(fs + addr));
>  }
>  #include "../cmdline.c"
> +static unsigned long get_cmd_line_ptr(void)
> +{
> +	unsigned long cmd_line_ptr = real_mode->hdr.cmd_line_ptr;
> +
> +	return cmd_line_ptr;

	return (unsigned long)real_mode->hdr.cmd_line_ptr;

should suffice.

> +}
>  int cmdline_find_option(const char *option, char *buffer, int bufsize)
>  {
> -	return __cmdline_find_option(real_mode->hdr.cmd_line_ptr, option, buffer, bufsize);
> +	return __cmdline_find_option(get_cmd_line_ptr(), option, buffer, bufsize);
>  }
>  int cmdline_find_option_bool(const char *option)
>  {
> -	return __cmdline_find_option_bool(real_mode->hdr.cmd_line_ptr, option);
> +	return __cmdline_find_option_bool(get_cmd_line_ptr(), option);
>  }
>  
>  #endif
> diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
> index c463725..316e7b2 100644
> --- a/arch/x86/kernel/head64.c
> +++ b/arch/x86/kernel/head64.c
> @@ -111,13 +111,22 @@ static void __init clear_bss(void)
>  	       (unsigned long) __bss_stop - (unsigned long) __bss_start);
>  }
>  
> +static unsigned long get_cmd_line_ptr(void)
> +{
> +	unsigned long cmd_line_ptr = boot_params.hdr.cmd_line_ptr;
> +
> +	return cmd_line_ptr;

ditto.

> +}
> +
>  static void __init copy_bootdata(char *real_mode_data)
>  {
>  	char * command_line;
> +	unsigned long cmd_line_ptr;
>  
>  	memcpy(&boot_params, real_mode_data, sizeof boot_params);
> -	if (boot_params.hdr.cmd_line_ptr) {
> -		command_line = __va(boot_params.hdr.cmd_line_ptr);
> +	cmd_line_ptr = get_cmd_line_ptr();
> +	if (cmd_line_ptr) {
> +		command_line = __va(cmd_line_ptr);
>  		memcpy(boot_command_line, command_line, COMMAND_LINE_SIZE);
>  	}
>  }
> -- 
> 1.7.10.4
> 
> 

-- 
Regards/Gruss,
Boris.
