Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0KLS5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 13:57:11 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56172 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab0KLS5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 13:57:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uNL5/IbO+dK1E5rxErWu5g5EdP8045LInHKnYlT2yhjwcwzRy3UbTO2Cim/r46/lIJ
         dtbfwGnFhwRcdp1bvqxBGcWmQHzUvfkP+r12ZTFWtaoEnfg7hotciAY1XrC9wZUKXBlU
         EHh62zto+zPQ3Ujo07K0mSQwM6RvD46CeWiMg=
Date: Fri, 12 Nov 2010 10:57:00 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Stefan Achatz <stefan_achatz@web.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@aristanetworks.com>,
        "Serge E. Hallyn" <serue@us.ibm.com>, Tejun Heo <tj@kernel.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 1/2] sysfs: Introducing sysfs_create_bin_group()
Message-ID: <20101112185700.GE1224@core.coreip.homeip.net>
References: <1289585918.2629.12.camel@neuromancer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289585918.2629.12.camel@neuromancer>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 12, 2010 at 07:18:38PM +0100, Stefan Achatz wrote:
> Implemented group functions for easier creation of multiple binary sysfs
> attributes similar to existing attribute_group handling functions.
> The code reuses struct attribute_group instead of inventing a new struct
> binary_attribute_group.
> 
> Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>

Looks good to me, thanks for implementing this.

