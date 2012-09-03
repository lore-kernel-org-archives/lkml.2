Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab2ICSjN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 14:39:13 -0400
Received: from mx2.netapp.com ([216.240.18.37]:33515 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754980Ab2ICSjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 14:39:11 -0400
X-IronPort-AV: E=Sophos;i="4.80,361,1344236400"; 
   d="scan'208";a="685268951"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix memset in NFS zap caches
Thread-Topic: [PATCH] Fix memset in NFS zap caches
Thread-Index: AQHNigLiTnmJlQHzNUyblrA1JsIXkpd5aCAA
Date: Mon, 3 Sep 2012 18:39:10 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA908F81A8E@SACEXCMBX04-PRD.hq.netapp.com>
References: <20120903183515.GT16230@one.firstfloor.org>
In-Reply-To: <20120903183515.GT16230@one.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A25747C6886B594AB40470E69F6C7ADB@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q83IdIvS007583

On Mon, 2012-09-03 at 20:35 +0200, Andi Kleen wrote:
> Fix memset in nfs_zap_caches_locked
> 
> This memset overruns the buffer by 4 bytes on 64bit systems.
> 
> gcc 4.8 correct complains:
> 
> /backup/lsrc/git/linux-lto-2.6/fs/nfs/inode.c: In function
> 'nfs_zap_caches_locked':
> /backup/lsrc/git/linux-lto-2.6/fs/nfs/inode.c:157:41: warning: argument
> to 'sizeof' in 'memset' call is the same pointer type '__be32 *' as the
> destination; expected '__be32' or an explicit length
> [-Wsizeof-pointer-memaccess]
>   memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
>                                          ^
> Add a * to sizeof the correct type.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> diff --git a/fs/nfs/inode.c b/fs/nfs/inode.c
> index c6e895f..69e7f0f 100644
> --- a/fs/nfs/inode.c
> +++ b/fs/nfs/inode.c
> @@ -154,7 +154,7 @@ static void nfs_zap_caches_locked(struct inode *inode)
>  	nfsi->attrtimeo = NFS_MINATTRTIMEO(inode);
>  	nfsi->attrtimeo_timestamp = jiffies;
>  
> -	memset(NFS_COOKIEVERF(inode), 0, sizeof(NFS_COOKIEVERF(inode)));
> +	memset(NFS_COOKIEVERF(inode), 0, sizeof(*NFS_COOKIEVERF(inode)));
>  	if (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode))
>  		nfsi->cache_validity |= NFS_INO_INVALID_ATTR|NFS_INO_INVALID_DATA|NFS_INO_INVALID_ACCESS|NFS_INO_INVALID_ACL|NFS_INO_REVAL_PAGECACHE;
>  	else

Hi Andi,

No, this is a gcc bug.

NFS_COOKIEVERF(inode) resolves to an array, so the current code is
correct. The above change will cause the 2nd half of the array to remain
uninitialised...

Cheers
  Trond


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
