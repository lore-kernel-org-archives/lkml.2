Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab0FCHKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:10:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:50221 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751871Ab0FCHKK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:10:10 -0400
MIME-Version: 1.0
In-Reply-To: <20100603054018.GE11311@gvim.org>
References: <AANLkTikxws5kmFhnBO1MLzE65ETka3Jy0R5ayAKTS1Lc@mail.gmail.com>
	<201005312338.55109.rjw@sisk.pl>
	<20100531232617.GF31155@gvim.org>
	<20100601090737.4bc243d9@schatten.dmk.lab>
	<20100601140519.GC1281@gvim.org>
	<AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
	<20100602133910.GA9106@gvim.org>
	<AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
	<20100603031842.GB11311@gvim.org>
	<AANLkTiks7sQBbDnN6QrtGVqSXLob1qCs7VA12LZAWnfM@mail.gmail.com>
	<20100603054018.GE11311@gvim.org>
Date: Thu, 3 Jun 2010 00:10:03 -0700
Message-ID: <AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: markgross@thegnar.org
Cc: Brian Swetland <swetland@google.com>,
       Florian Mickler <florian@mickler.org>, 640e9920@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 2, 2010 at 10:40 PM, mark gross <640e9920@gmail.com> wrote:
> On Wed, Jun 02, 2010 at 09:54:15PM -0700, Brian Swetland wrote:
>> On Wed, Jun 2, 2010 at 8:18 PM, mark gross <640e9920@gmail.com> wrote:
>> > On Wed, Jun 02, 2010 at 02:58:30PM -0700, Arve Hjønnevåg wrote:
>> >>
>> >> The list is not short. You have all the inactive and active
>> >> constraints on the same list. If you change it to a two level list
>> >> though, the list of unique values (which is the list you have to walk)
>> >> may be short enough for a tree to be overkill.
>> >
>> > what have you seen in practice from the wake-lock stats?
>> >
>> > I'm having a hard time seeing where you could get more than just a
>> > handfull.  However; one could go to a dual list (like the scheduler) and
>> > move inactive nodes from an active to inactive list, or we could simply
>> > remove them from the list uppon inactivity.  which would would well
>> > after I change the api to have the client allocate the memory for the
>> > nodes...  BUT, if your moving things in and out of a list a lot, I'm not
>> > sure the break even point where changing the structure helps.
>> >
>> > We'll need to try it.
>> >
>> > I think we will almost never see more than 10 list elements.
>> >
>> > --mgross
>> >
>> >
>>
>> I see about 80 (based on the batteryinfo dump) on my Nexus One
>> (QSD8250, Android Froyo):
>
> shucks.
>
> well I think for a pm_qos class that has boolean dynamic range we can
> get away with not walking the list on every request update.  we can use
> a counter, and the list will be for mostly for stats.
>

Did you give any thought to my suggestion to only use one entry per
unique value on the first level list and then use secondary lists of
identical values. That way if you only have two constraints values the
list you have to walk when updating a request will never have more
than two entries regardless of how many total request you have.

A request update then becomes something like this:
  if on primary list {
    unlink from primary list
    if secondary list is not empty
      get next secondary entry and add in same spot on primary list
  }
  unlink from secondary list
  find new spot on primary list
  if already there
    add to secondary list
  else
    add to primary list

-- 
Arve Hjønnevåg
