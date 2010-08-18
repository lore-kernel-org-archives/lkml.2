Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751222Ab0HREvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 00:51:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:39307 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab0HREvH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 00:51:07 -0400
From: Nikanth Karthikesan <knikanth@suse.de>
Organization: suse.de
To: Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH] Export mlock information via smaps
Date: Wed, 18 Aug 2010 10:23:41 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.2-default; KDE/4.3.5; x86_64; ; )
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
References: <201008171039.31070.knikanth@suse.de> <1282062336.10679.226.camel@calx>
In-Reply-To: <1282062336.10679.226.camel@calx>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201008181023.41378.knikanth@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 August 2010 21:55:36 Matt Mackall wrote:
> On Tue, 2010-08-17 at 10:39 +0530, Nikanth Karthikesan wrote:
> > Currently there is no way to find whether a process has locked its pages
> > in memory or not. And which of the memory regions are locked in memory.
> >
> > Add a new field to perms field 'l' to export this information. The
> > information exported via maps file is not changed.
> 
> I'm worried that your new 'l' flag will fatally surprise some naive
> parser of this file.
> 

So how to proceed? Create another "ssmaps" file or something? :) Or is the
following patch any better? Even the "Yes"/"No" could be changed to "0 kB" or
"x kB", if it would make it better.

Thanks
Nikanth

Currently there is no way to find whether a process has locked its pages in
memory or not. And which of the memory regions are locked in memory.

Add a new field "Locked" to export this information via smaps file.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index a6aca87..6eafd26 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -373,6 +373,7 @@ Referenced:          892 kB
 Swap:                  0 kB
 KernelPageSize:        4 kB
 MMUPageSize:           4 kB
+Locked:         No
 
 The first  of these lines shows  the same information  as is displayed for the
 mapping in /proc/PID/maps.  The remaining lines show  the size of the mapping,
@@ -397,6 +398,8 @@ To clear the bits for the file mapped pages associated with the process
     > echo 3 > /proc/PID/clear_refs
 Any other value written to /proc/PID/clear_refs will have no effect.
 
+The "Locked" indicates whether the mapping is locked in memory or not.
+
 
 1.2 Kernel data
 ---------------
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index aea1d3f..7bafbcf 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -405,7 +405,8 @@ static int show_smap(struct seq_file *m, void *v)
 		   "Referenced:     %8lu kB\n"
 		   "Swap:           %8lu kB\n"
 		   "KernelPageSize: %8lu kB\n"
-		   "MMUPageSize:    %8lu kB\n",
+		   "MMUPageSize:    %8lu kB\n"
+		   "Locked:         %s\n",
 		   (vma->vm_end - vma->vm_start) >> 10,
 		   mss.resident >> 10,
 		   (unsigned long)(mss.pss >> (10 + PSS_SHIFT)),
@@ -416,7 +417,8 @@ static int show_smap(struct seq_file *m, void *v)
 		   mss.referenced >> 10,
 		   mss.swap >> 10,
 		   vma_kernel_pagesize(vma) >> 10,
-		   vma_mmu_pagesize(vma) >> 10);
+		   vma_mmu_pagesize(vma) >> 10,
+		   (vma->vm_flags & VM_LOCKED) ? "Yes" : "No");
 
 	if (m->count < m->size)  /* vma is copied successfully */
 		m->version = (vma != get_gate_vma(task)) ? vma->vm_start : 0;
