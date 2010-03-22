Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436Ab0CVReW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:34:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905Ab0CVReU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:34:20 -0400
Date: Mon, 22 Mar 2010 18:34:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
 project
Message-ID: <20100322173400.GB15795@elte.hu>
References: <20100322111411.GC3483@elte.hu>
 <4BA7629B.7020604@redhat.com>
 <20100322124428.GA12475@elte.hu>
 <4BA76810.4040609@redhat.com>
 <20100322143212.GE14201@elte.hu>
 <4BA7821C.7090900@codemonkey.ws>
 <20100322155505.GA18796@elte.hu>
 <4BA796DF.7090005@redhat.com>
 <20100322165107.GD18796@elte.hu>
 <4BA7A406.9050203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA7A406.9050203@redhat.com>
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


* Avi Kivity <avi@redhat.com> wrote:

> >>>  - Easy default reference to guest instances, and a way for tools to
> >>>    reference them symbolically as well in the multi-guest case. Preferably
> >>>    something trustable and kernel-provided - not some indirect information
> >>>    like a PID file created by libvirt-manager or so.
> >>
> >> Usually 'layering violation' is trotted out at such suggestions.
> >> [...]
> >
> > That's weird, how can a feature request be a 'layering violation'?
> 
> The 'something trustable and kernel-provided'.  The kernel knows nothing 
> about guest names.

The kernel certainly knows about other resources such as task names or network 
interface names or tracepoint names. This is kernel design 101.

> > If something that users find straightforward and usable is a layering 
> > violation to you (such as easily being able to access their own files on 
> > the host as well ...) then i think you need to revisit the definition of 
> > that term instead of trying to fix the user.
> 
> Here is the explanation, you left it quoted:
> 
> >> [...]  I don't like using the term, because sometimes the layers are 
> >> incorrect and need to be violated.  But it should be done explicitly, not 
> >> as a shortcut for a minor feature (and profiling is a minor feature, most 
> >> users will never use it, especially guest-from-host).
> >>
> >> The fact is we have well defined layers today, kvm virtualizes the cpu 
> >> and memory, qemu emulates devices for a single guest, libvirt manages 
> >> guests. We break this sometimes but there has to be a good reason.  So 
> >> perf needs to talk to libvirt if it wants names.  Could be done via 
> >> linking, or can be done using a pluging libvirt drops into perf.

This is really just the much-discredited microkernel approach for keeping 
global enumeration data that should be kept by the kernel ...

Lets look at the ${HOME}/.qemu/qmp/ enumeration method suggested by Anthony. 
There's numerous ways that this can break:

 - Those special files can get corrupted, mis-setup, get out of sync, or can
   be hard to discover.

 - The ${HOME}/.qemu/qmp/ solution suggested by Anthony has a very obvious
   design flaw: it is per user. When i'm root i'd like to query _all_ current
   guest images, not just the ones started by root. A system might not even
   have a notion of '${HOME}'.

 - Apps might start KVM vcpu instances without adhering to the
   ${HOME}/.qemu/qmp/ access method.

 - There is no guarantee for the Qemu process to reply to a request - while
   the kernel can always guarantee an enumeration result. I dont want 'perf 
   kvm' to hang or misbehave just because Qemu has hung.

Really, for such reasons user-space is pretty poor at doing system-wide 
enumeration and resource management. Microkernels lost for a reason.

You are committing several grave design mistakes here.

Thanks,

	Ingo
