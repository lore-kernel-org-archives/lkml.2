Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964825Ab2CFQlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:41:24 -0500
Received: from mx2.netapp.com ([216.240.18.37]:32703 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab2CFQlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:41:22 -0500
X-IronPort-AV: E=Sophos;i="4.73,540,1325491200"; 
   d="scan'208";a="631127710"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 9/9] nfs: don't open in ->d_revalidate
Thread-Topic: [PATCH 9/9] nfs: don't open in ->d_revalidate
Thread-Index: AQHM+7XZ/8/o98YKtk2fJ0XNzaBcrJZd/pmA
Date: Tue, 6 Mar 2012 16:41:20 +0000
Message-ID: <1331052079.3260.33.camel@lade.trondhjem.org>
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
	 <1331038601-20353-10-git-send-email-miklos@szeredi.hu>
	 <1331043158.3260.3.camel@lade.trondhjem.org>
	 <87boo9k861.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87boo9k861.fsf@tucsk.pomaz.szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D9E08CB249D104ABD70D61BB4239D53@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q26GfXZO009085

On Tue, 2012-03-06 at 17:26 +0100, Miklos Szeredi wrote:
> "Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:
> 
> > On Tue, 2012-03-06 at 13:56 +0100, Miklos Szeredi wrote:
> >> From: Miklos Szeredi <mszeredi@suse.cz>
> >> 
> >> NFSv4 can't do reliable opens in d_revalidate, since it cannot know whether a
> >> mount needs to be followed or not.  It does check d_mountpoint() on the dentry,
> >> which can result in a weird error if the VFS found that the mount does not in
> >> fact need to be followed, e.g.:
> >> 
> >>   # mount --bind /mnt/nfs /mnt/nfs-clone
> >>   # echo something > /mnt/nfs/tmp/bar
> >>   # echo x > /tmp/file
> >>   # mount --bind /tmp/file /mnt/nfs-clone/tmp/bar
> >>   # cat  /mnt/nfs/tmp/bar
> >>   cat: /mnt/nfs/tmp/bar: Not a directory
> >> 
> >> Which should, by any sane filesystem, result in "something" being printed.
> >> 
> >> So instead do the open in f_op->open() and in the unlikely case that the cached
> >> dentry turned out to be invalid, drop the dentry and return ESTALE to let the
> >> VFS retry.
> >
> > This patch would force a complete new walk of the path in cases where
> > today we just do a single lookup of the last component.
> 
> I sort of anticipated that, but I really don't know how much of an issue
> is this.

It makes a big difference to the cache miss case, since not only is the
entire path looked up again, but the LOOKUP_REVAL flag gets set, which
forces a full lookup of each component (as opposed to just
revalidating).

> Of course it is possible to redo only the last component after
> f_op->open() return ESTALE but that requires reshuffling do_last().
> 
> >  It really
> > doesn't seem worth taking that penalty just in order to make some insane
> > bind mount corner cases work.
> 
> It's not at all insane if for example we have multiple mount namespaces.
> NFS is clearly broken and it needs to be fixed, one way or another.

Right, but this is still an extremely rare usage case: you are the first
person to report it as being broken (OK, Al may have mentioned it in the
past too). There have been no actual user reports AFAIK.

OTOH, cache misses are frequent.

> If you think this is a serious performance regression then lets drop
> this patch and add it to the atomic open series together with the
> do_last() reshuffling.

That sounds like a good suggestion to me.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
