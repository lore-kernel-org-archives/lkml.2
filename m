Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934254Ab0EEMNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:13:04 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:45085 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934114Ab0EEMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:12:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=S1wVy+Gccd08Onaqwrr9BpdrUkhC2O0bpPNjnl71PxjlhPbztL52gCtu784X/96gf5
         zGvqIqUcFfr6vpGHWUrxthOBrU2kDGjVgHY6+4E9t1jM2fI1HC5/Uho3NL85E3cB1rUg
         qQndnLtqJBrZ3zlQKpd+gZw3XFP16StlwS6ck=
Message-ID: <4BE160C6.90404@gmail.com>
Date: Wed, 05 May 2010 14:12:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.5pre) Gecko/20100430 SUSE/3.1b2-7.1 Thunderbird/3.1b2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alexey Dobriyan <adobriyan@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Neil Horman <nhorman@tuxdriver.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Resource limits interface proposal [was: pull request for writable
 limits]
References: <4B1D32D1.4090404@gmail.com> <4B9136F4.4010007@gmail.com> <alpine.LFD.2.00.1003201207160.18017@i5.linux-foundation.org> <20100321060607.GA4062@x200> <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1003211128520.18017@i5.linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 03/21/2010 07:38 PM, Linus Torvalds wrote:
> Or even just _one_ system call that takes two pointers, and can do an 
> atomic replace-and-return-the-old-value, like 'sigaction()' does, ie 
> something like
> 
> 	int prlimit64(pid, limit, const struct rlimit64 *new, struct rlimit64 *old);
> 
> wouldn't that be a nice generic interface?

So I ended up with thinking about these possibilities:

1) internal representation of limits will stay as is in signal_struct,
i.e. long limits with infinity being ~0ul. This is the least intrusive
solution. The new prlimit64 will convert rlimit64 to rlimit and pass
down to do_prlimit. With setrlimit and getrilimit just as wrappers it
will look like:
prlimit64(pid, resource, new64, old64) ->
    new = convert_to_rlim(new64)
    tsk = find_task(pid)
    do_prlimit(tsk, resource, new, old)
    old64 = convert_to_rlim64(old)
setrlimit(resource, rlim) ->
    do_prlimit(current, resource, rlim, NULL)
getrlimit(resource, rlim) ->
    do_prlimit(current, resource, NULL, rlim)
with appropriate copy_{from,to}_user. (And setrlimit+getrlimit will be
scheduled for removal with all the compat crap around them.)

It may also be that rlimit64 will contain flags like:
#define RLIM64_CUR_INFINITY     0x00000001
#define RLIM64_MAX_INFINITY     0x00000002
struct rlimit64 {
        __u64 rlim_cur;
        __u64 rlim_max;
        __u32 flags;
};
if I understood Alexey correctly to separate limits values from
infinity? flags then will be converted to ~0ul when converting from
rlimit64 to rlimit above too.

The drawback is when a 32-bit user passes down a value >= (1 << 32),
EINVAL shall occur.

The pros are, no locking, no magic, longs are naturally atomic. Still
with arch-independent parameter for sys_prlimit64.


2) Introduce an rlimit lock and move every user to the rlimit helpers
which appropriately lock the accesses. And making locking a nop when
BITS_PER_LONG == 64. Then we can have rlimit64 in signal_struct and
everything will happen on 64-bit limit values.

If we decide to separate infinity from value with the flags above, we
should also reconsider what infinity will be. Much code just counts with
rlimit.rlim_{cur,max} being the highest possible value and doesn't count
with something like rlimit64.flags. This will result in locks not-being
a nop on 64-bit, because we want fresh rlim_cur+flags and rlim_max+flags
pairs. We could also have the flags solely in the syscall interface and
~0ULL count as infty internally.

In this case the situation will be
prlimit64(pid, resource, new64, old64) ->
    tsk = find_task(pid)
    do_prlimit(tsk, resource, new64, old64)
setrlimit(resource, rlim) ->
    rlim64 = convert_to_rlim64(rlim)
    do_prlimit(current, resource, rlim64, NULL)
getrlimit(resource, rlim) ->
    do_prlimit(current, resource, NULL, rlim64)
    rlim = convert_to_rlim(rlim64)

We cannot fail in prlimit64 due to limited space in longs on 32-bit,
however we added locking which may slow things down. I have no idea how
contended the lock will be, but as rlimits are used in the scheduler and
filesystem core, it might affect performance. I might measure if this is
of interest.


3) [inspired by Jan Kara's idea who knows how inode handling works] It's
some kind of similar to 2), we just avoid locks similarly to
inode->i_size accessors.

It doesn't solve the case of separate flags though.



Just a side note, we cannot use the rlimit64 name which is already
reserved in glibc headers for limits handling.

I will appreciate any comments.

thanks,
-- 
js

-- 
js
suse labs

-- 
js
