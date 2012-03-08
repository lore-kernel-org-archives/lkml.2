Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758353Ab2CHRCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 12:02:12 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:12897 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753603Ab2CHRCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 12:02:09 -0500
X-Authority-Analysis: v=2.0 cv=FOSZNpUs c=1 sm=0 a=/DbS/tiKggfTkRRHPZEB4g==:17 a=Qsx_du5GiBkA:10 a=ra92YfU4GoUA:10 a=A5zQsA2EFX4A:10 a=S1A5HrydsesA:10 a=rwTK06fU3TBHUJLy_rYA:9 a=wya41BpFLOf4AZDjRkcA:7 a=pILNOxqGKmIA:10 a=8p6aHGHOzYSjCyI80j0A:9 a=/DbS/tiKggfTkRRHPZEB4g==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.78.168.186
Message-ID: <4F58E60F.1030503@ubuntu.com>
Date: Thu, 08 Mar 2012 12:02:07 -0500
From: Phillip Susi <psusi@ubuntu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: Jacek Luczak <difrost.kernel@gmail.com>, linux-ext4@vger.kernel.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: getdents - ext4 vs btrfs performance
References: <CADDYkjS5VJeYyHzqumazQ0qKg+HwA6GO+zYSJj7rkHNZFwjcoQ@mail.gmail.com> <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
In-Reply-To: <E15A491F-62E2-4518-939F-07B3AB4C3E65@mit.edu>
Content-Type: multipart/mixed;
 boundary="------------030501040107040408020009"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030501040107040408020009
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

On 2/29/2012 11:44 PM, Theodore Tso wrote:
> You might try sorting the entries returned by readdir by inode number
> before you stat them.    This is a long-standing weakness in
> ext3/ext4, and it has to do with how we added hashed tree indexes to
> directories in (a) a backwards compatible way, that (b) was POSIX
> compliant with respect to adding and removing directory entries
> concurrently with reading all of the directory entries using
> readdir.

When I ran into this a while back, I cobbled together this python script 
to measure the correlation from name to inode, inode to first data 
block, and name to first data block for all of the small files in a 
large directory, and found that ext4 gives a very poor correlation due 
to that directory hashing.  This is one of the reasons I prefer using 
dump instead of tar for backups, since it rips through my Maildir more 
than 10 times faster than tar, since it reads the files in inode order.


--------------030501040107040408020009
Content-Type: text/plain;
 name="correlation.py"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="correlation.py"

#!/usr/bin/python

import os
from stat import *
import fcntl
import array

names = os.listdir('.')
lastino = 0
name_to_ino_in = 0
name_to_ino_out = 0
lastblock = 0
name_to_block_in = 0
name_to_block_out = 0
iblocks = list()
inode_to_block_in = 0
inode_to_block_out = 0

for file in names :
    try :
        st = os.stat(file)
    except OSError:
        continue
    if not S_ISREG(st.st_mode) :
        continue
    if st.st_ino > lastino :
        name_to_ino_in += 1
    else : name_to_ino_out += 1
    lastino = st.st_ino    
    f = open(file)
    buf = array.array('I', [0])
    err = fcntl.ioctl(f.fileno(), 1, buf)
    if err != 0 :
        print "ioctl failed on " + f
    block = buf[0]
    if block != 0 :
        if block > lastblock :
            name_to_block_in += 1
        else : name_to_block_out += 1
        lastblock = block
        iblocks.append((st.st_ino,block))
print "Name to inode correlation: " + str(float(name_to_ino_in) / float((name_to_ino_in + name_to_ino_out)))
print "Name to block correlation: " + str(float(name_to_block_in) / float((name_to_block_in + name_to_block_out)))
iblocks.sort()
lastblock = 0
for i in iblocks:
    if i[1] > lastblock:
        inode_to_block_in += 1
    else: inode_to_block_out += 1
    lastblock = i[1]
print "Inode to block correlation: " + str(float(inode_to_block_in) / float((inode_to_block_in + inode_to_block_out)))

--------------030501040107040408020009--
