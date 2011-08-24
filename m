Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab1HXT2B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 15:28:01 -0400
Received: from smtp106.prem.mail.ac4.yahoo.com ([76.13.13.45]:27225 "HELO
	smtp106.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751194Ab1HXT17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 15:27:59 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 1VaIqU0VM1kbSC6kGp6jIKOmcopD91D9YwqP3e3WtMskwhR
 3wff6XjLm3OIfO9MLt35Cw.YHnTIpfMvwdITASAd2AHrFK2EJdrKaAYWmDsh
 dMZmrodmEDaYBL2kVQ6teYts892pUPAKH2OsgYi1ZC0qr14vvQWgA8hUZDp1
 x88c6dvIddNbRDIi5bzHb5SZVS9Y08QvezjHt89.wylzDC1o0hiYyGKVunU5
 mRPTocvaAZ3aCEbsDssoEgmKxZXRMa_FXYSz_4i6p.jVA9w9J3ynlYdzLEco
 Bp37bYTFvA6e9XwjLqygHN7iWTn6a4iMJZ38Q1KbfAyPGf5LV_vST9lr8X9W
 _tscuEJx1XwcIeNSjDGYZkO2g8I_vWvQ8IC3egNhD0HY1nw--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Wed, 24 Aug 2011 14:27:55 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 13/15] x86: add cmpxchg_flag() variant
In-Reply-To: <4E5527C2.8000801@goop.org>
Message-ID: <alpine.DEB.2.00.1108241408310.30776@router.home>
References: <cover.1314045780.git.jeremy.fitzhardinge@citrix.com> <738d736ecffa3bd32df76ae41188aa39c2ace941.1314054734.git.jeremy.fitzhardinge@citrix.com> <alpine.DEB.2.00.1108231355380.26421@router.home> <4E540548.4080402@goop.org> <4E541154.6090805@zytor.com>
 <4E542681.2090703@goop.org> <alpine.DEB.2.00.1108240852370.24118@router.home> <4E5527C2.8000801@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011, Jeremy Fitzhardinge wrote:

> I only looked in arch/x86, but I didn't find any that were
> straightforward candidates for cmpxchg_flag.

Look at core code: mm/slub.c

> >  And if the cmpxchg is a 16 byte
> > cmpxchg (cmpxchg_double) then the comparison is getting more expensive.
>
> We're talking about the difference between cmpxchg_flag()  - which does
> a sete based on the flags set up cmpxchg - and a variant based on "asm
> goto" which could, in principle, avoid the need for sete by allowing a
> control flow statment to directly use the asm goto's conditional jump.
> The performance of both is invariant wrt the cmpxchg argument size.

Indeed for sete the size of the argument does not matter. Look at
percpu_cmpxchg_double() and cmpxchg_double() in arch/x86/include for some
of the functions I wrote. The sete is used to avoid the double word
comparisons that would otherwise have been necessary.

But still the solution with the flags would save another instruction and
the generated code would not be as ugly. For not only do you have an
additional sete you will then also have to check the result again. This
means at least two additional instruction.


