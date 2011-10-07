Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab1JGLUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:20:45 -0400
Received: from mail.de.keymile.com ([195.8.104.1]:34874 "HELO
	mail.de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759833Ab1JGLUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:20:44 -0400
From: Gerlando Falauto <gerlando.falauto@keymile.com>
To: linux-kernel@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>,
        Gerlando Falauto <gerlando.falauto@keymile.com>
Subject: CIFS fails to automount DFS shares
Date: Fri,  7 Oct 2011 13:09:30 +0200
Message-Id: <1317985771-28876-1-git-send-email-gerlando.falauto@keymile.com>
X-Mailer: git-send-email 1.7.1
X-ESAFE-STATUS: [srvhellgate.de.keymile.net] Mail clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am new here, so please forgive me if I am abusing something or being
too verbose...
I found a problem with samba/CIFS when the server uses DFS.
The same problem (or at least a similar one) has also been reported in:
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/740062
https://bugs.launchpad.net/ubuntu/+source/cifs-utils/+bug/809243

What happens is that when you mount a SAMBA share which has DFS folders
(i.e. folders which are physically located at another server, sort-of a
remote symlink), you get the following error when you try to access that
directory. 

$ mount -t cifs //server/dfs /mnt/dfs
$ cd /mnt/dfs
$ ls -l
total 0
drwx------ 0 user     root 0 May  4  2010 test
$ cd test
bash: cd: test: Is a directory

What should happen instead is that the remote share should get
automagically mounted under "/mnt/dfs/test".

Apparently it all started here:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=01c64feac45cea1317263eabc4f7ee1b240f297f

which introduced automount for CIFS mounts as well (as opposed to
simulating a symlink), and was admittedly untested.
So apparently this problem has been lying around since 2.6.38-rc1.

I did some futher investigation and found that this behaviour only
appears when the name of the directory in question has been cached
somehow.
So, for instance, if you do not "ls" on "/mnt/dfs" before tryint to "cd
test", the remote share gets happily mounted.
Everything also works when trying to cd into "test" spelled with a
different case: "cd Test", "cd TEST", cd "TeSt" would always succeed.
Also in that case the direntry would not be present.
The missing point in the broken case is that follow_automount() is not
called beacuse DCACHE_NEED_AUTOMOUNT is not set, and apparently
d_instantiate() is the only way to go.

This patch seems to fix the problem by marking as no-longer-valid a
dentry whose inode turned out to be of automount type; I am no expert in
this area so I am not quite sure this is the best way to approach this.

Particularly, according to Documentation/filesystems/vfs.txt:
<<<
d_revalidate may be called in rcu-walk mode (nd->flags & LOOKUP_RCU).
If in rcu-walk mode, the filesystem must revalidate the dentry without
blocking or storing to the dentry, d_parent and d_inode should not be
used without care (because they can go NULL), instead nd->inode should
be used.
>>>

but nd->inode is definitely something different than direntry->d_inode.

Thank you.
Gerlando

P.S. I just noticed how nfs_lookup_verify_inode() does pretty much the
same thing, so maybe my proposal is not that foolish after all.

Gerlando Falauto (1):
  CIFS: fix automount for DFS shares

 fs/cifs/dir.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

