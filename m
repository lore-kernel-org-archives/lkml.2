Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab1FWPdz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 11:33:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37687 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758288Ab1FWPdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 11:33:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rrc3SjlsRf5nAZIJDIbGEDeBZxdaEOvnKi4SCQHSad47uft2Otv7EivUQ1XyzKtREX
         Uo54SrboCzkQDM/PSn1BeKq8wRyH+wIx/FgIrFNQM30BzFx+oJyPa8iE/IdHVv5+ISCo
         SPZTJ9FVeLcKYiBb2I+A3EaG7QBgmCqiOZVk4=
Message-ID: <4E035CDE.5090304@gmail.com>
Date: Thu, 23 Jun 2011 17:33:50 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alex Elder <aelder@sgi.com>
CC: xfs-masters@oss.sgi.com, xfs@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: Silence bounds checking compiler warning
References: <4E0356E6.30104@gmail.com>
In-Reply-To: <4E0356E6.30104@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 05:08 PM, Maarten Lankhorst wrote:
> gcc with -Warray-bounds generates a false positive on this
> since xfs defines the struct with u8 name[1]; to be able to
> add a tag at the end.
>
> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
> ---
>  fs/xfs/xfs_dir2_block.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/xfs/xfs_dir2_block.c b/fs/xfs/xfs_dir2_block.c
> index 580d99c..09b4aed 100644
> --- a/fs/xfs/xfs_dir2_block.c
> +++ b/fs/xfs/xfs_dir2_block.c
> @@ -1148,7 +1148,7 @@ xfs_dir2_sf_to_block(
>  		((char *)block + XFS_DIR2_DATA_DOTDOT_OFFSET);
>  	dep->inumber = cpu_to_be64(xfs_dir2_sf_get_inumber(sfp, &sfp->hdr.parent));
>  	dep->namelen = 2;
> -	dep->name[0] = dep->name[1] = '.';
> +	dep->name[0] = ((__u8 *)dep->name)[1] = '.';
>  	tagp = xfs_dir2_data_entry_tag_p(dep);
>  	*tagp = cpu_to_be16((char *)dep - (char *)block);
>  	xfs_dir2_data_log_entry(tp, bp, dep);
Oops, that still gives a warning, I used (u8*) first which works, but it seems the type
conversion was what made it shut up. Is there any type I can cast __u8 to safely,
or is memset preferred? gcc was too smart and saw through my __u8 cast.

~Maarten
