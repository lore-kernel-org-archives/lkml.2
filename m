Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1LVT6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 14:58:10 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55631 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753365Ab1LVT6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 14:58:08 -0500
Date: Thu, 22 Dec 2011 19:58:07 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org
Subject: [sigh] binder shite is back ;-/
Message-ID: <20111222195807.GP23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thesis: binder is a true example of what "Enterprise Quality" means.
Nothing good, that is.

Exhibit 1:
in their ->mmap() they have
        if (proc->buffer) {
                ret = -EBUSY;
                failure_string = "already mapped";
                goto err_already_mapped;
        }

        area = get_vm_area(vma->vm_end - vma->vm_start, VM_IOREMAP);
        if (area == NULL) {
                ret = -ENOMEM;
                failure_string = "get_vm_area";
                goto err_get_vm_area_failed;
        }  
        proc->buffer = area->addr;

Note that there's nothing stopping two processes from doing mmap() on the
same file at the same time.

Exhibit 2: while proc->files is set to the ->files of whoever does mmap(),
proc->tsk is set to task_struct of whoever does open().  Then
task_get_unused_fd_flags() does expand ->files after having checked
rlimit on ->tsk.

Exhibit 3:
        if (vma)
                mm = NULL;
        else   
                mm = get_task_mm(proc->tsk);    

        if (mm) {
                down_write(&mm->mmap_sem);
                vma = proc->vma;
        }
Note that proc->vma is created by whoever had done mmap(), _not_ whoever
had done open().  Not to mention that there's no reason why either task would
still have the original ->mm...

Exhibit 4: mmap that thing and then fork().  Leaving aside the joy of
getting stack dumps in your face, it will succeed.  And then when you
unmap that thing in child (or child exits, for that matter) you'll get
proc->vma = NULL.  On a live one.

Exhibit 5: while we are at it, mmap one and then munmap its middle.

As far as I can see, the basic attitude in that code is "surely, nobody
will do anything unexpected to poor li'l me".  As far as I can tell,
manipulations of descriptor tables suffer the same kind of braindamage,
etc.
