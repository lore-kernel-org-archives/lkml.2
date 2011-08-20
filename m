Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab1HTMWo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 08:22:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab1HTMWn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 08:22:43 -0400
Message-ID: <4E4FA6D8.7030407@redhat.com>
Date: Sat, 20 Aug 2011 08:21:44 -0400
From: Josef Bacik <josef@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Liu Bo <liubo2009@cn.fujitsu.com>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mingo@kernel.org, jwboyer@gmail.com, linux-btrfs@vger.kernel.org,
        chris.mason@oracle.com, dave@jikos.cz
Subject: Re: [PATCH v2] Btrfs: use do_div to avoid compile errors on 32bit
 box
References: <1313806667-30495-1-git-send-email-liubo2009@cn.fujitsu.com>
In-Reply-To: <1313806667-30495-1-git-send-email-liubo2009@cn.fujitsu.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2011 10:17 PM, Liu Bo wrote:
> When doing div operation of u64 type, we need to be careful and use do_div
> to avoid compile ERROR on 32bit box:
> 
> "ERROR: "__udivdi3" [fs/btrfs/btrfs.ko] undefined!
> make[1]: *** [__modpost] Error 1
> 
> v1->v2:
> - fix stupid do_div() with type "signed integer".
> 
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> ---
>  fs/btrfs/extent-tree.c |   11 ++++++-----
>  1 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index 80d6148..e43e4f1 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6735,9 +6735,10 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>  	struct btrfs_fs_devices *fs_devices = root->fs_info->fs_devices;
>  	struct btrfs_device *device;
>  	u64 min_free;
> +	u32 dev_min = 1;
> +	u32 dev_nr = 0;
> +	u32 dup = 2;
>  	int index;
> -	int dev_nr = 0;
> -	int dev_min = 1;
>  	int full = 0;
>  	int ret = 0;
>  
> @@ -6796,14 +6797,14 @@ int btrfs_can_relocate(struct btrfs_root *root, u64 bytenr)
>  	index = get_block_group_index(block_group);
>  	if (index == 0) {
>  		dev_min = 4;
> -		min_free /= 2;
> +		do_div(min_free, dup);

I think Linus was less complaining about how you're dividing here and
more about the fact that you are.  A divide by 2 is the same as a >> 1.
 I'll send a patch to fix this.  Thanks,

Josef
