Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932512Ab2LNWA7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 17:00:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50935 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932393Ab2LNWA6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 17:00:58 -0500
Message-ID: <50CBA171.4080403@zytor.com>
Date: Fri, 14 Dec 2012 14:00:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, aarcange@redhat.com,
        ak@linux.intel.com, Pavel Emelyanov <xemul@parallels.com>,
        Stefani Seibold <stefani@seibold.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org, criu@openvz.org, mingo@redhat.com,
        john.stultz@linaro.org, tglx@linutronix.de
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit
 kernel
References: <50CA81A4.9040702@zytor.com> <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com> <50CA85BD.7070502@zytor.com> <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com> <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com> <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com> <50CAE485.5020608@parallels.com> <50CB716D.6020501@zytor.com> <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com> <50CB7459.7010107@zytor.com> <20121214201217.GE6582@moon> <50CB9553.7050808@zytor.com> <CALCETrUS7JDtLd0jYy7cRNoBm1VHhMw3sTPRjhsm3uDwoPQrCA@mail.gmail.com>
In-Reply-To: <CALCETrUS7JDtLd0jYy7cRNoBm1VHhMw3sTPRjhsm3uDwoPQrCA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 01:27 PM, Andy Lutomirski wrote:
> 
> I don't know all that much about the linux vm.  Can we create a
> special vdso address_space or struct inode or something so that a
> single vma can contain pages with different flags?
> 

No, that is still different vmas, but it probably isn't a big deal.

The advantage of having an inode/namespace is that it lets you use
mmap() as opposed to mremap() with it, which might be useful, I don't know.

One option for the checkpoint people might actually be to not use the
vdso for a process that needs to be checkpointed and restarted on a
different machine or different kernel version.  Instead they can install
a pseudo-vdso which just calls normal system calls, and is simply a
static piece of code that makes normal system calls ... since the
internals of the kernel are hidden from userspace it is "clean" that way.

With any actual vdso you risk something like:

	-> vdso entry
	-> signal received, transfer to signal handler
	-> checkpoint
	-> restart
	-> signal handler exit

... and now you return to the address in the old vdso, but the internals
of the vdso may have changed.

	-hpa


