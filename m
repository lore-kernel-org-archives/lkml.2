Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab0C3TXk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 15:23:40 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43498 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab0C3TXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 15:23:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pmkpxvVr9eEZqf+2rLdkqQF/yQz3GIlLmiHOuWW84YmTELXHTuUkY2EQZy1GDF6WFL
         D2C87VGtCNmswNNiAmR6VL2DkwDuNEWGdlTRW0etAXofcexQfE96UnNs3uybvwNUZZDp
         gn86HPbj9Qnbk1iKmZ3dJRLYbZVN+PmkzH2KA=
Subject: Re: [PATCH 1/6] sysfs: Basic support for multiple super blocks
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, linux-fsdevel@vger.kernel.org,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       netdev@vger.kernel.org
In-Reply-To: <1269973889-25260-1-git-send-email-ebiederm@xmission.com>
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>
	 <1269973889-25260-1-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 30 Mar 2010 21:23:32 +0200
Message-ID: <1269977012.2048.0.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 30 mars 2010 à 11:31 -0700, Eric W. Biederman a écrit :
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Add all of the necessary bioler plate to support
> multiple superblocks in sysfs.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/sysfs/mount.c |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/sysfs/sysfs.h |    3 ++
>  2 files changed, 59 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/sysfs/mount.c b/fs/sysfs/mount.c
> index 0cb1088..6a433ac 100644
> --- a/fs/sysfs/mount.c
> +++ b/fs/sysfs/mount.c
> @@ -71,16 +71,70 @@ static int sysfs_fill_super(struct super_block *sb, void *data, int silent)
>  	return 0;
>  }
>  
> +static int sysfs_test_super(struct super_block *sb, void *data)
> +{
> +	struct sysfs_super_info *sb_info = sysfs_info(sb);
> +	struct sysfs_super_info *info = data;
> +	int found = 1;
> +	return found;
> +}
> +
> +static int sysfs_set_super(struct super_block *sb, void *data)
> +{
> +	int error;
> +	error = set_anon_super(sb, data);
> +	if (!error)
> +		sb->s_fs_info = data;
> +	return error;
> +}
> +
>  static int sysfs_get_sb(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> -	return get_sb_single(fs_type, flags, data, sysfs_fill_super, mnt);
> +	struct sysfs_super_info *info;
> +	struct super_block *sb;
> +	int error;
> +
> +	error = -ENOMEM;
> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
> +	if (!info)
> +		goto out;
> +	sb = sget(fs_type, sysfs_test_super, sysfs_set_super, info);
> +	if (IS_ERR(sb) || sb->s_fs_info != info)
> +		kfree(info);
> +	if (IS_ERR(sb)) {
> +		kfree(info);

double kfree(info) ?

> +		error = PTR_ERR(sb);
> +		goto out;
> +	}
> +


