Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab2A3AMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 19:12:39 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:55005 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab2A3AMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 19:12:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Earl Chew <echew@ixiacom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org>
	<4F1D8180.9030509@ixiacom.com> <m1mx9enzr0.fsf@fess.ebiederm.org>
	<4F1D8F37.6020806@ixiacom.com> <4F25CEB5.8070704@ixiacom.com>
Date: Sun, 29 Jan 2012 16:15:10 -0800
In-Reply-To: <4F25CEB5.8070704@ixiacom.com> (Earl Chew's message of "Sun, 29
	Jan 2012 14:56:53 -0800")
Message-ID: <m1ty3ekpv5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ALaFwBJq/QTXCv6/tiUfsdNt3+CooOSk=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earl Chew <echew@ixiacom.com> writes:

>> If you are interested in fixing this properly with a tiny buffer
>> reachable from struct file I think this can be worth fixing.  I think
>> this is doable by using seq_file in proc_sys_read.
>
> I've looked into making proc_sys_read() use seq_file, but there are a few
> issues to work through.
>
> I'm assuming that the existing kernel modules must continue to use the
> ctl_table/proc_dointvec/etc interface without requiring patching.
>
> The two main consequences of this are:
>
> a. The existing struct ctl_table interface should be preserved.
>    Kernel modules use this to publish into procfs.

Generally.  Changing all 200 or so users of the ctl_table interface is a
pain to audit and make certain you having done something silly.

> b. The existing proc_dointvec(), etc, functions must be preserved
>    because they are exported via EXPORT_SYMBOL. Kernel modules
>    may rely on these symbols in arbitrary ways.

You only have to worry about in kernel users, and a quick source audit
should allow to be certain that there are no arbitrary weird uses
of proc_dointvec.

> I tried use seq_file in proc_sys_read, and it comes close to solving
> the problem. The issue is that proc_dointvec() requires a __user pointer.
>
> A seq_file has an internal buffer that could be filled by proc_dointvec() -- but that
> seq_file buffer is in kernel space.
>
> This is not a problem isolated to the seq_file implementation. I think that
> any approach involving a small local buffer would mean that that buffer is
> in kernel space, and that buffer cannot be passed to proc_dointvec() as it
> stands now because proc_dointvec() requires a __user buffer.

We can definitely change the signature of proc_handler and thus
proc_dointvec and friends to be friendlier to an internal buffer.

For prototyping it probably makes sense to use set_fs so you can
use an internal buffer without needing to change the method.

> One approach that might work is to add a new field to struct ctl_table :
>
> struct ctl_table
> {
> 	...
> 	proc_seq_handler *proc_seq_handler;
> };
>
> Existing modules can continue to use proc_dointvec() etc and fixed
> code can use the new proc_seq_handler interface using the new
> proc_seq_dointvec() etc.
>
>
> Although this preserves the old interface, it seems to me that this
> approach is flawed in that kernel modules using struct ctl_table and proc_dointvec()
> continue to be broken -- they are not fixed.

It might make a good intermediate transition scheme while existing
tables are being updated.

> So, perhaps breaking assumption (b) might be a reasonable thing to do ?

Definitely.

> If we accept that proc_dointvec() etc are only or mainly used in the
> context of filling out struct ctl_table, and that other kernel modules
> don't use proc_dointvec() in other contexts, then we can change the
> call signature of proc_dointvec() to stop using a __user pointer:

Exactly.

> 1. Change signature of proc_dointvec() etc to stop using __user pointer for reads
> 2. Change definition of typedef proc_call_handler to stop using __user pointer for reads
> 3. In kernel/sysctl.c don't use copy_to_user() for reads

All of which sound like nice cleanups, and likely to reduce the number
of places where people can badly get things wrong.

> Then proc_sys_read() can use proc_dointvec() etc to fill seq_file.

Yes.  That sounds like a nice cleanup.

> For writes, the existing behaviour needs to be preserved. One approach
> that would solve this would be to add:
>
> 	union proc_buffer {
> 		void __user *uptr;
> 		void *kptr;
> 	};
>
> 	typedef int proc_handler (struct ctl_table *ctl, int write,
>                           union proc_buffer buffer, size_t *lenp, loff_t *ppos);


> I think this would be preferable to either casting away __user for reads, or
> adding two pointers to the proc_handler signature (one with __user, one without).
>
> If write is indicated, use buffer.uptr, and if not the handlers would use buffer.kptr.

For interface design I would look carefully at the bitmap interface that
comes out of sysctl.  I think that is the most data interface we have.

I suspect what we want for writes is to read the existing value into an
internal buffer, and then allow partial writes to the internal buffer.

I don't know if writable seq_files exist.

> But this is not perfect.  Kernel modules containing their _own_ proc_handler
> definitions would now be broken severely.
>
>
> And now I circle back to the proc_seq_handler approach.  Each ctl_table client
> must be fixed individually (ie switch from proc_handler to proc_seq_handler).
>
> What do you think ?

It sounds like you are thinking things through well.  

For a transition strategy we may want to change proc_handler into
operations structure instead of just a function pointer.

Only having a single method we can call sounds like a pain.

struct ctl_proc_operations {
	int (*proc_handler)(....);
        int (*proc_seq_handler)(...);
};

Or maybe:

struct ctl_proc_operations {
	int (*proc_handler)(....);
        int (*proc_seq_read_handler)(...);
        int (*proc_seq_write_handler)(...);
};

Having the option of different read/write methods is a plus.

More usefully this should allow us to update what the implementation
of things like proc_dointvec mean without having to update all of
the tables.  Which should make it much easier to preserve correctness,
because we don't a huge number of manual edits to ctl_table structures
all over the kernel.

Eric

