Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751509Ab2KFFGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 00:06:03 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:52743 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176Ab2KFFF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 00:05:59 -0500
Message-ID: <1352181784.8752.27.camel@falcor>
Subject: Re: [PATCH RFC 3/4] firmware: Add a signature check
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        joeyli <jlee@suse.com>, Jiri Kosina <jkosina@suse.cz>,
        David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.ke
Date: Tue, 06 Nov 2012 01:03:04 -0500
In-Reply-To: <s5hd2zs9db6.wl%tiwai@suse.de>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com>
	 <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz>
	 <20121029174131.GC7580@srcf.ucam.org> <s5hobjia6vj.wl%tiwai@suse.de>
	 <20121031173728.GA18615@srcf.ucam.org> <s5h390utqv3.wl%tiwai@suse.de>
	 <1351743715. <s5hd2zs9db6.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12110605-2876-0000-0000-000001C2EBE6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-11-05 at 18:20 +0100, Takashi Iwai wrote:
> Add a feature to check the firmware signature, specified via Kconfig
> CONFIG_FIRMWARE_SIG.  The signature check is performed only for the
> direct fw loading without udev.  Also no check for built-in firmware
> blobs is implemented yet.
> 
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  drivers/base/Kconfig          |  6 +++++
>  drivers/base/firmware_class.c | 56 +++++++++++++++++++++++++++++++++++---
>  include/linux/firmware.h      |  7 +++++
>  kernel/module_signing.c       | 63 +++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 128 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index b34b5cd..3696fd7 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -145,6 +145,12 @@ config EXTRA_FIRMWARE_DIR
>  	  this option you can point it elsewhere, such as /lib/firmware/ or
>  	  some other directory containing the firmware files.
> 
> +config FIRMWARE_SIG
> +	bool "Firmware signature verification"
> +	depends on FW_LOADER && MODULE_SIG
> +	help
> +	  Enable firmware signature check.
> +
>  config DEBUG_DRIVER
>  	bool "Driver Core verbose debug messages"
>  	depends on DEBUG_KERNEL
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 8945f4e..575bc4c 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -36,6 +36,11 @@ MODULE_AUTHOR("Manuel Estrada Sainz");
>  MODULE_DESCRIPTION("Multi purpose firmware loading support");
>  MODULE_LICENSE("GPL");
> 
> +#ifdef CONFIG_FIRMWARE_SIG
> +static bool sig_enforce;
> +module_param(sig_enforce, bool, 0644);
> +#endif
> +
>  /* Builtin firmware support */
> 
>  #ifdef CONFIG_FW_LOADER
> @@ -287,7 +292,7 @@ static noinline long fw_file_size(struct file *file)
>  	return st.size;
>  }
> 
> -static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf)
> +static bool fw_read_file_contents(struct file *file, void **bufp, size_t *sizep)
>  {
>  	long size;
>  	char *buf;
> @@ -302,11 +307,39 @@ static bool fw_read_file_contents(struct file *file, struct firmware_buf *fw_buf
>  		vfree(buf);
>  		return false;
>  	}
> -	fw_buf->data = buf;
> -	fw_buf->size = size;
> +	*bufp = buf;
> +	*sizep = size;
>  	return true;
>  }
> 
> +#ifdef CONFIG_FIRMWARE_SIG
> +static bool verify_signature(struct firmware_buf *buf, const char *path)
> +{
> +	const unsigned long markerlen = sizeof(FIRMWARE_SIG_STRING) - 1;
> +	struct file *file;
> +	void *sig_data;
> +	size_t sig_size;
> +	bool success;
> +
> +	file = filp_open(path, O_RDONLY, 0);
> +	if (IS_ERR(file))
> +		return false;
> +
> +	success = fw_read_file_contents(file, &sig_data, &sig_size);
> +	fput(file);
> +	if (success) {
> +		if (sig_size > markerlen &&
> +		    !memcmp(sig_data, FIRMWARE_SIG_STRING, markerlen))
> +			success = !fw_verify_sig(buf->data, buf->size,
> +						 sig_data + markerlen,
> +						 sig_size - markerlen);
> +		pr_debug("verified signature %s: %d\n", path, success);
> +		vfree(sig_data);
> +	}
> +	return success;
> +}
> +#endif /* CONFIG_FIRMWARE_SIG */
> +
>  static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
>  {
>  	int i;
> @@ -320,8 +353,23 @@ static bool fw_get_filesystem_firmware(struct firmware_buf *buf)
>  		file = filp_open(path, O_RDONLY, 0);
>  		if (IS_ERR(file))
>  			continue;
> -		success = fw_read_file_contents(file, buf);
> +		success = fw_read_file_contents(file, &buf->data, &buf->size);
>  		fput(file);
> +#ifdef CONFIG_FIRMWARE_SIG
> +		if (success) {
> +			snprintf(path, PATH_MAX, "%s/%s.sig", fw_path[i],
> +				 buf->fw_id);
> +			if (!verify_signature(buf, path)) {
> +				pr_err("Invalid signature file %s\n", path);
> +				if (sig_enforce) {
> +					vfree(buf->data);
> +					buf->data = NULL;
> +					buf->size = 0;
> +					success = false;
> +				}
> +			}
> +		}
> +#endif /* CONFIG_FIRMWARE_SIG */

The existing kernel modules are read by userspace into a buffer, which
is passed to the kernel.  As there is no way of verifying what was read
by userspace is the same as what was passed to the kernel, the signature
verification is done, in the kernel, on the buffer contents.  The new
kernel module syscall passes a file descriptor.  With commit "41110a4
ima: support new kernel module syscall" the kernel module signature is
measured/appraised like any other file in the IMA policy.

Although the default policy should already be measuring/appraising the
firmware, because of the open, you might want to add a new hook
FIRMWARE_CHECK here, for finer grain IMA policy control.

thanks,

Mimi

>  		if (success)
>  			break;
>  	}
> diff --git a/include/linux/firmware.h b/include/linux/firmware.h
> index e4279fe..2e9e457 100644
> --- a/include/linux/firmware.h
> +++ b/include/linux/firmware.h
> @@ -79,4 +79,11 @@ static inline int uncache_firmware(const char *name)
>  }
>  #endif
> 
> +#ifdef CONFIG_FIRMWARE_SIG
> +#define FIRMWARE_SIG_STRING "~Linux firmware signature~\n"
> +/* defined in kernel/module_signing.c */
> +int fw_verify_sig(const void *fw_data, size_t fw_size,
> +		  const void *sig_data, size_t sig_size);
> +#endif
> +
>  #endif
> diff --git a/kernel/module_signing.c b/kernel/module_signing.c
> index ea1b1df..7994452 100644
> --- a/kernel/module_signing.c
> +++ b/kernel/module_signing.c
> @@ -11,6 +11,7 @@
> 
>  #include <linux/kernel.h>
>  #include <linux/err.h>
> +#include <linux/export.h>
>  #include <crypto/public_key.h>
>  #include <crypto/hash.h>
>  #include <keys/asymmetric-type.h>
> @@ -247,3 +248,65 @@ error_put_key:
>  	pr_devel("<==%s() = %d\n", __func__, ret);
>  	return ret;	
>  }
> +
> +#ifdef CONFIG_FIRMWARE_SIG
> +/*
> + * Verify the firmware signature, similar like module signature check
> + * but it's stored in a separate file
> + */
> +int fw_verify_sig(const void *fw_data, size_t fw_size,
> +		  const void *sig_data, size_t sig_size)
> +{
> +	struct public_key_signature *pks;
> +	struct module_signature ms;
> +	struct key *key;
> +	size_t sig_len;
> +	int ret;
> +
> +	if (sig_size <= sizeof(ms))
> +		return -EBADMSG;
> +
> +	memcpy(&ms, sig_data, sizeof(ms));
> +	sig_data += sizeof(ms);
> +	sig_size -= sizeof(ms);
> +
> +	sig_len = be32_to_cpu(ms.sig_len);
> +	if (sig_size < sig_len + (size_t)ms.signer_len + ms.key_id_len)
> +		return -EBADMSG;
> +
> +	/* For the moment, only support RSA and X.509 identifiers */
> +	if (ms.algo != PKEY_ALGO_RSA ||
> +	    ms.id_type != PKEY_ID_X509)
> +		return -ENOPKG;
> +
> +	if (ms.hash >= PKEY_HASH__LAST ||
> +	    !pkey_hash_algo[ms.hash])
> +		return -ENOPKG;
> +
> +	key = request_asymmetric_key(sig_data, ms.signer_len,
> +				     sig_data + ms.signer_len, ms.key_id_len);
> +	if (IS_ERR(key))
> +		return PTR_ERR(key);
> +
> +	pks = mod_make_digest(ms.hash, fw_data, fw_size);
> +	if (IS_ERR(pks)) {
> +		ret = PTR_ERR(pks);
> +		goto error_put_key;
> +	}
> +
> +	sig_data += ms.signer_len + ms.key_id_len;
> +	ret = mod_extract_mpi_array(pks, sig_data, sig_len);
> +	if (ret < 0)
> +		goto error_free_pks;
> +
> +	ret = verify_signature(key, pks);
> +
> +error_free_pks:
> +	mpi_free(pks->rsa.s);
> +	kfree(pks);
> +error_put_key:
> +	key_put(key);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(fw_verify_sig);
> +#endif /* CONFIG_FIRMWARE_SIG */



