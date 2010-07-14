Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757755Ab0GNU6N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:58:13 -0400
Received: from claw.goop.org ([74.207.240.146]:56811 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757132Ab0GNU6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:58:11 -0400
Message-ID: <4C3E24E1.7030107@goop.org>
Date: Wed, 14 Jul 2010 13:58:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Lightning/1.0b2pre Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Palfrader <peter@palfrader.org>, Avi Kivity <avi@redhat.com>,
        Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        stable@kernel.org, stable-review@kernel.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Glauber Costa <glommer@redhat.com>,
        Zachary Amsden <zamsden@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [patch 134/149] x86, paravirt: Add a global synchronization point
 	for pvclock
References: <20100707124731.GJ15122@anguilla.noreply.org>	<4C359D5A.1050906@redhat.com>	<20100713102350.GW15122@anguilla.noreply.org>	<4C3C68C8.4060409@redhat.com>	<20100713141902.GB15122@anguilla.noreply.org>	<4C3C8CE5.1080705@redhat.com>	<20100713162207.GC15122@anguilla.noreply.org>	<4C3C9589.4090602@redhat.com>	<4C3C96EC.8060901@redhat.com>	<4C3C9839.4090404@redhat.com>	<20100713172526.GE15122@anguilla.noreply.org>	<AANLkTini61PZO1_icO2jRcBmMvWm24splgjZA1lUgab2@mail.gmail.com>	<AANLkTikDo0UsJxGekCdFgDMEHOONLiRe7ZOSf_j0ZKjf@mail.gmail.com>	<4C3CAE8F.10900@goop.org>	<4C3CE560.5050701@zytor.com>	<4C3CFB8B.1090804@goop.org> <AANLkTilmqWhHFO5zpfe5g53adUd18nIDli2tJt54k3rg@mail.gmail.com> <4C3DF1BE.2070404@goop.org> <4C3DF447.1000801@zytor.com> <4C3DF519.6030406@goop.org> <4C3DF7AF.7010402@zytor.com> <4C3DFA88.5020007@goop.org> <4C3DFD12.3050700@zytor.com> <4C3DFED2.5000807@goop.org> <4C3DFFB8.4070009@zytor.com>
In-Reply-To: <4C3DFFB8.4070009@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2010 11:19 AM, H. Peter Anvin wrote:
> On 07/14/2010 11:15 AM, Jeremy Fitzhardinge wrote:
>   
>> I think we should consider that deprecated and rely on dependencies and
>> clobbers.
>>
>>     
> I don't think that's practical in general.  If the compiler is *that
> broken*, I don't see how it is usable at all.
>   

Well, over the years, gcc has explicitly changed the docs to weaken the
meaning of "asm volatile" from "not being moved ``significantly''" to
"no real guarantees about movement at all".

I don't see why its so broken.  There are lots of mechanisms to control
asm ordering; we don't need "asm volatile" as well.  But we do need it
to mean "still emit an apparently dead asm with no outputs (or unused
outputs)".

They can still be omitted if the whole basic block is dead code, and
they can be duplicated by things like inlining and loop unrolling.  But
presumably they can never be evaluated more times than the source code
says they should be, so to that extent they're like volatile variables.

I think the use of the "volatile" keyword here is a red herring.  Just
because the gcc devs decided to use it as a qualifier for asm statements
doesn't mean that one should read anything other than a vague, vague
relationship to volatile variables (and extra-vague given how weakly
defined *they* are).

> As Linus indicated, I don't think we can assume the gcc documentation to
> accurately reflect the intent of the gcc team, mostly because I think it
> often lags way behind what they're thinking.
>   

I can get not trusting gcc to do what the documentation says it should
do, but relying on it to do things that the documentation definitely
says it doesn't seems foolhardy.

I'm finding it a bit surreal to be arguing on the side of "don't trust
gcc" vs you and Linus on the "gcc developers are arbitrary, capricious
and untrustworthy, but we can rely on this piece of undocumented
behaviour" side.

    J
