Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab2GaOh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 10:37:29 -0400
Received: from mx2.netapp.com ([216.240.18.37]:45012 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754393Ab2GaOh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 10:37:27 -0400
X-IronPort-AV: E=Sophos;i="4.77,686,1336374000"; 
   d="scan'208";a="670459597"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Mel Gorman <mgorman@suse.de>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with the nfs tree
Thread-Topic: linux-next: manual merge of the akpm tree with the nfs tree
Thread-Index: AQHNbtR4a/OwVO3zl0Gi+NGAKMKYSZdDp5EAgABEHAA=
Date: Tue, 31 Jul 2012 14:37:24 +0000
Message-ID: <1343745442.519.20.camel@lade.trondhjem.org>
References: <20120731142441.0d01100f9d050ec6e479c923@canb.auug.org.au>
	 <20120731103336.GN612@suse.de>
In-Reply-To: <20120731103336.GN612@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <A6BB553D7D0ECB4DB001B8242D701D2E@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6VEbaNl011296

On Tue, 2012-07-31 at 11:33 +0100, Mel Gorman wrote:
> On Tue, Jul 31, 2012 at 02:24:41PM +1000, Stephen Rothwell wrote:
> > Hi Andrew,
> > 
> > Today's linux-next merge of the akpm tree got a conflict in
> > net/sunrpc/xprtsock.c between commit 5cf02d09b50b ("nfs: skip commit in
> > releasepage if we're freeing memory for fs-related reasons") from the nfs
> > tree and commit "nfs: enable swap on NFS" from the akpm tree.
> > 
> > Just context changes?  I fixed it up (I think - see below) and can carry
> > the fix as necessary.
> 
> Functionally it looks fine. As you say, it all looks like context
> changes. Arguably code like this
> 
> current->flags &= ~PF_FSTRANS
> 
> could use tsk_restore_flags instead() even though it should never be
> necessary as PF_FSTRANS would not be set on function entry. However,
> it would set up a depedency between the patch sets that is undesirable.
> If both sets get merged then it might make sense as a cleanup to use
> tsk_restore_flags() but not until then.
> 
> Thanks Stephen.
> 

Do we really need to set both PF_FSTRANS and PF_MEMALLOC here? The
reason why I merged the PF_FSTRANS patch is that we have the deadlock
problem when allocating a new socket even before we add swap-over-nfs.
Adding PF_FSTRANS to disallow entry into the NFS layer by the memory
allocator fixes that issue.
What value does PF_MEMALLOC add? Is that in order to prevent recursion
into other areas of the swap code (say, if you mix swap-over-nfs with
ordinary swap-to-disk)?

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
