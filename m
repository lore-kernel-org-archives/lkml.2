Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932583Ab2LMOoo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 09:44:44 -0500
Received: from mx1.netapp.com ([216.240.18.38]:44005 "EHLO mx1.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab2LMOoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 09:44:18 -0500
X-Greylist: delayed 563 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Dec 2012 09:44:18 EST
X-IronPort-AV: E=Sophos;i="4.84,273,1355126400"; 
   d="scan'208";a="230595949"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "ycnian@gmail.com" <ycnian@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>
Subject: Re: [PATCH] nfs: Don't return referenced delegations
Thread-Topic: [PATCH] nfs: Don't return referenced delegations
Thread-Index: AQHN2P25HGqNgJtDPUKWDrT34w34JZgXUiWA
Date: Thu, 13 Dec 2012 14:34:53 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA91192A73F@SACEXCMBX04-PRD.hq.netapp.com>
References: <1355380636-10915-1-git-send-email-ycnian@gmail.com>
In-Reply-To: <1355380636-10915-1-git-send-email-ycnian@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.117]
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF5A70267A97E044A33975714F3B4E79@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBDEilD2026771

On Thu, 2012-12-13 at 14:37 +0800, ycnian@gmail.com wrote:
> From: Yanchuan Nian <ycnian@gmail.com>
> 
> The client returns unreferenced delegations in state management. It scans all
> delegations and tests the NFS_DELEGATION_REFERENCED flag. if this flag is not
> set, NFS_DELEGATION_RETURN will be set and the delegation will be returned. 
> But unfortunately NFS_DELEGATION_REFERENCED is cleared after the testing, so 
> delegations which are still being used will be returned in the next state
> management.
> 
> Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
> ---
>  fs/nfs/delegation.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
> index 81c5eec..485e8c0 100644
> --- a/fs/nfs/delegation.c
> +++ b/fs/nfs/delegation.c
> @@ -506,7 +506,7 @@ static void nfs_mark_return_unreferenced_delegations(struct nfs_server *server)
>  	struct nfs_delegation *delegation;
>  
>  	list_for_each_entry_rcu(delegation, &server->delegations, super_list) {
> -		if (test_and_clear_bit(NFS_DELEGATION_REFERENCED, &delegation->flags))
> +		if (test_bit(NFS_DELEGATION_REFERENCED, &delegation->flags))
>  			continue;
>  		nfs_mark_return_delegation(server, delegation);
>  	}

The clearing of the bit here is 100% intentional. This is a variant on
basic mark-and-sweep garbage collection where if the bit hasn't been set
again the next time we scan, then we assume the delegation isn't being
used.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
