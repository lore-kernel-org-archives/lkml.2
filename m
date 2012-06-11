Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755210Ab2FKObb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 10:31:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50214 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2FKOb3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 10:31:29 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <e82083d1-af9f-4766-992c-926413f02423@default>
References: <1339325468-30614-1-git-send-email-levinsasha928@gmail.com>
	<1339325468-30614-5-git-send-email-levinsasha928@gmail.com>
	<4FD5856C.5060708@kernel.org>
	<1339410650.4999.38.camel@lappy>
	<e82083d1-af9f-4766-992c-926413f02423@default>
Date: Mon, 11 Jun 2012 10:31:28 -0400
X-Google-Sender-Auth: _xtnjzs0DYufReIVHA8fcI28cng
Message-ID: <CAPbh3ruqk+dU4C8b=mSko+2EjumrswgkO6CUp73=8thvLNAA8A@mail.gmail.com>
Subject: Re: [PATCH v3 04/10] mm: frontswap: split out __frontswap_unuse_pages
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Sasha Levin <levinsasha928@gmail.com>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 11, 2012 at 10:27 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
>> From: Sasha Levin [mailto:levinsasha928@gmail.com]
>> Subject: Re: [PATCH v3 04/10] mm: frontswap: split out __frontswap_unuse_pages
>>
>> > > + assert_spin_locked(&swap_lock);
>> >
>> > Normally, we should use this assertion when we can't find swap_lock is hold or not easily
>> > by complicated call depth or unexpected use-case like general function.
>> > But I expect this function's caller is very limited, not complicated.
>> > Just comment write down isn't enough?
>>
>> Is there a reason not to do it though? Debugging a case where this
>> function is called without a swaplock and causes corruption won't be
>> easy.
>
> I'm not sure of the correct kernel style but I like the fact
> that assert_spin_locked both documents the lock requirement and tests
> it at runtime.

The kernel style is to do "
3) Separate your changes.

Separate _logical changes_ into a single patch file.
"

So it is fine, but it should be in its own patch.
>
> I don't know the correct kernel syntax but is it possible
> to make this code be functional when the kernel "debug"
> option is on, but a no-op when "debug" is disabled?
> IMHO, that would be the ideal solution.
>
>> > > + for (type = swap_list.head; type >= 0; type = si->next) {
>> > > +         si = swap_info[type];
>> > > +         si_frontswap_pages = atomic_read(&si->frontswap_pages);
>> > > +         if (total_pages_to_unuse < si_frontswap_pages) {
>> > > +                 pages = pages_to_unuse = total_pages_to_unuse;
>> > > +         } else {
>> > > +                 pages = si_frontswap_pages;
>> > > +                 pages_to_unuse = 0; /* unuse all */
>> > > +         }
>> > > +         /* ensure there is enough RAM to fetch pages from frontswap */
>> > > +         if (security_vm_enough_memory_mm(current->mm, pages)) {
>> > > +                 ret = -ENOMEM;
>> >
>> >
>> > Nipick:
>> > I am not sure detailed error returning would be good.
>> > Caller doesn't matter it now but it can consider it in future.
>> > Hmm,
>>
>> Is there a reason to avoid returning a meaningful error when it's pretty
>> easy?
>
> I'm certainly not an expert on kernel style (as this whole series
> of patches demonstrates :-) but I think setting a meaningful
> error code is useful documentation and plans for future users
> that might use the error code.

Aye.
