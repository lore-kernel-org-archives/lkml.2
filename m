Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937898Ab0CPPbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 11:31:16 -0400
Received: from mail-fx0-f219.google.com ([209.85.220.219]:36618 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933060Ab0CPPbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 11:31:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:cc:subject;
        b=TXuFkD33d/+c0+Mu6h0TBrpqsb7iSfvRnLUB3YvRVqiSJeHtW61QKI9uLWfwZB8eHe
         owOjzD3TwsuI4m/8zlX3sgGRS9oZ7WoMQEcaLLTxtsmVA3TNHg1CYTQZWzOgwrE0tFV2
         f4FIELwGhOtfHPtn4Y31zGMQVwfFS2ofYINGo=
Message-ID: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
Date: Tue, 16 Mar 2010 08:31:12 -0700 (PDT)
From: Ben Gamari <bgamari.foss@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Olly Betts <olly@survex.com>, martin f krafft <madduck@madduck.net>
Subject: Poor interactive performance with I/O loads with fsync()ing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey all,

Recently I started using the Xapian-based notmuch mail client for everyday
use.  One of the things I was quite surprised by after the switch was the
incredible hit in interactive performance that is observed during database
updates. Things are particularly bad during runs of 'notmuch new,' which scans
the file system looking for new messages and adds them to the database.
Specifically, the worst of the performance hit appears to occur when the
database is being updated.

During these periods, even small chunks of I/O can become minute-long ordeals.
It is common for latencytop to show 30 second long latencies for page faults
and writing pages.  Interactive performance is absolutely abysmal, with other
unrelated processes feeling horrible latencies, causing media players,
editors, and even terminals to grind to a halt.

Despite the system being clearly I/O bound, iostat shows pitiful disk
throughput (700kByte/second read, 300 kByte/second write). Certainly this poor
performance can, at least to some degree, be attributable to the fact that
Xapian uses fdatasync() to ensure data consistency. That being said, it seems
like Xapian's page usage causes horrible thrashing, hence the performance hit
on unrelated processes. Moreover, the hit on unrelated processes is so bad
that I would almost suspect that swap I/O is being serialized by fsync() as
well, despite being on a separate swap partition beyond the control of the
filesystem.

Xapian, however, is far from the first time I have seen this sort of
performance cliff. Rsync, which also uses fsync(), can also trigger this sort
of thrashing during system backups, as can rdiff. slocate's updatedb
absolutely kills interactive performance as well.

Issues similar to this have been widely reported[1-5] in the past, and despite
many attempts[5-8] within both I/O and memory managements subsystems to fix
it, the problem certainly remains. I have tried reducing swappiness from 60 to
40, with some small improvement and it has been reported[20] that these sorts
of symptoms can be negated through use of memory control groups to prevent
interactive process pages from being evicted.

I would really like to see this issue finally fixed. I have tried
several[2][3] times to organize the known data about this bug, although in all
cases discussion has stopped with claims of insufficient data (which is fair,
admittedly, it's a very difficult issue to tackle). However, I do think that
_something_ has to be done to alleviate the thrashing and poor interactive
performance that these work-loads cause.

Thanks,

- Ben


[1] http://bugzilla.kernel.org/show_bug.cgi?id=5900
[2] http://bugzilla.kernel.org/show_bug.cgi?id=7372
[3] http://bugzilla.kernel.org/show_bug.cgi?id=12309
[4] http://lkml.org/lkml/2009/4/28/24
[5] http://lkml.org/lkml/2009/3/26/72
[6] http://notmuchmail.org/pipermail/notmuch/2010/001868.html

[10] http://lkml.org/lkml/2009/5/16/225
[11] http://lkml.org/lkml/2007/7/21/219
[12] http://lwn.net/Articles/328363/
[13] http://lkml.org/lkml/2009/4/6/114

[20] http://lkml.org/lkml/2009/4/28/68

