Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab0GYTUH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 15:20:07 -0400
Received: from lo.gmane.org ([80.91.229.12]:45373 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751481Ab0GYTUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 15:20:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Suli Yang <yangsuli@gmail.com>
Subject: question about adding checksumming into ext2
Date: Sun, 25 Jul 2010 19:13:50 +0000 (UTC)
Message-ID: <loom.20100725T211257-863@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 128.141.48.32 (Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; GTB0.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; CIBA; InfoPath.3; .NET4.0C; AskTB5.6))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hell, everyone,

I am trying to modify the ext2 file system to include checksuming on a per 
block basis. That is, for each pointer in the file system, I would like to add 
one field to store the checksum. When writing a block, the fs will compute the 
checksum for that block of data and store it in the appropriate place; when 
reading a block, the fs will also compute the checksum and compare it to the 
checksum previously stored, if there’s a mismatch, fs reports an error. 

I am not quite sure what I should do here…. So I am wondering if anyone could 
give me a hand, or direct me to some resources which might be helpful?

Basically what I have done is adding fields in inode and indirect block to 
include checksum. (Now I put them immediately after the pointer, and each of 
the checksum occupies the space of a __le32. That’s probably not the best 
design because it would be very difficult if I want to change the size of the 
checksum; but what’s done is done…) For this purpose I also changed the way 
the ext2 file system goes through the pointers in the file metadata ( to be 
more specific, the ext2_get_branch, ext2_alloc_branch, ext2_splice_branch, 
ext2_getblocks functions, etc..)  For this part, I have already compiled the 
code and done some basic tests. It seems running OK.

So what need to do now is to modify the read/write function of ext2, so that 
when read in /write out a block of data, it also does the checksuming stuff. 

So my question is: where should I make the modification????

>From my understanding I think I have two choices (plz correct me if I am 
wrong): one is to do checksuming when we are reading from/writing to the page 
cache. That is, to modify something like file->f_op->aio_read/aio_write, or 
address_space->a_ops->write_end. The benefit of doing this is that it would be 
easier to get the block numbers (relative to the beginning of the file) from 
the range of file which needs to be read/written , and thus which checksum to 
modify (It’s not that simple, though….). The drawback, however, is that we 
have to compute the checksum each time we access page cache, which would be a 
significant cost. Also, there are a lot of places where we change page cache…
e.g, regular file read/write, nobh write, file mapping…. etc. It would be 
quite difficult to locate all those places and it may not be good practice 

The other possibility is to modify the process when we read data from the 
disk / commit write to the disk. The advantage of doing this is obvious; 
however, there are still some problems: 1. The code which actually access the 
disk may be everywhere, too. From reading the code I learned that both 
generic_file_aio_write and background threads which are responsible for 
flushing dirty pages into disk eventually called ext2_writepage ( 
ext2_writepages will call __mpage_writepage, which will then call 
ext2_writepage in case of an ext2 file, right?). However, for many other 
cases.say nobh writing, file mapping, direct I/0, do they all eventually call 
ext2_writepage or not? I guess I still need to find out. 2. Functions which 
deal with reading/writing data from/ino disk are such low level so that their 
argument is something like bio instead of file position and range; and it’s 
not straightforward in concept to get the position where we are 
reading/writing the file from the bio. 3. Some file operation (say, 
simple_fsync, which is called by ext2_fsync), actually called ll_rw_block, and 
bypassed the ext2 writepage(s) functions. What should I do in this case?

Thank you very much for your attention and help 

p.s  I noticed that the generic_file_sync function first called 
filemap_wrte_and_wait_range() to sync a file, then again it called 
sync_mapping_buffers to sync a file, and again it called sync_inode() to sync 
the very same file. Is there a particular reason for such a redundancy? Thank 
you. 








