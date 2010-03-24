Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349Ab0CXPtq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 11:49:46 -0400
Received: from daytona.panasas.com ([67.152.220.89]:44367 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752784Ab0CXPtn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 11:49:43 -0400
Message-ID: <4BAA3493.1030802@panasas.com>
Date: Wed, 24 Mar 2010 17:49:39 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       pNFS Mailing List <pnfs@linux-nfs.org>,
       Benny Halevy <bhalevy@panasas.com>,
       "J. Bruce Fields" <bfields@citi.umich.edu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT BISECT] first bad commit: 1f36f774 Switch !O_CREAT case to use
 of do_last()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Mar 2010 15:49:42.0024 (UTC) FILETIME=[9E3C5880:01CACB69]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1f36f774b22a0ceb7dd33eca626746c81a97b6a5 is the first bad commit
commit 1f36f774b22a0ceb7dd33eca626746c81a97b6a5
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Dec 26 10:56:19 2009 -0500

    Switch !O_CREAT case to use of do_last()
    
    ... and now we have all intents crap well localized
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

:040000 040000 53c1effc5b22746bb83cdbc6a419bf898067882d 9606f7275fde188a056fd174aa1d622ac0630893 M      fs

I have a file corruption regression  bisected to above. (The one step before def4af30cf945a3735ffca865788ea84b30b25d9
was fine)

The test:

- I have an exofs filesystem mounted on /mnt/exofs
- []$ cd /mnt/exofs/some_linux_git; git status;
  All is fine
- []$ mount -t nfs4 -o minorversion=0 localhost:/ /mnt/nfs
  (Where etc/exports will export /mnt/exofs via nfs4.1)
- []$ cd /mnt/nfs/some_linux_git; git status;
  This will fail and will corrupt the .git/index file. Sometimes the file would be
  too short, and sometimes the file will become a directory (Yes really)

Simple revert of this patch over 2.6.34-rc2 will not work so I've not checked it.
A single threaded read like: "diff -r /mnt/nfs/some_linux_git /mnt/nfs/some_linux_git.back"
or even "diff -r /mnt/exofs/some_linux_git /mnt/nfs/some_linux_git" works fine.
A simple dd write test works fine as well.

So it looks like a race that only something like git can exercise, with multi threaded
reads and writes, through nfs/nfsd.

I know Benny also had failures with files export ontop of 2.6.34-rc2
(I looked at the patch, it is totally out of my league, please help)

I will try to reproduce this with a more conventional FS, or any thing else
I should test?

Thanks
Boaz
