Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0GJWhY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 18:37:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:53195 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab0GJWhW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 18:37:22 -0400
Date: Sat, 10 Jul 2010 15:36:42 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
cc: kvm@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mori.keisuke@oss.ntt.co.jp,
       Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       Chris Wright <chrisw@redhat.com>, Dor Laor <dlaor@redhat.com>,
       Lon Hohberger <lhh@redhat.com>, "Perry N. Myers" <pmyers@redhat.com>,
       Luiz Capitulino <lcapitulino@redhat.com>, berrange@redhat.com
Subject: Re: [RFC] High availability in KVM
In-Reply-To: <4C199348.6050108@oss.ntt.co.jp>
Message-ID: <alpine.DEB.2.00.1007101510180.27626@asgard.lang.hm>
References: <4C199348.6050108@oss.ntt.co.jp>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Fernando Luis Vazquez Cao wrote:

> Existing open source HA stacks such as pacemaker/corosync and Red
> Hat Cluster Suite rely on software clustering techniques to detect
> both hardware failures and software failures, and employ fencing to
> avoid split-brain situations which, in turn, makes it possible to
> perform failover safely. However, when applied to virtualization
> environments these solutions show some limitations:
>
>   - Hardware detection relies on polling mechanisms (for example
>     pinging a network interface to check for network connectivity),
>     imposing a trade off between failover time and the cost of
>     polling. The alternative is having the failing system send an
>     alarm to the HA software to trigger failover. The latter
>     approach is preferable but it is not always applicable when
>     dealing with bare-metal; depending on the failure type the
>     hardware may not able to get a message out to notify the HA
>     software. However, when it comes to virtualization environments
>     we can certainly do better. If a hardware failure, be it real
>     hardware or virtual hardware, is fully contained within a
>     virtual machine the host or hypervisor can detect that and
>     notify the HA software safely using clean resources.

you still need to detect failures that you won't be notified of.

what if a network cable goes bad and your data isn't getting through? you 
won't get any notification of this without doing polling, even in a 
virtualized environment.

also, in a virtualized environment you may have firewall rules between 
virtual hosts, if those get misconfigured you may have 'virual physical 
connectivity' still, but not the logical connectivity that you need.

>   - In most cases, when a hardware failure is detected the state of
>     the failing node is not known which means that some kind of
>     fencing is needed to lock resources away from that
>     node. Depending on the hardware and the cluster configuration
>     fencing can be a pretty expensive operation that contributes to
>     system downtime. Virtualization can help here. Upon failure
>     detection the host or hypervisor could put the virtual machine
>     in a quiesced state and release its hardware resources before
>     notifying the HA software, so that it can start failover
>     immediately without having to mingle with the failing virtual
>     machine (we now know that it is in a known quiesced state). Of
>     course this only makes sense in the event-driven failover case
>     described above.
>
>   - Fencing operations commonly involve killing the virtual machine,
>     thus depriving us of potentially critical debugging information:
>     a dump of the virtual machine itself. This issue could be solved
>     by providing a virtual machine control that puts the virtual
>     machine in a known quiesced state, releases its hardware
>     resources, but keeps the guest and device model in memory so
>     that forensics can be conducted offline after failover. Polling
>     HA resource agents should use this new command if postmortem
>     analysis is important.

I don't see this as the job of the virtualization hypervisor. the software 
HA stacks include the ability to run external scripts to perform these 
tasks. These scripts can perform whatever calls to the hypervisor that 
are appropriate to freeze, shutdown, or disconnect the virtual server (and 
what is appropriate will vary from implementation to implementation)

providing sample scripts that do this for the various HA stacks makes 
sense as it gives people examples of what can be done and lets them tailor 
exactly what does happen to their needs.

> We are pursuing a scenario where current polling-based HA resource
> agents are complemented with an event-driven failure notification
> mechanism that allows for faster failover times by eliminating the
> delay introduced by polling and by doing without fencing. This would
> benefit traditional software clustering stacks and bring a feature
> that is essential for fault tolerance solutions such as Kemari.

heartbeat/pacemaker has been able to do sub-second failovers for several 
years, I'm not sure that notification is really needed.

that being said the HA stacks do allow for commands to be fed into the HA 
system to tell a machine to go active/passive already, so why don't you 
have your notification just call scripts to make the appropriate calls?

> Additionally, for those who want or need to stick with a polling
> model we would like to provide a virtual machine control that
> freezes a virtual machine into a failover-safe state without killing
> it, so that postmortem analysis is still possible.

how is this different from simply pausing the virtual machine?

> In the following sections we discuss the RAS-HA integration
> challenges and the changes that need to be made to each component of
> the qemu-KVM stack to realize this vision. While at it we will also
> delve into some of the limitations of the current hardware error
> subsystems of the Linux kernel.
>
>
> HARDWARE ERRORS AND HIGH AVAILABILITY
>
> The major open source software stacks for Linux rely on polling
> mechanisms to detect both software errors and hardware failures. For
> example, ping or an equivalent is widely used to check for network
> connectivity interruptions. This is enough to get the job done in
> most cases but one is forced to make a trade off between service
> disruption time and the burden imposed by the polling resource
> agent.
>
> On the hardware side of things, the situation can be improved if we
> take advantage of CPU and chipset RAS capabilities to trigger
> failover in the event of a non-recoverable error or, even better, do
> it preventively when hardware informs us things might go awry. The
> premise is that RAS features such as hardware failure notification
> can be leveraged to minimize or even eliminate service
> down-times.

