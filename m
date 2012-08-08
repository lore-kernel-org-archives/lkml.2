Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759041Ab2HHRs0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:48:26 -0400
Received: from plane.gmane.org ([80.91.229.3]:60460 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758977Ab2HHRsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:48:24 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Lutz Vieweg <lvml@5t9.de>
Subject: POSIX_FADV_DONTNEED causing excessive amounts of block I/O
Date: Wed, 08 Aug 2012 19:48:11 +0200
Message-ID: <jvu8oq$8sl$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: barriere.frankfurter-softwarefabrik.de
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120601 Thunderbird/13.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently investigated the I/O performance of some software and
noticed that "iotop" and "pidstat -d" reported way more write activity
than the application could ever have written.

Further investigation revealed that the application was using
posix_fadvise(..., POSIX_FADV_DONTNEED) on regions of a file it
just wrote - which seems reasonable given that the data in question
is not expected to be read by this or any other application soon,
and the manual page of posix_fadvise states:

 > The advice is not binding; it merely constitutes an expectation on behalf of the application.
...
 >      POSIX_FADV_DONTNEED
 >              The specified data will not be accessed in the near future.

The regions that the application used posix_fadvise() on where often smaller
than one page (4096 byte), but it seems as if the kernel (3.5.0) triggers an immediate
write out of a whole page for each call to posix_fadvise(), causing lots
of unneccessary I/O.

You can reproduce the effect by running the following tiny C program, while
you run "iotop"/"pidstat -d 1"/"iostat -dx 1" on the same system:

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>

int main(int argc, char ** argv) {

     int fd;
     off_t i;
     char c = 0;

     fd = open("dummytestfile", O_WRONLY | O_CREAT | O_TRUNC, 0777);

     for (i = 0; i < 10000; i++) {
          write(fd, &c, 1);
          posix_fadvise(fd, i, 1, POSIX_FADV_DONTNEED);

          usleep(1000);
     }

     close(fd);

     return 0;
}

This program writes no more than 10.000 bytes over a period of 10 seconds, but
the utilities report that it writes ~ 2 Megabytes per second!

I would have expected that posix_fadvise(..., POSIX_FADV_DONTNEED) just marks
a dirty page such that it is written out the next time it's convenient for the
I/O scheduler - but the multiplication of actual I/O is certainly not what the
application programmer could have expected, given the documentation of
posix_fadvise...

Regards,

Lutz Vieweg

