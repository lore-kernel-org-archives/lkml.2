Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752918Ab2C0EmV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 00:42:21 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42578 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab2C0EmU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 00:42:20 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyVELrXO50pfbL-eH48K3_3noRkKMDCqTSVsuSQ0hHRWw@mail.gmail.com>
References: <alpine.LFD.2.02.1203021544300.28247@i5.linux-foundation.org>
	<CABS55+D97mKFdQhGdAXjMGfyRiWd4Os8wfRq9YNa-FQAEQSR7Q@mail.gmail.com>
	<CA+55aFyVELrXO50pfbL-eH48K3_3noRkKMDCqTSVsuSQ0hHRWw@mail.gmail.com>
Date: Tue, 27 Mar 2012 00:42:19 -0400
Message-ID: <CAMzpN2hqay2h111C6pWw6VEBMLDfO_UF-Xf41M1x5ewp5K90yw@mail.gmail.com>
Subject: Re: Word-at-a-time dcache name accesses (was Re: .. anybody know of
 any filesystems that depend on the exact VFS 'namehash' implementation?)
From: Brian Gerst <brgerst@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jason Garrett-Glaser <jason@x264.com>, Andi Kleen <andi@firstfloor.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 12:38 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sun, Mar 4, 2012 at 7:58 PM, Jason Garrett-Glaser <jason@x264.com> wrote:
>>
>> There is an improvement you can make to this.  "bsf" is microcoded in
>> many future CPUs (e.g. Piledriver) in favor of tzcnt, which has
>> slightly different flag behavior and no undefined behavior and is part
>> of BMI1.
>
> So I've gotten rid of 'bsf' because it really does have problems on
> many CPU's. It's disgustingly slow on some older CPU's.
>
> I asked around on G+ to see if that would be useful, and there's a
> nice simple four-instruction sequence for the 32-bit case using just
> trivial operations (one shift, one and, a couple of adds).
>
> For the 64-bit case, the bsf can be replaced with a single multiply
> and shift. The bsf is still better on some CPU's, but the single
> multiply and shift is more consistently good - and as long as it
> doesn't stall the CPU, we're good, because the end result of it all
> won't be used until several cycles later.
>
> So my current patch is attached - it does depend on the current -git
> tree having moved dentry_cmp() into fs/dcache.c, so it's on top of
> *tonights* -git tree, but this is something I'm pretty happy with, and
> was planning on actually committing early in the 3.4 merge window.
>
> My profiling seems to show that the multiply is pretty much free on
> 64-bit at least on the cpu's I have access to - it's not like a
> multiply is free, but I do suspect it gets hidden very well by any OoO
> instruction scheduling.
>
> A bit-count instructions (popcount or bsf or tzcnt is obviously in
> *theory* less work than a 64-bit multiply, but the multiply is
> "portable". Even if it isn't optimal, it shouldn't be horrible on any
> 64-bit capable x86 CPU, and it also means (for example) that the code
> might even work on non-x86 chips.
>
> I did only very limited profiling of the 32-bit case, but it's really
> just four cheap ALU instructions there and didn't really show up at
> all in the limited profiles I did. And at least I checked that the
> code worked. I have to say that the advantage of "vectorizing" this
> code is obviously much less if you can only do 4-byte "vectors", so I
> didn't actually time whether the patch *improves* anything on x86-32.
>
>                                     Linus

This patch is causing my system (x86-64, Fedora 16) to fail to boot
when DEBUG_PAGEALLOC=n.  No oops, but these error messages were in the
log for the bad kernel:

type=1400 audit(1332802076.643:4): avc:  denied  { dyntransition } for
 pid=1 comm="systemd" scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:init_exec_t:s0 tclass=process
systemd[1]: Failed to transition into init label
'system_u:object_r:init_exec_t:s0', ignoring.
type=1400 audit(1332816477.781:5): avc:  denied  { create } for  pid=1
comm="systemd" scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:init_exec_t:s0 tclass=unix_dgram_socket
systemd[1]: systemd-shutdownd.socket failed to listen on sockets:
Permission denied
systemd[1]: Unit systemd-shutdownd.socket entered failed state.
type=1400 audit(1332816477.782:6): avc:  denied  { create } for  pid=1
comm="systemd" scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:syslogd_exec_t:s0 tclass=unix_dgram_socket
systemd[1]: syslog.socket failed to listen on sockets: Permission denied
systemd[1]: Unit syslog.socket entered failed state.
systemd-kmsg-syslogd[457]: No or too many file descriptors passed.
type=1400 audit(1332816477.847:7): avc:  denied  { create } for  pid=1
comm="systemd" scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:udev_exec_t:s0
tclass=netlink_kobject_uevent_socket
systemd[1]: udev-kernel.socket failed to listen on sockets: Permission denied
systemd[1]: Unit udev-kernel.socket entered failed state.
type=1400 audit(1332816477.848:8): avc:  denied  { create } for  pid=1
comm="systemd" scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:udev_exec_t:s0 tclass=unix_stream_socket
systemd[1]: udev-control.socket failed to listen on sockets: Permission denied
systemd[1]: Unit udev-control.socket entered failed state.
type=1400 audit(1332816477.848:9): avc:  denied  { create } for  pid=1
comm="systemd" scontext=system_u:system_r:kernel_t:s0
tcontext=system_u:object_r:init_exec_t:s0 tclass=unix_stream_socket
systemd[1]: systemd-stdout-syslog-bridge.socket failed to listen on
sockets: Permission denied

--
Brian Gerst
