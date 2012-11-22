Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab2KVVXy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:23:54 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53959 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab2KVVWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:22:41 -0500
Message-Id: <20121122212235.690256454@openvz.org>
User-Agent: quilt/0.48-1
Date: Fri, 23 Nov 2012 01:15:26 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        James Bottomley <jbottomley@parallels.com>,
        Matthew Helsley <matt.helsley@gmail.com>,
        aneesh.kumar@linux.vnet.ibm.com, bfields@fieldses.org, oleg@redhat.com,
        rientjes@google.com, tvrtko.ursulin@onelan.co.uk,
        linux-kernel@vger.kernel.org, Cyrill Gorcunov <gorcunov@openvz.org>,
        Andrey Vagin <avagin@openvz.org>, Al Viro <viro@zeniv.linux.org.uk>
Subject: [patch -mm 4/4] docs: Add documentation about /proc/<pid>/fdinfo/<fd> output
References: <20121122211522.075455799@openvz.org>
Content-Disposition: inline; filename=docs-proc-fdinfo
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Andrey Vagin <avagin@openvz.org>
CC: Al Viro <viro@ZenIV.linux.org.uk>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: James Bottomley <jbottomley@parallels.com>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>
CC: Matthew Helsley <matt.helsley@gmail.com>
CC: "J. Bruce Fields" <bfields@fieldses.org>
CC: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
CC: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
---
 Documentation/filesystems/proc.txt |   81 +++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)

Index: linux-2.6.git/Documentation/filesystems/proc.txt
===================================================================
--- linux-2.6.git.orig/Documentation/filesystems/proc.txt
+++ linux-2.6.git/Documentation/filesystems/proc.txt
@@ -41,6 +41,7 @@ Table of Contents
   3.5	/proc/<pid>/mountinfo - Information about mounts
   3.6	/proc/<pid>/comm  & /proc/<pid>/task/<tid>/comm
   3.7   /proc/<pid>/task/<tid>/children - Information about task children
+  3.8   /proc/<pid>/fdinfo/<fd> - Information about opened file
 
   4	Configuring procfs
   4.1	Mount options
@@ -1623,6 +1624,86 @@ pids, so one need to either stop or free
 if precise results are needed.
 
 
+3.7	/proc/<pid>/fdinfo/<fd> - Information about opened file
+---------------------------------------------------------------
+This file provides information associated with an opened file. The regular
+files have at least two fields -- 'pos' and 'flags'. The 'pos' represents
+the current offset of the opened file in decimal form [see lseek(2) for
+details] and the 'flags' denotes octal O_xxx mask the file has been
+created with [see open(2) for details].
+
+A typical output is
+
+	pos:	0
+	flags:	0100002
+
+The files such as eventfd, fsnotify, signalfd, epoll among the regular pos/flags
+pair provide additional information peculiar to the objects they represent.
+
+	Eventfd files
+	~~~~~~~~~~~~~
+	pos:	0
+	flags:	04002
+	eventfd-count:	5a
+
+	where 'eventfd-count' is hex value of a counter.
+
+	Signalfd files
+	~~~~~~~~~~~~~~
+	pos:	0
+	flags:	04002
+	sigmask:	0000000000000200
+
+	where 'sigmask' is hex value of the signal mask associated
+	with a file.
+
+	Epoll files
+	~~~~~~~~~~~
+	pos:	0
+	flags:	02
+	tfd:        5 events:       1d data: ffffffffffffffff
+
+	where 'tfd' is a target file descriptor number in decimal form,
+	'events' is events mask being watched and the 'data' is data
+	associated with a target [see epoll(7) for more details].
+
+	Fsnotify files
+	~~~~~~~~~~~~~~
+	For inotify files the format is the following
+
+	pos:	0
+	flags:	02000000
+	inotify wd:3 ino:9e7e sdev:800013 mask:800afce ignored_mask:0 fhandle-bytes:8 fhandle-type:1 f_handle:7e9e0000640d1b6d
+
+	where 'wd' is a watch descriptor in decimal form, ie a target file
+	descriptor number, 'ino' and 'sdev' are inode and device where the
+	target file lays on and the 'mask' is the mask of events, all in hex
+	form [see inotify(7) for more details].
+
+	In case if the kernel built with exportfs the path to the target file
+	is encoded as a file handle. The file handle provided by three fields
+	'fhandle-bytes', 'fhandle-type' and 'f_handle', all in hex format.
+
+	If the kernel is built without exportfs support the file handle won't be
+	printed out.
+
+	For fanotify files the format is the following
+
+	pos:	0
+	flags:	02
+	fanotify ino:2 sdev:800013 mask:1 ignored_mask:40000000 fhandle-bytes:8 fhandle-type:1 f_handle:0200000000000000
+
+	or
+
+	pos:	0
+	flags:	02
+	fanotify mnt_id:13 mask:1 ignored_mask:40000000
+
+	where 'ino', 'sdev' are target inode and device, 'mnt_id' is the mount point identifier,
+	'mask' is the events mask used and 'ignored_mask' is the mask of events which are
+	to be ignored. All written in hex format.
+
+
 ------------------------------------------------------------------------------
 Configuring procfs
 ------------------------------------------------------------------------------

