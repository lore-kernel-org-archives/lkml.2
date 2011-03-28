Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1C1QHL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 12:07:11 -0400
Received: from e24smtp04.br.ibm.com ([32.104.18.25]:40183 "EHLO
	e24smtp04.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753999Ab1C1QHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:07:08 -0400
Message-ID: <4D90B222.1060302@linux.vnet.ibm.com>
Date: Mon, 28 Mar 2011 13:06:58 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Peter Huewe <huewe.external.infineon@googlemail.com>
CC: James Morris <jmorris@namei.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] TPM driver robustness fixes
References: <4D81708D.5090607@linux.vnet.ibm.com> <alpine.LRH.2.00.1103220956350.14837@tundra.namei.org> <AANLkTimS1ss=977x3d-7Wcpj0wGthzW3_G+wqF1wQMc3@mail.gmail.com> <AANLkTi=uZME7Pr761VJkEiJYFp7L3iexjV3JeMmL63it@mail.gmail.com> <4D88A12D.60301@linux.vnet.ibm.com> <AANLkTi=+QFL5aMym68Dx=Vgomy9MQRV1AB1AreTua_mW@mail.gmail.com>
In-Reply-To: <AANLkTi=+QFL5aMym68Dx=Vgomy9MQRV1AB1AreTua_mW@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11032816-8936-0000-0000-00000175606B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2011 01:08 PM, Peter Huewe wrote:
> Or rather:
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index d184d75..2f2f65e 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1052,6 +1052,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
>  {
>         struct tpm_chip *chip = file->private_data;
>         ssize_t ret_size;
> +       int rc;
> 
>         del_singleshot_timer_sync(&chip->user_read_timer);
>         flush_work_sync(&chip->work);
> @@ -1062,8 +1063,11 @@ ssize_t tpm_read(struct file *file, char __user *buf,
>                         ret_size = size;
> 
>                 mutex_lock(&chip->buffer_mutex);
> -               if (copy_to_user(buf, chip->data_buffer, ret_size))
> +               rc = copy_to_user(buf, chip->data_buffer, ret_size);
> +               memset(chip->data_buffer, 0, ret_size);
> +               if (rc)
>                         ret_size = -EFAULT;
> +
>                 mutex_unlock(&chip->buffer_mutex);
>         }
> 
> 
> 
> Thanks,
> Peter

This approach is definitely the best.

Thanks,
Rajiv


-- 
Thanks,
Rajiv Andrade <srajiv@br.ibm.com>
Security Development
IBM Linux Technology Center
+55 19 81095527

