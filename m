Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755517Ab2JPCAh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:00:37 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:18405 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2JPCAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:00:36 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-e2-507cbfc1fd23
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>, "'Arnd Bergmann'" <arnd@arndb.de>
Cc: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <1350198545.1915.233.camel@kjgkr>
 <A7BD3CDD-330C-498A-BB36-631DE6B9777C@dubeyko.com>
 <201210141519.37752.arnd@arndb.de> <20121015223409.GE2739@dastard>
In-reply-to: <20121015223409.GE2739@dastard>
Subject: RE: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Tue, 16 Oct 2012 11:00:32 +0900
Message-id: <015901cdab42$06deac20$149c0460$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2rJTQbk0QCOZOuTnSMlo3yWfEGMAAF7TQQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd2D+2sCDPpf61lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mnt0X2ArmaVasu/WErYHxpkIXIyeHhICJxOHXe1kgbDGJC/fW
	s3UxcnEICSxilJi48z8rhDOfSWJD/xTGLkYODjYBbYnN+w1AGkQEPCXubrnCBFLDLDCDSeLx
	7j0sEA23GSWutc5iB6niFNCROHDtLxOILSzgIXHt6wawOIuAqsSjw+tZQYbyCthK9G/PAgnz
	CghK/Jh8jwUkzCygLjFlSi5ImBlo7ZN3F8CqJYDCj/7qQpxgJPH3+xZGiBIRiX0v3jFOYBSa
	hWTQLIRBs5AMmoWkYwEjyypG0dSC5ILipPRcI73ixNzi0rx0veT83E2M4CB+Jr2DcVWDxSFG
	AQ5GJR7eDOeaACHWxLLiytxDjBIczEoivB4TgUK8KYmVValF+fFFpTmpxYcYpTlYlMR5mz1S
	AoQE0hNLUrNTUwtSi2CyTBycUg2MQl/XZxk+iXY2PvH0q0TlUzVOpRdsLLpW4lLsbK/5eM7M
	c5DtPOxephGxeuXDL22WX11Nw36kTirP2nUoJv2dzDbGiJ2MjgU/l0WtEtScWPmaLfdc17N9
	hl07F5h6SNq0MG98/zf+tGmEwYq9Xx2aHgQuO/ZIatOr45l3ZvWkadcevLXGp263EktxRqKh
	FnNRcSIAa+qDS14CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sun, Oct 14, 2012 at 03:19:37PM +0000, Arnd Bergmann wrote:
> > On Sunday 14 October 2012, Vyacheslav Dubeyko wrote:
> > > On Oct 14, 2012, at 11:09 AM, Jaegeuk Kim wrote:
> > > > 2012-10-14 (일), 02:21 +0400, Vyacheslav Dubeyko:
> > > Extended attributes are more flexible way, from my point of view. The xattr gives
> > > possibility to make hint to filesystem at any time and without any dependencies with
> > > application's functional opportunities. Documented way of using such extended attributes
> > > gives to user flexible way of manipulation of filesystem behavior (but I remember that
> > > you don't believe in an user :-)).
> > >
> > > So, I think that fadvise() and extended attributes can be complementary solutions.
> >
> > Right. Another option is to have ext4 style attributes, see
> > http://linux.die.net/man/1/chattr
> 
> Xattrs are much prefered to more "ext4 style" flags because xattrs
> are filesystem independent. Indeed, some filesystems can't store any
> new "ext4 style" flags without a change of disk format or
> internally mapping them to an xattr. So really, xattrs are the best
> way forward for such hints.
> 
> > Unlike extended attributes, there is a limited number of those,
> > and they can only be boolean flags, but that might be enough for
> > this particular use case.
> 
> A boolean is not sufficient for access policy hints. An extensible
> xattr format is probably the best approach to take here, so that we
> can easily introduce new access policy hints as functionality is
> required. Indeed, an extensible xattr could start with just a
> hot/cold boolean, and grow from there....
> 
> > The main reason I can see against extended attributes is that they are not stored
> > very efficiently in f2fs, unless a lot of work is put into coming up with a good
> > implementation. A single flags bit can trivially be added to the inode in
> > comparison (if it's not there already).
> 
> That's a deficiency that should be corrected, then, because xattrs
> are very common these days.

IMO, most file systems including f2fs have some inefficiency to store
and retrieve xattrs, since they have to allocate an additional block.
The only distinct problem in f2fs is that there is a cleaning overhead.
So, that's the why xattr is not an efficient way in f2fs.

OTOH, I think xattr itself is for users, not for communicating
between file system and users.
Moreover, I'm not sure in the current android, but I saw ICS android
did not call any xattr operations, even if mount option was enabled.

> 
> And given that stuff like access frequency tracking is being
> implemented at the VFS level, access policy hints should also be VFS
> functionality. A bad filesystem implementation should not dictate
> the interface for generically useful functionality....
> 
> > > Anyway, hardcoding or saving in filesystem list of file extensions is a nasty way. It
> > > can be not safe or hardly understandable by users the way of reconfiguration filesystem
> > > by means of tunefs or debugfs with the purpose of file extensions addition in such
> > > "black-box" as TV or smartphones, from my point of view.
> >
> > It is only a performance hint though, so it is not a correctness issue the
> > file system gets it wrong. In order to do efficient garbage collection, a log
> > structured file system should take all the information it can get about the
> > expected life of data it writes. I agree that the list, even in the form of
> > mkfs time settings, is not a clean abstraction, but in the place of an Android
> > phone manufacturer I would still enable it if it promises a significant
> > performance advantage over not using it. I guess it would be nice if this
> > could be overridden in some form, e.g. using an ioctl on the file as ext4 does.
> 
> An xattr on the root inode that holds a list like this is something
> that could be set at mkfs time, but then also updated easily by new
> software packages that are installed...
> 
> > We should also take the kinds of access we have seen on a file into account.
> 
> Yes, but it should be done at the VFS level, not in the filesystem
> itself. Integrated into the current hot inode/range tracking that is
> being worked on right now, I'd suggest.
> 
> IOWs, these access policy issues are not unique to F2FS or it's use
> case. Anything to do with access hints, policy, tracking, file
> classification, etc that can influence data locality, reclaim,
> migration, etc need to be dealt with at the VFS, independently of a
> specific filesystem. Filesystems can make use of that information
> how they please (whether in the kernel or via userspace tools), but
> having filesystem specific interfaces and implementations of the
> same functionality is extremely wasteful. Let's do it once, and do
> it right the first time. ;)

I agree that VFS should support something, but before then, it needs
to do something by the file system first.
Because, we have to figure out what kind of information are really useful.
Thanks,

> 
> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

