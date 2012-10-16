Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab2JPC3s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 22:29:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36445 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2JPC3r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 22:29:47 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-2a-507cc68e5dfb
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
To: "'Arnd Bergmann'" <arnd@arndb.de>, "'Changman Lee'" <cm224.lee@gmail.com>
Cc: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>,
        "'Jaegeuk Kim'" <jaegeuk.kim@gmail.com>, viro@zeniv.linux.org.uk,
        "'Theodore Ts'o'" <tytso@mit.edu>, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
 <201210141519.37752.arnd@arndb.de>
 <CAN863PuYDSSFmaKtsVvdX4aFpS8hAMvFmhJpsky0x=ySn0QsqQ@mail.gmail.com>
 <201210151405.41392.arnd@arndb.de>
In-reply-to: <201210151405.41392.arnd@arndb.de>
Subject: RE: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Tue, 16 Oct 2012 11:29:33 +0900
Message-id: <015a01cdab46$145caa10$3d15fe30$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2q3jYOh33EL0JnQ5uoxXq+X3egWAAY/noQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd2+YzUBBi9XCFpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MD7P3Mxc8VqzY2fmHrYFxmlQXIyeHhICJxJOZ+1ghbDGJC/fW
	s3UxcnEICUxnlFi74xI7hDOfSWLt3SdAGQ4ONgFtic37DUAaRAQ8Jc49mcsCUsMsMINJ4vHu
	PSwQDecYJTYs72EHaeAU0JdYOtkMpEFYwEPi2tcN7CA2i4CqxIOfU5hBbF4BW4nDdxqZIGxB
	iR+T77GAtDILqEtMmZILEmYGWvvk3QVWkLAEUPjRX12IE4wkZi9azApRIiKx78U7xgmMQrOQ
	DJqFMGgWkkGzkHQsYGRZxSiaWpBcUJyUnmuoV5yYW1yal66XnJ+7iREcxM+kdjCubLA4xCjA
	wajEw5vhXBMgxJpYVlyZe4hRgoNZSYTXYyJQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+zR0qA
	kEB6YklqdmpqQWoRTJaJg1OqgVHfvP1QnBZzwYzmhf/NNpv4xSTzNhSV3tgjwfxy2qFM5i0b
	th4PXZYszDPzV3y0xIVP926tamJmi+fUvJf/5ddZr2cZddP7T2ueUuDVfci37nq1TDNnaVSS
	Nfevh+viDU+/cTAR3bBK+HXR37Luh9LKT298d3eYv9vqfYPslq7Xaza/tP8WxKvEUpyRaKjF
	XFScCABpmK0/XgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Monday 15 October 2012, Changman Lee wrote:
> > 2012년 10월 15일 월요일에 Arnd Bergmann<arnd@arndb.de>님이 작성:
> > > It is only a performance hint though, so it is not a correctness issue the
> > > file system gets it wrong. In order to do efficient garbage collection, a log
> > > structured file system should take all the information it can get about the
> > > expected life of data it writes. I agree that the list, even in the form of
> > > mkfs time settings, is not a clean abstraction, but in the place of an Android
> > > phone manufacturer I would still enable it if it promises a significant
> > > performance advantage over not using it. I guess it would be nice if this
> > > could be overridden in some form, e.g. using an ioctl on the file as ext4 does.
> > >
> > Right. This is related with HOT/COLD separation policy of f2fs. If we know
> > that data is COLD, we can manage gc effectively.
> > I think that ext lists are placed in sb is better like your advice because
> > it's difficult to fix user app. Although it's nasty way.
> 
> Ok. I think you should adapt the terminology though. Right now, the optimization
> is to mark the data as COLD because we expect it to be written less often than
> other kinds of data. However, the hot/cold terms are usually only applied to
> data that we assume is going to be written soon or not based on how often
> the same data has been accessed in the past.
> 
> Anything you detect from the file name is not really a hint on hot/cold
> files, but rather on the expected access pattern: These files are going
> to be written once, and will be read-only after that, they are probably
> multiple megabytes in size, and if you have a lot of them, they are likely
> to live for the same time.
> 
> It may well be possible that we later decide to use the hint in a different
> way, e.g. to put these files into yet another separate log, aside from
> other hot or cold files.
> 
> > > We should also take the kinds of access we have seen on a file into account.
> > > E.g. if someone opens a file O_RDWR and performs seek or pwrite on it, we can
> > > assume that it's not in the category of typical media files, and a file that
> > > gets written to disk linearly in multiple megabytes might belong into the
> > > category even if it is named otherwise.
> > >
> > This is more general but it's hard to adapt now.
> 
> I think it's important to leave the option open for a future optimization.
> Right now, what we have to get agreement on is the on-disk format, because
> we absolutely don't want to make incompatible changes to that once f2fs
> has been merged into the kernel and is getting used on real systems.
> 
> This is independent of how the code is implemented at the moment, and
> any tuning regarding how to group different kinds of data into the six
> logs is completely up to how things work out in practice. But you should
> definitely ensure that those changes don't require changing the format
> if we decide to use a different number of logs in the future, or to
> use the logs differently.
> 
> The split between logs for nodes on the one hand and data on the other
> is something that can well be hardcoded, and it's ok to have a hard
> upper bound on the number of logs in the file system, possibly higher
> than 6.
> 

Thank you for a lot of points to be addressed. :)
Maybe it's time to summarize them.
Please let me know what I misunderstood.

[In v2]
- Extension list
  : Mkfs supports configuring extensions by user, and that information
    will be stored in the superblock. In order to reduce the cleaning overhead,
    f2fs supports an additional interface, ioctl, likewise ext4.

- The number of active logs
  : No change will be done in on-disk layout (i.e., max 6 logs).
    Instead, f2fs supports changing the number with a mount option.
    Currently, I think 4, 5, and 6 would be enough.

- Section size
  : Mkfs supports multiples of segments for a section, not power-of-two.

[Future optimization]
- Data separation
  : file access pattern, and else?

> 	Arnd

