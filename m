Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810Ab2HPDRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 23:17:19 -0400
Received: from evergreen.ssec.wisc.edu ([128.104.108.253]:59631 "EHLO
	evergreen.ssec.wisc.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab2HPDRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 23:17:17 -0400
X-Greylist: delayed 1866 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Aug 2012 23:17:17 EDT
Date: Wed, 15 Aug 2012 21:46:10 -0500
From: Daniel Forrest <dan.forrest@ssec.wisc.edu>
To: linux-kernel@vger.kernel.org
Subject: Repeated fork() causes SLAB to grow without bound
Message-ID: <20120816024610.GA5350@evergreen.ssec.wisc.edu>
Reply-To: Daniel Forrest <dan.forrest@ssec.wisc.edu>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm hoping someone has seen this before...

I've been trying to track down a performance problem with Linux 3.0.4.
The symptom is system-mode load increasing over time while user-mode
load remains constant while running a data ingest/processing program.

Looking at /proc/meminfo I noticed SUnreclaim increasing steadily.

Looking at /proc/slabinfo I noticed anon_vma and anon_vma_chain also
increasing steadily.

I was able to generate a simple test program that will cause this:

---

#include <unistd.h>

int main(int argc, char *argv[])
{
   pid_t pid;

   while (1) {
      pid = fork();
      if (pid == -1) {
	 /* error */
	 return 1;
      }
      if (pid) {
	 /* parent */
	 sleep(2);
	 break;
      }
      else {
	 /* child */
	 sleep(1);
      }
   }
   return 0;
}

---

In the actual program (running as a daemon), a child is reading data
while its parent is processing the previously read data.  At any time
there are only a few processes in existence, with older processes
exiting and new processes being fork()ed.  Killing the program frees
the slab usage.

I patched the kernel to 3.0.40, but the problem remains.  I also
compiled with slab debugging and can see that the growth of anon_vma
and anon_vma_chain is due to anon_vma_clone/anon_vma_fork.

Is this a known issue?  Is it fixed in a later release?

Thanks,

-- 
Daniel K. Forrest		Space Science and
dan.forrest@ssec.wisc.edu	Engineering Center
(608) 890 - 0558		University of Wisconsin, Madison
