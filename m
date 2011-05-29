Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755797Ab1E2Sop (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 14:44:45 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54614 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab1E2Son (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 14:44:43 -0400
Date: Sun, 29 May 2011 20:44:09 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tony Luck <tony.luck@gmail.com>,
        linux-kernel@vger.kernel.org, davej@redhat.com,
        kees.cook@canonical.com, davem@davemloft.net, eranian@google.com,
        adobriyan@gmail.com, penberg@kernel.org,
        Arjan van de Ven <arjan@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Valdis.Kletnieks@vt.edu,
        pageexec@freemail.hu
Subject: Re: [RFC][PATCH] Randomize kernel base address on boot
Message-ID: <20110529184409.GA9835@elte.hu>
References: <1306516230.3339.17.camel@dan>
 <20110527171611.GE4356@elte.hu>
 <BANLkTim7+gPdvQS99oJ7xteYOAQaSSr8Sw@mail.gmail.com>
 <20110527174644.GG4356@elte.hu>
 <4DDFE52D.4070308@zytor.com>
 <BANLkTimVQbHvW8tCACAcC8zRkyY1KyU2ww@mail.gmail.com>
 <20110528121820.GB12059@elte.hu>
 <4DE19DC3.7090106@zytor.com>
 <20110529124702.GE26627@elte.hu>
 <4DE28E1E.60207@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE28E1E.60207@zytor.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 05/29/2011 05:47 AM, Ingo Molnar wrote:
> > 
> > Do you mean we'd not start at a 2MB boundary and thus would waste on 
> > average an about 0.125 worth of huge-TLB cache entry?
> > 
> > That does not look like a very big issue to me - but maybe i'm 
> > missing something and you mean something else.
> > 
> 
> The problem is that because of the misalignment, and whatever falls 
> on the other side of that memory boundary we might end up having to 
> fracture the 2 MB page into 4K pages.

We already have that kind of fragmentation anyway, due to NX and due 
to the readonly area. Randomization does not really make that 
situation much worse.

But the thing is, we could fully eliminate all those disadvantages on 
64-bit x86:

We could put a 2MB hole between end of text (end of X) and start of 
readonly data (start of NX), and another 2MB hole between end of 
readonly and start of data.

That way we'd have:

 - the low alias is mapped NX as well, so the whole area and 
   surrounding pages are 2MB aligned. The 'holes' are freed up as 
   __initmem so not wasted.

 - the high alias will have three areas:

    - the    text area, which is 2MB mapped as X
    - the ro-data area, which is 2MB mapped as NX-RO
    - the    data area, which is 2MB mapped as NX-RW

because there's at least 2MB of distance between end of text and 
start of data there's a guarantee that both will be fully 2MB mapped.

Btw., we might want to do this regardless of randomization, for 
performance reasons: right now the NX and readonly area fragments the 
2MB mapping around the kernel text already, into 4K mappings.

Hm?

Thanks,

	Ingo
