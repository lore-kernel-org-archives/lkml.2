Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751826Ab1BTGQQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 01:16:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51282 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217Ab1BTGQO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 01:16:14 -0500
MIME-Version: 1.0
In-Reply-To: <m1oc67zcov.fsf@fess.ebiederm.org>
References: <20110216185234.GA11636@tiehlicka.suse.cz> <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com>
 <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
 <20110217090910.GA3781@tiehlicka.suse.cz> <AANLkTikPKpNHxDQAYBd3fiQsmVozLtCVDsNn=+eF_q2r@mail.gmail.com>
 <20110217163531.GF14168@elte.hu> <m1pqqqfpzh.fsf@fess.ebiederm.org>
 <AANLkTinB=EgDGNv-v-qD-MvHVAmstfP_CyyLNhhotkZx@mail.gmail.com>
 <20110218122938.GB26779@tiehlicka.suse.cz> <20110218162623.GD4862@tiehlicka.suse.cz>
 <AANLkTimO=M5xG_mnDBSxPKwSOTrp3JhHVBa8=wHsiVHY@mail.gmail.com>
 <m1oc68ilw7.fsf@fess.ebiederm.org> <AANLkTincrnq1kMcAYEWYLf5vdbQ4DYbYObbg=0cLfHnm@mail.gmail.com>
 <m1oc67zcov.fsf@fess.ebiederm.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 19 Feb 2011 22:15:23 -0800
Message-ID: <AANLkTik8kjt1TZ5vOoAm_y0f7toGtOSpxOsgCXO-bey9@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Michal Hocko <mhocko@suse.cz>, Ingo Molnar <mingo@elte.hu>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 19, 2011 at 6:01 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> So I think the change below to fix dev_deactivate which Eric D. missed
> will fix this problem.  Now to go test that.

You know what? I think the whole thing is crap. I did a simple grep
for 'unregister_netdevice_many()', and they are all buggy.

Look in net/ipv4/ip_gre.c, net/ipv4/ipip.c,net/ipv4/ipmr.c,
net/ipv6/sit.c, look in net/ipv6/ip6mr.c, just just about anywhere.
Those people *all* do basically a list-head on the stack, and then
they do unregister_netdevice_many() on those things, and they clearly
expect the list to be gone.

I suspect that the right thing to do really is to change the semantics
of those functions that take that kill-list *entirely*. Namely that
they will literall ykill the list too, not just the entries on the
list.

So unregister_netdevice_many() should always return with the list
empty and destroyed. There is no valid use of a list of netdevices
after you've unregistered them.

Now, dev_deactivate_many() actually has uses of that list after
they've been de-activated (__dev_close_many will deactivate them, and
then after that do the whole ndo_stop dance too, so I guess all (two)
callers of that function need to get rid of their list manually. So I
think your patch to sch_generic.c is good, but I really think the
semantics of unregister_netdevice_many() should just be changed.

And I think the networking people need to do some serious code review
of this whole thing. The whole "let's build a list on the stack, then
leave it around, and later use it randomly when the stack head pointer
is long gone" thing is just incredible crapola. We shouldn't be
finding these things one-by-one as a list debugging thing fires.
People need tolook at their code and fix it before the bugs start
triggering.

                           Linus
