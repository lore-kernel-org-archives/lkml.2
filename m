Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2JPLip (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 07:38:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:63449 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499Ab2JPLin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 07:38:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Tue, 16 Oct 2012 11:38:35 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "'Dave Chinner'" <david@fromorbit.com>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <20121015223409.GE2739@dastard> <015901cdab42$06deac20$149c0460$%kim@samsung.com>
In-Reply-To: <015901cdab42$06deac20$149c0460$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201210161138.35388.arnd@arndb.de>
X-Provags-ID: V02:K0:NqL6+ltfIq29/bJN/w81eK0c7zarQ/U7gXxJOBUGL7Z
 2PxeVC2NyMnYdHXo6a1rGQAyLe2MP/qmOrsmw8z7bHQn+KezJK
 LKoKLC2+zpyirRB39A29n2NQXAmXvnsfkuOBLB3+SpGDMp/gDM
 4yNmEJ2OTuxsFKMA8p4YpwotiLSCu+HLLRVyLWWMI4FfkCj40T
 ijmjzv6EfZIyimJT4N5VqnrRxb+exuypqLCG3ub+lr8Z9/c7zV
 OFIF0OLgUDYLMP+1E9CPjnZi43tl8ZLtcPgcU6thUqH/ynA885
 O2KdNZbbPJPXp26feDxbhBTgckdF9+T+EtxV5wk+r/Pq9/JqTP
 b2rMoxxPVoFbAycBusaA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 October 2012, Jaegeuk Kim wrote:
> On Monday 15 October 2012, Dave Chinner wrote:
> > On Sun, Oct 14, 2012 at 03:19:37PM +0000, Arnd Bergmann wrote:
> > > On Sunday 14 October 2012, Vyacheslav Dubeyko wrote:
> > > > On Oct 14, 2012, at 11:09 AM, Jaegeuk Kim wrote:
> > > > > 2012-10-14 (일), 02:21 +0400, Vyacheslav Dubeyko:
> > 
> > > The main reason I can see against extended attributes is that they are not stored
> > > very efficiently in f2fs, unless a lot of work is put into coming up with a good
> > > implementation. A single flags bit can trivially be added to the inode in
> > > comparison (if it's not there already).
> > 
> > That's a deficiency that should be corrected, then, because xattrs
> > are very common these days.
> 
> IMO, most file systems including f2fs have some inefficiency to store
> and retrieve xattrs, since they have to allocate an additional block.
> The only distinct problem in f2fs is that there is a cleaning overhead.
> So, that's the why xattr is not an efficient way in f2fs.

I would hope that there is a better way to encode extented attributes
if the current method is not efficient enough. Maybe Dave or someone
else who is experienced with this can make suggestions.

What is the "expected" size of the attributes normally? Does it
make sense to put attributes for multiple files into a single block?
 
> OTOH, I think xattr itself is for users, not for communicating
> between file system and users.

No, you are mistaken in that point, as Dave explained.

> Moreover, I'm not sure in the current android, but I saw ICS android
> did not call any xattr operations, even if mount option was enabled.

I realize that Android is currently your main target, but to get
the file system merged into Linux, it needs to fit in with the
overall strategy for file systems, which includes more than just
Android.

> > And given that stuff like access frequency tracking is being
> > implemented at the VFS level, access policy hints should also be VFS
> > functionality. A bad filesystem implementation should not dictate
> > the interface for generically useful functionality....

Agreed.

> > An xattr on the root inode that holds a list like this is something
> > that could be set at mkfs time, but then also updated easily by new
> > software packages that are installed...

Yes, good idea.

> > > We should also take the kinds of access we have seen on a file into account.
> > 
> > Yes, but it should be done at the VFS level, not in the filesystem
> > itself. Integrated into the current hot inode/range tracking that is
> > being worked on right now, I'd suggest.
> > 
> > IOWs, these access policy issues are not unique to F2FS or it's use
> > case. Anything to do with access hints, policy, tracking, file
> > classification, etc that can influence data locality, reclaim,
> > migration, etc need to be dealt with at the VFS, independently of a
> > specific filesystem. Filesystems can make use of that information
> > how they please (whether in the kernel or via userspace tools), but
> > having filesystem specific interfaces and implementations of the
> > same functionality is extremely wasteful. Let's do it once, and do
> > it right the first time. ;)
> 
> I agree that VFS should support something, but before then, it needs
> to do something by the file system first.
> Because, we have to figure out what kind of information are really useful.

As mentioned before, such tuning can still be done after the file system
is merged, as long as the on-disk structure is flexible enough.

As you said yourself, imlpementing the hints by detecting access patterns
from the file system itself as I suggested would be a lot of work, and
if the VFS can give us that information for free in the future, we can
wait for that to happen (or help out on the implementation if necessary)
and then implement it based on those APIs.

	Arnd
