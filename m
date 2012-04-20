Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab2DTWNY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 18:13:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33247 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753570Ab2DTWNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 18:13:22 -0400
Date: Fri, 20 Apr 2012 23:13:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
Message-ID: <20120420221315.GN6871@ZenIV.linux.org.uk>
References: <alpine.LRH.2.02.1204190101380.30151@tundra.namei.org>
 <1334772473.2137.22.camel@falcor>
 <20120418183938.GH6589@ZenIV.linux.org.uk>
 <1334865448.2429.35.camel@falcor>
 <20120420004303.GB6871@ZenIV.linux.org.uk>
 <alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
 <20120420190418.GK6871@ZenIV.linux.org.uk>
 <CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
 <20120420195833.GM6871@ZenIV.linux.org.uk>
 <CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 02:12:55PM -0700, Linus Torvalds wrote:

> Are they all like that? No. But most of the ones outside of mm/ do fit
> that simple pattern and should probably be fixed up just to have them
> not contain VM locking details in them *anyway*.

Kinda-sorta.  I agree that such helpers make sense, but you are too
optimistic about the number of such places.  And clusterfuck around
mremap() is fairly deep, so propagating all way back to up_write()
wont' be fun.

sys_shmdt() is misusing do_munmap(), AFAICS.  And there we call it many
times in a loop, unmapping only a subset, so it's not like we could
blindly pick a string of vmas and handle them all separately afterwards.
It could be handled if we passed an initially empty list, collecting
vmas in it as we go, but... ouch

BTW, looks like I've just found a bug in oprofile - take a look at
sys_munmap() and you'll see that it's almost exactly your proposed
helper.  The only difference is that it starts with calling
	profile_munmap(addr);
(mind you, *before* grabbing ->mmap_sem), which is to say
        blocking_notifier_call_chain(&munmap_notifier, 0, (void *)addr);
i.e. a really fancy way to arrange a call of munmap_notify() from
drivers/oprofile/buffer_sync.c.  Which does the following:
{
        unsigned long addr = (unsigned long)data;
        struct mm_struct *mm = current->mm;
        struct vm_area_struct *mpnt;

        down_read(&mm->mmap_sem);

        mpnt = find_vma(mm, addr);
        if (mpnt && mpnt->vm_file && (mpnt->vm_flags & VM_EXEC)) {
                up_read(&mm->mmap_sem);
                /* To avoid latency problems, we only process the current CPU,
                 * hoping that most samples for the task are on this CPU
                 */
                sync_buffer(raw_smp_processor_id());
                return 0;
        }

        up_read(&mm->mmap_sem);
        return 0;
}

Leaving aside the convoluted way it's done, it's obviously both racy and
incomplete.  The worst part is, sync_buffer() *can't* be called with
any ->mmap_sem held; it goes through a bunch of task_struct, grabbing
->mmap_sem shared.  Fun...
