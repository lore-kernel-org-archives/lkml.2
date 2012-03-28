Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758450Ab2C1Vpn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:45:43 -0400
Received: from mx2.netapp.com ([216.240.18.37]:33432 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757482Ab2C1Vpm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:45:42 -0400
X-IronPort-AV: E=Sophos;i="4.75,333,1330934400"; 
   d="scan'208";a="637005147"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "sage@newdream.net" <sage@newdream.net>,
        "ericvh@gmail.com" <ericvh@gmail.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 05/16] nfs: don't open in ->d_revalidate
Thread-Topic: [PATCH 05/16] nfs: don't open in ->d_revalidate
Thread-Index: AQHNDSDJQSek4O0mmEKyHI8e6Qk/35aAsz+A
Date: Wed, 28 Mar 2012 21:45:18 +0000
Message-ID: <1332971123.19172.21.camel@lade.trondhjem.org>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
	 <1332966285-30358-6-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1332966285-30358-6-git-send-email-miklos@szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A3BFAF06487434F9EC0A10A60DB3C7C@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2SLjmCj000558

On Wed, 2012-03-28 at 22:24 +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> NFSv4 can't do reliable opens in d_revalidate, since it cannot know whether a
> mount needs to be followed or not.  It does check d_mountpoint() on the dentry,
> which can result in a weird error if the VFS found that the mount does not in
> fact need to be followed, e.g.:
> 
>   # mount --bind /mnt/nfs /mnt/nfs-clone
>   # echo something > /mnt/nfs/tmp/bar
>   # echo x > /tmp/file
>   # mount --bind /tmp/file /mnt/nfs-clone/tmp/bar
>   # cat  /mnt/nfs/tmp/bar
>   cat: /mnt/nfs/tmp/bar: Not a directory
> 
> Which should, by any sane filesystem, result in "something" being printed.
> 
> So instead do the open in f_op->open() and in the unlikely case that the cached
> dentry turned out to be invalid, drop the dentry and return ESTALE to let the
> VFS retry.


Just one comment. Would it now make sense for NFSv4 to just skip
->d_revalidate() if LOOKUP_OPEN is set, and LOOKUP_EXCL is not set? We
will in any case be doing a revalidation in nfs4_file_open.

Otherwise, the rest all looks good to me.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
