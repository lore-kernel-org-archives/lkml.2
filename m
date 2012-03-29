Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab2C2MTQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:19:16 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:35915 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab2C2MTJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:19:09 -0400
MIME-Version: 1.0
X-Originating-IP: [178.164.179.119]
In-Reply-To: <1332971123.19172.21.camel@lade.trondhjem.org>
References: <1332966285-30358-1-git-send-email-miklos@szeredi.hu>
	<1332966285-30358-6-git-send-email-miklos@szeredi.hu>
	<1332971123.19172.21.camel@lade.trondhjem.org>
Date: Thu, 29 Mar 2012 14:19:08 +0200
Message-ID: <CAJfpegsrzZKDCCuxfM=CzGGTdxajqRjMFtubPwQzLyFY5kEChg@mail.gmail.com>
Subject: Re: [PATCH 05/16] nfs: don't open in ->d_revalidate
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
Cc: "viro@ZenIV.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "sage@newdream.net" <sage@newdream.net>,
        "ericvh@gmail.com" <ericvh@gmail.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 11:45 PM, Myklebust, Trond
<Trond.Myklebust@netapp.com> wrote:
> On Wed, 2012-03-28 at 22:24 +0200, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>>
>> NFSv4 can't do reliable opens in d_revalidate, since it cannot know whether a
>> mount needs to be followed or not.  It does check d_mountpoint() on the dentry,
>> which can result in a weird error if the VFS found that the mount does not in
>> fact need to be followed, e.g.:
>>
>>   # mount --bind /mnt/nfs /mnt/nfs-clone
>>   # echo something > /mnt/nfs/tmp/bar
>>   # echo x > /tmp/file
>>   # mount --bind /tmp/file /mnt/nfs-clone/tmp/bar
>>   # cat  /mnt/nfs/tmp/bar
>>   cat: /mnt/nfs/tmp/bar: Not a directory
>>
>> Which should, by any sane filesystem, result in "something" being printed.
>>
>> So instead do the open in f_op->open() and in the unlikely case that the cached
>> dentry turned out to be invalid, drop the dentry and return ESTALE to let the
>> VFS retry.
>
>
> Just one comment. Would it now make sense for NFSv4 to just skip
> ->d_revalidate() if LOOKUP_OPEN is set, and LOOKUP_EXCL is not set? We
> will in any case be doing a revalidation in nfs4_file_open.

And dentry is positive and regular.  Which is basically what
nfs4_lookup_revalidate() does check at the moment.

One question is whether this can be done without dropping out of RCU
mode, which might be a real performance win. I'm not sure about
dereferencing inode->i_mode.  AFAICS it should be fine, considering
that destruction of the inode will leave the mode bits untouched,
but...

Thanks,
Miklos
