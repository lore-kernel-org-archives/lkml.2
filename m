Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751130Ab0INEFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:05:08 -0400
Received: from lo.gmane.org ([80.91.229.12]:57511 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab0INEFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:05:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Brett Russ <icycle+lkml@gmail.com>
Subject: O_DIRECT reads appear to be cached on block device partition file?
Date: Mon, 13 Sep 2010 23:49:32 -0400
Message-ID: <i6mrcc$ers$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 68-187-222-30.dhcp.oxfr.ma.charter.com
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Running a 2.6.31 kernel on a blade chassis system with multiple blades 
sharing common JBOD storage.  The application intelligently divides the 
drives up among the blades, but one blade in particular is charged with 
monitoring.  As part of this, this one monitoring blade can perform 
reads of a certain 512B sector of all disks in the system.  This sector 
is often written by other blades, these writes are sync'd to disk.  To 
work around the lack of cache coherency between the distinct blades, I'm 
using O_DIRECT on the monitoring blade such that it always reads from 
the media to get the latest copy of this sector.  The basic steps are:

# grab a 512B aligned buffer (use 4KB to be safe)
posix_memalign(&ptr, getpagesize(), 512B)
open(/dev/sdX3, O_RDONLY|O_DIRECT)
lseek(fd, offset, SEEK_SET)
read(fd, ptr, 512B)

If I run the above on the monitoring blade, then sync an update to the 
sector in question from another blade, then re-reun the above code on 
the monitoring blade, believe it or not I appear to be reading stale 
data.  If I use dd with iflag=direct, reading the same sector offset at 
the /dev/sdX3 partition file, I see the same stale data as seen from the 
code above.  If, however, I instead access this sector offset from the 
/dev/sdX device file using the (offset of partition 3 + offset of the 
sector) I see the intended data, which makes me believe some caching 
occurred locally for /dev/sdX3.

I've searched google for too long, coming up empty.  I've tried changing 
the open flags to O_RDWR|O_DIRECT in case the kernel was doing something 
special b/c it believed there to be no writing to this fd.  Perhaps 
there is an issue with reading only 512B rather than the 1KB Linux block 
size or 4KB page size?

Am I missing something about O_DIRECT, especially as it pertains to a 
device (and a partition on that device) file?  I thought NO caching 
would be involved.

Any clues appreciated,
thanks,
Brett

