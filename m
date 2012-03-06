Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756336Ab2CFQ0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:26:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:34933 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755949Ab2CFQ0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:26:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.14.28.199 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
From: Miklos Szeredi <miklos@szeredi.hu>
To: "Myklebust\, Trond" <Trond.Myklebust@netapp.com>
Cc: "viro\@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch\@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 9/9] nfs: don't open in ->d_revalidate
References: <1331038601-20353-1-git-send-email-miklos@szeredi.hu>
	<1331038601-20353-10-git-send-email-miklos@szeredi.hu>
	<1331043158.3260.3.camel@lade.trondhjem.org>
Date: Tue, 06 Mar 2012 17:26:14 +0100
In-Reply-To: <1331043158.3260.3.camel@lade.trondhjem.org> (Trond Myklebust's
	message of "Tue, 6 Mar 2012 14:12:38 +0000")
Message-ID: <87boo9k861.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Myklebust, Trond" <Trond.Myklebust@netapp.com> writes:

> On Tue, 2012-03-06 at 13:56 +0100, Miklos Szeredi wrote:
>> From: Miklos Szeredi <mszeredi@suse.cz>
>> 
>> NFSv4 can't do reliable opens in d_revalidate, since it cannot know whether a
>> mount needs to be followed or not.  It does check d_mountpoint() on the dentry,
>> which can result in a weird error if the VFS found that the mount does not in
>> fact need to be followed, e.g.:
>> 
>>   # mount --bind /mnt/nfs /mnt/nfs-clone
>>   # echo something > /mnt/nfs/tmp/bar
>>   # echo x > /tmp/file
>>   # mount --bind /tmp/file /mnt/nfs-clone/tmp/bar
>>   # cat  /mnt/nfs/tmp/bar
>>   cat: /mnt/nfs/tmp/bar: Not a directory
>> 
>> Which should, by any sane filesystem, result in "something" being printed.
>> 
>> So instead do the open in f_op->open() and in the unlikely case that the cached
>> dentry turned out to be invalid, drop the dentry and return ESTALE to let the
>> VFS retry.
>
> This patch would force a complete new walk of the path in cases where
> today we just do a single lookup of the last component.

I sort of anticipated that, but I really don't know how much of an issue
is this.

Of course it is possible to redo only the last component after
f_op->open() return ESTALE but that requires reshuffling do_last().

>  It really
> doesn't seem worth taking that penalty just in order to make some insane
> bind mount corner cases work.

It's not at all insane if for example we have multiple mount namespaces.
NFS is clearly broken and it needs to be fixed, one way or another.

If you think this is a serious performance regression then lets drop
this patch and add it to the atomic open series together with the
do_last() reshuffling.

Thanks,
Miklos
