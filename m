Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2JOOF5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:05:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58855 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693Ab2JOOFx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:05:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Changman Lee <cm224.lee@gmail.com>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
Date: Mon, 15 Oct 2012 14:05:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>,
        Jaegeuk Kim <jaegeuk.kim@gmail.com>,
        =?utf-8?q?=EA=B9=80=EC=9E=AC=EA=B7=B9?= <jaegeuk.kim@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chur.lee@samsung.com" <chur.lee@samsung.com>,
        "cm224.lee@samsung.com" <cm224.lee@samsung.com>,
        "jooyoung.hwang@samsung.com" <jooyoung.hwang@samsung.com>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com> <201210141519.37752.arnd@arndb.de> <CAN863PuYDSSFmaKtsVvdX4aFpS8hAMvFmhJpsky0x=ySn0QsqQ@mail.gmail.com>
In-Reply-To: <CAN863PuYDSSFmaKtsVvdX4aFpS8hAMvFmhJpsky0x=ySn0QsqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201210151405.41392.arnd@arndb.de>
X-Provags-ID: V02:K0:4UAJ14EI/py0xGtvlmc+3X+dIwLGNcZ4lBKXLh2aWvU
 F5q1BkvtiicWkAztkrkRa3zFM3f8bFR9I6Rpdy6Kq4OMO11R3+
 HlBqsFz0EZSGhY65/F+QcLA+iPiLXlPRJFC5yiW0S+/Xk1phJH
 yqik61XptF2m6uhScUvrtOBhdLHhr4EEQuljgfTQPTChhSCmXt
 sL5Gd4p6e3ReO3z9XuKKvmk7DB/9mxHNtrZpJhJLeMlsrlQF3C
 gm7ZPolxypOV289HBp5I8z4xHY50PK3TeKBa4CPm8ffJGit95T
 /9Uf9gJm0lMOTd8vktO6uCERJaVJ+jpzJl7ItfcUkuEP2im8gs
 ncS8KywsxQbQyoHCNPFU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 October 2012, Changman Lee wrote:
> 2012년 10월 15일 월요일에 Arnd Bergmann<arnd@arndb.de>님이 작성:
> > It is only a performance hint though, so it is not a correctness issue the
> > file system gets it wrong. In order to do efficient garbage collection, a log
> > structured file system should take all the information it can get about the
> > expected life of data it writes. I agree that the list, even in the form of
> > mkfs time settings, is not a clean abstraction, but in the place of an Android
> > phone manufacturer I would still enable it if it promises a significant
> > performance advantage over not using it. I guess it would be nice if this
> > could be overridden in some form, e.g. using an ioctl on the file as ext4 does.
> >
> Right. This is related with HOT/COLD separation policy of f2fs. If we know
> that data is COLD, we can manage gc effectively.
> I think that ext lists are placed in sb is better like your advice because
> it's difficult to fix user app. Although it's nasty way.

Ok. I think you should adapt the terminology though. Right now, the optimization
is to mark the data as COLD because we expect it to be written less often than
other kinds of data. However, the hot/cold terms are usually only applied to
data that we assume is going to be written soon or not based on how often
the same data has been accessed in the past.

Anything you detect from the file name is not really a hint on hot/cold
files, but rather on the expected access pattern: These files are going
to be written once, and will be read-only after that, they are probably
multiple megabytes in size, and if you have a lot of them, they are likely
to live for the same time.

It may well be possible that we later decide to use the hint in a different
way, e.g. to put these files into yet another separate log, aside from
other hot or cold files.

> > We should also take the kinds of access we have seen on a file into account.
> > E.g. if someone opens a file O_RDWR and performs seek or pwrite on it, we can
> > assume that it's not in the category of typical media files, and a file that
> > gets written to disk linearly in multiple megabytes might belong into the
> > category even if it is named otherwise.
> >
> This is more general but it's hard to adapt now.

I think it's important to leave the option open for a future optimization.
Right now, what we have to get agreement on is the on-disk format, because
we absolutely don't want to make incompatible changes to that once f2fs
has been merged into the kernel and is getting used on real systems.

This is independent of how the code is implemented at the moment, and
any tuning regarding how to group different kinds of data into the six
logs is completely up to how things work out in practice. But you should
definitely ensure that those changes don't require changing the format
if we decide to use a different number of logs in the future, or to
use the logs differently.

The split between logs for nodes on the one hand and data on the other
is something that can well be hardcoded, and it's ok to have a hard
upper bound on the number of logs in the file system, possibly higher
than 6.

	Arnd
