Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab0DOMMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 08:12:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26070 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356Ab0DOMM2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 08:12:28 -0400
Subject: Re: [RFC][PATCH] Security: fix cap_file_mmap() off-by-one error to
 avoid kernel null pointer exploit
From: Eric Paris <eparis@redhat.com>
To: wzt.wzt@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       jmorris@namei.org, eparis@parisplace.org
In-Reply-To: <20100415055132.GA3921@localhost.localdomain>
References: <20100415055132.GA3921@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Apr 2010 08:12:20 -0400
Message-ID: <1271333540.3042.17.camel@dhcp235-240.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-15 at 13:51 +0800, wzt.wzt@gmail.com wrote:

NAK

The fix to the comment is fine, but you missed the point ENTIRELY.  The
WHOLE point of being able to set dac_mmap_min_addr == 0 is so you can
disable the protection.  There exist tools (wine and dosemu) which NEED
to map the 0 page.  Thus dac_mmap_min_addr == 0 means the protection is
disabled.  If you don't want to disable the protection, don't disable
it!

-Eric


> ---
>  security/commoncap.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/security/commoncap.c b/security/commoncap.c
> index 6166973..cc6b458 100644
> --- a/security/commoncap.c
> +++ b/security/commoncap.c
> @@ -931,7 +931,7 @@ int cap_vm_enough_memory(struct mm_struct *mm, long pages)
>   * @addr: address attempting to be mapped
>   * @addr_only: unused
>   *
> - * If the process is attempting to map memory below mmap_min_addr they need
> + * If the process is attempting to map memory below dac_mmap_min_addr they need
>   * CAP_SYS_RAWIO.  The other parameters to this function are unused by the
>   * capability security module.  Returns 0 if this mapping should be allowed
>   * -EPERM if not.

A patch with only this change would be fine.

> @@ -942,7 +942,7 @@ int cap_file_mmap(struct file *file, unsigned long reqprot,
>  {
>  	int ret = 0;
>  
> -	if (addr < dac_mmap_min_addr) {
> +	if (addr <= dac_mmap_min_addr) {
>  		ret = cap_capable(current, current_cred(), CAP_SYS_RAWIO,
>  				  SECURITY_CAP_AUDIT);
>  		/* set PF_SUPERPRIV if it turns out we allow the low mmap */

Clearly missed the boat on this one.

