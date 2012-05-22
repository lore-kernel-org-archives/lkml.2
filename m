Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758976Ab2EVPAo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:00:44 -0400
Received: from mx2.netapp.com ([216.240.18.37]:26397 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab2EVPAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:00:42 -0400
X-IronPort-AV: E=Sophos;i="4.75,637,1330934400"; 
   d="scan'208";a="649433237"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] NFS: init client before declaration
Thread-Topic: [PATCH] NFS: init client before declaration
Thread-Index: AQHNOBgchN+45TnxmEuX3jdeWgHLc5bWU9EAgAAIiAA=
Date: Tue, 22 May 2012 15:00:17 +0000
Message-ID: <1337698816.4269.15.camel@lade.trondhjem.org>
References: <20120522124018.338.20817.stgit@localhost.localdomain>
	 <1337696984.4269.4.camel@lade.trondhjem.org>
In-Reply-To: <1337696984.4269.4.camel@lade.trondhjem.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <07CAB8D0164E214F8575E78072FEE78A@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4MF0sWZ017861

On Tue, 2012-05-22 at 10:29 -0400, Trond Myklebust wrote:
> On Tue, 2012-05-22 at 16:40 +0400, Stanislav Kinsbursky wrote:
> > Client have to be initialized prior to adding it to per-net clients list,
> > because otherwise there are races, shown below:
> > 
> > CPU#0					CPU#1
> > _____					_____
> > 
> > nfs_get_client
> > nfs_alloc_client
> > list_add(..., nfs_client_list)
> > 					rpc_fill_super
> > 					rpc_pipefs_event
> > 					nfs_get_client_for_event
> > 					__rpc_pipefs_event
> > 					(clp->cl_rpcclient is uninitialized)
> > 					BUG()
> > init_client
> > clp->cl_rpcclient = ...
> > 
> 
> Why not simply change nfs_get_client_for_event() so that it doesn't
> touch nfs_clients that have clp->cl_cons_state!=NFS_CS_READY?
> 
> That should ensure that it doesn't touch nfs_clients that failed to
> initialise and/or are still in the process of being initialised.

...actually, come to think of it. Why not just add a helper function
"bool nfs_client_active(const struct nfs_client *clp)" to
fs/nfs/client.c that does a call to
	wait_event_killable(nfs_client_active_wq, clp->cl_cons_state < NFS_CS_INITING);
and checks the resulting value of clp->cl_cons_state?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
