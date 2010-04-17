Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0DQTnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 15:43:25 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:43339 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab0DQTnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 15:43:24 -0400
To: linux-kernel@vger.kernel.org
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <trond@netapp.com>
Subject: 2.6.34rc4 NFS writeback regression (bisected): client often fails to delete things it just created
From: Nix <nix@esperi.org.uk>
Emacs: don't cry -- it won't help.
Date: Sat, 17 Apr 2010 20:43:16 +0100
Message-ID: <87tyr9dfvv.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Trond Cc:ed as this seems to be a bug in one of your
 writeback-for-2.6.34 commits.]

In 2.6.34rcX (tip of tree) I've started seeing this sort of thing when
building over NFS (v3):

[...]
-- Found LibXslt: /usr/lib64/libxslt.so
--   found libxml-2.0, version 2.7.6
-- Found LibXml2: /usr/lib64/libxml2.so
-- Found shared-mime-info version: 0.71
-- Looking for __progname
CMake Error: Remove failed on file: /usr/src/kde/x86_64-mutilate/build/CMakeFiles/CMakeTmp/CMakeFiles/cmTryCompileExec.dir/.nfs000000000031fc510000082f: System Error: Device or resource busy
[... eventually, cmake fails because of this error.]

The silly-renamed files are invariably no longer in use (they tend to be
GCC output, ELF executables run as part of testsuites) but haven't been
removed, and they -EBUSY when removal is attempted.

A complete strace log of running cmake against current HEAD (with lots
of these errors) is at
<http://www.esperi.org.uk/~nix/temporary/strace-kdelibs-nfs-EBUSY.log.lzma>.
I can do a packet capture too if you like.

I also see it after doing 'make install's followed by an 'rm -rf' of the
build tree: the rm -rf fails because half the files are 'in use' (they
aren't). Repeating the rm -rf a few seconds later works. fuser, even as
root, shows no processes holding these files open.

This bisects down to

commit acdc53b2146c7ee67feb1f02f7bc3020126514b8
Author: Trond Myklebust <Trond.Myklebust@netapp.com>
Date:   Fri Feb 19 17:03:26 2010 -0800

    NFS: Replace __nfs_write_mapping with sync_inode()
    
    Now that we have correct COMMIT semantics in writeback_single_inode, we can
    reduce and simplify nfs_wb_all(). Also replace nfs_wb_nocommit() with a
    call to filemap_write_and_wait(), which doesn't need to hold the
    inode->i_mutex.
    
    With that done, we can eliminate nfs_write_mapping() altogether.
    
    Signed-off-by: Trond Myklebust <Trond.Myklebust@netapp.com>

I suspect that unlink()ing a not otherwise open file for which writeback
is still underway is causing the files to be sillyrenamed because
writeback is holding them open. If writeback is the only user, they
should surely not be held open: nobody cares what their contents are,
and a lot of code depends on rm -r of directories containing recently-
written-but-still-closed files succeeding.
