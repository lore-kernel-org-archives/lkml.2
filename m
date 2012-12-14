Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2LNSpB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:45:01 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:38047 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756906Ab2LNSo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:44:59 -0500
MIME-Version: 1.0
In-Reply-To: <50CB716D.6020501@zytor.com>
References: <1355343572-23074-1-git-send-email-stefani@seibold.net>
 <50C9148C.4040308@zytor.com> <1355378005.24283.11.camel@wall-e>
 <1d3061cb-76d0-4e42-9b75-a975b05384ec@email.android.com> <1355379433.24701.1.camel@wall-e>
 <f984cb31-baa5-4176-8e85-37266e2cfb8d@email.android.com> <1355383038.18653.2.camel@wall-e>
 <CALCETrWmYpEh9pLiohF+yu9FnrVfSNdHB_TQOKL6+LkdTF+cVw@mail.gmail.com>
 <50CA6E4C.6000305@zytor.com> <CALCETrV1kvhOvDpzTavGb1X9HT+PdEPXJ0H8afs7jzxpcF7Kjg@mail.gmail.com>
 <50CA81A4.9040702@zytor.com> <CALCETrWCMQys5MCbd6E_7c+Bsvph5cfkrDDm5tNpyBdgVE-YeQ@mail.gmail.com>
 <50CA85BD.7070502@zytor.com> <CALCETrWKDJd1T_VCRNAzD-KTtYBbmvgE_ZYvb8uN4nBUYQvkgA@mail.gmail.com>
 <8c3585bc-fc7d-4826-913c-f4581494d91d@email.android.com> <CALCETrX5KUiQaV7dsAFa1SYyWPjUVwh43HvbPwqPStMxqE0ctQ@mail.gmail.com>
 <50CAE485.5020608@parallels.com> <50CB716D.6020501@zytor.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 14 Dec 2012 10:44:37 -0800
Message-ID: <CALCETrWazriQVbQPc8u+KFyNUaa=kJUc=jdh9w7z6rS+kWEX1w@mail.gmail.com>
Subject: Re: [CRIU] [PATCH] Add VDSO time function support for x86 32-bit kernel
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, aarcange@redhat.com,
        ak@linux.intel.com, Stefani Seibold <stefani@seibold.net>,
        x86@kernel.org, linux-kernel@vger.kernel.org, criu@openvz.org,
        mingo@redhat.com, john.stultz@linaro.org, tglx@linutronix.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 10:35 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/14/2012 12:34 AM, Pavel Emelyanov wrote:
>> On 12/14/2012 06:20 AM, Andy Lutomirski wrote:
>>> On Thu, Dec 13, 2012 at 6:18 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>>> Wouldn't the vdso get mapped already and could be mremap()'d.  If we
>>> really need more control I'd almost push for a device/filesystem node
>>> that could be mmapped the usual way.
>>>
>>> Hmm.  That may work, but it'll still break ABI.  I'm not sure that
>>> criu is stable enough yet that we should care.  Criu people?
>>
>> It's not yet, but we'd still appreciate the criu-friendly vdso redesign.
>>
>>> (In brief summary: how annoying would it be if the vdso was no longer
>>> just a bunch of constant bytes that lived somewhere?)
>>
>> It depends on what vdso is going to be. In the perfect case it should
>> a) be mremap-able to any address (or be at fixed address _forever_, but
>>    I assume this is not feasible);
>> b) have entry points at fixed (or somehow movable) places.
>>
>> I admit that I didn't understand your question properly, if I did,
>> please correct me.
>>
>
> mremap() should work.  At the same time, the code itself is not going to
> have any stability guarantees between kernel versions -- it obviously
> cannot.

We could guarantee that the symbols in the vdso resolve to particular
offsets within the vdso.  (Yes, this is ugly.)

Does criu support checkpointing with one version of a shared library
and restoring with another?  If there are no textrels (or whatever the
relocation type that actually modifies text as opposed to just the plt
or got) then, in principle, it should be doable.  Otherwise some
kernel help will be needed to checkpoint reliably on one kernel and
restore somewhere else.

(This isn't a regression -- it's already broken.)

>
> Incidentally, the MAYWRITE bit which is there to allow breakpoints is
> obviously problematic for the vvar page.  We could mark the vvar page
> differently, meaning more vmas, or we could decide it just doesn't
> matter and that if you mprotect() the vvar page and write to it you get
> exactly what you asked for...

I have no strong preference here.

--Andy
