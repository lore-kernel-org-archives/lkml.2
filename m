Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2FSRqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:46:47 -0400
Received: from mx2.netapp.com ([216.240.18.37]:48507 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab2FSRqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:46:45 -0400
X-IronPort-AV: E=Sophos;i="4.75,799,1330934400"; 
   d="scan'208";a="656507630"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Ken Moffat <zarniwhoop@ntlworld.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: nfs3 problem with -rc{2,3} : blame
Thread-Topic: nfs3 problem with -rc{2,3} : blame
Thread-Index: AQHNTbfMQXPaY40l50mll7MzWrSjoJcCSNMAgAAAxYCAAAjvAIAADkmA
Date: Tue, 19 Jun 2012 17:46:28 +0000
Message-ID: <1340127987.3754.16.camel@lade.trondhjem.org>
References: <20120618141854.GA7962@milliways>
	 <1340031234.2451.13.camel@lade.trondhjem.org>
	 <20120618160005.GA10169@milliways> <20120618200525.GA15654@milliways>
	 <20120618215323.GA17561@milliways>
	 <1340057002.20570.31.camel@lade.trondhjem.org>
	 <20120618221052.GA18341@milliways> <20120619010641.GA22288@milliways>
	 <1340122836.3754.9.camel@lade.trondhjem.org>
	 <1340123001.3754.11.camel@lade.trondhjem.org>
	 <20120619165520.GA11015@milliways>
In-Reply-To: <20120619165520.GA11015@milliways>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3A2AB7A13D4EF746B3C177B774FCAC3C@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5JHkrrK029569

On Tue, 2012-06-19 at 17:55 +0100, Ken Moffat wrote:
> On Tue, Jun 19, 2012 at 04:23:23PM +0000, Myklebust, Trond wrote:
> > On Tue, 2012-06-19 at 12:20 -0400, Trond Myklebust wrote:
> > > 
> > > However you are saying that the problem is there when you compile a
> > > kernel with this commit as the head, and it goes away when you compile a
> > > kernel with commit 3e9e0ca3f19e911ce13c2e6c9858fcb41a37496c as the head?
> > > 
>  Provided I apply 4f97615d as well, so that it compiles, yes.
> 
> > > I'm confused as to how a bug in that patch could depend on
> > > CONFIG_NFS_V4, but I'll see what I can find.
> 
>  Thanks
> > 
> > By the way, I thought your test-case was doing firefox downloads. Do
> > those really use O_DIRECT?
> > 
>  I originally saw the problem doing that, but it was on the second
> download.  Or perhaps third or fourth - I tend not to remember
> successful downloads when I've got a lot of packages to check for new
> versions.  Using my backup script seemed a more reliable way to
> trigger a problem (but, only if there is something substantial to
> back up, such as a new vmlinuz).
> 
>  Thinking about this, it is almost certain that between the first
> download and the one that failed (several hours later) my backup
> script did run, from fcron, so I now think the rsync problem is what
> leads to issues when other programs later try to update the same nfs
> directory.

Does the following patch make any difference?

You probably want to ensure that you also have commit
906369e43c29001c39c7dfed8a01b9dff24ace75 (which is in 3.5-rc3) since
that corrects a similar issue.

Cheers
  Trond
8<------------------------------------------------------------
>From ed3b97f9af6421f326de413e6d6556d1ecc3399d Mon Sep 17 00:00:00 2001
From: Trond Myklebust <Trond.Myklebust@netapp.com>
Date: Tue, 19 Jun 2012 13:39:14 -0400
Subject: [PATCH] NFS: Fix a refcounting issue in O_DIRECT

In nfs_direct_write_reschedule(), the requests from nfs_scan_commit_list
have a refcount of 2, whereas the operations in
nfs_direct_write_completion_ops expect them to have a refcount of 1.

This patch adds a call to release the extra references.

Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>
---
 fs/nfs/direct.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 3168f6e..9a4cbfc 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -490,6 +490,7 @@ static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 			dreq->error = -EIO;
 			spin_unlock(cinfo.lock);
 		}
+		nfs_release_request(req);
 	}
 	nfs_pageio_complete(&desc);
 
-- 
1.7.10.2


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
