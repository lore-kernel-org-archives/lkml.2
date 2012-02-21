Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429Ab2BUS0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:26:52 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:60674 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754676Ab2BUS0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:26:51 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.180.14.193 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F43DB69.9060509@zytor.com>
References: <alpine.LFD.2.02.1202191412060.3898@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201145130.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201146450.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201147350.4237@i5.linux-foundation.org>
 <alpine.LFD.2.02.1202201148100.4237@i5.linux-foundation.org>
 <CA+5PVA5Zkka6Q2kcvWbvA3xr9=5TZ+VWWsWzYcRQ1GpccpJHew@mail.gmail.com>
 <CA+55aFyqz-2ejsRpbRdYx7UHDBg3q=9nvmtrj2nLeuZonrkz1A@mail.gmail.com>
 <4F42FE08.5020309@zytor.com> <CA+55aFxKLvHXRkx-x+zOkHJk__uTJc90Z0i+00W-hqDaQb_HCQ@mail.gmail.com>
 <4F43DB69.9060509@zytor.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Feb 2012 10:26:30 -0800
X-Google-Sender-Auth: eUc8S7MbZGphsdTuryGrsjM37SY
Message-ID: <CA+55aFxap0zAAJOCcz0f+DKBuG6VQa7kq1j2JD1S4ysgmb62aA@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] i387: support lazy restore of FPU state
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Jongman Heo <jongman.heo@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 9:59 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> I don't know if unlazy_fpu() being out of line will cause a context
> switch performance loss, though.

unlazy_fpu() is no longer used for context switching - it's only used
for unlazying the FPU.

Part of the whole FP mess is that there were all these *insane*
dependencies where these things were used for different semantic
issues. That's largely fixed now, and things have a single semantic
use.

> Acked-by: H. Peter Anvin <hpa@zytor.com>
>
> Let me know if you'd prefer me to pull this into the -tip tree.

Yes, but I'll send you this with a proper commit log. I'll also send
you another patch that splits "<asm/i387.h>" into two.

Right now <asm/i387.h> has two different users: the first of which
"normal kernel use" kind of things (ie kernel_fpu_begin() and friends)
that really don't care about the internals very deeply. But the second
class of user is the actual i387 internal implementation thing that is
used by i387.c and xsave.c etc to actually implement the exposed
interfaces.

As a result, <asm/i387.h> is this mixture of exposed interfaces and
"deep internal knowledge". And as a result, that deep internal
knowledge kind of accidentally gets exposed to code that really
shouldn't be exposed to it.

I have a patch that fixes that. I'll send you a series of two patches
with sign-offs and commentary asap.

                   Linus
