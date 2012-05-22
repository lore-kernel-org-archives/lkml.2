Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758692Ab2EVO3q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:29:46 -0400
Received: from mx2.netapp.com ([216.240.18.37]:30728 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab2EVO3n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:29:43 -0400
X-IronPort-AV: E=Sophos;i="4.75,639,1330934400"; 
   d="scan'208";a="649421098"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH] NFS: init client before declaration
Thread-Topic: [PATCH] NFS: init client before declaration
Thread-Index: AQHNOBgchN+45TnxmEuX3jdeWgHLc5bWU9EA
Date: Tue, 22 May 2012 14:29:44 +0000
Message-ID: <1337696984.4269.4.camel@lade.trondhjem.org>
References: <20120522124018.338.20817.stgit@localhost.localdomain>
In-Reply-To: <20120522124018.338.20817.stgit@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <26160BC8A5820F43B46320360F0ADF1B@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q4METr9r017710

On Tue, 2012-05-22 at 16:40 +0400, Stanislav Kinsbursky wrote:
> Client have to be initialized prior to adding it to per-net clients list,
> because otherwise there are races, shown below:
> 
> CPU#0					CPU#1
> _____					_____
> 
> nfs_get_client
> nfs_alloc_client
> list_add(..., nfs_client_list)
> 					rpc_fill_super
> 					rpc_pipefs_event
> 					nfs_get_client_for_event
> 					__rpc_pipefs_event
> 					(clp->cl_rpcclient is uninitialized)
> 					BUG()
> init_client
> clp->cl_rpcclient = ...
> 

Why not simply change nfs_get_client_for_event() so that it doesn't
touch nfs_clients that have clp->cl_cons_state!=NFS_CS_READY?

That should ensure that it doesn't touch nfs_clients that failed to
initialise and/or are still in the process of being initialised.

Cheers
  Trond

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
