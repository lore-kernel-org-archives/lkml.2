Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112Ab2JQDZu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 23:25:50 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28476 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755690Ab2JQDZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 23:25:48 -0400
X-AuditID: cbfee61b-b7fd46d0000046e0-51-507e253b45be
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Dave Chinner'" <david@fromorbit.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>
Cc: "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <20121015223409.GE2739@dastard>
 <015901cdab42$06deac20$149c0460$%kim@samsung.com>
 <201210161138.35388.arnd@arndb.de> <20121016204412.GF2864@dastard>
 <1350426621.1958.119.camel@kjgkr> <20121016225410.GA26797@dastard>
In-reply-to: <20121016225410.GA26797@dastard>
Subject: RE: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Wed, 17 Oct 2012 12:25:46 +0900
Message-id: <021501cdac17$1912f330$4b38d990$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2r8SpfKFF8H56FQ+20JZop/cNydwAJUyHw
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHLMWRmVeSWpSXmKPExsVy+t9jQV1r1boAg/+9YhaXd81hc2D0+LxJ
	LoAxissmJTUnsyy1SN8ugStjwZ17jAVHhCtmdk5gamBcz9/FyMkhIWAi8ePlAhYIW0ziwr31
	bF2MXBxCAtMZJSa+/AXlzGeS2NCwm7GLkYODTUBbYvN+A5AGEQF/iZ2vehhBapgFJjBJ3Fmy
	ixGiYS6TxLs5l9lBqjgFdCWW3t7NBmILC3hIXPu6ASzOIqAqsaXjKzOIzStgK3H2/Xt2CFtQ
	4sfke2AnMQvoSXz8c5sRwpaX2LzmLTPIERIC6hKP/upCHGEksfXuHKgSEYl9L94xTmAUmoVk
	0iwkk2YhmTQLScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ+bmbGMGh/Ex6B+OqBotDjAIc
	jEo8vAFLawOEWBPLiitzDzFKcDArifCaNwKFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8zZ7pAQI
	CaQnlqRmp6YWpBbBZJk4OKUaGOdHsHRfkb56XlfkssmbjawrDNfdEbcscDZLuCi8+rTMxs8y
	L5Un/2np2WDAEdPvXz93jQGT6tQl07/uF3u2xk/ux48F++vlX/Kumvqlkj3ukGxw8hqdxS9T
	3j+OijYSvNc5tZxjxZFXO8yMy7cr/Hk53ZblqpnYEZ6Uf3mbnC1TDTxvH9OaZKLEUpyRaKjF
	XFScCAA2kMJyYQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Oct 17, 2012 at 07:30:21AM +0900, Jaegeuk Kim wrote:
> > > > > OTOH, I think xattr itself is for users, not for communicating
> > > > > between file system and users.
> > > >
> > > > No, you are mistaken in that point, as Dave explained.
> > >
> > > e.g. selinux, IMA, ACLs, capabilities, etc all communicate
> > > information that the kernel uses for access control. That's why
> > > xattrs have different namespaces like "system", "security" and
> > > "user". Only user attributes are truly for user data
> > > - the rest are for communicating information to the kernel....
> > >
> >
> > I agree that "system" is used by kernel.
> > How about the file system view?
> 
> Not sure what you mean - the filesystem woul dsimply read the xattrs
> in the system namespace as it needs, just like the other subsystems
> like selinux or IMA do.
> 
> > Would you explain what file systems retrieve xattrs and use
> > them with their own purpose?
> 
> I think cachefs users a "CacheFiles.cache" namespace for storing
> information it needs in xattrs. ecryptfs stores crypto metadata in
> xattrs in the lower filesytem. NFSv4 servers store junction mount
> information in xattrs.
> 
> So there are examples where filesystems use xattrs for special
> information. However, in most cases filesystems don't need xattrs
> for their own metadata primarily because that gets added to their
> own on-disk formats. IThe above are all "overlay" style filesystems
> that don't have their own on-disk formats, so need to use xattrs to
> store their per-inode metadata.
> 
> The case of access hints and allocation policies are not somethign
> that are native to any filesystem on-disk format. They are abstract
> concepts that really only the software generating/using that
> information knows about. Given we want the software that uses this
> information to be in VFS, it is separate from every filesystem and
> this is exactly the use case that system xattrs were intended for.
> :)

I understand. Thank you very much. :)

> 
> > Sorry, I'm not familiar with xattrs in depth.
> >
> > Unfortunately, "system" is not implemented in f2fs yet. :(
> 
> If you've already implemented the user.* namespace, then it's
> trivial to support the other namespaces - it's just prefixing the
> xattrs with the appropriate string instead of "user"....
> 

Ok, I'll do right now.
Thanks, again.

> Cheers,
> 
> Dave.
> --
> Dave Chinner
> david@fromorbit.com

