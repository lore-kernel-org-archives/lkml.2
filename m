Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2LNRps (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:45:48 -0500
Received: from mx12.netapp.com ([216.240.18.77]:4112 "EHLO mx12.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab2LNRpr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:45:47 -0500
X-IronPort-AV: E=Sophos;i="4.84,282,1355126400"; 
   d="scan'208";a="601950"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Yanchuan Nian <ycnian@gmail.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] nfs: Don't return referenced delegations
Thread-Topic: [PATCH] nfs: Don't return referenced delegations
Thread-Index: AQHN2P25HGqNgJtDPUKWDrT34w34JZgXUiWAgAF2DQCAAFGegA==
Date: Fri, 14 Dec 2012 17:45:45 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA91192E4A7@SACEXCMBX04-PRD.hq.netapp.com>
References: <1355380636-10915-1-git-send-email-ycnian@gmail.com>
	 <4FA345DA4F4AE44899BD2B03EEEC2FA91192A73F@SACEXCMBX04-PRD.hq.netapp.com>
	 <CAC5OsZMOQSD2dor-TRcrmwk5t3aupwmX-WB7dbxDryKYjWPcSw@mail.gmail.com>
In-Reply-To: <CAC5OsZMOQSD2dor-TRcrmwk5t3aupwmX-WB7dbxDryKYjWPcSw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.118]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CFC8D5BE0F715F4A8011129A63E14B70@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qBEHjslr001750

On Fri, 2012-12-14 at 20:53 +0800, Yanchuan Nian wrote:
> 
> 
> 2012/12/13 Myklebust, Trond <Trond.Myklebust@netapp.com>
>         On Thu, 2012-12-13 at 14:37 +0800, ycnian@gmail.com wrote:
>         > From: Yanchuan Nian <ycnian@gmail.com>
>         >
>         > The client returns unreferenced delegations in state
>         management. It scans all
>         > delegations and tests the NFS_DELEGATION_REFERENCED flag. if
>         this flag is not
>         > set, NFS_DELEGATION_RETURN will be set and the delegation
>         will be returned.
>         > But unfortunately NFS_DELEGATION_REFERENCED is cleared after
>         the testing, so
>         > delegations which are still being used will be returned in
>         the next state
>         > management.
>         >
>         > Signed-off-by: Yanchuan Nian <ycnian@gmail.com>
>         > ---
>         >  fs/nfs/delegation.c |    2 +-
>         >  1 files changed, 1 insertions(+), 1 deletions(-)
>         >
>         > diff --git a/fs/nfs/delegation.c b/fs/nfs/delegation.c
>         > index 81c5eec..485e8c0 100644
>         > --- a/fs/nfs/delegation.c
>         > +++ b/fs/nfs/delegation.c
>         > @@ -506,7 +506,7 @@ static void
>         nfs_mark_return_unreferenced_delegations(struct nfs_server
>         *server)
>         >       struct nfs_delegation *delegation;
>         >
>         >       list_for_each_entry_rcu(delegation,
>         &server->delegations, super_list) {
>         > -             if
>         (test_and_clear_bit(NFS_DELEGATION_REFERENCED,
>         &delegation->flags))
>         > +             if (test_bit(NFS_DELEGATION_REFERENCED,
>         &delegation->flags))
>         >                       continue;
>         >               nfs_mark_return_delegation(server,
>         delegation);
>         >       }
>         
>         
>         The clearing of the bit here is 100% intentional. This is a
>         variant on
>         basic mark-and-sweep garbage collection where if the bit
>         hasn't been set
>         again the next time we scan, then we assume the delegation
>         isn't being
>         used.
>  
> Oh, now I know. If the client gets an open delegation from the server
> without
> any operations in the following few minutes, the delegation will be
> returned.
> After that, if the client wants to read data from the server, it has
> to
> revalidate local cache first. In this situation, the client can't get
> benefit 
> from delegation. RFC 3530 says The server will recall a delegation
> if there are conflicting operations from another client. So why
> doesn't the
> client hold the delegation until receiving the recall request? Is
> there some 
> special reason? I am new to NFS and sorry to trouble you.

It's about resource management. Both the client and the server need to
keep state in memory for each delegation that is held. What we've seen
is servers running out of state if the client is too greedy about
holding onto delegations that aren't being used. In theory the server
could start recalling those delegations, but how does it know which ones
are still important to the client?

For that reason, we try to be good NFS citizens by returning delegations
that are not being used by processes. The scan is done once every lease
period (so typically once a minute). If a delegation hasn't been used in
that lease period, then it is returned.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
