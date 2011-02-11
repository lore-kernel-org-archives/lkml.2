Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207Ab1BKPJT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 10:09:19 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50929 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab1BKPJS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 10:09:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:content-type;
        b=OsaopfRiF07SE57HHT+KFyogixVexBoQy+h+uQsGC0MSGt9Jd5N2DTYdiT1v3pqgOx
         VpB9DYG/oWysKjIZ/uNKOJZ/2hSQ/sYhk8yhen6Hn6Qdhy13Hdq8kDFPmgwBNBNYJGYP
         6bkanf1MAsDTitMQXGVu7pgUib3ISafTzKgfE=
MIME-Version: 1.0
From: Andrew Lutomirski <andy@luto.us>
Date: Fri, 11 Feb 2011 10:08:52 -0500
X-Google-Sender-Auth: YsgBfe5aJ1kwTiG_Xvs6hG1VQYc
Message-ID: <AANLkTin4628kHMRogoAarDWyGGb8-6-BiixihJmy_AUj@mail.gmail.com>
Subject: 2.6.37: Multi-second I/O latency while untarring
To: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As I type this, I have an ssh process running that's dumping data into
a fifo at high speed (maybe 500Mbps) and a tar process that's
untarring from the same fifo onto btrfs.  The btrfs fs is mounted -o
space_cache,compress.  This machine has 8GB ram, 8 logical cores, and
a fast (i7-2600) CPU, so it's not an issue with the machine struggling
under load.

Every few tens of seconds, my system stalls for several seconds.
These stalls cause keyboard input to be lost, firefox to hang, etc.

Setting tar's ionice priority to best effort / 7 or to idle makes no difference.

ionice idle and queue_depth = 1 on the disk (a slow 2TB WD) also makes
no difference.

max_sectors_kb = 64 in addition to the above doesn't help either.

latencytop shows regular instances of 2-7 *second* latency, variously
in sync_page, start_transaction, btrfs_start_ordered_extent, and
do_get_write_access (from jbd2 on my ext4 root partition).

echo 3 >drop_caches gave me 7 GB free RAM.  I still had stalls when
4-5 GB were still free (so it shouldn't be a problem with important
pages being evicted).

In case it matters, all of my partitions are on LVM on dm-crypt, but
this machine has AES-NI so the overhead from that should be minimal.
In fact, overall CPU usage is only about 10%.

What gives?  I thought this stuff was supposed to be better on modern kernels.

--Andy
