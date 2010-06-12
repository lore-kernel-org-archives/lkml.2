Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab0FLFAz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 01:00:55 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36393 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab0FLFAx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 01:00:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=xYzA/RgqGov/SvgjyzDjEs4ky5KN85W2vqBfJN/KWF9+tKlVTiEzc0qNXKV9i1cyV9
         QKCb8CawdExCPs5q979Eq5kzmZpvg+Wb6GyA2hLcYXJtw28MYyousE2VRGKwduin1HUZ
         SV8nH7u5P8/4tevKc7hyJpfD3WvrAFycVsxhY=
MIME-Version: 1.0
In-Reply-To: <20100524011907.GC12087@dastard>
References: <20100523002023.41f5a5c8@aaa.pulp.binarylife.net>
	<20100523101856.GL2150@dastard>
	<20100523092344.0fcaab42@aaa.pulp.binarylife.net>
	<20100524011907.GC12087@dastard>
Date: Sat, 12 Jun 2010 01:00:52 -0400
X-Google-Sender-Auth: R6zeX-zAHQgQ0R4HCU6oUtuZNDA
Message-ID: <AANLkTinyt6V9phjXrzrxm67THdRwTiN6pOim3uBUbo1Z@mail.gmail.com>
Subject: Re: WARNING in xfs_lwr.c, xfs_write()
From: Ilia Mirkin <imirkin@alum.mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Roman Kononov <roman@binarylife.net>, xfs@oss.sgi.com,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to pick up an old-ish thread, but I have a similar situation:

On Sun, May 23, 2010 at 9:19 PM, Dave Chinner <david@fromorbit.com> wrote:
> On Sun, May 23, 2010 at 09:23:44AM -0500, Roman Kononov wrote:
>> On 2010-05-23, 20:18:56 +1000, Dave Chinner <david@fromorbit.com> wrote:
>> > Can you find out what the application is triggering this?

I noticed this happening with mysql and xtrabackup -- the latter opens
up mysql's files while mysql is still running (and modifying its own
files) and backs them up in a (hopefully) safe way. mysql had been
running on the machine without any such warnings for a while before we
ran the backup, so I'm pretty sure that the backup is involved,
although its process is never listed. Specifically the warning is:

[2584257.839386] ------------[ cut here ]------------
[2584257.839395] WARNING: at fs/xfs/linux-2.6/xfs_lrw.c:651
xfs_write+0x3dc/0x784()
[2584257.839398] Hardware name: PowerEdge R710
[2584257.839399] Modules linked in: nfsd cifs iTCO_wdt iTCO_vendor_support
[2584257.839406] Pid: 7761, comm: mysqld Not tainted 2.6.33-gentoo-r2 #1
[2584257.839407] Call Trace:
[2584257.839411]  [<ffffffff8120da46>] ? xfs_write+0x3dc/0x784
[2584257.839415]  [<ffffffff81038733>] warn_slowpath_common+0x77/0xa4
[2584257.839417]  [<ffffffff8103876f>] warn_slowpath_null+0xf/0x11
[2584257.839419]  [<ffffffff8120da46>] xfs_write+0x3dc/0x784
[2584257.839424]  [<ffffffff810033ce>] ? apic_timer_interrupt+0xe/0x20
[2584257.839427]  [<ffffffff8120a51a>] xfs_file_aio_write+0x5a/0x5c
[2584257.839430]  [<ffffffff810d7cbe>] do_sync_write+0xc0/0x106
[2584257.839435]  [<ffffffff810ff862>] ? __fsnotify_parent+0xc7/0xd3
[2584257.839437]  [<ffffffff810d8624>] vfs_write+0xab/0x105
[2584257.839439]  [<ffffffff810d86da>] sys_pwrite64+0x5c/0x7d
[2584257.839442]  [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b
[2584257.839444] ---[ end trace 8b0c2a6e5e86745f ]---

> Yes, it should be safe, but the kernel code can't know whether this
> is true or not - there are no specific interlocks with direct IO to
> prevent concurrent buffered IO to the same region while a direct IO
> is in progress. XFS does best effort attempts to maintain coherency
> does not provide any guarantees, hence the warning when known race
> conditions are tripped.

Would it be safe to remove the warning at
fs/xfs/linux-2.6/xfs_lrw.c:651 (which looks like it has moved to
xfs_file.c in 2.6.34)? It seems undesirable to get a long stream of
these (51 in this particular instance) every time we run a backup...
IOW, is the warning purely something along the lines of "Userspace is
doing something wonky, but the underlying FS will still be fine no
matter what" kind of deal, or could there be an actual problem with
the XFS metadata itself?

Thanks for any advice,

Ilia Mirkin
imirkin@alum.mit.edu
