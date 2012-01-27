Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2A0TeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 14:34:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60755 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453Ab2A0TeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 14:34:11 -0500
Message-ID: <4F22FC2E.3000400@canonical.com>
Date: Fri, 27 Jan 2012 11:34:06 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120119 Thunderbird/10.0
MIME-Version: 1.0
To: Kees Cook <kees@ubuntu.com>
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kees Cook <kees@outflux.net>
Subject: Re: [PATCH 1/4] AppArmor: refactor securityfs to use structures
References: <1327624163-21576-1-git-send-email-kees@ubuntu.com> <1327624163-21576-2-git-send-email-kees@ubuntu.com>
In-Reply-To: <1327624163-21576-2-git-send-email-kees@ubuntu.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2012 04:29 PM, Kees Cook wrote:
> From: Kees Cook <kees@outflux.net>
> 
> Use a file tree structure to represent the AppArmor securityfs.
> 
> Signed-off-by: Kees Cook <kees@ubuntu.com>
Acked-by: John Johansen <john.johansen@canonical.com>

> ---
>  security/apparmor/apparmorfs.c         |  132 ++++++++++++++++++++++----------
>  security/apparmor/include/apparmorfs.h |   24 ++++++
>  2 files changed, 114 insertions(+), 42 deletions(-)
> 
> diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
> index e39df6d..1e22bb3 100644
> --- a/security/apparmor/apparmorfs.c
> +++ b/security/apparmor/apparmorfs.c
> @@ -144,36 +144,103 @@ static const struct file_operations aa_fs_profile_remove = {
>  
>  /** Base file system setup **/
>  
> -static struct dentry *aa_fs_dentry __initdata;
> +static struct aa_fs_entry aa_fs_entry_apparmor[] = {
> +	AA_FS_FILE_FOPS(".load", 0640, &aa_fs_profile_load),
> +	AA_FS_FILE_FOPS(".replace", 0640, &aa_fs_profile_replace),
> +	AA_FS_FILE_FOPS(".remove", 0640, &aa_fs_profile_remove),
> +	{ }
> +};
>  
> -static void __init aafs_remove(const char *name)
> -{
> -	struct dentry *dentry;
> +static struct aa_fs_entry aa_fs_entry =
> +	AA_FS_DIR("apparmor", aa_fs_entry_apparmor);
>  
> -	dentry = lookup_one_len(name, aa_fs_dentry, strlen(name));
> -	if (!IS_ERR(dentry)) {
> -		securityfs_remove(dentry);
> -		dput(dentry);
> +/**
> + * aafs_create_file - create a file entry in the apparmor securityfs
> + * @fs_file: aa_fs_entry to build an entry for (NOT NULL)
> + * @parent: the parent dentry in the securityfs
> + *
> + * Use aafs_remove_file to remove entries created with this fn.
> + */
> +static int __init aafs_create_file(struct aa_fs_entry *fs_file,
> +				   struct dentry *parent)
> +{
> +	int error = 0;
> +
> +	fs_file->dentry = securityfs_create_file(fs_file->name,
> +						 S_IFREG | fs_file->mode,
> +						 parent, fs_file,
> +						 fs_file->file_ops);
> +	if (IS_ERR(fs_file->dentry)) {
> +		error = PTR_ERR(fs_file->dentry);
> +		fs_file->dentry = NULL;
>  	}
> +	return error;
>  }
>  
>  /**
> - * aafs_create - create an entry in the apparmor filesystem
> - * @name: name of the entry (NOT NULL)
> - * @mask: file permission mask of the file
> - * @fops: file operations for the file (NOT NULL)
> + * aafs_create_dir - recursively create a directory entry in the securityfs
> + * @fs_dir: aa_fs_entry (and all child entries) to build (NOT NULL)
> + * @parent: the parent dentry in the securityfs
>   *
> - * Used aafs_remove to remove entries created with this fn.
> + * Use aafs_remove_dir to remove entries created with this fn.
>   */
> -static int __init aafs_create(const char *name, umode_t mask,
> -			      const struct file_operations *fops)
> +static int __init aafs_create_dir(struct aa_fs_entry *fs_dir,
> +				  struct dentry *parent)
>  {
> -	struct dentry *dentry;
> +	int error;
> +	struct aa_fs_entry *fs_file;
>  
> -	dentry = securityfs_create_file(name, S_IFREG | mask, aa_fs_dentry,
> -					NULL, fops);
> +	fs_dir->dentry = securityfs_create_dir(fs_dir->name, parent);
> +	if (IS_ERR(fs_dir->dentry)) {
> +		error = PTR_ERR(fs_dir->dentry);
> +		fs_dir->dentry = NULL;
> +		goto failed;
> +	}
>  
> -	return IS_ERR(dentry) ? PTR_ERR(dentry) : 0;
> +	for (fs_file = fs_dir->v.files; fs_file->name; ++fs_file) {
> +		if (fs_file->v_type == AA_FS_TYPE_DIR)
> +			error = aafs_create_dir(fs_file, fs_dir->dentry);
> +		else
> +			error = aafs_create_file(fs_file, fs_dir->dentry);
> +		if (error)
> +			goto failed;
> +	}
> +
> +	return 0;
> +
> +failed:
> +	return error;
> +}
> +
> +/**
> + * aafs_remove_file - drop a single file entry in the apparmor securityfs
> + * @fs_file: aa_fs_entry to detach from the securityfs (NOT NULL)
> + */
> +static void __init aafs_remove_file(struct aa_fs_entry *fs_file)
> +{
> +	if (!fs_file->dentry)
> +		return;
> +
> +	securityfs_remove(fs_file->dentry);
> +	fs_file->dentry = NULL;
> +}
> +
> +/**
> + * aafs_remove_dir - recursively drop a directory entry from the securityfs
> + * @fs_dir: aa_fs_entry (and all child entries) to detach (NOT NULL)
> + */
> +static void __init aafs_remove_dir(struct aa_fs_entry *fs_dir)
> +{
> +	struct aa_fs_entry *fs_file;
> +
> +	for (fs_file = fs_dir->v.files; fs_file->name; ++fs_file) {
> +		if (fs_file->v_type == AA_FS_TYPE_DIR)
> +			aafs_remove_dir(fs_file);
> +		else
> +			aafs_remove_file(fs_file);
> +	}
> +
> +	aafs_remove_file(fs_dir);
>  }
>  
>  /**
> @@ -183,14 +250,7 @@ static int __init aafs_create(const char *name, umode_t mask,
>   */
>  void __init aa_destroy_aafs(void)
>  {
> -	if (aa_fs_dentry) {
> -		aafs_remove(".remove");
> -		aafs_remove(".replace");
> -		aafs_remove(".load");
> -
> -		securityfs_remove(aa_fs_dentry);
> -		aa_fs_dentry = NULL;
> -	}
> +	aafs_remove_dir(&aa_fs_entry);
>  }
>  
>  /**
> @@ -207,25 +267,13 @@ static int __init aa_create_aafs(void)
>  	if (!apparmor_initialized)
>  		return 0;
>  
> -	if (aa_fs_dentry) {
> +	if (aa_fs_entry.dentry) {
>  		AA_ERROR("%s: AppArmor securityfs already exists\n", __func__);
>  		return -EEXIST;
>  	}
>  
> -	aa_fs_dentry = securityfs_create_dir("apparmor", NULL);
> -	if (IS_ERR(aa_fs_dentry)) {
> -		error = PTR_ERR(aa_fs_dentry);
> -		aa_fs_dentry = NULL;
> -		goto error;
> -	}
> -
> -	error = aafs_create(".load", 0640, &aa_fs_profile_load);
> -	if (error)
> -		goto error;
> -	error = aafs_create(".replace", 0640, &aa_fs_profile_replace);
> -	if (error)
> -		goto error;
> -	error = aafs_create(".remove", 0640, &aa_fs_profile_remove);
> +	/* Populate fs tree. */
> +	error = aafs_create_dir(&aa_fs_entry, NULL);
>  	if (error)
>  		goto error;
>  
> diff --git a/security/apparmor/include/apparmorfs.h b/security/apparmor/include/apparmorfs.h
> index cb1e93a..4fdf02f 100644
> --- a/security/apparmor/include/apparmorfs.h
> +++ b/security/apparmor/include/apparmorfs.h
> @@ -15,6 +15,30 @@
>  #ifndef __AA_APPARMORFS_H
>  #define __AA_APPARMORFS_H
>  
> +enum aa_fs_type {
> +	AA_FS_TYPE_FOPS,
> +	AA_FS_TYPE_DIR,
> +};
> +
> +struct aa_fs_entry;
> +
> +struct aa_fs_entry {
> +	const char *name;
> +	struct dentry *dentry;
> +	umode_t mode;
> +	enum aa_fs_type v_type;
> +	union {
> +		struct aa_fs_entry *files;
> +	} v;
> +	const struct file_operations *file_ops;
> +};
> +
> +#define AA_FS_FILE_FOPS(_name, _mode, _fops) \
> +	{ .name = (_name), .v_type = AA_FS_TYPE_FOPS, \
> +	  .mode = (_mode), .file_ops = (_fops) }
> +#define AA_FS_DIR(_name, _value) \
> +	{ .name = (_name), .v_type = AA_FS_TYPE_DIR, .v.files = (_value) }
> +
>  extern void __init aa_destroy_aafs(void);
>  
>  #endif /* __AA_APPARMORFS_H */

