Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab2BVTru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 14:47:50 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61082 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755678Ab2BVTrZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 14:47:25 -0500
MIME-Version: 1.0
In-Reply-To: <1329920626.3258.174.camel@deadeye>
References: <1329845435-2313-1-git-send-email-wad@chromium.org>
	<1329845435-2313-5-git-send-email-wad@chromium.org>
	<38d58caa17befe422065efe5dc451a34.squirrel@webmail.greenhost.nl>
	<1329920626.3258.174.camel@deadeye>
Date: Wed, 22 Feb 2012 13:47:23 -0600
Message-ID: <CABqD9hYRPQbAY2KejstrutEO_jXU3QgBB9og_ByAaFcXZx4GHg@mail.gmail.com>
Subject: Re: [PATCH v10 05/11] seccomp: add system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Indan Zupancic <indan@nul.nu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, pmoore@redhat.com,
        akpm@linux-foundation.org, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, keescook@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 22, 2012 at 8:23 AM, Ben Hutchings
<bhutchings@solarflare.com> wrote:
> On Wed, 2012-02-22 at 09:19 +0100, Indan Zupancic wrote:
> [...]
>> Alternative approach: Tell the arch at filter install time and only run the
>> filters with the same arch as the current system call. If no filters are run,
>> deny the systemcall.
>>
>> Advantages:
>>
>> - Filters don't have to check the arch every syscall entry.
>>
>> - Secure by default. Filters don't have to do anything arch specific to
>>   be secure, no surprises possible.
>>
>> - If a new arch comes into existence, there is no chance of old filters
>>   becoming buggy and insecure. This is especially true for archs that
>>   had only one mode, but added another one later on: Old filters had no
>>   need to check the mode at all.
> [...]
>
> What about when there are multiple layers of restrictions?  So long as
> any one layer covers the new architecture, there is no default-deny even
> though the other layers might not cover it.

This is the biggest challenge with using the split-labeled approach. I
started with the first patches supporting compat and non-compat
side-by-side.  It makes things complicated with inheritance.  If you
have a parent that installed filters for arch=i386 and arch=x86_64,
then a child process installs a filter for arch=x86_64, its behavior
when spawned by that parent is that any i386 calls the parent allows
are allowed, but when it is spawned without any inherited filters, no
i386 calls would be allowed.  This was part of the reason why I
abandoned that approach and went with locking the compat bit.  I don't
think there is a clean way to support inheritance and
implicit-disallow without it being hideous. (I had tried it before
with annotations saying if a filter was inherited or self-created, but
that made the code much more complex for very little gain, imo.)

> I would have thought the way to make sure the architecture is always
> checked is to pack it together with the syscall number.

If the current patchset used the elf machine only and not the
AUDIT_ARCH_* that might be possible since e_machine is only 16 bits.
However, that would still assume that an arch wouldn't introduce a
syscall number above 65535 which is most likely not a safe assumption.
 Am I wrong there?

thanks!
will
