Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab0FCBQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 21:16:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:59537 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757816Ab0FCBQG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 21:16:06 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=mVG5leUeMBjlkN4PhUWm0GV6hRnGtjDxEPSRpGqQfIcxAsh80BdngzyUORjsdqbZy
	NShJ7QQ+Ysf9Z14lTOyOQ==
MIME-Version: 1.0
In-Reply-To: <1275513074.2913.258.camel@sbs-t61.sc.intel.com>
References: <20100210232343.GA11465@linux-os.sc.intel.com>
	<tip-17d9ddc72fb8bba0d4f67868c9c612e472a594a9@git.kernel.org>
	<1275136178.27810.13539.camel@twins>
	<1275139902.27810.13737.camel@twins>
	<AANLkTimZkyRwP5k290rUr-DUMhsynl9fzBkS68x-57KM@mail.gmail.com>
	<1275412748.27810.27883.camel@twins>
	<AANLkTilGfY1PnNgpEeB3AQEqTNoDJQfPTxK5LNUYb7ZA@mail.gmail.com>
	<1275414172.27810.27961.camel@twins>
	<AANLkTil8ly_3P2DgEI9oI_ZbYP6FkwP2lCY2v47iAn9-@mail.gmail.com>
	<1275417720.27810.28160.camel@twins>
	<1275513074.2913.258.camel@sbs-t61.sc.intel.com>
Date: Wed, 2 Jun 2010 18:15:59 -0700
Message-ID: <AANLkTim9MqwWx4v51joJ1m_wjfn_bggEFPsjxsR6TBgY@mail.gmail.com>
Subject: Re: [PATCH] rbtree: undo augmented damage -v2
From: Venkatesh Pallipadi <venki@google.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
       Fabio Checconi <fabio@gandalf.sssup.it>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 2:11 PM, Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> On Tue, 2010-06-01 at 11:42 -0700, Peter Zijlstra wrote:
>> On Tue, 2010-06-01 at 11:09 -0700, Venkatesh Pallipadi wrote:
>> > On Tue, Jun 1, 2010 at 10:42 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > > On Tue, 2010-06-01 at 10:34 -0700, Venkatesh Pallipadi wrote:
>> > >>
>> > >> Yes. This will cover all the cases on insert. But on erase, there is
>> > >> still a case where a rotate of sibling node is done during the
>> > >> re-coloration process. There we have a child change on sibling's
>> > >> child. I am not able to think of any easy way to handle that case.
>> > >
>> > > Let me go draw some figures with pen and paper to match up the erase
>> > > path with the rb_augment_erase_begin() code, because I can't quite spot
>> > > the case we're missing.
>> > >
>> > > If you have it handy, ascii art might help..
>> >
>> > It is this case
>> >
>> >     P
>> >    / \
>> >   N   S
>> >      / \
>> >     SL SR
>> >
>> > changing to
>> >
>> >     P
>> >    / \
>> >   N  SL
>> >       \
>> >        S
>> >         \
>> >         SR
>>
>> Right, but see: http://en.wikipedia.org/wiki/Red-black_tree
>> That is delete_case5, however then we fall into delete_case6 and perform
>> a left rotation.
>>
>> So suppose we start with the tree:
>>
>>     P                  P               P                SL
>>   /   \               / \             / \               / \
>>  D     S      -->    N  S      -->   N   SL     -->    P   S
>>   \   / \              / \                \           /     \
>>    N SL  SR          SL* SR                S*        N      SR
>>                                             \
>>                                              SR
>>
>> and then remove D, delete case 5 and finally delete case 6, * marks red.
>>
>> rb_augment_erase_begin(D) will return N, and then rb_augment_path(N)
>> will re-augment: N, P, SL and S.
>
>
>      P                       SL
>    /  \                     /  \
>   N    S       --->        N    S
>  /   /  \                 /      \
>  C   SL  SR               C        SR
>
> If P needs to be removed, we need to re-augment S also in this case,
> right? It looks like we are not handling this case.
>

rb_augment_erase_begin() should take care of that. In this case, it
will return S as the deepest node and we start the walk-back-to-root
from there.

Thanks,
Venki
