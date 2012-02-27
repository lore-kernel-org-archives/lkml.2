Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2B0QVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:21:37 -0500
Received: from mx2.netapp.com ([216.240.18.37]:10028 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753960Ab2B0QVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:21:34 -0500
X-IronPort-AV: E=Sophos;i="4.73,491,1325491200"; 
   d="scan'208";a="628887010"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH v2 1/4] SUNRPC: release per-net clients lock before
 calling PipeFS dentries creation
Thread-Topic: [PATCH v2 1/4] SUNRPC: release per-net clients lock before
 calling PipeFS dentries creation
Thread-Index: AQHM9Weod0HJbXoOhkm4LDxKtXHHipZRcwyA
Date: Mon, 27 Feb 2012 16:21:32 +0000
Message-ID: <1330359695.5541.45.camel@lade.trondhjem.org>
References: <20120227154713.7941.17963.stgit@localhost6.localdomain6>
	 <20120227155055.7941.18741.stgit@localhost6.localdomain6>
In-Reply-To: <20120227155055.7941.18741.stgit@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <6090798A0FDE1447ABDA8D6F1B94D7D3@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1RGM0KY019328

On Mon, 2012-02-27 at 19:50 +0400, Stanislav Kinsbursky wrote:
> Lockdep is sad otherwise, because inode mutex is taken on PipeFS dentry
> creation, which can be called on mount notification, where this per-net client
> lock is taken on clients list walk.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 
> ---
>  net/sunrpc/clnt.c |   10 +++++++---
>  1 files changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> index bb7ed2f3..ddb5741 100644
> --- a/net/sunrpc/clnt.c
> +++ b/net/sunrpc/clnt.c
> @@ -84,7 +84,7 @@ static void rpc_register_client(struct rpc_clnt *clnt)
>  	struct sunrpc_net *sn = net_generic(clnt->cl_xprt->xprt_net, sunrpc_net_id);
>  
>  	spin_lock(&sn->rpc_client_lock);
> -	list_add(&clnt->cl_clients, &sn->all_clients);
> +	list_add_tail(&clnt->cl_clients, &sn->all_clients);
>  	spin_unlock(&sn->rpc_client_lock);
>  }
>  
> @@ -208,15 +208,19 @@ static int rpc_pipefs_event(struct notifier_block *nb, unsigned long event,
>  			    void *ptr)
>  {
>  	struct super_block *sb = ptr;
> -	struct rpc_clnt *clnt;
> +	struct rpc_clnt *clnt, *tmp;
>  	int error = 0;
>  	struct sunrpc_net *sn = net_generic(sb->s_fs_info, sunrpc_net_id);
>  
>  	spin_lock(&sn->rpc_client_lock);
> -	list_for_each_entry(clnt, &sn->all_clients, cl_clients) {
> +	list_for_each_entry_safe(clnt, tmp, &sn->all_clients, cl_clients) {
> +		atomic_inc(&clnt->cl_count);
> +		spin_unlock(&sn->rpc_client_lock);
>  		error = __rpc_pipefs_event(clnt, event, sb);
> +		rpc_release_client(clnt);
>  		if (error)
>  			break;
> +		spin_lock(&sn->rpc_client_lock);
>  	}
>  	spin_unlock(&sn->rpc_client_lock);
>  	return error;
> 

This won't be safe. Nothing guarantees that 'tmp' remains valid after
you drop the spin_lock.

I think you rather need to add a check for whether clnt->cl_dentry is in
the right state (NULL if RPC_PIPEFS_UMOUNT or non-NULL if
RPC_PIPEFS_MOUNT) before deciding whether or not to atomic_inc() and
drop the lock, so that you can restart the loop after calling
__rpc_pipefs_event().


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
