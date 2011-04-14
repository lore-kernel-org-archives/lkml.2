Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753696Ab1DNVf2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 17:35:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:36225 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752597Ab1DNVf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 17:35:27 -0400
Message-ID: <4DA7689B.70809@suse.com>
Date: Thu, 14 Apr 2011 17:35:23 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: James Morris <jmorris@namei.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Peter Huewe <huewe.external.infineon@googlemail.com>
Subject: Re: [GIT PULL] TPM driver robustness fixes
References: <4D81708D.5090607@linux.vnet.ibm.com>
In-Reply-To: <4D81708D.5090607@linux.vnet.ibm.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 03/16/2011 10:23 PM, Rajiv Andrade wrote:
> Hi James,
> 
> 
> The following changes since commit
> 2e270d84223262a38d4755c61d55f5c73ea89e56:
> 
>   Merge branch 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6 (2011-03-16
> 13:26:17 -0700)
> 
> are available in the git repository at:
> 
>   git://tpmdd.git.sourceforge.net/gitroot/tpmdd/tpmdd/ for-james
> 
> Peter Huewe (3):
> 
>       This patch changes the call of tpm_transmit by supplying the size
> of the userspace buffer instead of TPM_BUFSIZE
> 
>       This patch fixes information leakage to the userspace by
> initializing the data buffer to zero
> 
>       Since the buffer might contain security related data it might be a
> good idea to zero the buffer after we have copied it to userspace.
> 
>  drivers/char/tpm/tpm.c |    7 ++++---
> 
>  1 files changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.c b/drivers/char/tpm/tpm.c
> 
> index 1f46f1c..c6d2cde 100644
> 
> --- a/drivers/char/tpm/tpm.c
> 
> +++ b/drivers/char/tpm/tpm.c
> 
> @@ -427,7 +427,7 @@ static ssize_t tpm_transmit(struct tpm_chip *chip,
> const char *buf,
> 
>      goto out;
> 
>  
> 
>  out_recv:
> 
> -    rc = chip->vendor.recv(chip, (u8 *) buf, bufsiz);
> 
> +    rc = chip->vendor.recv(chip, (u8 *) buf, TPM_BUFSIZE);
> 
>      if (rc<  0)
> 
>          dev_err(chip->dev,
> 
>              "tpm_transmit: tpm_recv: error %zd\n", rc);
> 

This works in the tpm_write case, but it seems like it's introducing a
bug in the __tpm_pcr_read (bufsiz=30) and tpm_continue_selftest
(bufsiz=10) cases. Am I missing something?

- -Jeff

> @@ -980,7 +980,7 @@ int tpm_open(struct inode *inode, struct file *file)
> 
>          return -EBUSY;
> 
>      }
> 
>  
> 
> -    chip->data_buffer = kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
> 
> +    chip->data_buffer = kzalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
> 
>      if (chip->data_buffer == NULL) {
> 
>          clear_bit(0,&chip->is_open);
> 
>          put_device(chip->dev);
> 
> @@ -1035,7 +1035,7 @@ ssize_t tpm_write(struct file *file, const char
> __user *buf,
> 
>      }
> 
>  
> 
>      /* atomic tpm command send and result receive */
> 
> -    out_size = tpm_transmit(chip, chip->data_buffer, TPM_BUFSIZE);
> 
> +    out_size = tpm_transmit(chip, chip->data_buffer, in_size);
> 
>  
> 
>      atomic_set(&chip->data_pending, out_size);
> 
>      mutex_unlock(&chip->buffer_mutex);
> 
> @@ -1064,6 +1064,7 @@ ssize_t tpm_read(struct file *file, char __user *buf,
> 
>          mutex_lock(&chip->buffer_mutex);
> 
>          if (copy_to_user(buf, chip->data_buffer, ret_size))
> 
>              ret_size = -EFAULT;
> 
> +        memset(chip->data_buffer, 0, ret_size);
> 
>          mutex_unlock(&chip->buffer_mutex);
> 
>      }
> 
>  
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk2naJsACgkQLPWxlyuTD7JMoQCaAj3aOiGYFubu/NKHRT0bM4Fy
wwkAn2Zj2yH2KLFrA0otJZ3ZSOZttd9B
=cxp4
-----END PGP SIGNATURE-----
