Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab0FCPRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:17:42 -0400
Received: from ist.d-labs.de ([213.239.218.44]:57856 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756225Ab0FCPRk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:17:40 -0400
Date: Thu, 3 Jun 2010 17:17:27 +0200
From: Florian Mickler <florian@mickler.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Arve =?ISO-8859-15?Q?Hj=F8nnev=E5g?= <arve@android.com>,
       markgross@thegnar.org, 640e9920@gmail.com,
       Peter Zijlstra <peterz@infradead.org>,
       Brian Swetland <swetland@google.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603171727.7d835a1d@schatten.dmk.lab>
In-Reply-To: <1275575794.5914.74.camel@mulgrave.site>
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
	<AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
	<1275575794.5914.74.camel@mulgrave.site>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jun 2010 09:36:34 -0500
James Bottomley <James.Bottomley@suse.de> wrote:

> On Thu, 2010-06-03 at 00:10 -0700, Arve Hjønnevåg wrote:
> > On Wed, Jun 2, 2010 at 10:40 PM, mark gross <640e9920@gmail.com> wrote:
> > > On Wed, Jun 02, 2010 at 09:54:15PM -0700, Brian Swetland wrote:
> > >> On Wed, Jun 2, 2010 at 8:18 PM, mark gross <640e9920@gmail.com> wrote:
> > >> > On Wed, Jun 02, 2010 at 02:58:30PM -0700, Arve Hjønnevåg wrote:
> > >> >>
> > >> >> The list is not short. You have all the inactive and active
> > >> >> constraints on the same list. If you change it to a two level list
> > >> >> though, the list of unique values (which is the list you have to walk)
> > >> >> may be short enough for a tree to be overkill.
> > >> >
> > >> > what have you seen in practice from the wake-lock stats?
> > >> >
> > >> > I'm having a hard time seeing where you could get more than just a
> > >> > handfull.  However; one could go to a dual list (like the scheduler) and
> > >> > move inactive nodes from an active to inactive list, or we could simply
> > >> > remove them from the list uppon inactivity.  which would would well
> > >> > after I change the api to have the client allocate the memory for the
> > >> > nodes...  BUT, if your moving things in and out of a list a lot, I'm not
> > >> > sure the break even point where changing the structure helps.
> > >> >
> > >> > We'll need to try it.
> > >> >
> > >> > I think we will almost never see more than 10 list elements.
> > >> >
> > >> > --mgross
> > >> >
> > >> >
> > >>
> > >> I see about 80 (based on the batteryinfo dump) on my Nexus One
> > >> (QSD8250, Android Froyo):
> > >
> > > shucks.
> > >
> > > well I think for a pm_qos class that has boolean dynamic range we can
> > > get away with not walking the list on every request update.  we can use
> > > a counter, and the list will be for mostly for stats.
> > >
> > 
> > Did you give any thought to my suggestion to only use one entry per
> > unique value on the first level list and then use secondary lists of
> > identical values. That way if you only have two constraints values the
> > list you have to walk when updating a request will never have more
> > than two entries regardless of how many total request you have.
> > 
> > A request update then becomes something like this:
> >   if on primary list {
> >     unlink from primary list
> >     if secondary list is not empty
> >       get next secondary entry and add in same spot on primary list
> >   }
> >   unlink from secondary list
> >   find new spot on primary list
> >   if already there
> >     add to secondary list
> >   else
> >     add to primary list
> 
> This is just reinventing hash bucketed lists.  To get the benefits, all
> we do is implement an N state constraint as backed by an N bucketed hash
> list, which the kernel already has all the internal mechanics for.
> 
> James
>

http://www.itl.nist.gov/div897/sqg/dads/HTML/priorityque.html

So no reinvention. Just using a common scheme. 

Cheers,
Flo