having run dozens of sets of HA systems for about 10 years, I find that 
very few of the failures that I have experianced would have been helped by 
this. hardware very seldom gives me any indication that it's about to 
fail, and even when it does fail it's usually only discovered due to the 
side effects of other things I am trying to do not working.

> Generally speaking, hardware errors reported to the operating system
> can be classified into two broad categories: corrected errors and
> uncorrected errors. The later are not necessarily critical errors
> that require a system restart; depending on the hardware and the
> software running on the affected system resource such errors may be
> recoverable. The picture looks like this (definitions taken from
> "Advanced Configuration and Power Interface Specification, Revision
> 4.0a" and slightly modified to get rid of ACPI jargon):
>
>   - Corrected error: Hardware error condition that has been
>     corrected by the hardware or by the firmware by the time the
>     kernel is notified about the existence of an error condition.
>
>   - Uncorrected error: Hardware error condition that cannot be
>     corrected by the hardware or by the firmware. Uncorrected errors
>     are either fatal or non-fatal.
>
>       o A fatal hardware error is an uncorrected or uncontained
> 	  error condition that is determined to be unrecoverable by
> 	  the hardware. When a fatal uncorrected error occurs, the
> 	  system is usually restarted to prevent propagation of the
> 	  error.
>
>       o A non-fatal hardware error is an uncorrected error condition
> 	  from which the kernel can attempt recovery by trying to
> 	  correct the error. These are also referred to as correctable
> 	  or recoverable errors.
>
> Corrected errors are inoffensive in principle, but they may be
> harbingers of fatal non-recoverable errors. It is thus reasonable in
> some cases to do preventive failover or live migration when a
> certain threshold is reached. However this is arguably the job
> systems management software, not the HA, so this case will not be
> discussed in detail here.

the easiest way to do this is to log the correctable errors and let normal 
log analysis tools notice these errors and decide to take action. trying 
to make the hypervisor do something here is putting policy in the wrong 
place.

> Uncorrected errors are the ones HA software cares about.
>
> When a fatal hardware error occurs the firmware may decide to
> restart the hardware. If the fatal error is relayed to the kernel
> instead the safest thing to do is to panic to avoid further
> damage. Even though it is theoretically possible to send a
> notification from the kernel's error or panic handler, this is a
> extremely hardware-dependent operation and will not be considered
> here. To detect this type of failures one's old reliable
> polling-based resource agent is the way to go.

and in this case you probably cannot trust the system to send notification 
without damaging things further, simply halting is probably the only safe 
thing to do.

> Non-fatal or recoverable errors are the most interesting in the
> pack.  Detection should ideally be performed in a non-intrusive way
> and feed the policy engine with enough information about the error
> to make the right call. If the policy engine decides that the error
> might compromise service continuity it should notify the HA stack so
> that failover can be started immediately.

again, log the errors and let existing log analysis/alerting tools decide 
what action to take.

> Currently KVM is only notified about memory errors detected by the
> MCE subsystem. When running on newer x86 hardware, if MCE detects an
> error on user-space it signals the corresponding process with
> SIGBUS. Qemu, upon receiving the signal, checks the problematic
> address which the kernel stored in siginfo and decides whether to
> inject the MCE to the virtual machine.
>
> An obvious limitation is that we would like to be notified about
> other types of error too and, as suggested before, a file-based
> interface that can be sys_poll'ed might be needed for that. 
> On a different note, in a HA environment the qemu policy described
> above is not adequate; when a notification of a hardware error that
> our policy determines to be serious arrives the first thing we want
> to do is to put the virtual machine in a quiesced state to avoid
> further wreckage. If we injected the error into the guest we would
> risk a guest panic that might detectable only by polling or, worse,
> being killed by the kernel, which means that postmortem analysis of
> the guest is not possible. Once we had the guests in a quiesced
> state, where all the buffers have been flushed and the hardware
> sources released, we would have two modes of operation that can be
> used together and complement each other.

it sounds like you really need to be running HA at two layers

1. on the host layer to detect problems with the host and decide to 
freeze/migrate  virtual machines to another system

2. inside the guests to make sure that the guests that are running (on 
multiple real machines) continue to provide services.

but what is your alturnative to sending the error into the guest? 
depending on what the error is you may or may not be able to freeze the 
guest (it makes no sense to try and flush buffers to a drive that won't 
accept writes for example)

>   - Proactive: A qmp event describing the error (severity, topology,
>     etc) is emitted. The HA software would have to register to
>     receive hardware error events, possibly using the libvirt
>     bindings. Upon receiving the event the HA software would know
>     that the guest is in a failover-safe quiesced state so it could
>     do without fencing and proceed to the failover stage directly.

if it's not a fatal error then the system can continue to run (for at 
least a few more seconds ;-), let such errors get written to syslog and 
let a tool like SEC (simple event correlator) see the logs and deicde what 
to do. there's no need to modify the kernel/KVM for this.

>   - Passive: Polling resource agents that need to check the state of
>     the guest generally use libvirt or a wrapper such as virsh. When
>     the state is SHUTOFF or CRASHED the resource agent proceeds to
>     the facing stage, which might be expensive and usually involves
>     killing the qemu process. We propose adding a new state that
>     indicates the failover-safe state described before. In this
>     state the HA software would not need to use fencing techniques
>     and since the qemu process is not killed postmortem analysis of
>     the virtual machine is still possible.

how do you define failover-safe states? why would the HA software (with 
the assistance of a log watcher) not be able to do the job itself?

I do think that it's significant that all the HA solutions out there 
prefer to test if the functionality works rather than watching for log 
events to say there may be a problem, but there's nothing preventing this 
from easily being done.

David Lang

