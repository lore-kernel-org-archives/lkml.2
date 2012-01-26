Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034Ab2AZDrf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 22:47:35 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51227 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607Ab2AZDrd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 22:47:33 -0500
MIME-Version: 1.0
In-Reply-To: <201201260209.54513.vda.linux@googlemail.com>
References: <CAObL_7EA-Z8yBbr1+-VW0v8k1okdcMfjRe5LgWo8YL5uvOkXbQ@mail.gmail.com>
 <201201260032.57937.vda.linux@googlemail.com> <ca17a86f7c88f8884e4ffc9bafbf2dff.squirrel@webmail.greenhost.nl>
 <201201260209.54513.vda.linux@googlemail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 25 Jan 2012 19:47:12 -0800
X-Google-Sender-Auth: WZKh_48T_FXRIpBpWUzsmKnKbio
Message-ID: <CA+55aFzDZhGoa1TH=RAtjK3Ti3=NPAYvreSxiTxTu3wnu8Z61g@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Indan Zupancic <indan@nul.nu>, Oleg Nesterov <oleg@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Jamie Lokier <jamie@shareable.org>,
        Andrew Lutomirski <luto@mit.edu>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, segoon@openwall.com, rostedt@goodmis.org,
        jmorris@namei.org, scarybeasts@gmail.com, avi@redhat.com,
        penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk, mingo@elte.hu,
        akpm@linux-foundation.org, khilman@ti.com, borislav.petkov@amd.com,
        amwang@redhat.com, ak@linux.intel.com, eric.dumazet@gmail.com,
        gregkh@suse.de, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 25, 2012 at 5:09 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
>
> Please look at strace source, get_scno() function, where
> it reads syscall no and parameters. Let's see....
> - POWERPC: has 32-bit and 64-bit mode
> - X86_64: has 32-bit and 64-bit mode
> - IA64: has i386-compat mode
> - ARM: has more than one ABI
> - SPARC: has 32-bit and 64-bit mode
>
> Do you want to re-invent a different arch-specific way to report
> syscall type for each of these arches?

I think an arch-specific one is better than trying to make some
generic one that is messy.

As you say, many architectures have multiple system call ABIs.

But they tend to be very *different* issues. They can be about
multiple ABI's, as you mention, and even when they *look* similar
(32-bit vs 64-bit ABI's) they are actually totally different issues.

On x86, the real issue is not so much "32-bit vs 64-bit" as "multiple
system call entry models", where a 64-bit process can use the system
call entry for a 32-bit one. That is not true on POWER, for example,
and trying to make it out to be the same issue only muddles the point,
and confuses things. It really is NOT AT ALL the same issue, even if
you can make it "look" like the same issue by calling it a 32-bit vs
64-bit thing.

So for POWER, it really is about the mode of the CPU/process. For x86,
it really isn't. Trying to equate the two is *wrong*.

I seriously think it's better to be architecture-specific than to be
that kind of totally confused, and try to "consolidate" the issue,
when they are actually two totally different issues.

                        Linus
