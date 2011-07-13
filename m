Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751103Ab1GMTzU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 15:55:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964Ab1GMTzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 15:55:19 -0400
Message-ID: <4E1DF827.9050103@redhat.com>
Date: Wed, 13 Jul 2011 15:55:19 -0400
From: William Cohen <wcohen@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Red Hat/3.1.11-2.el6_1 Thunderbird/3.1.11
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Is  perf sample/hw_breakpoint/data_breakpoint.ko suppose to work
 on guest vm?
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was experimenting with data_breakpoint.ko in the kernel
samples/hw_breakpoint directory. The example works on the raw
hardware, but does not appear to work on the guest vm. The hardware
breakpoint on guest vm registers without an error, but there are never
any breakpoints encountered on the guest vm.

Hardware is a Quad-Core AMD Opteron(tm) Processor 2350 running an
updated version of Fedora 15 x86-64 and linux-3.0.0-rc7+ kernel, and
qemu-0.14.0-7.1.fc15.x86_64.  The guest vm on the machine is also
Fedora 15 x86-64 and linux-3.0.0-rc7+ kernel.

On the host I run load the hw_breakpoint.ko module with "insmod
hw_breakpoint.ko" I get back traces as expected like the following:

Jul 13 14:20:24 dhcp231-201 kernel: [ 1839.715091] Dump stack from sample_hbp_handler
Jul 13 14:20:25 dhcp231-201 kernel: [ 1840.786672] pid_max value is changed
Jul 13 14:20:25 dhcp231-201 kernel: [ 1840.786686] Pid: 17372, comm: su Not tainted 3.0.0-rc7+ #1
Jul 13 14:20:25 dhcp231-201 kernel: [ 1840.786694] Call Trace:
Jul 13 14:20:25 dhcp231-201 kernel: [ 1840.786700]  <#DB>  [<ffffffffa0475023>] sample_hbp_handler+0x23/0x34 [data_breakpoint]
Jul 13 14:20:25 dhcp231-201 kernel: [ 1840.786734]  [<ffffffff810e4e24>] __perf_event_overflow+0x118/0x1b9
Jul 13 14:20:25 dhcp231-201 kernel: [ 1840.786748]  [<ffffffff810885b6>] ? __l
...

When I do the same on the guest vm I never see any backtraces due to
the data location being read or written.  The guest vm doesn't report
that hardware breakpoints are unavailable. There just doesn't appear to
be any hits of the hardware breakpoint when used within the guest
vm. All the output from the hw_breakpoint.ko module for the guest vm is:

Jul 13 15:49:19 f15-x86-64 kernel: [ 1701.968294] HW Breakpoint for pid_max write installed
Jul 13 15:49:51 f15-x86-64 kernel: [ 1733.100810] HW Breakpoint for pid_max write uninstalled


If you don't have the sample modules available, there is a similar test
using the perf command. On raw machine:

# more /proc/kallsyms |grep pid_max$
ffffffff81a264e8 D pid_max
# sudo perf stat -a --event=mem:0xffffffff81a264e8 bash
...
# exit
exit

 Performance counter stats for 'bash':

                18 unknown                 

        7.141821652  seconds time elapsed


On guest vm never get any breakpoint hits:
#  more /proc/kallsyms |grep pid_max$
ffffffff81a264e8 D pid_max
# perf stat -a --event=mem:0xffffffff81a264e8 bash
...
# exit
exit

 Performance counter stats for 'bash':

                 0 unknown                 

       34.924628839  seconds time elapsed

Any thoughts why hardware breakpoints don't work on guest vm?

-Will
