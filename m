Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760175Ab1LPQwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 11:52:42 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:5204 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab1LPQwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 11:52:36 -0500
X-Authority-Analysis: v=2.0 cv=ePqRfQV1 c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=zQGhUK9Iw4MA:10 a=Ux3sHj7e4BMA:10 a=8nJEP1OIZ-IA:10 a=h_3PsyRdw9qmgTIqnuUA:9 a=wPNLvfGTeEIA:10 a=t-P-qlZwZyPXCTfk:21 a=yJP9xedK0fPandN4:21 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4EEB774D.1070407@cfl.rr.com>
Date: Fri, 16 Dec 2011 11:52:29 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: tty idle time and hooking inode_ops from a chardev
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I finally have spent some time figuring out an ancient bug that has 
bothered me on and off over the years: why the terminal idle time that 
who reports is sometimes very wrong.  It seems that this feature relies 
on the atime of the tty dev node being updated by the kernel whenever 
input is entered ( or more specifically, when it is read ).  Some 
programs, notably emacs and less, open /dev/tty rather than use stdin, 
and as a result, the atime of that inode is updated instead of the 
specific tty emacs is attached to.  This also means that if you mknod 
another inode to reach that tty ( say, for a chroot ), the times won't 
be updated correctly either.

To solve this, I think that a timestamp needs to be added to the struct 
tty_struct, and this should be updated whenever there is input, rather 
than updating the inode when the input is actually read.  In order to 
maintain compatibility with user space however, I would like to hook the 
stat calls and update the inode's atime from tty_struct whenever user 
space checks it.

To do this, I think that tty_open would need to replace the 
inode_operations pointer to point to its own version that has a set of 
functions that forward to the original inode_operations, but the 
iop->getattr would update the inode's atime from the tty_struct.  This 
means it needs to be able to locate both the tty_struct and the original 
inode_operations given the inode.  Is the i_private member of struct 
inode available for the tty code to use for this?

Alternatively, does anyone have a better idea to accomplish this?

Perhaps instead, struct cdev could gain a function pointer to allow it 
to hook vfs_stat?  I'm pretty sure there is a way to find the tty_struct 
given the cdev ( through dev_t? ), but I'm not sure what it is.
