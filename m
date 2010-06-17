Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432Ab0FQDPZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 23:15:25 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48899 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756647Ab0FQDPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 23:15:24 -0400
Message-ID: <4C199348.6050108@oss.ntt.co.jp>
Date: Thu, 17 Jun 2010 12:15:20 +0900
From: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: kvm@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mori.keisuke@oss.ntt.co.jp,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Chris Wright <chrisw@redhat.com>, Dor Laor <dlaor@redhat.com>,
       Lon Hohberger <lhh@redhat.com>, "Perry N. Myers" <pmyers@redhat.com>,
       Luiz Capitulino <lcapitulino@redhat.com>, berrange@redhat.com
Subject: [RFC] High availability in KVM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are trying to improve the integration of KVM with the most common
HA stacks, but we would like to share with the community what we are
trying to achieve and how before we take a wrong turn.

This is a pretty long write-up, but please bear with me.
---


  Virtualization has boosted flexibility on the data center, allowing
  for efficient usage of computer resources, increased server
  consolidation, load balancing on a per-virtual machine basis -- you
  name it, However we feel there is an aspect of virtualization that
  has not been fully exploited so far: high availability (HA).

  Traditional HA solutions can be classified in two groups: fault
  tolerant servers, and software clustering.

  Broadly speaking, fault tolerant servers protect us against hardware
  failures and, generally, rely on redundant hardware (often
  proprietary), and hardware failure detection to trigger fail-over.

  On the other hand, software clustering, as its name indicates, takes
  care of software failures and usually requires a standby server
  whose software configuration for the part we are trying to make
  fault tolerant must be identical to that of the active server.

  Existing open source HA stacks such as pacemaker/corosync and Red
  Hat Cluster Suite rely on software clustering techniques to detect
  both hardware failures and software failures, and employ fencing to
  avoid split-brain situations which, in turn, makes it possible to
  perform failover safely. However, when applied to virtualization
  environments these solutions show some limitations:

    - Hardware detection relies on polling mechanisms (for example
      pinging a network interface to check for network connectivity),
      imposing a trade off between failover time and the cost of
      polling. The alternative is having the failing system send an
      alarm to the HA software to trigger failover. The latter
      approach is preferable but it is not always applicable when
      dealing with bare-metal; depending on the failure type the
      hardware may not able to get a message out to notify the HA
      software. However, when it comes to virtualization environments
      we can certainly do better. If a hardware failure, be it real
      hardware or virtual hardware, is fully contained within a
      virtual machine the host or hypervisor can detect that and
      notify the HA software safely using clean resources.

    - In most cases, when a hardware failure is detected the state of
      the failing node is not known which means that some kind of
      fencing is needed to lock resources away from that
      node. Depending on the hardware and the cluster configuration
      fencing can be a pretty expensive operation that contributes to
      system downtime. Virtualization can help here. Upon failure
      detection the host or hypervisor could put the virtual machine
      in a quiesced state and release its hardware resources before
      notifying the HA software, so that it can start failover
      immediately without having to mingle with the failing virtual
      machine (we now know that it is in a known quiesced state). Of
      course this only makes sense in the event-driven failover case
      described above.

    - Fencing operations commonly involve killing the virtual machine,
      thus depriving us of potentially critical debugging information:
      a dump of the virtual machine itself. This issue could be solved
      by providing a virtual machine control that puts the virtual
      machine in a known quiesced state, releases its hardware
      resources, but keeps the guest and device model in memory so
      that forensics can be conducted offline after failover. Polling
      HA resource agents should use this new command if postmortem
      analysis is important.

  We are pursuing a scenario where current polling-based HA resource
  agents are complemented with an event-driven failure notification
  mechanism that allows for faster failover times by eliminating the
  delay introduced by polling and by doing without fencing. This would
  benefit traditional software clustering stacks and bring a feature
  that is essential for fault tolerance solutions such as Kemari.

  Additionally, for those who want or need to stick with a polling
  model we would like to provide a virtual machine control that
  freezes a virtual machine into a failover-safe state without killing
  it, so that postmortem analysis is still possible.

  In the following sections we discuss the RAS-HA integration
  challenges and the changes that need to be made to each component of
  the qemu-KVM stack to realize this vision. While at it we will also
  delve into some of the limitations of the current hardware error
  subsystems of the Linux kernel.


