Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab1K2MlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 07:41:24 -0500
Received: from mexforward.lss.emc.com ([128.222.32.20]:15902 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab1K2MlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 07:41:22 -0500
From: <tao.peng@emc.com>
To: <skinsbursky@parallels.com>
CC: <Trond.Myklebust@netapp.com>, <linux-nfs@vger.kernel.org>,
        <xemul@parallels.com>, <neilb@suse.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jbottomley@parallels.com>,
        <bfields@fieldses.org>, <davem@davemloft.net>, <devel@openvz.org>
Date: Tue, 29 Nov 2011 07:40:19 -0500
Subject: RE: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference from
 blocklayout routines
Thread-Topic: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference from
 blocklayout routines
Thread-Index: AcyukY9ts3BtGyv/REqRoBBt3RXgUwAAFmgQ
Message-ID: <F19688880B763E40B28B2B462677FBF805E3A4AFFD@MX09A.corp.emc.com>
References: <20111129090754.20730.64567.stgit@localhost6.localdomain6>
 <20111129091037.20730.59391.stgit@localhost6.localdomain6>
 <F19688880B763E40B28B2B462677FBF805E3A4AFF2@MX09A.corp.emc.com>
 <4ED4CDCE.9080804@parallels.com>
In-Reply-To: <4ED4CDCE.9080804@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pATCfahg007696

> -----Original Message-----
> From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> Sent: Tuesday, November 29, 2011 8:19 PM
> To: Peng, Tao
> Cc: Trond.Myklebust@netapp.com; linux-nfs@vger.kernel.org; Pavel Emelianov; neilb@suse.de;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; James Bottomley; bfields@fieldses.org;
> davem@davemloft.net; devel@openvz.org
> Subject: Re: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference from blocklayout routines
> 
> 29.11.2011 16:00, tao.peng@emc.com Ğ¿Ğ¸ÑˆĞµÑ‚:
> >> -----Original Message-----
> >> From: linux-nfs-owner@vger.kernel.org [mailto:linux-nfs-owner@vger.kernel.org] On Behalf Of
> Stanislav
> >> Kinsbursky
> >> Sent: Tuesday, November 29, 2011 6:11 PM
> >> To: Trond.Myklebust@netapp.com
> >> Cc: linux-nfs@vger.kernel.org; xemul@parallels.com; neilb@suse.de; netdev@vger.kernel.org; linux-
> >> kernel@vger.kernel.org; jbottomley@parallels.com; bfields@fieldses.org; davem@davemloft.net;
> >> devel@openvz.org
> >> Subject: [PATCH 4/5] NFS: remove RPC PipeFS mount point reference from blocklayout routines
> >>
> >> This is a cleanup patch. We don't need this reference anymore, because
> >> blocklayout pipes dentries now creates and destroys in per-net operations and
> >> on PipeFS mount/umount notification.
> >> Note that nfs4blocklayout_register_net() now returns 0 instead of -ENOENT in
> >> case of PipeFS superblock absence. This is ok, because blocklayout pipe dentry
> >> will be created on PipeFS mount event.
> > When is the "pipefs mount event" going to happen? When inserting kernel modules or when user issues
> mount command?
> >
> 
> When user issues mount command.
> Kernel mounts of PipeFS has been removed with all these patch sets I've sent
> already.
Then it is going to break blocklayout user space program blkmapd, which is stared before mounting any file system and it tries to open the pipe file when started.
Not sure if you implement the same logic on nfs pipe as well. But if you do, then nfs client user space program idmapd will fail to start for the same reason.

Why not just fail to load module if you fail to initialize pipefs? When is rpc_get_sb_net() going to fail?

> 
> 
> > Thanks,
> > Tao
> >
> >>
> >> Signed-off-by: Stanislav Kinsbursky<skinsbursky@parallels.com>
> >>
> >> ---
> >>   fs/nfs/blocklayout/blocklayout.c |    9 +--------
> >>   1 files changed, 1 insertions(+), 8 deletions(-)
> >>
> >> diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
> >> index acf7ac9..8211ffd 100644
> >> --- a/fs/nfs/blocklayout/blocklayout.c
> >> +++ b/fs/nfs/blocklayout/blocklayout.c
> >> @@ -1032,7 +1032,7 @@ static struct dentry *nfs4blocklayout_register_net(struct net *net,
> >>
> >>   	pipefs_sb = rpc_get_sb_net(net);
> >>   	if (!pipefs_sb)
> >> -		return ERR_PTR(-ENOENT);
> >> +		return 0;
> >>   	dentry = nfs4blocklayout_register_sb(pipefs_sb, pipe);
> >>   	rpc_put_sb_net(net);
> >>   	return dentry;
> >> @@ -1083,7 +1083,6 @@ static struct pernet_operations nfs4blocklayout_net_ops = {
> >>
> >>   static int __init nfs4blocklayout_init(void)
> >>   {
> >> -	struct vfsmount *mnt;
> >>   	int ret;
> >>
> >>   	dprintk("%s: NFSv4 Block Layout Driver Registering...\n", __func__);
> >> @@ -1093,12 +1092,6 @@ static int __init nfs4blocklayout_init(void)
> >>   		goto out;
> >>
> >>   	init_waitqueue_head(&bl_wq);
> >> -
> >> -	mnt = rpc_get_mount();
> >> -	if (IS_ERR(mnt)) {
> >> -		ret = PTR_ERR(mnt);
> >> -		goto out_remove;
> >> -	}
> >>   	ret = rpc_pipefs_notifier_register(&nfs4blocklayout_block);
> >>   	if (ret)
> >>   		goto out_remove;
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> Best regards,
> Stanislav Kinsbursky

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
