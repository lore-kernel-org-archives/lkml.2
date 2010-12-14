Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab0LNJxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:53:00 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:54910 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0LNJw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:52:59 -0500
Date: Tue, 14 Dec 2010 15:22:59 +0530
From: "Suzuki K. Poulose" <suzuki@in.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Christoph Hellwig <hch@lst.de>, Masami Hiramatsu <mhiramat@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Daisuke HATAYAMA <d.hatayama@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Roland McGrath <roland@redhat.com>,
        Amerigo Wang <amwang@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>
Subject: [RFC] [Patch 0/21] Non disruptive application core dump
 infrastructure
Message-ID: <20101214152259.67896960@suzukikp>
Organization: IBM
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is series of patches implementing an infrastructure for capturing the core 
of an application without disrupting its process semantics.

The infrastructure makes use of the freezer subsystem in kernel to freeze the 
threads and then collect the information to generate  the core.

The interface is provided by a /proc/pid/core file, reading which can give the 
ELF formatted core of the process with "pid". The interface supports "seek" 
operation on the fd, allowing the dumper to have control on the data that is 
being dumped. Also it allows the user to store the dump at any location.

The current implementation supports both native as well as the compat ELF 
tasks.

An open() call to the /proc/pid/core will try to freeze the threads in the 
process and the read() requests will dynamically generate the contents for the 
core file. The ELF header & Program Headers are stored in a kernel buffer to 
allow us to map the fpos to the required data section.

In case a thread is not frozen within a time interval, after issuing the freeze 
request, we fill the register state information with 0's to indicate we could 
not capture the data.

A close() would kick the threads out of the refrigerator().


The implementation reuses some of the existing ELF core generation code by 
exporting them. Some of the code common to both native and compat ELF class 
support has been moved to a common place, elfcore-common.c. Also some of the 
reusable functions, specific to the ELF class handling, has been made global, 
after renaming the compat version of the same.

We also added a new API -elf_core_copy_extra_phdrs() -for "reading" the arch 
specific program headers, versus the existing elf_core_write_extra_phdrs().

Patches 1 to 9 deals with re-arranging the ELF code to be reusable by the 
infrastructure.

Patches 10 to 21 implements the infrastructure.

TODO: Add support for collecting the arch specific notes, currently used only 
by Cell platform.

Please let me know your review comments / thoughts.

  arch/ia64/kernel/elfcore.c       |   34 ++
  arch/um/sys-i386/elfcore.c       |   32 ++
  fs/Makefile                      |    1
  fs/binfmt_elf.c                  |  162 +------------
  fs/compat_binfmt_elf.c           |    7
  fs/elfcore-common.c              |  138 +++++++++++
  fs/proc/Makefile                 |    2
  fs/proc/base.c                   |    1
  fs/proc/gencore-compat-elf.c     |   61 ++++
  fs/proc/gencore-elf.c            |  479+++++++++++++++++++++++++++++++++++++++ 
  fs/proc/gencore.c                |  297++++++++++++++++++++++++ 
  fs/proc/gencore.h                |   71 +++++
  fs/proc/internal.h               |    1
  include/linux/elfcore-internal.h |   73 +++++
  include/linux/elfcore.h          |    3
  include/linux/freezer.h          |   12
  kernel/elfcore.c                 |    6
  kernel/power/process.c           |    9
  18 files changed, 1241 insertions(+), 148 deletions(-)


Thanks

Suzuki
