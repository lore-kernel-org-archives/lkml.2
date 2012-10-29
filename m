Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab2J2JAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 05:00:49 -0400
Received: from smtp.nue.novell.com ([195.135.221.5]:40720 "EHLO
	smtp.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316Ab2J2JAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 05:00:46 -0400
Subject: Re: [PATCH V3 07/10] Secure boot: Add a dummy kernel parameter
 that will switch on Secure Boot mode
From: joeyli <jlee@suse.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Matthew Garrett <mjg@redhat.com>, tiwai@suse.de
In-Reply-To: <20120925130818.GE18546@hansolo.jdub.homelinux.org>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <1348152065-31353-8-git-send-email-mjg@redhat.com>
	 <20120920163237.GA11077@kroah.com>
	 <20120925130818.GE18546@hansolo.jdub.homelinux.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Oct 2012 17:00:06 +0800
Message-ID: <1351501206.21227.47.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Josh, 

於 二，2012-09-25 於 09:08 -0400，Josh Boyer 提到：
> This forcibly drops CAP_COMPROMISE_KERNEL from both cap_permitted and cap_bset
> in the init_cred struct, which everything else inherits from.  This works on
> any machine and can be used to develop even if the box doesn't have UEFI.
> 
> Signed-off-by: Josh Boyer <jwboyer@redhat.com>
> ---
>  Documentation/kernel-parameters.txt |  7 +++++++
>  kernel/cred.c                       | 17 +++++++++++++++++
>  2 files changed, 24 insertions(+)
> 
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 9b2b8d3..93978d5 100644
...
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
...
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
>  

Tahashi has a good idea for use strtobool to allow
'secureboot_enable=yes' works. Please consider the following change.


Thanks a lot!
Joey Lee

>From f6841a476f3d332fe7b04cb716e0b518cccd5055 Mon Sep 17 00:00:00 2001
From: Lee, Chun-Yi <jlee@suse.com>
Date: Mon, 29 Oct 2012 16:36:57 +0800
Subject: [PATCH] efi: more user-friendly secureboot_enable parameter

From: Takashi Iwai <tiwai@suse.de>

Use strtobool can allow 'secureboot_enable=yes', it's more user-friendly.

Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 kernel/cred.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cred.c b/kernel/cred.c
index 3f5be65..70897a2 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -633,9 +633,10 @@ void __init secureboot_enable()
 /* Dummy Secure Boot enable option to fake out UEFI SB=1 */
 static int __init secureboot_enable_opt(char *str)
 {
-	int sb_enable = !!simple_strtol(str, NULL, 0);
-	if (sb_enable)
+	bool sb_enable;
+	if (!strtobool(str, &sb_enable) && sb_enable)
 		secureboot_enable();
+
 	return 1;
 }
 __setup("secureboot_enable=", secureboot_enable_opt);
-- 
1.6.0.2




