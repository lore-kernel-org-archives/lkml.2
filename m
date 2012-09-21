Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab2IUI1K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 04:27:10 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:59690 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756445Ab2IUI1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 04:27:04 -0400
Subject: Re: [PATCH V2 07/10] Secure boot: Add a dummy kernel parameter
 that will switch on Secure Boot mode
From: joeyli <jlee@suse.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
In-Reply-To: <1348152065-31353-8-git-send-email-mjg@redhat.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-8-git-send-email-mjg@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 Sep 2012 16:20:53 +0800
Message-ID: <1348215653.5337.94.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 四，2012-09-20 於 10:41 -0400，Matthew Garrett 提到：
> From: Josh Boyer <jwboyer@redhat.com>
> 
> This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and cap_bset
> in the init_cred struct, which everything else inherits from.  This works on
> any machine and can be used to develop even if the box doesn't have UEFI.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>

Patch works to me for test lock the IO port access.

Tested-by: Lee, Chun-Yi <jlee@suse.com>

Joey Lee

> ---
>  kernel/cred.c | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/kernel/cred.c b/kernel/cred.c
> index de728ac..7e6e83f 100644
> --- a/kernel/cred.c
> +++ b/kernel/cred.c
> @@ -623,6 +623,23 @@ void __init cred_init(void)
>  				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
>  }
>  
> +void __init secureboot_enable()
> +{
> +	pr_info("Secure boot enabled\n");
> +	cap_lower((&init_cred)->cap_bset, CAP_COMPROMISE_KERNEL);
> +	cap_lower((&init_cred)->cap_permitted, CAP_COMPROMISE_KERNEL);
> +}
> +
> +/* Dummy Secure Boot enable option to fake out UEFI SB=1 */
> +static int __init secureboot_enable_opt(char *str)
> +{
> +	int sb_enable = !!simple_strtol(str, NULL, 0);
> +	if (sb_enable)
> +		secureboot_enable();
> +	return 1;
> +}
> +__setup("secureboot_enable=", secureboot_enable_opt);
> +
>  /**
>   * prepare_kernel_cred - Prepare a set of credentials for a kernel service
>   * @daemon: A userspace daemon to be used as a reference


