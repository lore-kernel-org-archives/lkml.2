Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072Ab0C3ICx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 04:02:53 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:52478 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0C3ICu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 04:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=os2w2vvs78dud6s1SSn6uV3t5IGf/DdR2iN5cvYTL4AppzkMYtBG6gZ/mskc79uPhS
         ZQormbIdTQ3uXuj3xaHjUuyX2egUVHY731rJxuPVXyyqpNbGyp5ImcPJunJKdoj0m2LJ
         x2rYBASJ1OKf2I3ZsDHyer7flmcpuYl+bBhLQ=
MIME-Version: 1.0
In-Reply-To: <54cce25c1003280829q2a173c91p55bc3297a3163452@mail.gmail.com>
References: <54cce25c1003280829q2a173c91p55bc3297a3163452@mail.gmail.com>
Date: Tue, 30 Mar 2010 10:02:48 +0200
Message-ID: <54cce25c1003300102v71b6809cvad379bafd6d15c2d@mail.gmail.com>
Subject: reiserfs + acl corruption
From: Marco Gatti <marco.gatti@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope to post in the right place.
I recently suffered a filesystem corruption with reiserfs in a
production environment and I was able to reproduce it.
The corruption started when i played with extended attributes, posix
acls, with a partition containing hundreds of thousands of files.
To reproduce the issue test it this way (using bash) in a separate
disk, partition or virtual disk using loopback:

mkfsreiserfs /dev/sdc1
mount -o acl /dev/sdc1 /mnt
cd /mnt
mkdir dir_with_many_files
touch dir_with_many_files/{1..100000}
setfacl -R -m u:username:rw dir_with_many_files
setfacl -R -x u:username dir_with_many_files    (slow responsiveness of
system during the execution of this command)
setfacl -R -b dir_with_many_files

With a debian lenny standard kernel 2.6.26 (port amd64) these commands
ends succesfully and no corruption occours.
With a recent kernel, versions 2.6.32.8 - 2.6.32.9 - 2.6.32.10,
(x86_64) compiled in different ways, from standard configuration to
optimized versions even with no support for modules i get thousands of
this kind of message:

REISERFS warning (device sdc1): jdm-20002 reiserfs_xattr_get: Invalid
hash for xattr (system.posix_acl_access) associated with [2 848 0x0
SD]

then wierd things start to happen and the more you use this filesystem
the more you disrupt it: this leads to a corrupted filesystem!
If you try with less files, let's say 50000, no corruption or error
occour to me.
The number of files to reproduce this behaviour could be different and
it seems to be related to the machine you use: 100000 are enought for
a virtual machine with 1GB of RAM, but i needed 300000 of files using
a real machine with 4GB of RAM.
I tested other filesystem but i get no corruption at all with ext2,
ext3, ext4 and xfs.
I use debian stable or testing environments and i'm using reiserfs
included in vanilla kernels, with default options.
Am I doing something wrong?
Can someone test and reproduce this behaviour?
Regards

Marco Gatti
