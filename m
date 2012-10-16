Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324Ab2JPCvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:51:39 -0400
Received: from mx2.netapp.com ([216.240.18.37]:37300 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab2JPCvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:51:37 -0400
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="701083542"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Chen Gang <gang.chen@asianux.com>
CC: Jeff Layton <jlayton@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug fix] nfs-client: fix nfs_inode_attrs_need_update for async
 read_done comes during truncating to smaller size
Thread-Topic: [Bug fix] nfs-client: fix nfs_inode_attrs_need_update for
 async read_done comes during truncating to smaller size
Thread-Index: AQHNqnpVDDzstrioNkubCev8dufUjZe6OzGAgAAG8QCAAICBAIAA2z2AgAAU0gA=
Date: Tue, 16 Oct 2012 02:51:35 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA909253103@SACEXCMBX04-PRD.hq.netapp.com>
References: <507B70F1.7040903@asianux.com>
	  <4FA345DA4F4AE44899BD2B03EEEC2FA909236BB5@SACEXCMBX04-PRD.hq.netapp.com>
	  <507B968A.9090104@asianux.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA90923F1C4@SACEXCMBX04-PRD.hq.netapp.com>
	 <507CBA3F.6000204@asianux.com>
In-Reply-To: <507CBA3F.6000204@asianux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <518E12B4B1011F43B6FFCAB21AE7ABD7@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9G2pjRU029323

On Tue, 2012-10-16 at 09:37 +0800, Chen Gang wrote:
> äº 2012å¹´10æœˆ15æ—¥ 20:32, Myklebust, Trond å†™é“:
> > RPC is not ordered. The fact that we get one RPC reply before another
> > does not mean that the server sent them in that order.
> > 
> > This is doubly true when you use UDP as the transport protocol.
> 
> 1) is it means: nfs_inode_attrs_need_update need not consider async
> read_done situation ?

I don't understand what you mean. This is mainly about the asynchronous
write situation...

> 2) for correctness, I do not think "nfs_size_to_loff_t(fattr->size) >
> i_size_read(inode)" in nfs_size_need_update is enough. (at least need
> use "!=" instead of '>'), do you think so ?

No... If I did, I would have changed this 15 years ago when I was
writing that code. Nothing here is new... 2.6.27-rc9 has the exact same
heuristics.
It boils down to the rule that if you want to ensure that data is not
_lost_, then you have to ensure that the cached file size is not less
than the true file size.

> 3) another reference:
> 
>   A) for an old kernel version (such as 2.6.27-rc9), no such issue
> (because it did not have nfs_size_need_update).
> 
>   B) the test tools which I use is from the LTP (Linux Test Project),
> they use both udp and tcp to test both the nfsv2 and nfsv3.

So what combinations are failing?

>   C) truly LTP has its limitations: "for stress test, LTP let nfs client
> and server under the same machine, which will cause kernel stable
> issue", but for net test, LTP use different machine (I got our issue
> from LTP net test).

Running the client and server on the same machine is likely to deadlock
due to memory pressure issues. The client needs to be able to _increase_
memory pressure on the server in order to reduce its own pressure. That
doesn't work well when client == server.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
