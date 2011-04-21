Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070Ab1DUOZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 10:25:47 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:47862 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981Ab1DUOZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 10:25:45 -0400
Date: Thu, 21 Apr 2011 19:41:25 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>, sds@tycho.nsa.gov
Subject: Re: [PATCH v3 2.6.39-rc1-tip 12/26] 12: uprobes: slot allocation
 for uprobes
Message-ID: <20110421141125.GG10698@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
 <20110401143457.15455.64839.sendpatchset@localhost6.localdomain6>
 <1303145171.32491.886.camel@twins>
 <20110419062654.GB10698@linux.vnet.ibm.com>
 <BANLkTimw7dV9_aSsrUfzwSdwr6UwZDsRwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimw7dV9_aSsrUfzwSdwr6UwZDsRwg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Eric Paris <eparis@parisplace.org> [2011-04-20 09:40:57]:

> On Tue, Apr 19, 2011 at 2:26 AM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
> > * Peter Zijlstra <peterz@infradead.org> [2011-04-18 18:46:11]:
> >
> >> On Fri, 2011-04-01 at 20:04 +0530, Srikar Dronamraju wrote:
> 
> >> > +static int xol_add_vma(struct uprobes_xol_area *area)
> >> > +{
> >> > +   struct vm_area_struct *vma;
> >> > +   struct mm_struct *mm;
> >> > +   struct file *file;
> >> > +   unsigned long addr;
> >> > +   int ret = -ENOMEM;
> >> > +
> >> > +   mm = get_task_mm(current);
> >> > +   if (!mm)
> >> > +           return -ESRCH;
> >> > +
> >> > +   down_write(&mm->mmap_sem);
> >> > +   if (mm->uprobes_xol_area) {
> >> > +           ret = -EALREADY;
> >> > +           goto fail;
> >> > +   }
> >> > +
> >> > +   /*
> >> > +    * Find the end of the top mapping and skip a page.
> >> > +    * If there is no space for PAGE_SIZE above
> >> > +    * that, mmap will ignore our address hint.
> >> > +    *
> >> > +    * We allocate a "fake" unlinked shmem file because
> >> > +    * anonymous memory might not be granted execute
> >> > +    * permission when the selinux security hooks have
> >> > +    * their way.
> >> > +    */
> >>
> >> That just annoys me, so we're working around some stupid sekurity crap,
> >> executable anonymous maps are perfectly fine, also what do JITs do?
> >
> > Yes, we are working around selinux security hooks, but do we have a
> > choice.
> >
> > James can you please comment on this.
> 
> [added myself and stephen, the 2 SELinux maintainers]

Thanks for pitching in.

> 
> This is just wrong.  Anything to 'work around' SELinux in the kernel
> is wrong.  SELinux access decisions are determined by policy not by
> dirty hacks in the code to subvert any kind of security claims that
> policy might hope to enforce.
> 
> [side note, security_file_mmap() is the right call if there is a file
> or not.  It should just be called security_mmap() but the _file_ has
> been around a long time and just never had a need to be changed]
> 

Okay,

> Now how to fix the problems you were seeing.  If you run a modern
> system with a GUI I'm willing to bet the pop-up window told you
> exactly how to fix your problem.  If you are not on a GUI I accept
> it's a more difficult as you most likely don't have the setroubleshoot
> tools installed to help you out.  I'm just guess what your problem
> was, but I think you have two solutions either:

I am not running GUI on my testbox and mostly disable selinux unless I
need to test if uprobes works on selinux environment.

> 
> 1) chcon -t unconfined_execmem_t /path/to/your/binary
> 2) setsebool -P allow_execmem 1
> 
> The first will cause the binary to execute in a domain with
> permissions to execute anonymous memory, the second will allow all
> unconfined domains to execute anonymous memory.

We arent restricted to a particular binary/binaries. We want an
infrastructure that can trace all user-space applications. So the
first option doesnt seem to help us.

If I understand the second option. we would want this command to be
run on any selinux enabled machines that wants uprobes to be working.

> 
> I did hear this question though: On a different but related note, how
> is the use of uprobes controlled? Does it apply the same checking as
> for ptrace?
> 

Uprobes is an infrastructure to trace user space applications.
Uprobes will use Singlestepping out of line approach compared to
ptrace's approach of re-inserting the original instruction on a
breakpoint hit.

Uprobes inserts a breakpoint and registers itself with the notifier
mechanism similar to kprobes. Once we hit the breakpoint, the
notifier callback will determine that the breakpoint was indeed
inserted by uprobes, run the handler and then tries to singlestep the
original instruction from a __different__ location. This approach
works much better for multithreaded applications and also reduces
context switches.

To achieve this for user space applications, we need to create that
__different__ location from where we can singlestep. Uprobes creates
this location by adding a new executable single page vma. This page
will have slots to which we copy the original instruction. 
Once we singlestep the original instruction at a reserved slot, we do
the necessary fixups.

Initially we created the single page executable vma as an anonymous
vma.
However SElinux wasnt happy to see an executable anonymous VMA. Hence we
added shmem-file. The vma is semi-transparent to the user i.e,
in-kernel  uprobes infrastructure will create this vma as and when
first breakpoint is hit for that process-group. This vma is cleaned up
at the process-group exit time.

Our idea is to export this to regular users through system-call so
that regular debuggers like gdb can benefit.

> Thanks guys!  If you have SELinux or LSM problems in the future let me
> know.  It's likely the solution is easier than you imagine   ;)

Can I assume that you would be okay with Peter's suggestion of using 
install_special_mapping() instead of we calling do_mmap_pgoff().

-- 
Thanks and Regards
Srikar
