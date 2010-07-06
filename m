Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360Ab0GFUWZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 16:22:25 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36559 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752200Ab0GFUWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 16:22:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Bp8+Li6/AiPk8DKti+nFEegdmWS1/VEnXAt0e190wdW9Xp7o+7NuDYAiaXiMTXoJuJ
         ebCS2AJYwJD3xtYaTPA8HFyXSxqULwPyl8DMfiR2AX2j54G8h5/t7rDc1kAE0Bt6mxcJ
         hFEb7mLp/0CDU64nHfPO8cS7ijtVFhyPFd8k0=
From: "Sergey V." <sftp.mtuci@gmail.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Subject: Re: [PATCH v2]ipmi:ipmi_si_intf.c Fix warning: variable 'addr_space' set but not used
Date: Wed, 7 Jul 2010 00:14:36 +0400
User-Agent: KMail/1.13.3 (Linux/2.6.33.5; KDE/4.4.3; x86_64; ; )
Cc: minyard@acm.org, akpm@linux-foundation.org,
       openipmi-developer@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       jillsmitt@linuxcenter.kz
References: <1278436544-6091-1-git-send-email-justinmattock@gmail.com> <201007062205.30616.sftp.mtuci@gmail.com> <4C337628.7080006@gmail.com>
In-Reply-To: <4C337628.7080006@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201007070014.36816.sftp.mtuci@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 of July 2010 22:30:00 Justin P. Mattock wrote:
> 
> > Hello Justin.
> >
> > [...]
> >> @@ -2021,10 +2020,6 @@ static __devinit int try_init_spmi(struct SPMITable
> > *spmi)
> >>   	}
> >>
> >>   	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
> >> -		addr_space = IPMI_MEM_ADDR_SPACE;
> >> -	else
> >> -		addr_space = IPMI_IO_ADDR_SPACE;
> >> -
> >>   	info = kzalloc(sizeof(*info), GFP_KERNEL);
> >>   	if (!info) {
> >>   		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
> >
> > This looks like after applying this patch 'info = ...' will be part of
> > if statement (without indent before 'info = ...')
> >
> > 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
> > 		info = kzalloc(sizeof(*info), GFP_KERNEL);
> >
> > It's correct?
> >
> > Thanks
> >
> 
> the original patch I dont think this is correct. a bit confusing with 
> the if(!info) at the bottom of this.
> here's an updated version if it looks to be correct I'll resend if not 
> I'll redu:
> 
> 
> ---
>   drivers/char/ipmi/ipmi_si_intf.c |    7 -------
>   1 files changed, 0 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c 
> b/drivers/char/ipmi/ipmi_si_intf.c
> index 094bdc3..ef03ecd 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -2013,19 +2013,12 @@ struct SPMITable {
>   static __devinit int try_init_spmi(struct SPMITable *spmi)
>   {
>   	struct smi_info  *info;
> -	u8 		 addr_space;
> 
>   	if (spmi->IPMIlegacy != 1) {
>   		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
>   		return -ENODEV;
>   	}
> 
> -	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
> -		addr_space = IPMI_MEM_ADDR_SPACE;
> -	else
> -		addr_space = IPMI_IO_ADDR_SPACE;
> -
> -	info = kzalloc(sizeof(*info), GFP_KERNEL);
>   	if (!info) {
>   		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
>   		return -ENOMEM;
> -- 1.7.1.rc1.21.gf3bd6
> 
> Thanks for the info on this..
> 
> Justin P. Mattock
> 

Sorry, but I think that new patch is not correct.

Why do you delete this row "info = kzalloc(sizeof(*info), GFP_KERNEL)"?
There is the only one unused variable `addr_space`, so I think it should
be removed, that's all.

The following code is correct and not need to be changed:

	info = kzalloc(sizeof(*info), GFP_KERNEL);
	if (!info) {
		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");

Please see below my patch.
Thanks.

---
Fix compile warning
drivers/char/ipmi/ipmi_si_intf.c: In function 'try_init_spmi':
drivers/char/ipmi/ipmi_si_intf.c:2016:8: warning: variable 'addr_space' set but 
not used

Signed-off-by: Sergey V. <sftp.mtuci@gmail.com>
---
 drivers/char/ipmi/ipmi_si_intf.c |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c 
b/drivers/char/ipmi/ipmi_si_intf.c
index 094bdc3..1f5f025 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2013,18 +2013,12 @@ struct SPMITable {
 static __devinit int try_init_spmi(struct SPMITable *spmi)
 {
 	struct smi_info  *info;
-	u8 		 addr_space;
 
 	if (spmi->IPMIlegacy != 1) {
 		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
 		return -ENODEV;
 	}
 
-	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		addr_space = IPMI_MEM_ADDR_SPACE;
-	else
-		addr_space = IPMI_IO_ADDR_SPACE;
-
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
 		printk(KERN_ERR PFX "Could not allocate SI data (3)\n");
-- 
1.7.1
