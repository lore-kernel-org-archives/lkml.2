Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965326Ab1JFXRJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 19:17:09 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46373 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758991Ab1JFXRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 19:17:07 -0400
Message-ID: <1317943022.1095.25.camel@mop>
Subject: A =?UTF-8?Q?Plumber=E2=80=99s?= Wish List for Linux
From: Kay Sievers <kay.sievers@vrfy.org>
To: linux-kernel@vger.kernel.org
Cc: lennart@poettering.net, harald@redhat.com, david@fubar.dk, greg@kroah.com
Date: Fri, 07 Oct 2011 01:17:02 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0 (3.2.0-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We’d like to share our current wish list of plumbing layer features we
are hoping to see implemented in the near future in the Linux kernel and
associated tools. Some items we can implement on our own, others are not
our area of expertise, and we will need help getting them implemented.

Acknowledging that this wish list of ours only gets longer and not
shorter, even though we have implemented a number of other features on
our own in the previous years, we are posting this list here, in the
hope to find some help.

If you happen to be interested in working on something from this list or
able to help out, we’d be delighted. Please ping us in case you need
clarifications or more information on specific items.


Thanks,
Kay, Lennart, Harald, in the name of all the other plumbers



An here’s the wish list, in no particular order:

* (ioctl based?) interface to query and modify the label of a mounted
FAT volume:
A FAT labels is implemented as a hidden directory entry in the file
system which need to be renamed when changing the file system label,
this is impossible to do from userspace without unmounting. Hence we’d
like to see a kernel interface that is available on the mounted file
system mount point itself. Of course, bonus points if this new interface
can be implemented for other file systems as well, and also covers fs
UUIDs in addition to labels.

* CPU modaliases in /sys/devices/system/cpu/cpuX/modalias:
useful to allow module auto-loading of e.g. cpufreq drivers and KVM
modules. Andy Kleen has a patch to create the alias file itself. CPU
‘struct sysdev’ needs to be converted to ‘struct device’ and a ‘struct
bus_type cpu’ needs to be introduced to allow proper CPU coldplug event
replay at bootup. This is one of the last remaining places where
automatic hardware-triggered module auto-loading is not available. And
we’d like to see that fix to make numerous ugly userspace work-arounds
to achieve the same go away.

* expose CAP_LAST_CAP somehow in the running kernel at runtime:
Userspace needs to know the highest valid capability of the running
kernel, which right now cannot reliably be retrieved from header files
only. The fact that this value cannot be detected properly right now
creates various problems for libraries compiled on newer header files
which are run on older kernels. They assume capabilities are available
which actually aren’t. Specifically, libcap-ng claims that all running
processes retain the higher capabilities in this case due to the
“inverted” semantics of CapBnd in /proc/$PID/status.

* export ‘struct device_type fb/fbcon’ of ‘struct class graphics’
Userspace wants to easily distinguish ‘fb’ and ‘fbcon’ from each other
without the need to match on the device name.

* allow changing argv[] of a process without mucking with environ[]:
Something like setproctitle() or a prctl() would be ideal. Of course it
is questionable if services like sendmail make use of this, but otoh for
services which fork but do not immediately exec() another binary being
able to rename this child processes in ps is of importance.

* module-init-tools: provide a proper libmodprobe.so from
module-init-tools:
Early boot tools, installers, driver install disks want to access
information about available modules to optimize bootup handling.

* fork throttling mechanism as basic cgroup functionality that is
available in all hierarchies independent of the controllers used:
This is important to implement race-free killing of all members of a
cgroup, so that cgroup member processes cannot fork faster then a cgroup
supervisor process could kill them. This needs to be recursive, so that
not only a cgroup but all its subgroups are covered as well.

* proper cgroup-is-empty notification interface:
The current call_usermodehelper() interface is an unefficient and an
ugly hack. Tools would prefer anything more lightweight like a netlink,
poll() or fanotify interface.

* allow user xattrs to be set on files in the cgroupfs (and maybe
procfs?)

* simple, reliable and future-proof way to detect whether a specific pid
is running in a CLONE_NEWPID container, i.e. not in the root PID
namespace. Currently, there are available a few ugly hacks to detect
this (for example a process wanting to know whether it is running in a
PID namespace could just look for a PID 2 being around and named
kthreadd which is a kernel thread only visible in the root namespace),
however all these solutions encode information and expectations that
better shouldn’t be encoded in a namespace test like this. This
functionality is needed in particular since the removal of the the ns
cgroup controller which provided the namespace membership information to
user code.

* allow making use of the “cpu” cgroup controller by default without
breaking RT. Right now creating a cgroup in the “cpu” hierarchy that
shall be able to take advantage of RT is impossible for the generic case
since it needs an RT budget configured which is from a limited resource
pool. What we want is the ability to create cgroups in “cpu” whose
processes get an non-RT weight applied, but for RT take advantage of the
parent’s RT budget. We want the separation of RT and non-RT budget
assignment in the “cpu” hierarchy, because right now, you lose RT
functionality in it unless you assign an RT budget. This issue severely
limits the usefulness of “cpu” hierarchy on general purpose systems
right now.

* Add a timerslack cgroup controller, to allow increasing the timer
slack of user session cgroups when the machine is idle.

* An auxiliary meta data message for AF_UNIX called SCM_CGROUPS (or
something like that), i.e. a way to attach sender cgroup membership to
messages sent via AF_UNIX. This is useful in case services such as
syslog shall be shared among various containers (or service cgroups),
and the syslog implementation needs to be able to distinguish the
sending cgroup in order to separate the logs on disk. Of course stm
SCM_CREDENTIALS can be used to look up the PID of the sender followed by
a check in /proc/$PID/cgroup, but that is necessarily racy, and actually
a very real race in real life.

* SCM_COMM, with a similar use case as SCM_CGROUPS. This auxiliary
control message should carry the process name as available
in /proc/$PID/comm.

