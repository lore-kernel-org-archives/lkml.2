Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab0FDEHN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:07:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:49356 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0FDEHL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:07:11 -0400
MIME-Version: 1.0
In-Reply-To: <201006032305.58082.rjw@sisk.pl>
References: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
	<AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
	<1275575794.5914.74.camel@mulgrave.site>
	<201006032305.58082.rjw@sisk.pl>
Date: Thu, 3 Jun 2010 21:07:07 -0700
Message-ID: <AANLkTimiIyT2TxV5BhhtXwKNKUN9Pa5Bl8YtcoJpHNsw@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: James Bottomley <James.Bottomley@suse.de>, markgross@thegnar.org,
       640e9920@gmail.com, Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 2:05 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday 03 June 2010, James Bottomley wrote:
>> On Thu, 2010-06-03 at 00:10 -0700, Arve Hjønnevåg wrote:
>> > On Wed, Jun 2, 2010 at 10:40 PM, mark gross <640e9920@gmail.com> wrote:
>> > > On Wed, Jun 02, 2010 at 09:54:15PM -0700, Brian Swetland wrote:
>> > >> On Wed, Jun 2, 2010 at 8:18 PM, mark gross <640e9920@gmail.com> wrote:
>> > >> > On Wed, Jun 02, 2010 at 02:58:30PM -0700, Arve Hjønnevåg wrote:
>> > >> >>
>> > >> >> The list is not short. You have all the inactive and active
>> > >> >> constraints on the same list. If you change it to a two level list
>> > >> >> though, the list of unique values (which is the list you have to walk)
>> > >> >> may be short enough for a tree to be overkill.
>> > >> >
>> > >> > what have you seen in practice from the wake-lock stats?
>> > >> >
>> > >> > I'm having a hard time seeing where you could get more than just a
>> > >> > handfull.  However; one could go to a dual list (like the scheduler) and
>> > >> > move inactive nodes from an active to inactive list, or we could simply
>> > >> > remove them from the list uppon inactivity.  which would would well
>> > >> > after I change the api to have the client allocate the memory for the
>> > >> > nodes...  BUT, if your moving things in and out of a list a lot, I'm not
>> > >> > sure the break even point where changing the structure helps.
>> > >> >
>> > >> > We'll need to try it.
>> > >> >
>> > >> > I think we will almost never see more than 10 list elements.
>> > >> >
>> > >> > --mgross
>> > >> >
>> > >> >
>> > >>
>> > >> I see about 80 (based on the batteryinfo dump) on my Nexus One
>> > >> (QSD8250, Android Froyo):
>> > >
>> > > shucks.
>> > >
>> > > well I think for a pm_qos class that has boolean dynamic range we can
>> > > get away with not walking the list on every request update.  we can use
>> > > a counter, and the list will be for mostly for stats.
>> > >
>> >
>> > Did you give any thought to my suggestion to only use one entry per
>> > unique value on the first level list and then use secondary lists of
>> > identical values. That way if you only have two constraints values the
>> > list you have to walk when updating a request will never have more
>> > than two entries regardless of how many total request you have.
>> >
>> > A request update then becomes something like this:
>> >   if on primary list {
>> >     unlink from primary list
>> >     if secondary list is not empty
>> >       get next secondary entry and add in same spot on primary list
>> >   }
>> >   unlink from secondary list
>> >   find new spot on primary list
>> >   if already there
>> >     add to secondary list
>> >   else
>> >     add to primary list
>>
>> This is just reinventing hash bucketed lists.  To get the benefits, all
>> we do is implement an N state constraint as backed by an N bucketed hash
>> list, which the kernel already has all the internal mechanics for.
>
> Agreed.
>

No, a hash is used for quick lookup of a specific value, not to find
an extreme value. It is however extremely similar to plists. The only
difference is that plists link all the secondary lists together. If we
want to have constraints that autoexpire, then keeping the secondary
lists separate allows the same optimization as I did for
wakelock/suspend_blocker timeouts where no timer is active if an
(equal or stricter) non-expiring constraint is active.

-- 
Arve Hjønnevåg
