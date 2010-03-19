Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0CSIWQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 04:22:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37667 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab0CSIWL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 04:22:11 -0400
Date: Fri, 19 Mar 2010 09:21:22 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Avi Kivity <avi@redhat.com>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       zhiteng.huang@intel.com, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100319082122.GE12576@elte.hu>
References: <1268717232.2813.36.camel@localhost>
 <1268969929.2813.184.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268969929.2813.184.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Nice progress!

This bit:

> 1) perf kvm top
> [root@lkp-ne01 norm]# perf kvm --host --guest --guestkallsyms=/home/ymzhang/guest/kallsyms
> --guestmodules=/home/ymzhang/guest/modules top

Will be really be painful to developers - to enter that long line while we 
have these things called 'computers' that ought to reduce human work. Also, 
it's incomplete, we need access to the guest system's binaries to do ELF 
symbol resolution and dwarf decoding.

So we really need some good, automatic way to get to the guest symbol space, 
so that if a developer types:

   perf kvm top

Then the obvious thing happens by default. (which is to show the guest 
overhead)

There's no technical barrier on the perf tooling side to implement all that: 
perf supports build-ids extensively and can deal with multiple symbol spaces - 
as long as it has access to it. The guest kernel could be ID-ed based on its 
/sys/kernel/notes and /sys/module/*/notes/.note.gnu.build-id build-ids.

So some sort of --guestmount option would be the natural solution, which 
points to the guest system's root: and a Qemu enumeration of guest mounts 
(which would be off by default and configurable) from which perf can pick up 
the target guest all automatically. (obviously only under allowed permissions 
so that such access is secure)

This would allow not just kallsyms access via $guest/proc/kallsyms but also 
gives us the full space of symbol features: access to the guest binaries for 
annotation and general symbol resolution, command/binary name identification, 
etc.

Such a mount would obviously not broaden existing privileges - and as an 
additional control a guest would also have a way to indicate that it does not 
wish a guest mount at all.

Unfortunately, in a previous thread the Qemu maintainer has indicated that he 
will essentially NAK any attempt to enhance Qemu to provide an easily 
discoverable, self-contained, transparent guest mount on the host side.

No technical justification was given for that NAK, despite my repeated 
requests to particulate the exact security problems that such an approach 
would cause.

If that NAK does not stand in that form then i'd like to know about it - it 
makes no sense for us to try to code up a solution against a standing 
maintainer NAK ...

The other option is some sysadmin level hackery to NFS-mount the guest or so. 
This is a vastly inferior method that brings us back to the absymal usability 
levels of OProfile:

 1) it wont be guest transparent
 2) has to be re-done for every guest image. 
 3) even if packaged it has to be gotten into every. single. Linux. distro. separately.
 4) old Linux guests wont work out of box

In other words: it's very inconvenient on multiple levels and wont ever happen 
on any reasonable enough scale to make a difference to Linux.

Which is an unfortunate situation - and the ball is on the KVM/Qemu side so i 
can do little about it.

Thanks,

	Ingo
