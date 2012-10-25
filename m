Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656Ab2JYOOV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:14:21 -0400
Received: from c62.cesmail.net ([216.154.195.54]:25509 "EHLO c62.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759640Ab2JYOOS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:14:18 -0400
Message-ID: <20121025101416.v1wilj95q8wkk0os-cebfxv@webmail.spamcop.net>
Date: Thu, 25 Oct 2012 10:14:16 -0400
From: Pavel Roskin <proski@gnu.org>
To: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Bisected regression: iterate_fd() selinux change affects flash
	plugin
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
User-Agent: Internet Messaging Program (IMP) H3 (4.1.4)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Al!

I have noticed that Mozilla Firefox gets stuck for seconds or minutes  
on some sites, in particular on Facebook with Linux 3.7-rc1 and newer  
mainline kernels.  Disabling flash plugin fixes the delays.

This is a Fedora 17 system with SELinux enabled, on x86_64  
architecture, with all updates, with LXDE desktop.  It's not the  
Fedora 16 system I mentioned before, it has never had LXDE login  
problems due to replace_fd().

Bisecting lead me to the patch that introduced iterate_fd():

commit c3c073f808b22dfae15ef8412b6f7b998644139a
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Aug 21 22:32:06 2012 -0400

     new helper: iterate_fd()

     iterates through the opened files in given descriptor table,
     calling a supplied function; we stop once non-zero is returned.
     Callback gets struct file *, descriptor number and const void *
     argument passed to iterator.  It is called with files->file_lock
     held, so it is not allowed to block.

     tty_io, netprio_cgroup and selinux flush_unauthorized_files()
     converted to its use.

     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

I have found that reverting the changes to security/selinux/hooks.c is  
sufficient to restore the correct behavior.

-- 
Regards,
Pavel Roskin
