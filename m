Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab2FELAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 07:00:07 -0400
Received: from mailxx.hitachi.co.jp ([133.145.228.50]:39563 "EHLO
	mailxx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933557Ab2FELAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 07:00:04 -0400
X-AuditID: b753bd60-92fc6ba000002ea5-16-4fcde45928b1
X-AuditID: b753bd60-92fc6ba000002ea5-16-4fcde45928b1
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Subject: [RFC PATCH 0/2] ivring: Add IVRing driver
To: linux-kernel@vger.kernel.org, Cam Macdonell <cam@cs.ualberta.ca>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Rusty Russell <rusty@rustcorp.com.au>, qemu-devel@nongnu.org,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Date: Tue, 05 Jun 2012 19:49:54 +0900
Message-ID: <20120605104954.15442.62695.stgit@ltc189.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patch set provides a new communication path "IVRing" for
collecting kernel log or tracing data of guests by a host without using network
in a virtualization environment. Network is generally used to collect log or
tracing data after outputting the data as a file. However, since I/O resources
such as network or block are shared with other guests, these resources should
not be used for logging or tracing. Moreover, high load will be taken to
applications on guests using network I/O because there are many network stack
layers. Then, a communication method for collecting the data without using
I/O resources is needed.

There are two requirements to collect kernel log or tracing data by a host:
 (1) To minimize for user applications in a guest
     - not using I/O resources
 (2) To be implemented recording buffer like ring
     - keep on recording log data or trace data
To meet these requirements, a ring-buffer as a device driver for guest OSs,
called IVRing, is constructed on Inter-VM shared memory (IVShmem) device.
IVShmem implemented in QEMU is a virtual PCI RAM device and uses POSIX shared
memory on a host. This device is originally used as a virtual device for
low-overhead communication between two guests. On the other hand, here, IVShmem
is used as a communication path between a guest and a host for collecting data.
IVRing is a buffer of logging or tracing data in a guest, and IVRing-reader,
opening shared memory as IVRing on a host, reads the data without memory copying
between a guest and a host. Thus, two requirements are met for collecting kernel
log or tracing data.

We will talk about IVRing in LinuxCon Japan 2012:
	https://events.linuxfoundation.org/events/linuxcon-japan
	Title: Low-Overhead Ring-Buffer of Kernel Tracing &
	       Tracing Across Host OS and Guest OS
	Speakers: Yoshihiro Yunomae and Akihiro Nagai
You can download our slides about IVRing in the schedule page.

***Evaluation***
When a host collects tracing data of a guest, the performance of using IVRing
is compared with that of using network.

<environment>
The overview of this evaluation is as follows:
 (a) A guest on a KVM is prepared.
     - The guest is dedicated one physical CPU as a virtual CPU(VCPU).

 (b) The guest starts to write tracing data to a SystemTap buffer.
     - The probe points of SystemTap are all trace points of sched, timer,
       and kmem.

 (c) The tracing data are recorded to IVRing sharing memory with a host or
     the tracing data are sent to a host via network.
     - 3 patterns, IVRing, NFS, and SSH, are measured.
       Each methods is explained about later.

 (d) Writing trace data, dhrystone 2 in UNIX bench is executed as a benchmark
     tool in the guest.
     - Dhrystone 2 intends system performance by repeating integer arithmetic
       as a score.
     - Since higher score equals to better system performance, if the score
       decrease based on bare environment, it indicates that any operation
       disturbs the integer arithmetic. Then, we define the overhead of
       transporting trace data is calculated as follows:
		OVERHEAD = (1 - SCORE_OF_A_METHOD/BARE_SCORE) * 100.

The performance of each method is compared as follows:
 [1] IVRing
     - A SystemTap script in a guest records trace data to IVRing.
     - A IVRing-reader on a host reads the data.
 [2] NFS
     - A directory in a guest is shared with that in a host via NFS.
     - A SystemTap script in a guest records trace data to a file
       in the directory.
 [3] SSH
     - A SystemTap script in a guest output trace data to a host using
       standard output via SSH.

Other information is as follows:
 - host
   kernel: 3.3.1-5 (Fedora16)
   CPU: Intel Xeon x5660@2.80GHz(6core)
   Memory: 50GB

 - guest(only booting one guest)
   kernel: 3.4.0+ (Fedora16)
   CPU: 1VCPU(dedicated)
   Memory: 2GB

<result>
3 patterns based on the bare environment were indicated as follows:
	                Scores      overhead against [0] Bare
	 [0] Bare      29043600                -
	 [1] IVRing    28565398              1.6[%]
	 [2] NFS       22000508             24.3[%]
	 [3] SSH       10246792             64.7[%]
The overhead of IVRing is much lower than other methods using network. This is
because the IVRing method only records trace data to a ring-buffer. On the
other hand, other methods read trace data from a SystemTap buffer to the
userland and send the data to a host via network. Therefore, a method of using
IVRing minimizes the overhead of transporting trace data from a guest to a host.

***How to use***
Here, how to use IVRing and IVRing-reader is simply given.

1. Prepare any distribution including qemu-kvm binary after 0.13.0 version.
 IVShmem was pushed on qemu-kvm mainline after 0.13.0 version.
 Latest Fedora or Ubuntsu are available.

2. Boot a guest installed IVRing driver with device option.
 A device option is needed as follows:
	-device ivshmem,size=<shm_size in MB>,shm=<shm_obj>
shm_obj, shared memory object path, is used later to share the memory region
with the reader on a host. For example, a device option is like below:
	-device ivshmem,size=2,shm=/ivshmem
 IVShmem supports interrupts mode using ivshmem_server and this IVRing driver is
implemented as usable for doorbelling to the reader as a experimental feature.
This feature will be used near the future.

3. Run IVRing-reader on a host.
 To share the memory region with IVShmem, s option for indicating shm_obj which
is same as the second step is needed like below:
	./ivring_reader -m 2 -f /tmp/log.txt -S 10 -N 2 -s /ivshmem
Each options are indicated 2nd patch in detail.
Then, IVRing-reader starts to read data from IVRing, but the ring-buffer is
empty yet.
	shared object size: 2097152 (bytes)
	Ring header is already initialized
	reader -1, writer 0, pos 20074a9f
	ivring_init_hdr: 0x7f128417d000
	Receive an interrupt 2
	Try to read buffer.
	Receive an interrupt 2
	no data
	__ivring_read ret=0
	Try to read buffer.
	no data
	__ivring_read ret=0
	Try to read buffer.
	...

4. Start to record logging or tracing data on a guest.
 API for kernel programing is available for IVRing driver:
	ivring_write(int ID, void *buf, size_t size).

It is used for kernel logging as follows:

 	int len;
	char buf[1024];
	len = sprintf(buf, "hogehoge\n",... )
	ivring_write(0, buf, len);

When SystemTap is used as a tracer, a sample script is as follows:

	%{
	extern int ivring_write(int id, void *buf, size_t size);
	%}

	function ivring_print(str:string) %{
		ivring_write(0, THIS->str, strlen(THIS->str));
	%}

	probe kernel.trace("sched*") {
		ivring_print(sprintf("%u: %s(%s)\n", gettimeofday(), pn(), $$parms))
	}
		
The script is executed as
	stap -vg ivring_writer_sample.stp.

 When it is success to record data to IVRing, reader outputs as follows:
	Try to read buffer.
	__ivring_read ret=4096
	__ivring_read ret=4096
	__ivring_read ret=313
	Try to read buffer.
	__ivring_read ret=4096
	__ivring_read ret=4096
	__ivring_read ret=632
	Try to read buffer.

***Future Work***
Features below will be implemented as future work:
 1. To implement a feature of notification from a guest to a host
 2. To implement user I/F on a guest
 3. To be usable in tracing system existing in-kernel
 4. To be usable in SMP environment
    (lockless ring-buffer like ftrace, one ring-buffer one CPU)
 5. To design for Live Migration

Thank you,

---

Yoshihiro YUNOMAE (2):
      ivring: Add a ring-buffer reader tool
      ivring: Add a ring-buffer driver on IVShmem


 drivers/Kconfig               |    1 
 drivers/Makefile              |    1 
 drivers/ivshmem/Kconfig       |    9 +
 drivers/ivshmem/Makefile      |    5 
 drivers/ivshmem/ivring.c      |  551 +++++++++++++++++++++++++++++++++++++++++
 drivers/ivshmem/ivring.h      |   77 ++++++
 tools/Makefile                |    1 
 tools/ivshmem/Makefile        |   19 +
 tools/ivshmem/ivring_reader.c |  516 ++++++++++++++++++++++++++++++++++++++
 tools/ivshmem/ivring_reader.h |   15 +
 tools/ivshmem/pr_msg.c        |  125 +++++++++
 tools/ivshmem/pr_msg.h        |   19 +
 12 files changed, 1339 insertions(+), 0 deletions(-)
 create mode 100644 drivers/ivshmem/Kconfig
 create mode 100644 drivers/ivshmem/Makefile
 create mode 100644 drivers/ivshmem/ivring.c
 create mode 100644 drivers/ivshmem/ivring.h
 create mode 100644 tools/ivshmem/Makefile
 create mode 100644 tools/ivshmem/ivring_reader.c
 create mode 100644 tools/ivshmem/ivring_reader.h
 create mode 100644 tools/ivshmem/pr_msg.c
 create mode 100644 tools/ivshmem/pr_msg.h

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com
