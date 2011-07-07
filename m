Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755229Ab1GGR1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 13:27:23 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:50798 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755142Ab1GGR1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 13:27:20 -0400
From: Richard Weinberger <richard@nod.at>
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Subject: Re: [PATCH 1/3] uml: drivers/net_user.c memory leak fix
Date: Thu, 7 Jul 2011 19:27:15 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.5; x86_64; ; )
Cc: Jeff Dike <jdike@addtoit.com>, user-mode-linux-devel@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>
References: <1310056562.3528.49.camel@vivanov>
In-Reply-To: <1310056562.3528.49.camel@vivanov>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107071927.16237.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 07 Juli 2011, 18:36:02 schrieb Vitaliy Ivanov:
> >From 9b9f36f46aa708c3245f5ded83f96421966b2edf Mon Sep 17 00:00:00 2001
> 
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Thu, 7 Jul 2011 19:23:13 +0300
> Subject: [PATCH 1/3] uml: drivers/net_user.c memory leak fix
> 
> Perform memory cleanup on exit.
> On receiving invalid 'pid' we still should clean 'output' variable.
> 
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> ---
>  arch/um/drivers/net_user.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/um/drivers/net_user.c b/arch/um/drivers/net_user.c
> index 9415dd9..989b653 100644
> --- a/arch/um/drivers/net_user.c
> +++ b/arch/um/drivers/net_user.c
> @@ -228,10 +228,11 @@ static void change(char *dev, char *what, unsigned
> char *addr, "buffer\n");
> 
>  	pid = change_tramp(argv, output, output_len);
> -	if (pid < 0) return;
> 
>  	if (output != NULL) {
> -		printk("%s", output);
> +		if (pid >= 0) {
> +			printk("%s", output);
> +		}
>  		kfree(output);
>  	}
>  }

This control logic is a bit strange.
When change_tramp() fails we should not printk() the output variable.

if (pid < 0){
 free(output);
 return;
}

Would be much cleaner.

Thanks,
//richard
