Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1HER1f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:27:35 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.33]:51325 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753578Ab1HER1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:27:33 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=I7fHHdvOj7QA:10 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=5_B_u4oos_kyVgIsh7oA:9 a=Wby51MQ9Vuke3Ho7rgUA:7 a=CjuIK1q_8ugA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'frank zago'" <fzago@systemfabricworks.com>,
        <linux-kernel@vger.kernel.org>
References: <OF4AE0115F.3AA5397E-ONC12578DF.002EC6DF-C12578DF.003348E5@transmode.se> <01dc01cc5159$317879a0$94696ce0$@systemfabricworks.com> <OF83CC7C9C.07EC5D4A-ONC12578E2.0024F5AE-C12578E2.004163C1@transmode.se> <019501cc52d7$c8688100$59398300$@systemfabricworks.com> <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@transmode.se>
In-Reply-To: <OF14136E0E.3F2388EF-ONC12578E3.00301969-C12578E3.00338524@transmode.se>
Subject: RE: [PATCH] add slice by 8 algorithm to crc32.c
Date: Fri, 5 Aug 2011 12:27:26 -0500
Message-ID: <026801cc5394$f54f6c70$dfee4550$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
thread-index: AQDVh4pDc04B6RwbKPhJsZYe9rqqGgID1lG1AfPbjtABsy4QAgGPPXDLlsJE56A=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> > >
> > > >
> > > > Modify all 'i' loops from for (i = 0; i < foo; i++) { ... } to for
(i =
> > foo
> > > > - 1; i >= 0; i--) { ... }
> > >
> > > That should be (i = foo; i ; --i) { ... }
> >
> > Shouldn't make much difference, branch on zero bit or branch on sign
bit.
> > But at the end of the day didn't help on Nehalem.

I figured out why "for (i = 0; i < len; i++) {...}" is faster than "for (;
len; len--) {...}" on my system.
The current code is

for (; Ien; len--) {
	load *++p
	...
}

Which turns into (in fake assembly)

top:
	dec len
	inc p
	load p
	...
	test len
	branch neq top

But when I replace that with 

for(i = 0; i < len; i++) {
	load *++p
	...
}

Gcc turns it into

top:
	load p[i]
	i++
	...
	compare i, len
	branch lt top

which is fewer instructions and i++ is well scheduled. Incrementing the
pointer has been moved out of the loop.