> ---
>  fs/sysfs/group.c      |   76 ++++++++++++++++++++++++++++++++++++------------
>  include/linux/sysfs.h |   11 +++++++
>  2 files changed, 68 insertions(+), 19 deletions(-)
> 
> diff --git a/fs/sysfs/group.c b/fs/sysfs/group.c
> index 442f34f..841baed 100644
> --- a/fs/sysfs/group.c
> +++ b/fs/sysfs/group.c
> @@ -27,7 +27,7 @@ static void remove_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  }
>  
>  static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
> -			const struct attribute_group *grp, int update)
> +			const struct attribute_group *grp, int update, int type)
>  {
>  	struct attribute *const* attr;
>  	int error = 0, i;
> @@ -45,7 +45,7 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  			if (!mode)
>  				continue;
>  		}
> -		error = sysfs_add_file_mode(dir_sd, *attr, SYSFS_KOBJ_ATTR,
> +		error = sysfs_add_file_mode(dir_sd, *attr, type,
>  					    (*attr)->mode | mode);
>  		if (unlikely(error))
>  			break;
> @@ -57,7 +57,7 @@ static int create_files(struct sysfs_dirent *dir_sd, struct kobject *kobj,
>  
>  
>  static int internal_create_group(struct kobject *kobj, int update,
> -				 const struct attribute_group *grp)
> +				 const struct attribute_group *grp, int type)
>  {
>  	struct sysfs_dirent *sd;
>  	int error;
> @@ -75,7 +75,7 @@ static int internal_create_group(struct kobject *kobj, int update,
>  	} else
>  		sd = kobj->sd;
>  	sysfs_get(sd);
> -	error = create_files(sd, kobj, grp, update);
> +	error = create_files(sd, kobj, grp, update, type);
>  	if (error) {
>  		if (grp->name)
>  			sysfs_remove_subdir(sd);
> @@ -97,9 +97,16 @@ static int internal_create_group(struct kobject *kobj, int update,
>  int sysfs_create_group(struct kobject *kobj,
>  		       const struct attribute_group *grp)
>  {
> -	return internal_create_group(kobj, 0, grp);
> +	return internal_create_group(kobj, 0, grp, SYSFS_KOBJ_ATTR);
>  }
>  
> +int sysfs_create_bin_group(struct kobject *kobj,
> +			   const struct attribute_group *grp)
> +{
> +	return internal_create_group(kobj, 0, grp, SYSFS_KOBJ_BIN_ATTR);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_create_bin_group);
> +
>  /**
>   * sysfs_update_group - given a directory kobject, create an attribute group
>   * @kobj:	The kobject to create the group on
> @@ -120,10 +127,15 @@ int sysfs_create_group(struct kobject *kobj,
>  int sysfs_update_group(struct kobject *kobj,
>  		       const struct attribute_group *grp)
>  {
> -	return internal_create_group(kobj, 1, grp);
> +	return internal_create_group(kobj, 1, grp, SYSFS_KOBJ_ATTR);
>  }
>  
> -
> +int sysfs_update_bin_group(struct kobject *kobj,
> +			   const struct attribute_group *grp)
> +{
> +	return internal_create_group(kobj, 1, grp, SYSFS_KOBJ_BIN_ATTR);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_update_bin_group);
>  
>  void sysfs_remove_group(struct kobject * kobj, 
>  			const struct attribute_group * grp)
> @@ -148,17 +160,15 @@ void sysfs_remove_group(struct kobject * kobj,
>  	sysfs_put(sd);
>  }
>  
> -/**
> - * sysfs_merge_group - merge files into a pre-existing attribute group.
> - * @kobj:	The kobject containing the group.
> - * @grp:	The files to create and the attribute group they belong to.
> - *
> - * This function returns an error if the group doesn't exist or any of the
> - * files already exist in that group, in which case none of the new files
> - * are created.
> - */
> -int sysfs_merge_group(struct kobject *kobj,
> -		       const struct attribute_group *grp)
> +void sysfs_remove_bin_group(struct kobject * kobj,
> +			    const struct attribute_group * grp)
> +{
> +	sysfs_remove_group(kobj, grp);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_remove_bin_group);
> +
> +int internal_merge_group(struct kobject *kobj,
> +		       const struct attribute_group *grp, int type)
>  {
>  	struct sysfs_dirent *dir_sd;
>  	int error = 0;
> @@ -173,7 +183,7 @@ int sysfs_merge_group(struct kobject *kobj,
>  		return -ENOENT;
>  
>  	for ((i = 0, attr = grp->attrs); *attr && !error; (++i, ++attr))
> -		error = sysfs_add_file(dir_sd, *attr, SYSFS_KOBJ_ATTR);
> +		error = sysfs_add_file(dir_sd, *attr, type);
>  	if (error) {
>  		while (--i >= 0)
>  			sysfs_hash_and_remove(dir_sd, NULL, (*--attr)->name);
> @@ -182,8 +192,30 @@ int sysfs_merge_group(struct kobject *kobj,
>  
>  	return error;
>  }
> +
> +/**
> + * sysfs_merge_group - merge files into a pre-existing attribute group.
> + * @kobj:	The kobject containing the group.
> + * @grp:	The files to create and the attribute group they belong to.
> + *
> + * This function returns an error if the group doesn't exist or any of the
> + * files already exist in that group, in which case none of the new files
> + * are created.
> + */
> +int sysfs_merge_group(struct kobject *kobj,
> +		       const struct attribute_group *grp)
> +{
> +	return internal_merge_group(kobj, grp, SYSFS_KOBJ_ATTR);
> +}
>  EXPORT_SYMBOL_GPL(sysfs_merge_group);
>  
> +int sysfs_merge_bin_group(struct kobject *kobj,
> +			  const struct attribute_group *grp)
> +{
> +	return internal_merge_group(kobj, grp, SYSFS_KOBJ_BIN_ATTR);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_merge_bin_group);
> +
>  /**
>   * sysfs_unmerge_group - remove files from a pre-existing attribute group.
>   * @kobj:	The kobject containing the group.
> @@ -207,6 +239,12 @@ void sysfs_unmerge_group(struct kobject *kobj,
>  }
>  EXPORT_SYMBOL_GPL(sysfs_unmerge_group);
>  
> +void sysfs_unmerge_bin_group(struct kobject *kobj,
> +			     const struct attribute_group *grp)
> +{
> +	sysfs_unmerge_group(kobj, grp);
> +}
> +EXPORT_SYMBOL_GPL(sysfs_unmerge_bin_group);
>  
>  EXPORT_SYMBOL_GPL(sysfs_create_group);
>  EXPORT_SYMBOL_GPL(sysfs_update_group);
> diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
> index 30b8815..653b0b0 100644
> --- a/include/linux/sysfs.h
> +++ b/include/linux/sysfs.h
> @@ -169,6 +169,17 @@ int sysfs_merge_group(struct kobject *kobj,
>  void sysfs_unmerge_group(struct kobject *kobj,
>  		       const struct attribute_group *grp);
>  
> +int sysfs_create_bin_group(struct kobject *kobj,
> +			   const struct attribute_group *grp);
> +int sysfs_update_bin_group(struct kobject *kobj,
> +			   const struct attribute_group *grp);
> +void sysfs_remove_bin_group(struct kobject * kobj,
> +			const struct attribute_group * grp);
> +int sysfs_merge_bin_group(struct kobject *kobj,
> +		       const struct attribute_group *grp);
> +void sysfs_unmerge_bin_group(struct kobject *kobj,
> +		       const struct attribute_group *grp);
> +
>  void sysfs_notify(struct kobject *kobj, const char *dir, const char *attr);
>  void sysfs_notify_dirent(struct sysfs_dirent *sd);
>  struct sysfs_dirent *sysfs_get_dirent(struct sysfs_dirent *parent_sd,
> -- 
> 1.7.2.3
> 
> 
> 

-- 
Dmitry
