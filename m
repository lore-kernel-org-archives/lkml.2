Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751492Ab1CNEUU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 00:20:20 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51637 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1CNEUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 00:20:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=C6+vGSXsDWb18fW6DCFEy+8lrsyTRHLvXgjq+r7PAGMP5cZ3AWosBKU1N8LrdtWAFW
         Tvdefk4IVK28UuIeQ1PjdZXMBHrWELraLW3qASLXVPJ1U1QnwCeMJeJhS93/AJzKzLEX
         7QVo/L4hE91HgTLzueD8II1HVSKs1Mzxa19YY=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: linux-kernel@vger.kernel.org
Subject: 2.6.35-rc4: mount results with and without MS_SILENT differ
Date: Mon, 14 Mar 2011 05:20:08 +0100
User-Agent: KMail/1.8.2
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Roman Borisov <ext-roman.borisov@nokia.com>,
        Alexander Shishkin <virtuoso@slind.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201103140520.08737.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was discovered by users of busybox.
Apparently, mount() calls with and without MS_SILENT

The following script was run in an empty test directory:

mkdir -p mount.dir mount.shared1 mount.shared2
touch mount.dir/a mount.dir/b
mount -vv --bind         mount.shared1 mount.shared1
mount -vv --make-rshared mount.shared1
mount -vv --bind         mount.shared2 mount.shared2
mount -vv --make-rshared mount.shared2
mount -vv --bind mount.shared2 mount.shared1
mount -vv --bind mount.dir     mount.shared2
ls -R mount.dir mount.shared1 mount.shared2
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
rm -f mount.dir/a mount.dir/b mount.dir/c
rmdir mount.dir mount.shared1 mount.shared2


mount -vv was used to show the mount() call arguments and result.
Output shows that flag argument has 0x00008000 = MS_SILENT bit:

mount: mount('mount.shared1','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared1','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared2','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared2','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('mount.dir','mount.shared2','(null)',0x00009000,'(null)'):0
mount.dir:
a
b

mount.shared1:

mount.shared2:
a
b


After adding --loud option to remove MS_SILENT bit from just one mount cmd:

mkdir -p mount.dir mount.shared1 mount.shared2
touch mount.dir/a mount.dir/b
mount -vv --bind         mount.shared1 mount.shared1 2>&1
mount -vv --make-rshared mount.shared1               2>&1
mount -vv --bind         mount.shared2 mount.shared2 2>&1
mount -vv --loud --make-rshared mount.shared2               2>&1  # <-HERE
mount -vv --bind mount.shared2 mount.shared1         2>&1
mount -vv --bind mount.dir     mount.shared2         2>&1
ls -R mount.dir mount.shared1 mount.shared2      2>&1
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
umount mount.dir mount.shared1 mount.shared2 2>/dev/null
rm -f mount.dir/a mount.dir/b mount.dir/c
rmdir mount.dir mount.shared1 mount.shared2


The result is different now - look closely at mount.shared1 directory listing.
Now it does show files 'a' and 'b':

mount: mount('mount.shared1','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared1','',0x0010c000,''):0
mount: mount('mount.shared2','mount.shared2','(null)',0x00009000,'(null)'):0
mount: mount('','mount.shared2','',0x00104000,''):0
mount: mount('mount.shared2','mount.shared1','(null)',0x00009000,'(null)'):0
mount: mount('mount.dir','mount.shared2','(null)',0x00009000,'(null)'):0

mount.dir:
a
b

mount.shared1:
a
b

mount.shared2:
a
b


I am not asking whether mount command should or should not use MS_SILENT bit.
It's an important question, but it doesn't belong to lkml.

My question is, intuitively, MS_SILENT should only affect (suppress)
kernel messages, it should never affect the outcome of the mount() call, right?

Here it is obviously not the case - the behavior is different. Is it a bug?

-- 
vda
