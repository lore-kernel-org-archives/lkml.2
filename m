Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2JOE1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 00:27:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:53132 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab2JOE1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 00:27:39 -0400
X-IronPort-AV: E=Sophos;i="4.80,586,1344236400"; 
   d="scan'208";a="700731101"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Chen Gang <gang.chen@asianux.com>
CC: Jeff Layton <jlayton@redhat.com>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug fix] nfs-client: fix nfs_inode_attrs_need_update for async
 read_done comes during truncating to smaller size
Thread-Topic: [Bug fix] nfs-client: fix nfs_inode_attrs_need_update for
 async read_done comes during truncating to smaller size
Thread-Index: AQHNqnpVDDzstrioNkubCev8dufUjZe6OzGA
Date: Mon, 15 Oct 2012 04:27:35 +0000
Message-ID: <4FA345DA4F4AE44899BD2B03EEEC2FA909236BB5@SACEXCMBX04-PRD.hq.netapp.com>
References: <507B70F1.7040903@asianux.com>
In-Reply-To: <507B70F1.7040903@asianux.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.114]
Content-Type: text/plain; charset="utf-8"
Content-ID: <0EEEFD88C4FD754C99DBA09DAF2EA1C9@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9F4Rik6023367

On Mon, 2012-10-15 at 10:12 +0800, Chen Gang wrote:
> Hello Trond Myklebust, Jeff Layton:
> 
> 1) Root Cause:
>    A) begin truncate to smaller, after async read finish starting.
>    B) async read done come, after truncate operation change inode size.
>    C) in nfs_inode_attrs_need_update, nfs_size_need_update return true.
>       i)   the bigger size is the original old size of client itself.
>       ii)  the smaller size is the current true size.
>       iii) nfs_inode_attrs_need_update not consider this situation.
> 
> 2) Fix nfs_size_need_update:
>    A) delete it:
>       i)   it is for performance, not necessary (not for correctness).
>       ii)  if it was necessary, it should use "!=" instead of '>'.
>       iii) it is the simplest way to fix this bug (maybe not best way).
>    B) consider this situation in it:
>       i)   it is the best way.
>       ii)  it is a little complex (need think of)
>       iii) sorry for I do not know how to fix it (at least now).
>    C) not touch it:
>       i)   correct another place (such as nfs_update_inode)
>       ii)  it is a bad idea (at least, I think it is)
>       iii) we need keep the source code as clearer as possible.
> 
> 3) Test Result:
>    A) it is one client and one server separately, under 3.6-rc5 x86_32.
>    B) use one process (fsx-linux) test (only one user mode thread).
>    C) only use read, truncate, llseek, fstat operation for one file.
> 
>    Before delete nfs_size_need_update, it causes issue.
>    After delete nfs_size_need_update, it is ok.

nfs_size_need_update is not about performance. It is a heuristic that is
entirely about ensuring correctness when faced with the fact that most
Linux filesystems are utterly incapable of reporting with modifications
that occur within < 1 second intervals because their mtime/ctime is
limited to 1 second resolutions.

Now, what are the conditions of your test setup? The above bug report is
meaningless unless it includes a description of what is being exported
by the server (including a proper listing of the contents
of /etc/exports and /proc/mounts). It should also include a description
of the NFS client mount options (see /proc/mounts on the client).

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
