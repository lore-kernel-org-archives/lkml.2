Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab2B0PBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 10:01:16 -0500
Received: from mx2.netapp.com ([216.240.18.37]:62015 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab2B0PBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 10:01:14 -0500
X-IronPort-AV: E=Sophos;i="4.73,491,1325491200"; 
   d="scan'208";a="628856441"
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
Subject: Re: [PATCH 2/4] NFS: replace per-net client lock by mutex
Thread-Topic: [PATCH 2/4] NFS: replace per-net client lock by mutex
Thread-Index: AQHM9VadVjGAEH5ilEO0vcxtPQmAoJZRXHWA
Date: Mon, 27 Feb 2012 15:00:18 +0000
Message-ID: <1330354815.5541.24.camel@lade.trondhjem.org>
References: <20120227134623.13371.61185.stgit@localhost6.localdomain6>
	 <20120227134900.13371.96849.stgit@localhost6.localdomain6>
In-Reply-To: <20120227134900.13371.96849.stgit@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <600AC5785E386347B60FF4F6BAC60906@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1RF1NY0018891

On Mon, 2012-02-27 at 17:49 +0400, Stanislav Kinsbursky wrote:
> Lockdep is sad otherwise, because inode mutex is taken on PipeFS dentry
> creation, which can be called on mount notification, where this per-net client
> lock is taken on clients list walk.
> 
> Note: I used simple mutex instead of rw semaphore because of
> nfs_put_client->atomic_dec_and_mutex_lock() call. Probably, there is a better
> solution here.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> 

This is overkill... We end up blocking NFSv4 callbacks while the
rpc_pipefs notifier runs through the nfs_clients creating or destroying
idmapper dentries.

Surely the rpc_pipefs_event() can take a reference to the nfs_client and
then drop the spin_lock if it sees that it needs to create or destroy a
dentry?

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
