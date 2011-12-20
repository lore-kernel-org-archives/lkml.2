Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331Ab1LTQir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 11:38:47 -0500
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:35059 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab1LTQib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 11:38:31 -0500
Message-ID: <4EF0B9F8.9020305@linux.vnet.ibm.com>
Date: Tue, 20 Dec 2011 14:38:16 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tim Gardner <tim.gardner@canonical.com>
CC: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>,
        tpmdd-devel@lists.sourceforge.net, stable@vger.kernel.org
Subject: Re: [PATCH 2/3] TPM: Close data_pending and data_buffer races
References: <1323196162-2717-1-git-send-email-tim.gardner@canonical.com> <1323196162-2717-3-git-send-email-tim.gardner@canonical.com>
In-Reply-To: <1323196162-2717-3-git-send-email-tim.gardner@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 11122016-1524-0000-0000-0000009CD99B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/11 16:29, Tim Gardner wrote:
> There is a race betwen tpm_read() and tpm_write where both chip->data_pending
> and chip->data_buffer can be changed by tpm_write() when tpm_read()
> clears chip->data_pending, but before tpm_read() grabs the mutex.
>
> Protect changes to chip->data_pending and chip->data_buffer by expanding
> the scope of chip->buffer_mutex.
>
> Reported-by: Seth Forshee<seth.forshee@canonical.com>
> Cc: Debora Velarde<debora@linux.vnet.ibm.com>
> Cc: Rajiv Andrade<srajiv@linux.vnet.ibm.com>
> Cc: Marcel Selhorst<m.selhorst@sirrix.com>
> Cc: tpmdd-devel@lists.sourceforge.net
> Cc: stable@vger.kernel.org
> Signed-off-by: Tim Gardner<tim.gardner@canonical.com>
> ---
>   drivers/char/tpm/tpm.c |   17 +++++++++--------
>   1 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> index b366b34..70bf9e5 100644
> --- a/drivers/char/tpm/tpm.c
> +++ b/drivers/char/tpm/tpm.c
> @@ -1074,12 +1074,15 @@ ssize_t tpm_write(struct file *file, const char __user *buf,
>   	struct tpm_chip *chip = file->private_data;
>   	size_t in_size = size, out_size;
>
> +	mutex_lock(&chip->buffer_mutex);
> +
>   	/* cannot perform a write until the read has cleared
>   	   either via tpm_read or a user_read_timer timeout */
> -	while (atomic_read(&chip->data_pending) != 0)
> +	while (atomic_read(&chip->data_pending) != 0) {
> +		mutex_unlock(&chip->buffer_mutex);
>   		msleep(TPM_TIMEOUT);
> -
> -	mutex_lock(&chip->buffer_mutex);
> +		mutex_lock(&chip->buffer_mutex);
> +	}
>
>   	if (in_size>  TPM_BUFSIZE)
>   		in_size = TPM_BUFSIZE;
> @@ -1112,22 +1115,20 @@ ssize_t tpm_read(struct file *file, char __user *buf,
>
>   	del_singleshot_timer_sync(&chip->user_read_timer);
>   	flush_work_sync(&chip->work);
> -	ret_size = atomic_read(&chip->data_pending);
> -	atomic_set(&chip->data_pending, 0);
> +	mutex_lock(&chip->buffer_mutex);
> +	ret_size = atomic_xchg(&chip->data_pending, 0);
>   	if (ret_size>  0) {	/* relay data */
>   		ssize_t orig_ret_size = ret_size;
>   		if (size<  ret_size)
>   			ret_size = size;
>
> -		mutex_lock(&chip->buffer_mutex);
>   		rc = copy_to_user(buf, chip->data_buffer, ret_size);
>   		memset(chip->data_buffer, 0, orig_ret_size);
>   		if (rc)
>   			ret_size = -EFAULT;

What about just moving atomic_set(&chip->data_pending, 0); to here?
If I'm not missing anything, this would be cleaner.

Rajiv
> -
> -		mutex_unlock(&chip->buffer_mutex);
>   	}
>
> +	mutex_unlock(&chip->buffer_mutex);
>   	return ret_size;
>   }
>   EXPORT_SYMBOL_GPL(tpm_read);

