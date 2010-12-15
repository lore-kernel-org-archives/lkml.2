Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751217Ab0LOFYH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 00:24:07 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46967 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750715Ab0LOFYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 00:24:05 -0500
Date: Wed, 15 Dec 2010 10:54:11 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] [Patch 0/21] Non disruptive application core dump
 infrastructure
Message-ID: <20101215105411.0bbc8629@suzukikp>
In-Reply-To: <20101215100437.ce38fde6.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101214152259.67896960@suzukikp>
 <20101215100437.ce38fde6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 10:04:37 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 14 Dec 2010 15:22:59 +0530
> "Suzuki K. Poulose" <suzuki@in.ibm.com> wrote:
> 
> > Hi all,
> > 
> > This is series of patches implementing an infrastructure for capturing the core 
> > of an application without disrupting its process semantics.
> > 
> > The infrastructure makes use of the freezer subsystem in kernel to freeze the 
> > threads and then collect the information to generate  the core.
> > 
> > The interface is provided by a /proc/pid/core file, reading which can give the 
> > ELF formatted core of the process with "pid". The interface supports "seek" 
> > operation on the fd, allowing the dumper to have control on the data that is 
> > being dumped. Also it allows the user to store the dump at any location.
> > 
> > The current implementation supports both native as well as the compat ELF 
> > tasks.
> > 
> > An open() call to the /proc/pid/core will try to freeze the threads in the 
> > process and the read() requests will dynamically generate the contents for the 
> > core file. The ELF header & Program Headers are stored in a kernel buffer to 
> > allow us to map the fpos to the required data section.
> > 
> > In case a thread is not frozen within a time interval, after issuing the freeze 
> > request, we fill the register state information with 0's to indicate we could 
> > not capture the data.
> > 
> > A close() would kick the threads out of the refrigerator().
> > 
> > 
> > The implementation reuses some of the existing ELF core generation code by 
> > exporting them. Some of the code common to both native and compat ELF class 
> > support has been moved to a common place, elfcore-common.c. Also some of the 
> > reusable functions, specific to the ELF class handling, has been made global, 
> > after renaming the compat version of the same.
> > 
> > We also added a new API -elf_core_copy_extra_phdrs() -for "reading" the arch 
> > specific program headers, versus the existing elf_core_write_extra_phdrs().
> > 
> > Patches 1 to 9 deals with re-arranging the ELF code to be reusable by the 
> > infrastructure.
> > 
> > Patches 10 to 21 implements the infrastructure.
> > 
> > TODO: Add support for collecting the arch specific notes, currently used only 
> > by Cell platform.
> > 
> > Please let me know your review comments / thoughts.
> > 
> 
> Your purpose of this patch is to debug an application without attaching to gdb
> or take coredump by gcore ? 

The purpose is to take the coredump in a more reliable way without affecting 
the process semantics.
> 
> IIUC, "freeze" is a bit dangerous because no one can ends the application while
> it's freezed and there is no information "it's frozen" via usaual user commands
> as 'ps' or 'top'. 
> 
> Can you add a new freeze state where the application can get SIGKILL,
> at least ? and show task's state as "frozen" in some way ? as
> task_state_array[] shows it in /proc/<pid>/status
I will investigate this approach.

Thanks
Suzuki
