Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1KUO6r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 09:58:47 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45599 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab1KUO6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 09:58:45 -0500
Message-ID: <4ECA671E.3080509@polito.it>
Date: Mon, 21 Nov 2011 15:58:38 +0100
From: Roberto Sassu <roberto.sassu@polito.it>
Organization: Politecnico di Torino
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Roberto Sassu <roberto.sassu@polito.it>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com, jmorris@namei.org, srajiv@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH] ima: add new kernel parameter ima_denycall_on_errors
References: <1321885097-14166-1-git-send-email-roberto.sassu@polito.it>
In-Reply-To: <1321885097-14166-1-git-send-email-roberto.sassu@polito.it>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This applies on top of my patches previously posted:

[PATCH 1/2] ima: split ima_add_digest_entry() function
[PATCH 2/2] ima: free memory of unused template entries

Roberto Sassu


On 11/21/2011 03:18 PM, Roberto Sassu wrote:
> The new kernel parameter tells IMA the action that must be done when an
> error in the measurement process occurs. If 'ima_denycall_on_errors' is
> equal to 1, the IMA hooks return an error, so that the system call will
> not be executed. Otherwise, the default behavior is to execute the system
> call and, eventually, to include in the measurements list those entries
> for which the PCR extend operation was failed.
>
> Signed-off-by: Roberto Sassu<roberto.sassu@polito.it>
> ---
>   Documentation/kernel-parameters.txt |    8 ++++
>   security/integrity/ima/ima.h        |    5 ++-
>   security/integrity/ima/ima_api.c    |   12 ++++--
>   security/integrity/ima/ima_init.c   |   11 ++++--
>   security/integrity/ima/ima_main.c   |   65 ++++++++++++++++++++++++-----------
>   security/integrity/ima/ima_queue.c  |    9 +++--
>   6 files changed, 78 insertions(+), 32 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index a0c5c5f..6fe6634 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -995,6 +995,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   			programs exec'd, files mmap'd for exec, and all files
>   			opened for read by uid=0.
>
> +	ima_denycall_on_errors=
> +			[IMA]
> +			Format: { "0" | "1" }
> +			0 -- execute the system call even if the inode was not
> +			     measured. (Default)
> +			1 -- deny the system call execution if the inode
> +			     measurement was failed.
> +
>   	init=		[KNL]
>   			Format:<full_path>
>   			Run specified binary instead of /sbin/init as init
> diff --git a/security/integrity/ima/ima.h b/security/integrity/ima/ima.h
> index 3ccf7ac..79e259c 100644
> --- a/security/integrity/ima/ima.h
> +++ b/security/integrity/ima/ima.h
> @@ -38,6 +38,7 @@ enum tpm_pcrs { TPM_PCR0 = 0, TPM_PCR8 = 8 };
>
>   /* set during initialization */
>   extern int ima_initialized;
> +extern int ima_enforce;
>   extern int ima_used_chip;
>   extern char *ima_hash;
>
> @@ -77,7 +78,7 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>   int ima_calc_hash(struct file *file, char *digest);
>   int ima_calc_template_hash(int template_len, void *template, char *digest);
>   int ima_calc_boot_aggregate(char *digest);
> -void ima_add_violation(struct inode *inode, const unsigned char *filename,
> +int ima_add_violation(struct inode *inode, const unsigned char *filename,
>   		       const char *op, const char *cause);
>
>   /*
> @@ -101,7 +102,7 @@ static inline unsigned long ima_hash_key(u8 *digest)
>   int ima_must_measure(struct inode *inode, int mask, int function);
>   int ima_collect_measurement(struct integrity_iint_cache *iint,
>   			    struct file *file);
> -void ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
> +int ima_store_measurement(struct integrity_iint_cache *iint, struct file *file,
>   			   const unsigned char *filename);
>   int ima_store_template(struct ima_template_entry *entry, int violation,
>   		       struct inode *inode);
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 88a2788..bae5b9e 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -67,7 +67,7 @@ int ima_store_template(struct ima_template_entry *entry,
>    * By extending the PCR with 0xFF's instead of with zeroes, the PCR
>    * value is invalidated.
>    */
> -void ima_add_violation(struct inode *inode, const unsigned char *filename,
> +int ima_add_violation(struct inode *inode, const unsigned char *filename,
>   		       const char *op, const char *cause)
>   {
>   	struct ima_template_entry *entry;
> @@ -90,6 +90,7 @@ void ima_add_violation(struct inode *inode, const unsigned char *filename,
>   err_out:
>   	integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
>   			    op, cause, result, 0);
> +	return result;
>   }
>
>   /**
> @@ -157,7 +158,7 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>    *
>    * Must be called with iint->mutex held.
>    */
> -void ima_store_measurement(struct integrity_iint_cache *iint,
> +int ima_store_measurement(struct integrity_iint_cache *iint,
>   			   struct file *file, const unsigned char *filename)
>   {
>   	const char *op = "add_template_measure";
> @@ -171,15 +172,18 @@ void ima_store_measurement(struct integrity_iint_cache *iint,
>   	if (!entry) {
>   		integrity_audit_msg(AUDIT_INTEGRITY_PCR, inode, filename,
>   				    op, audit_cause, result, 0);
> -		return;
> +		return result;
>   	}
>   	memset(&entry->template, 0, sizeof(entry->template));
>   	memcpy(entry->template.digest, iint->digest, IMA_DIGEST_SIZE);
>   	strncpy(entry->template.file_name, filename, IMA_EVENT_NAME_LEN_MAX);
>
>   	result = ima_store_template(entry, violation, inode);
> -	if (!result || result == -EEXIST)
> +	if (!result || result == -EEXIST) {
>   		iint->flags |= IMA_MEASURED;
> +		result = 0;
> +	}
>   	if (result<  0)
>   		kfree(entry);
> +	return result;
>   }
> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> index 17f1f06..7e29d6f 100644
> --- a/security/integrity/ima/ima_init.c
> +++ b/security/integrity/ima/ima_init.c
> @@ -39,7 +39,7 @@ int ima_used_chip;
>    * a different value.) Violations add a zero entry to the measurement
>    * list and extend the aggregate PCR value with ff...ff's.
>    */
> -static void __init ima_add_boot_aggregate(void)
> +static int __init ima_add_boot_aggregate(void)
>   {
>   	struct ima_template_entry *entry;
>   	const char *op = "add_boot_aggregate";
> @@ -66,10 +66,12 @@ static void __init ima_add_boot_aggregate(void)
>   	result = ima_store_template(entry, violation, NULL);
>   	if (result<  0)
>   		kfree(entry);
> -	return;
> +	goto out;
>   err_out:
>   	integrity_audit_msg(AUDIT_INTEGRITY_PCR, NULL, boot_aggregate_name, op,
>   			    audit_cause, result, 0);
> +out:
> +	return result;
>   }
>
>   int __init ima_init(void)
> @@ -85,7 +87,10 @@ int __init ima_init(void)
>   	if (!ima_used_chip)
>   		pr_info("IMA: No TPM chip found, activating TPM-bypass!\n");
>
> -	ima_add_boot_aggregate();	/* boot aggregate must be first entry */
> +	rc = ima_add_boot_aggregate();	/* boot aggregate must be first entry */
> +	if (rc != 0)
> +		return -EACCES;
> +
>   	ima_init_policy();
>
>   	return ima_fs_init();
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 1eff5cb..9f2edf5 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -27,6 +27,20 @@
>   #include "ima.h"
>
>   int ima_initialized;
> +int ima_enforce;
> +
> +/* ima_denycall_setup - deny syscall execution when inode measurement fails */
> +int ima_denycall_on_errors;
> +static int __init ima_denycall_setup(char *str)
> +{
> +	unsigned long deny;
> +
> +	ima_denycall_on_errors = 0;
> +	if (!kstrtoul(str, 0,&deny))
> +		ima_denycall_on_errors = deny ? 1 : 0;
> +	return 1;
> +}
> +__setup("ima_denycall_on_errors=", ima_denycall_setup);
>
>   char *ima_hash = "sha1";
>   static int __init hash_setup(char *str)
> @@ -47,16 +61,16 @@ __setup("ima_hash=", hash_setup);
>    * 	  could result in a file measurement error.
>    *
>    */
> -static void ima_rdwr_violation_check(struct file *file)
> +static int ima_rdwr_violation_check(struct file *file)
>   {
>   	struct dentry *dentry = file->f_path.dentry;
>   	struct inode *inode = dentry->d_inode;
>   	fmode_t mode = file->f_mode;
> -	int rc;
> +	int rc = 0;
>   	bool send_tomtou = false, send_writers = false;
>
>   	if (!S_ISREG(inode->i_mode) || !ima_initialized)
> -		return;
> +		return 0;
>
>   	mutex_lock(&inode->i_mutex);	/* file metadata: permissions, xattr */
>
> @@ -67,8 +81,10 @@ static void ima_rdwr_violation_check(struct file *file)
>   	}
>
>   	rc = ima_must_measure(inode, MAY_READ, FILE_CHECK);
> -	if (rc<  0)
> +	if (rc<  0) {
> +		rc = 0;
>   		goto out;
> +	}
>
>   	if (atomic_read(&inode->i_writecount)>  0)
>   		send_writers = true;
> @@ -76,11 +92,12 @@ out:
>   	mutex_unlock(&inode->i_mutex);
>
>   	if (send_tomtou)
> -		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
> -				  "ToMToU");
> +		rc = ima_add_violation(inode, dentry->d_name.name,
> +				       "invalid_pcr", "ToMToU");
>   	if (send_writers)
> -		ima_add_violation(inode, dentry->d_name.name, "invalid_pcr",
> -				  "open_writers");
> +		rc = ima_add_violation(inode, dentry->d_name.name,
> +				       "invalid_pcr", "open_writers");
> +	return (!rc) ? 0 : -EACCES;
>   }
>
>   static void ima_check_last_writer(struct integrity_iint_cache *iint,
> @@ -130,28 +147,31 @@ static int process_measurement(struct file *file, const unsigned char *filename,
>
>   	rc = ima_must_measure(inode, mask, function);
>   	if (rc != 0)
> -		return rc;
> +		return 0;
>   retry:
>   	iint = integrity_iint_find(inode);
>   	if (!iint) {
>   		rc = integrity_inode_alloc(inode);
> -		if (!rc || rc == -EEXIST)
> +		if (!rc || rc == -EEXIST) {
> +			rc = 0;
>   			goto retry;
> +		}
>   		return rc;
>   	}
>
>   	mutex_lock(&iint->mutex);
>
> -	rc = iint->flags&  IMA_MEASURED ? 1 : 0;
> -	if (rc != 0)
> +	if (iint->flags&  IMA_MEASURED)
>   		goto out;
>
>   	rc = ima_collect_measurement(iint, file);
> -	if (!rc)
> -		ima_store_measurement(iint, file, filename);
> +	if (rc != 0)
> +		goto out;
> +
> +	rc = ima_store_measurement(iint, file, filename);
>   out:
>   	mutex_unlock(&iint->mutex);
> -	return rc;
> +	return (!rc) ? 0 : -EACCES;
>   }
>
>   /**
> @@ -167,14 +187,14 @@ out:
>    */
>   int ima_file_mmap(struct file *file, unsigned long prot)
>   {
> -	int rc;
> +	int rc = 0;
>
>   	if (!file)
>   		return 0;
>   	if (prot&  PROT_EXEC)
>   		rc = process_measurement(file, file->f_dentry->d_name.name,
>   					 MAY_EXEC, FILE_MMAP);
> -	return 0;
> +	return (ima_enforce) ? rc : 0;
>   }
>
>   /**
> @@ -196,7 +216,7 @@ int ima_bprm_check(struct linux_binprm *bprm)
>
>   	rc = process_measurement(bprm->file, bprm->filename,
>   				 MAY_EXEC, BPRM_CHECK);
> -	return 0;
> +	return (ima_enforce) ? rc : 0;
>   }
>
>   /**
> @@ -213,11 +233,15 @@ int ima_file_check(struct file *file, int mask)
>   {
>   	int rc;
>
> -	ima_rdwr_violation_check(file);
> +	rc = ima_rdwr_violation_check(file);
> +	if (rc != 0&&  ima_enforce)
> +		goto out;
> +
>   	rc = process_measurement(file, file->f_dentry->d_name.name,
>   				 mask&  (MAY_READ | MAY_WRITE | MAY_EXEC),
>   				 FILE_CHECK);
> -	return 0;
> +out:
> +	return (ima_enforce) ? rc : 0;
>   }
>   EXPORT_SYMBOL_GPL(ima_file_check);
>
> @@ -226,6 +250,7 @@ static int __init init_ima(void)
>   	int error;
>
>   	error = ima_init();
> +	ima_enforce |= ima_denycall_on_errors;
>   	ima_initialized = 1;
>   	return error;
>   }
> diff --git a/security/integrity/ima/ima_queue.c b/security/integrity/ima/ima_queue.c
> index 7ae1e9a..cc1989f 100644
> --- a/security/integrity/ima/ima_queue.c
> +++ b/security/integrity/ima/ima_queue.c
> @@ -147,9 +147,12 @@ int ima_add_template_entry(struct ima_template_entry *entry, int violation,
>   	if (result != 0) {
>   		audit_cause = "TPM error";
>   		audit_info = 0;
> -		result = -ECOMM;
> -		kfree(qe);
> -		goto out;
> +		result = 1;
> +		if (ima_enforce) {
> +			result = -ECOMM;
> +			kfree(qe);
> +			goto out;
> +		}
>   	}
>
>   	ima_add_digest_entry(qe);

