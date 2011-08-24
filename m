Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751915Ab1HXWCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 18:02:51 -0400
Received: from claw.goop.org ([74.207.240.146]:53685 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924Ab1HXWCu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 18:02:50 -0400
Message-ID: <4E557507.2000302@goop.org>
Date: Wed, 24 Aug 2011 15:02:47 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 07/12] x86: use cmpxchg_flag() where applicable
References: <e1c8d3bcee83cc5ad00bdf8900a99add7abb1cb9.1314221624.git.jeremy.fitzhardinge@citrix.com> <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <3d7aea62fac48dd6e2da236d86234113fcd78178.1314221624.git.jeremy.fitzhardinge@citrix.com> <CA+55aFwEH16JAynxQzNTff0ikGnON9jq1mJOx1doDASV2a2fpg@mail.gmail.com>
In-Reply-To: <CA+55aFwEH16JAynxQzNTff0ikGnON9jq1mJOx1doDASV2a2fpg@mail.gmail.com>
X-Enigmail-Version: 1.3.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/24/2011 02:56 PM, Linus Torvalds wrote:
> Ok, I see nothing horrible in this series.
>
> The one reaction I have is that the cmpxchg_flag() thing returns an
> 8-bit value, but then a lot of the users end up having to extend it to
> a full "int" purely for calling convention reasons (eg I think
> 'down_write_trylock()' will have 'sete + movzl' - not a new problem,
> but since the whole point was to remove extraneous instructions and we
> no longer have the silly 'testl', it now annoys me more).
>
> So it seems a bit sad. But I guess it doesn't really matter.

It's still annoying because in practice sete sets a result, but most
users are just going to have to testb it to do a conditional anyway -
it's a pity there's no way to tell gcc that an asm has already set the
flags, and it can generate a jcc/setcc based on that.

I experimented with a variant based on "asm goto", so that the
conditional control flow is done by the asm itself, and gcc should be
able to make use of that (via constant folding).  But the resulting code
wasn't very spectacular, with quite a few unnecessary jumps.

    J
