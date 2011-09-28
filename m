Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754332Ab1I1RR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 13:17:57 -0400
Received: from claw.goop.org ([74.207.240.146]:38458 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1I1RR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 13:17:56 -0400
Message-ID: <4E834FBA.1080709@goop.org>
Date: Wed, 28 Sep 2011 09:47:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jan Beulich <JBeulich@suse.com>,
        Stephan Diestelhorst <stephan.diestelhorst@amd.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        the arch/x86 maintainers <x86@kernel.org>,
        xen-devel@lists.xensource.com, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, KVM <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 00/10] [PATCH RFC V2] Paravirtualized ticketlocks
References: <cover.1315878463.git.jeremy.fitzhardinge@citrix.com> <3300108.XQUp9Wrktc@chlor> <4E81FD52.50106@goop.org> <CA+55aFx7dv4C4ZB_3CFjdJmX_wpoxecpqo1ARYr1=zTVP=CVVA@mail.gmail.com> <4E835F8C0200007800058461@nat28.tlf.novell.com> <CA+55aFyVoZpZZp7ejypTv21Cx_qJWkZQdpJOnxBa_jUxsCjhuw@mail.gmail.com>
In-Reply-To: <CA+55aFyVoZpZZp7ejypTv21Cx_qJWkZQdpJOnxBa_jUxsCjhuw@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2011 09:10 AM, Linus Torvalds wrote:
> On Wed, Sep 28, 2011 at 8:55 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>> just use "lock xaddw" there too.
>> I'm afraid that's not possible, as that might carry from the low 8 bits
>> into the upper 8 ones, which must be avoided.
> Oh damn, you're right. So I guess the "right" way to do things is with
> cmpxchg, but some nasty mfence setup could do it too.

Could do something like:

	if (ticket->head >= 254)
		prev = xadd(&ticket->head_tail, 0xff02);
	else
		prev = xadd(&ticket->head_tail, 0x0002);

to compensate for the overflow.

    J