HARDWARE ERRORS AND HIGH AVAILABILITY

  The major open source software stacks for Linux rely on polling
  mechanisms to detect both software errors and hardware failures. For
  example, ping or an equivalent is widely used to check for network
  connectivity interruptions. This is enough to get the job done in
  most cases but one is forced to make a trade off between service
  disruption time and the burden imposed by the polling resource
  agent.

  On the hardware side of things, the situation can be improved if we
  take advantage of CPU and chipset RAS capabilities to trigger
  failover in the event of a non-recoverable error or, even better, do
  it preventively when hardware informs us things might go awry. The
  premise is that RAS features such as hardware failure notification
  can be leveraged to minimize or even eliminate service
  down-times.

  Generally speaking, hardware errors reported to the operating system
  can be classified into two broad categories: corrected errors and
  uncorrected errors. The later are not necessarily critical errors
  that require a system restart; depending on the hardware and the
  software running on the affected system resource such errors may be
  recoverable. The picture looks like this (definitions taken from
  "Advanced Configuration and Power Interface Specification, Revision
  4.0a" and slightly modified to get rid of ACPI jargon):

    - Corrected error: Hardware error condition that has been
      corrected by the hardware or by the firmware by the time the
      kernel is notified about the existence of an error condition.

    - Uncorrected error: Hardware error condition that cannot be
      corrected by the hardware or by the firmware. Uncorrected errors
      are either fatal or non-fatal.

        o A fatal hardware error is an uncorrected or uncontained
	  error condition that is determined to be unrecoverable by
	  the hardware. When a fatal uncorrected error occurs, the
	  system is usually restarted to prevent propagation of the
	  error.

        o A non-fatal hardware error is an uncorrected error condition
	  from which the kernel can attempt recovery by trying to
	  correct the error. These are also referred to as correctable
	  or recoverable errors.

  Corrected errors are inoffensive in principle, but they may be
  harbingers of fatal non-recoverable errors. It is thus reasonable in
  some cases to do preventive failover or live migration when a
  certain threshold is reached. However this is arguably the job
  systems management software, not the HA, so this case will not be
  discussed in detail here.

  Uncorrected errors are the ones HA software cares about.

  When a fatal hardware error occurs the firmware may decide to
  restart the hardware. If the fatal error is relayed to the kernel
  instead the safest thing to do is to panic to avoid further
  damage. Even though it is theoretically possible to send a
  notification from the kernel's error or panic handler, this is a
  extremely hardware-dependent operation and will not be considered
  here. To detect this type of failures one's old reliable
  polling-based resource agent is the way to go.

  Non-fatal or recoverable errors are the most interesting in the
  pack.  Detection should ideally be performed in a non-intrusive way
  and feed the policy engine with enough information about the error
  to make the right call. If the policy engine decides that the error
  might compromise service continuity it should notify the HA stack so
  that failover can be started immediately.


REQUIREMENTS

  * Linux kernel

  One of the main goals is to notify HA software about hardware errors
  as soon as they are detected so that service downtime can be
  minimized. For this a hardware error subsystem that follows an
  event-driven model is preferable because it allows us to eliminate
  the cost associated with polling. A file based API that provides a
  sys_poll interface and process signaling both fit the bill (the
  latter is pretty limited in its semantics an may not be adequate to
  communicate non-memory type errors).

  The hardware error subsystem should provide enough information to be
  able to map error sources (memory, PCI devices, etc) to processes or
  virtual machines, so that errors can be contained. For example, if a
  memory failure occurs but only affects user-space addresses being
  used by a regular process or a KVM guest there is no need to bring
  down the whole machine.

  In some cases, when a failure is detected in a hardware resource in
  use by one or more virtual machines it might be necessary to put
  them in a quiesced state before notifying the associated qemu
  process.

  Unfortunately there is no generic hardware error layer inside the
  kernel, which means that each hardware error subsystem does its own
  thing and there is even some overlap between them. See HARDWARE ERRORS IN LINUX below for a brief description of the current mess.

  * qemu-kvm

  Currently KVM is only notified about memory errors detected by the
  MCE subsystem. When running on newer x86 hardware, if MCE detects an
  error on user-space it signals the corresponding process with
  SIGBUS. Qemu, upon receiving the signal, checks the problematic
  address which the kernel stored in siginfo and decides whether to
  inject the MCE to the virtual machine.

  An obvious limitation is that we would like to be notified about
  other types of error too and, as suggested before, a file-based
  interface that can be sys_poll'ed might be needed for that.  

  On a different note, in a HA environment the qemu policy described
  above is not adequate; when a notification of a hardware error that
  our policy determines to be serious arrives the first thing we want
  to do is to put the virtual machine in a quiesced state to avoid
  further wreckage. If we injected the error into the guest we would
  risk a guest panic that might detectable only by polling or, worse,
  being killed by the kernel, which means that postmortem analysis of
  the guest is not possible. Once we had the guests in a quiesced
  state, where all the buffers have been flushed and the hardware
  sources released, we would have two modes of operation that can be
  used together and complement each other.

    - Proactive: A qmp event describing the error (severity, topology,
      etc) is emitted. The HA software would have to register to
      receive hardware error events, possibly using the libvirt
      bindings. Upon receiving the event the HA software would know
      that the guest is in a failover-safe quiesced state so it could
      do without fencing and proceed to the failover stage directly.

    - Passive: Polling resource agents that need to check the state of
      the guest generally use libvirt or a wrapper such as virsh. When
      the state is SHUTOFF or CRASHED the resource agent proceeds to
      the facing stage, which might be expensive and usually involves
      killing the qemu process. We propose adding a new state that
      indicates the failover-safe state described before. In this
      state the HA software would not need to use fencing techniques
      and since the qemu process is not killed postmortem analysis of
      the virtual machine is still possible.


HARDWARE ERRORS IN LINUX

  In modern x86 machines there is a plethora of error sources:

    - Processor machines check exception.
    - Chipset error message signals.
    - APEI (ACPI4).
    - NMI.
    - PCIe AER.
    - Non-platform devices (SCSI errors, ATA errors, etc).

  Detection of processor, memory, PCI express, and platform errors in
  the Linux kernel is currently provided by the MCE, the EDAC, and the
  PCIe AER subsystems, which covers the first 5 items in the list
  above. There is some overlap between them with regard to the errors
  they can detect and the hardware they poke into, but they are
  essentially independent systems with completely different
  architectures. To make things worse, there is no standard mechanism
  to notify about non-platform devices beyond the venerable printk().

  Regarding the user space notification mechanism, things do not get
  any better. Each error notification subsystem does its own thing:

    - MCE: Communicates with user space through the /dev/mcelog
      special device and
      /sys/devices/system/machinecheck/machinecheckN/. mcelog is
      usually the tool that hooks into /dev/mcelog (this device can be
      polled) to collect and decode the machine check errors.
      Alternatively,
      /sys/devices/system/machinecheck/machinecheckN/trigger can be
      used to set a program to be run when a machine check event is
      detected. Additionally, when an machine check error that affects
      only user space processes they are signaled SIGBUS.

      The MCE subsystem used to deal only with CPU errors, but it was
      extended to handle memory errors too and there is also initial
      support for ACPI4's APEI. The current MCE APEI implementation
      reaps memory errors notified through SCI, but support for other
      errors (platform, PCIe) and transports covered in the
      specification is in the works.

    - EDAC: Exports memory errors, ECC errors from non-memory devices
      (L1, L2 and L3 caches, DMA engines, etc), and PCI bus parity and
      SERR errors through /sys/devices/system/edac/*.

    - NMI: Uses printk() to write to the system log. When EDAC is
      enabled the NMI handler can also instruct EDAC to check for
      potential ECC errors.

    - PCIe AER subsystem: Notifies PCI-core and AER-capable drivers
      about errors in the PCI bus and uses printk() to write to the
      system log.
---


I would appreciate your comments and advice on any of the issues
presented here.

Thanks,
Fernando

