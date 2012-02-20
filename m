Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab2BTXsE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 18:48:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9740 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab2BTXrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 18:47:49 -0500
Message-ID: <4F42DBA0.4090502@redhat.com>
Date: Mon, 20 Feb 2012 17:47:44 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Haogang Chen <haogangchen@gmail.com>
CC: Theodore Tso <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yongqiang Yang <xiaoqiangnk@gmail.com>
Subject: Re: [PATCH] FS: ext4: fix integer overflow in alloc_flex_gd()
References: <1329777684-18396-1-git-send-email-haogangchen@gmail.com>
In-Reply-To: <1329777684-18396-1-git-send-email-haogangchen@gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/20/12 4:41 PM, Haogang Chen wrote:
> In alloc_flex_gd(), when flexbg_size is large, kmalloc size would
> overflow and flex_gd->groups would point to a buffer smaller than
> expected, causing OOB accesses when it is used.
> 
> Note that in ext4_resize_fs(), flexbg_size is calculated using
> sbi->s_log_groups_per_flex, which is read from the disk and only bounded
> to [1, 31]. The patch returns NULL for too large flexbg_size

Hm this raises a few questions I think.

On the one hand, making sure the kmalloc arg doesn't overflow here is
certainly a good thing and probably the right thing to do in the short term.

So I guess:

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

for that, to close the hole.

But the types are a mess; alloc_flex_gd() takes an unsigned long; 
it's passed an int, and assigns to flex_gd->count, an ext4_group_t
(which is an unsigned int). They should probably all be ext4_group_t
for consistency.

But that's not the worst of it...

Doesn't this also mean that a valid s_log_groups_per_flex (i.e. 31)
will fail in this resize code?  That would be an unexpected outcome.
2^31 groups per flex is a little crazy, but still technically valid
according to the limits in the code.

So really, trying to allocate an array of all possible groups-per-flex
in the resize code is probably a really bad idea to start with, and the
resize code has got serious problems if kmalloc(UINT_MAX-1) is expected
to work...

-Eric

> Signed-off-by: Haogang Chen <haogangchen@gmail.com>
> ---
>  fs/ext4/resize.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ext4/resize.c b/fs/ext4/resize.c
> index f9d948f..8601f4b 100644
> --- a/fs/ext4/resize.c
> +++ b/fs/ext4/resize.c
> @@ -161,6 +161,8 @@ static struct ext4_new_flex_group_data *alloc_flex_gd(unsigned long flexbg_size)
>  	if (flex_gd == NULL)
>  		goto out3;
>  
> +	if (flexbg_size >= UINT_MAX / sizeof(struct ext4_new_flex_group_data))
> +		goto out2;
>  	flex_gd->count = flexbg_size;
>  
>  	flex_gd->groups = kmalloc(sizeof(struct ext4_new_group_data) *

