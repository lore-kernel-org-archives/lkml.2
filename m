Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab1D3Uuf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 16:50:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52373 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755157Ab1D3Uub convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 16:50:31 -0400
MIME-Version: 1.0
In-Reply-To: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
References: <Xp4OiTz83N.A.O0D.JVGvNB@chimera>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Apr 2011 13:50:04 -0700
Message-ID: <BANLkTik2L0BQ0cwOnWrgjyvxV4KMHkgaFQ@mail.gmail.com>
Subject: Re: 2.6.39-rc5-git4: Reported regressions from 2.6.38
To: "Rafael J. Wysocki" <rjw@sisk.pl>, Alex Elder <aelder@sgi.com>,
        xfs@oss.sgi.com
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 30, 2011 at 12:42 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=34012
> Subject         : 2.6.39-rc4+: oom-killer busy killing tasks
> Submitter       : Christian Kujau <lists@nerdbynature.de>
> Date            : 2011-04-22 1:57 (9 days old)
> Message-ID      : <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org>
> References      : http://marc.info/?l=linux-kernel&m=130343744622331&w=2

Judging by the extended debug info in:

   http://nerdbynature.de/bits/2.6.39-rc4/oom/
   (The -9 files are the current ones)

that thing shows a _lot_ of xfs inodes:

  xfs_inode         479187 479187   1120   14    4 : tunables    0
0    0 : slabdata  34329  34329      0

even though there aren't that many dentries (each inode should have at
least one dentry associated with it under normal circumstances):

  dentry             97896  97900    160   25    1 : tunables    0
0    0 : slabdata   3916   3916      0

and then later when the system gets low on memory, the dentries shrink:

  dentry              1017   3525    160   25    1 : tunables    0
0    0 : slabdata    141    141      0

but the XFS inodes do not:

  xfs_inode         557579 557579   1120   14    4 : tunables    0
0    0 : slabdata  41492  41492      0

so I suspect it's some kind of XFS inode leak.

                      Linus
