Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2ALKQq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 05:16:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab2ALKQn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 05:16:43 -0500
Message-ID: <4F0EB2FF.30009@redhat.com>
Date: Thu, 12 Jan 2012 12:16:31 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Nadav Amit <nadav.amit@gmail.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
        Takuya Yoshikawa <takuya.yoshikawa@gmail.com>,
        Nadav Amit <namit@cs.technion.ac.il>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] KVM: Exception during emulation decode should propagate
References: <1326300811-17065-1-git-send-email-namit@cs.technion.ac.il> <20120112071137.303628cea69b79868956d860@gmail.com> <4F0E28C7.2010409@oss.ntt.co.jp> <0C475788-593F-46AA-8BE0-274E6765D46D@gmail.com>
In-Reply-To: <0C475788-593F-46AA-8BE0-274E6765D46D@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2012 11:07 AM, Nadav Amit wrote:
> >> 
> >> When I cleaned up insn_fetch(), I thought that fetching the instruction
> >> which is being executed by the guest cannot cause #PF.
> >> 
> >> The possibility that a meaningless userspace might similtaneously unmap
> >> the page, noted by Avi IIRC, was ignored intentionally, so we just fail
> >> in such a case.
> >> 
> >> Did you see any real problem?
>
> Well, I run some research project for which I emulate instructions quite
> often. I do see a real problem with Linux 3.0.0. Please note AFAIK #GP
> might occur as well during instruction fetch. I don't think failing is the
> right behavior in such case - there is no real reason to fail.
>
> Please tell me whether you are OK with KVM failing in such a scenario.

So long as it's just the guest who is affected (at the same privilege
level; we don't want guest userspace to cause a host failure).

We might have issues with userspace causing such a failure, or a nested
guest.  I see we already check for that in handle_emulation_failure()
(but not userspace).

> If not - I'll send an updated patch (in which x86_decode_insn returns
> EMULATION_OK when rc == X86EMUL_PROPAGATE_FAULT).

It guess it's better to be correct in the emulator than rely on a
failure allowing for guest-internal DoS.

-- 
error compiling committee.c: too many arguments to function

