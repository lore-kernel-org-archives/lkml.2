Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932175Ab2JNPT6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:19:58 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:53928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080Ab2JNPTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 11:19:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vyacheslav Dubeyko <slava@dubeyko.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Sun, 14 Oct 2012 15:19:37 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Jaegeuk Kim <jaegeuk.kim@gmail.com>,
        =?utf-8?q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <1350198545.1915.233.camel@kjgkr> <A7BD3CDD-330C-498A-BB36-631DE6B9777C@dubeyko.com>
In-Reply-To: <A7BD3CDD-330C-498A-BB36-631DE6B9777C@dubeyko.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201210141519.37752.arnd@arndb.de>
X-Provags-ID: V02:K0:RG86EFzFQYUe0jHage3D6avOiJhtO9Rmk+dI5x4v1uI
 sr2ZSkn7im107YK2GmmEXGeflXUd2oADFV6XSXY1CVlxgQbP9b
 gs4iylkpRkACsmtRPiYzcGhtD1xPgrmUmfzmLgFVRe/E4GhyEw
 OfLNESA16Hmo30rruWPrgJsuOrrXbn4Q+9w2AoMeB9e9uGBGLa
 tGC9j2alfYP3FsqOcP8hk+ieqORnaQ8XUbYF3rxvZhATv2oLpR
 FtcgZ/OMabWdeB8JieVNirFnRW0PbbEyD/e0FgKFoSvTmx4PAZ
 QJvoqqrRvvRAnJ0ViZY2MT/kkjz4eRH1VesV2lJ/2veBFqZbAX
 krgvCz/QYp0XP8XabwDI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 October 2012, Vyacheslav Dubeyko wrote: 
> On Oct 14, 2012, at 11:09 AM, Jaegeuk Kim wrote:
> > 2012-10-14 (일), 02:21 +0400, Vyacheslav Dubeyko:
> >> 
> >> By the way, how about extended attributes? It is possible to save in extended attribute
> >> a hint about file's content nature during creation operation or later. Moreover, extended
'> >> attribute gives possibility to change hint after renaming operation, for example.
> >> 
> > 
> > I think xattr is not a proper way to communicate between file system and
> > users.
> 
> I don't understand why you think that xattr is not proper way. Extended attributes are the
> way of adding some additional properties to filesystem object, from my point of view.

There are different kinds of extended attributes, as described by
http://linux.die.net/man/5/attr

I would think that the system namespace can hold an attribute that can be used for this.

> > How about fadvise()?
> > 
> 
> The fadvise() is a good suggestion. But, as I can understand, such solution requires
> using fadvise() during application implementation. So, from one point of view, it exists
> many applications that doesn't use fadvise() and, from another point of view, developers
> change style of coding not so easy.

Most importantly, fadvise is about accessing an open file, and I would expect anything
passed in there to be forgotten after the file is closed, while an attribute is associated
with the inode and should persist across open/close as well as mount/umount cycles.

> Extended attributes are more flexible way, from my point of view. The xattr gives
> possibility to make hint to filesystem at any time and without any dependencies with
> application's functional opportunities. Documented way of using such extended attributes
> gives to user flexible way of manipulation of filesystem behavior (but I remember that
> you don't believe in an user :-)).
> 
> So, I think that fadvise() and extended attributes can be complementary solutions.

Right. Another option is to have ext4 style attributes, see 
http://linux.die.net/man/1/chattr

Unlike extended attributes, there is a limited number of those, and they can
only be boolean flags, but that might be enough for this particular use case.

The main reason I can see against extended attributes is that they are not stored
very efficiently in f2fs, unless a lot of work is put into coming up with a good
implementation. A single flags bit can trivially be added to the inode in
comparison (if it's not there already).

> Anyway, hardcoding or saving in filesystem list of file extensions is a nasty way. It
> can be not safe or hardly understandable by users the way of reconfiguration filesystem 
> by means of tunefs or debugfs with the purpose of file extensions addition in such 
> "black-box" as TV or smartphones, from my point of view.

It is only a performance hint though, so it is not a correctness issue the
file system gets it wrong. In order to do efficient garbage collection, a log
structured file system should take all the information it can get about the
expected life of data it writes. I agree that the list, even in the form of
mkfs time settings, is not a clean abstraction, but in the place of an Android
phone manufacturer I would still enable it if it promises a significant
performance advantage over not using it. I guess it would be nice if this
could be overridden in some form, e.g. using an ioctl on the file as ext4 does.

We should also take the kinds of access we have seen on a file into account.
E.g. if someone opens a file O_RDWR and performs seek or pwrite on it, we can
assume that it's not in the category of typical media files, and a file that
gets written to disk linearly in multiple megabytes might belong into the
category even if it is named otherwise.

	Arnd
