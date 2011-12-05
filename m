Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab1LEKz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 05:55:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755825Ab1LEKzX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 05:55:23 -0500
Date: Mon, 5 Dec 2011 16:24:52 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Miche Baker-Harvey <miche@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Greg Kroah-Hartman <gregkh@suse.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Anton Blanchard <anton@samba.org>, Mike Waychison <mikew@google.com>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Eric Northrup <digitaleric@google.com>
Subject: Re: [PATCH v3 2/3] hvc_init(): Enforce one-time initialization.
Message-ID: <20111205105452.GB27683@amit-x200.redhat.com>
References: <20111108214452.28884.14840.stgit@miche.sea.corp.google.com>
 <20111108214504.28884.61814.stgit@miche.sea.corp.google.com>
 <874nybqo0o.fsf@rustcorp.com.au>
 <CAB8RdapbaueyWLJuJDE_ZdvLkRNM4sQHTxgmgO=jrnXZ6YPSmA@mail.gmail.com>
 <20111123103852.GG16665@amit-x200.redhat.com>
 <CAB8RdaoDxMCgTjuGP70bGrsrtgh=USYtU3Spo5OPtVMYAM5EzQ@mail.gmail.com>
 <20111129142149.GE2822@amit-x200.redhat.com>
 <CAB8RdapuPRym2dH_9mgmGdzpCxnP1KpS+hS8JJ-geVkga5fMcw@mail.gmail.com>
 <CAB8Rdapfuf5XH+X9gsUL+CJ9gTQcSNfq4Dj9DoYWQeFgD04ODQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB8Rdapfuf5XH+X9gsUL+CJ9gTQcSNfq4Dj9DoYWQeFgD04ODQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Tue) 29 Nov 2011 [09:50:41], Miche Baker-Harvey wrote:
> Good grief!  Sorry for the spacing mess-up!  Here's a resend with reformatting.
> 
> Amit,
> We aren't using either QEMU or kvmtool, but we are using KVM.  All

So it's a different userspace?  Any chance this different userspace is
causing these problems to appear?  Esp. since I couldn't reproduce
with qemu.

> the issues we are seeing happen when we try to establish multiple
> virtioconsoles at boot time.  The command line isn't relevant, but I
> can tell you the protocol that's passing between the host (kvm) and
> the guest (see the end of this message).
> 
> We do go through the control_work_handler(), but it's not
> providing synchronization.  Here's a trace of the
> control_work_handler() and handle_control_message() calls; note that
> there are two concurrent calls to control_work_handler().

Ah; how does that happen?  control_work_handler() should just be
invoked once, and if there are any more pending work items to be
consumed, they should be done within the loop inside
control_work_handler().

> I decorated control_work_handler() with a "lifetime" marker, and
> passed this value to handle_control_message(), so we can see which
> control messages are being handled from which instance of
> the control_work_handler() thread.
> 
> Notice that we enter control_work_handler() a second time before
> the handling of the second PORT_ADD message is complete. The
> first CONSOLE_PORT message is handled by the second
> control_work_handler() call, but the second is handled by the first
> control_work_handler() call.
> 
> root@myubuntu:~# dmesg | grep MBH
> [3371055.808738] control_work_handler #1
> [3371055.809372] + #1 handle_control_message PORT_ADD
> [3371055.810169] - handle_control_message PORT_ADD
> [3371055.810170] + #1 handle_control_message PORT_ADD
> [3371055.810244]  control_work_handler #2
> [3371055.810245] + #2 handle_control_message CONSOLE_PORT
> [3371055.810246]  got hvc_ports_mutex
> [3371055.810578] - handle_control_message PORT_ADD
> [3371055.810579] + #1 handle_control_message CONSOLE_PORT
> [3371055.810580]  trylock of hvc_ports_mutex failed
> [3371055.811352]  got hvc_ports_mutex
> [3371055.811370] - handle_control_message CONSOLE_PORT
> [3371055.816609] - handle_control_message CONSOLE_PORT
> 
> So, I'm guessing the bug is that there shouldn't be two instances of
> control_work_handler() running simultaneously?

Yep, I assumed we did that but apparently not.  Do you plan to chase
this one down?

		Amit
