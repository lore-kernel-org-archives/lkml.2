Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762Ab1GWLG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 07:06:28 -0400
Received: from mail.avalus.com ([89.16.176.221]:36063 "EHLO mail.avalus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991Ab1GWLGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 07:06:24 -0400
X-Greylist: delayed 567 seconds by postgrey-1.27 at vger.kernel.org; Sat, 23 Jul 2011 07:06:24 EDT
Date: Sat, 23 Jul 2011 11:56:53 +0100
From: Alex Bligh <alex@alex.org.uk>
Reply-To: Alex Bligh <alex@alex.org.uk>
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
cc: Alex Bligh <alex@alex.org.uk>
Subject: Crash safety semantics of mmap(), rename(), fsync(), msync()
Message-ID: <07D7E5FB493CDE95FB58EE78@Ximines.local>
X-Mailer: Mulberry/4.0.8 (Mac OS X)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have a question about safety of mmap, rename and fync()/msync().

I am creating a memory mapped file with a particular name, and I want to 
ensure the following in the event of a system crash / power outage / 
whatever:
A. If the file exists on disk with its final name at any stage, it MUST 
contain all the data I have written to it (i.e. it must never exist on disk 
with different data and this name)
B. At the exit from the function concerned, the file must exist with its 
final name, and must contain that data on disk.  The fd must still e open 
and the mmap in place (it's used to read from elsewhere).

What I am doing to achieve this is:
1. open (O_CREAT) to a temporary file name
2. ftruncate() the file to required length
3. mmap() the file
4. write the data to the mmap'd area
5. msync() the whole area to ensure the data is written
6. fsync() the file to ensure the metadata is written (e.g. the creation of 
the file in the first place and the extension of the file by ftruncate())
7. rename() the file to the required file name
8. fsync() the file again, to ensure the rename is written to disk to 
satisfy criteria B above)

This is all quite time critical. I can pretty much choose the fie system 
but would prefer something like ext4. The file is between 1MB and 8MB in 
size if that matters any.

The question I have is this: Is it really necessary to msync() and fsync() 
twice? Can I get away without (e.g.) the stage 6 msync? Or, without it, 
might a crash immediately after the rename() result in a file that has the 
permanent name, but the wrong metadata? (I only care about file name and 
recorded length I think). Or is rename() guaranteed to write out all 
metadata (e.g. file length), in which case can I drop both fsync()s? Or are 
the fsync()s guaranteed to be cheap if they do nothing?

-- 
Alex Bligh
