Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1LTS7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 13:59:11 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:43675 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab1LTS7E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 13:59:04 -0500
MIME-Version: 1.0
In-Reply-To: <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com>
References: <CAB9v_DFOm8eDwR5YsqLfUEtr0ku2Zp=NCOaEjkSmxJFcpQ9nPA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E287D8A556C@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFs_Rz04+waeBpVoJsLX+Ao7vQ4EtH2TJsX6jHZewWLQA@mail.gmail.com>
 <CAB9v_DEz44d54tZMyFenNoNNyu3LSA6dw31S_G8MaWp7UbAULQ@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E289048778E@shsmsx502.ccr.corp.intel.com>
 <CAB9v_DFL9K+hSum4k_TJBBP4jcenFiqggyzNNk3QHiPhkiqtxA@mail.gmail.com>
 <BC00F5384FCFC9499AF06F92E8B78A9E28904877AE@shsmsx502.ccr.corp.intel.com> <CAB9v_DEA4HJ2Xyc_fMrZ9gi9oNmKPTmG5LLCiwgsPDHbhgRaQw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 20 Dec 2011 10:58:41 -0800
X-Google-Sender-Auth: xNYNyjIDRhKh2_QUEUIz9BgSkjA
Message-ID: <CA+55aFwZ02yUBbUjJYuXjZnKcQRHC7uT9T1dckZQNSaC6SdnvA@mail.gmail.com>
Subject: Re: [Regression, bisected] a3e06bbe8445f57eb949e6474c5a9b30f24d2057:
 KVM: emulate lapic tsc deadline timer for guest"
To: Alexey Zaytsev <alexey.zaytsev@gmail.com>
Cc: "Liu, Jinsong" <jinsong.liu@intel.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
        "Garrett D'Amore" <garrett@nexenta.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 1:51 AM, Alexey Zaytsev
<alexey.zaytsev@gmail.com> wrote:
>
> Let me clarify the situation.
>
> Before this commit, the tsc was advertised in cpuid, and it was
> handled, if I understand things correctly, by qemu.
> After this commit, the tsc is advertised in cpuid, and is handled in
> the kernel, but only after qemu issues KVM_CREATE_IRQCHIP. If it does
> not issue the ioctl, the kernel just discards any wrmsrs done to the
> tsc. This does not look like an Illumos problem to me. Linux guests
> kind of work here, because they are  prepared to work on utterly
> broken hardware. Good for you, but please don't break less-prepared
> guests.

Yes. This is a regression, and needs to be fixed.

Liu, if you don't have time to debug it, we'll just revert the commit.
It's that easy. Regressions are not allowed. There are no excuses.

In particular, saying "just wait for qemu-kvm" is not an acceptable
answer, because the point is that things *used* to work, and they
broke. No "change it to work with the new kernel" allowed, except for
some *very* rare critical circumstances (usually "major security-bug
that we had to fix, and people who relied on it are thus out of
luck").

Commit a3e06bbe8445 still seems to revert cleanly, so that is the easy option.

That said, it sounds like maybe another solution is to start with the
TSC_DEADLINE timer bit in cpuid cleared, and only setting it after the
KVM_CREATE_IRQCHIP ioctl.

In fact, the patch is clearly buggy, in that it apparently doesn't
emulate TSC_DEADLINE correctly and natively on its own.

Jan, Marcelo, Avi - is there a quick fix, or should I just revert?

And please don't *EVER* tell people that they should just work around
regressions. Regressions are absolutely unacceptable. Kernel people
need to understand that.

                   Linus
