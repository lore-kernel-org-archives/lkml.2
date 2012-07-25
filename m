Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933030Ab2GYNjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 09:39:08 -0400
Received: from mail.renton.name ([90.155.165.44]:58440 "EHLO
	beaver.old-horrors.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2GYNjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 09:39:06 -0400
Date: Wed, 25 Jul 2012 17:36:37 +0400
From: Alexey Vlasov <renton@renton.name>
To: Mike Galbraith <efault@gmx.de>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com
Subject: Re: Attaching a process to cgroups
Message-ID: <20120725133637.GA9169@beaver>
References: <20120619185856.GC31797@beaver>
 <1340195298.15707.3.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1340195298.15707.3.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Now I've got almost 5k used groups and it got even worse. Now I've got
almost 5k used groups and it got even worse.

If only write was working slower, now everything connected with cgroups
is hardly working.

Could it be connected with synchronize_rcu()?

Hanging on read():

# strace -ttT cat /proc/cgroups 

17:30:43.825005 fstat(1, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 13), ...}) = 0 <0.000005>
17:30:43.825048 open("/proc/cgroups", O_RDONLY) = 3 <0.000014>
17:30:43.825085 fstat(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0 <0.000004>
17:30:43.825125 fadvise64(3, 0, 0, POSIX_FADV_SEQUENTIAL) = 0 <0.000005>
17:30:43.825161 read(3, "#subsys_name\thierarchy\tnum_cgrou"..., 32768) = 112 <7.447084>
17:30:51.272302 write(1, "#subsys_name\thierarchy\tnum_cgrou"..., 112#subsys_name       hierarchy       num_cgroups     enabled
cpuacct 1       16844   1
memory  2       16844   1
devices 3       16844   1
blkio   4       16844   1
) = 112 <0.000018>
17:30:51.272363 read(3, "", 32768)      = 0 <0.000007>
17:30:51.272405 brk(0x62d000)           = 0x62d000 <0.000011>
17:30:51.272444 close(3)                = 0 <0.000011>
17:30:51.272488 close(1)                = 0 <0.000007>
17:30:51.272518 close(2)                = 0 <0.000005>

On Wed, Jun 20, 2012 at 02:28:18PM +0200, Mike Galbraith wrote:
> On Tue, 2012-06-19 at 22:58 +0400, Alexey Vlasov wrote: 

> > Is it possible to somehow fasten a process of pid attaching to cgroup?
> > The problem is the pid attaches to a task-file with some strange delay:
> > 
> > 22:28:00.788224 open("/sys/fs/cgroup/memory/virtwww/w_test-l24-apache1_4bdf3d13/apache/tasks", O_WRONLY|O_CREAT|O_APPEND, 0666) = 3 <0.000035>
> > 22:28:00.788289 fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0 <0.000004>
> > 22:28:00.788326 mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7f5e78074000 <0.000005>
> > 22:28:00.788355 fstat(3, {st_mode=S_IFREG|0644, st_size=0, ...}) = 0 <0.000004>
> > 22:28:00.788389 lseek(3, 0, SEEK_SET)   = 0 <0.000004>
> > 22:28:00.788426 write(3, "16317\n", 6)  = 6 <0.128094>
> > 22:28:00.916578 close(3)                = 0 <0.000006>
> 
> 
> kernel/cgroup.c::cgroup_attach_task()
> {
> ...
> 	synchronize_rcu();
> ...
> }
> 
