Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab1ACK0r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 05:26:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482Ab1ACK0p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 05:26:45 -0500
Subject: Re: [PATCH] Update atime from future.
From: Steven Whitehouse <swhiteho@redhat.com>
To: yangsheng <sickamd@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
In-Reply-To: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
References: <1293631121-12667-1-git-send-email-sickamd@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 03 Jan 2011 10:27:48 +0000
Message-ID: <1294050468.2429.2.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-12-29 at 21:58 +0800, yangsheng wrote:
> Signed-off-by: sickamd@gmail.com
> ---
>  fs/inode.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index da85e56..6c8effd 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1469,7 +1469,13 @@ static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
>  		return 1;
>  
>  	/*
> -	 * Is the previous atime value older than a day? If yes,
> +	 * Is the previous atime value in future? If yes,
> +	 * update atime:
> +	 */
> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec) < 0)
> +		return 1;
> +	/*
> +	 * Is the previous atime value old than a day? If yes,
>  	 * update atime:
>  	 */
>  	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)

I don't think this is a good plan for cluster filesystems, since if the
times on the nodes are not exactly synchronised (we do highly recommend
people run ntp or similar) then this might lead to excessive atime
updating. The current behaviour is to ignore atimes which are in the
future for exactly this reason,

Steve.


