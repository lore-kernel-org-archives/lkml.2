Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab2ITQcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:32:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33816 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab2ITQct (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:32:49 -0400
Date: Thu, 20 Sep 2012 17:32:37 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH V2 07/10] Secure boot: Add a dummy kernel parameter that
 will switch on Secure Boot mode
Message-ID: <20120920163237.GA11077@kroah.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
 <1348152065-31353-8-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348152065-31353-8-git-send-email-mjg@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 10:41:02AM -0400, Matthew Garrett wrote:
> From: Josh Boyer <jwboyer@redhat.com>
> 
> This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and cap_bset
> in the init_cred struct, which everything else inherits from.  This works on
> any machine and can be used to develop even if the box doesn't have UEFI.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
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

Document this please in the bootparams file.

thanks,

greg k-h
