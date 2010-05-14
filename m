Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757716Ab0ENRTW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 13:19:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:33339 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755069Ab0ENRTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 13:19:19 -0400
Message-ID: <4BED8933.4060100@suse.de>
Date: Sat, 15 May 2010 01:32:35 +0800
From: Coly Li <coly.li@suse.de>
Reply-To: coly.li@suse.de
Organization: SuSE Labs
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.15 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, neilb@suse.de,
       linux-fsdevel@vger.kernel.org, sfrench@us.ibm.com,
       philippe.deniel@CEA.FR, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 6/9] ext4: Add get_fsid callback
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
In-Reply-To: <1273679444-14903-7-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/12/2010 11:50 PM, Aneesh Kumar K.V Wrote:
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> ---
>  fs/ext4/super.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index e14d22c..fc7d464 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1049,6 +1049,19 @@ static int bdev_try_to_free_page(struct super_block *sb, struct page *page,
>  	return try_to_free_buffers(page);
>  }
>  
> +static int ext4_get_fsid(struct super_block *sb, struct uuid *fsid)
> +{
> +	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct ext4_super_block *es = sbi->s_es;
> +
> +	memcpy(fsid->uuid, es->s_uuid, sizeof(fsid->uuid));
> +	/*
> +	 * We may want to make sure we return error if the s_uuid is not
> +	 * exactly unique
> +	 */
> +	return 0;
> +}
> +
>  #ifdef CONFIG_QUOTA
>  #define QTYPE2NAME(t) ((t) == USRQUOTA ? "user" : "group")
>  #define QTYPE2MOPT(on, t) ((t) == USRQUOTA?((on)##USRJQUOTA):((on)##GRPJQUOTA))
> @@ -1109,6 +1122,7 @@ static const struct super_operations ext4_sops = {
>  	.quota_write	= ext4_quota_write,
>  #endif
>  	.bdev_try_to_free_page = bdev_try_to_free_page,
> +	.get_fsid	= ext4_get_fsid,
>  };
>  
>  static const struct super_operations ext4_nojournal_sops = {
> @@ -1128,6 +1142,7 @@ static const struct super_operations ext4_nojournal_sops = {
>  	.quota_write	= ext4_quota_write,
>  #endif
>  	.bdev_try_to_free_page = bdev_try_to_free_page,
> +	.get_fsid	= ext4_get_fsid,
>  };
>  

Hi Aneesh,

Just wondering why not call sb->s_op->statfs() to get the fsid in do_sys_name_to_handle() ?
The overhead is a little bit more code to get fsid from struct kstatfs, but we can gain,
1) avoid to have one more callback in struct super_operations.
2) more file system can be supported (since most of file systems have statfs() call back)

Thanks.
-- 
Coly Li
SuSE Labs
