Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208Ab0FCNYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:24:38 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:35755 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab0FCNYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:24:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=ZNS3uFsmgiyPrlpJFEFLcxrqKqtCCop0XzG+4JnK7Bbc4mhseJJ/5gjzLv+dbLpWc0
         QLssZTXRPeqm4/q+N3tkc9FJhp2YAN1vPwVIw5kb8drkJZIa8r6yx+Z0YoGUt9zBq1qR
         2LbO/UN8etXRw/KLLM0gUnjTJJJyq3FH5pWus=
Date: Thu, 3 Jun 2010 06:24:49 -0700
From: mark gross <640e9920@gmail.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: markgross@thegnar.org, Brian Swetland <swetland@google.com>,
       Florian Mickler <florian@mickler.org>, 640e9920@gmail.com,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
Message-ID: <20100603132449.GA15595@gvim.org>
Reply-To: markgross@thegnar.org
References: <20100531232617.GF31155@gvim.org>
 <20100601090737.4bc243d9@schatten.dmk.lab>
 <20100601140519.GC1281@gvim.org>
 <AANLkTikF-B23_UWG1O3tlBl4m8NStAJllGhhevNhYZT6@mail.gmail.com>
 <20100602133910.GA9106@gvim.org>
 <AANLkTilSU79cnBODXFokzIPB1hRcZBxbwTgTQ59MeKcK@mail.gmail.com>
 <20100603031842.GB11311@gvim.org>
 <AANLkTiks7sQBbDnN6QrtGVqSXLob1qCs7VA12LZAWnfM@mail.gmail.com>
 <20100603054018.GE11311@gvim.org>
 <AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikvuqtcGS1UdePRxipSk4S5Vmci2uPfFtzZgx6X@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 12:10:03AM -0700, Arve Hjønnevåg wrote:
> On Wed, Jun 2, 2010 at 10:40 PM, mark gross <640e9920@gmail.com> wrote:
> > On Wed, Jun 02, 2010 at 09:54:15PM -0700, Brian Swetland wrote:
> >> On Wed, Jun 2, 2010 at 8:18 PM, mark gross <640e9920@gmail.com> wrote:
> >> > On Wed, Jun 02, 2010 at 02:58:30PM -0700, Arve Hjønnevåg wrote:
> >> >>
> >> >> The list is not short. You have all the inactive and active
> >> >> constraints on the same list. If you change it to a two level list
> >> >> though, the list of unique values (which is the list you have to walk)
> >> >> may be short enough for a tree to be overkill.
> >> >
> >> > what have you seen in practice from the wake-lock stats?
> >> >
> >> > I'm having a hard time seeing where you could get more than just a
> >> > handfull.  However; one could go to a dual list (like the scheduler) and
> >> > move inactive nodes from an active to inactive list, or we could simply
> >> > remove them from the list uppon inactivity.  which would would well
> >> > after I change the api to have the client allocate the memory for the
> >> > nodes...  BUT, if your moving things in and out of a list a lot, I'm not
> >> > sure the break even point where changing the structure helps.
> >> >
> >> > We'll need to try it.
> >> >
> >> > I think we will almost never see more than 10 list elements.
> >> >
> >> > --mgross
> >> >
> >> >
> >>
> >> I see about 80 (based on the batteryinfo dump) on my Nexus One
> >> (QSD8250, Android Froyo):
> >
> > shucks.
> >
> > well I think for a pm_qos class that has boolean dynamic range we can
> > get away with not walking the list on every request update.  we can use
> > a counter, and the list will be for mostly for stats.
> >
> 
> Did you give any thought to my suggestion to only use one entry per
> unique value on the first level list and then use secondary lists of
> identical values. That way if you only have two constraints values the

I thought you where talking about a active + inactive queue.  Sorry, I
didn't get what you where talking about.

> list you have to walk when updating a request will never have more
> than two entries regardless of how many total request you have.
> 
> A request update then becomes something like this:
>   if on primary list {
>     unlink from primary list
>     if secondary list is not empty
>       get next secondary entry and add in same spot on primary list
>   }
>   unlink from secondary list
>   find new spot on primary list
>   if already there
>     add to secondary list
>   else
>     add to primary list
>

I'm still no getting how this will allow me to reduce any aggregated
constratint re-computation to a list walk of at most 2 nodes.  But, from
a more specific point of view are you saying:
change the request struct to be something like:
struct dual_list_constriaint {
	struct list primary;
	struct list secondar;
	s32 value;
	...
} 

then uppon constraint foo update:

if foo->primary not empty:
	remove foor from primary list
	if gsecondary is not empty:
		ordered insert of foo into secondary list 
		? ordered on constraint value?
		? Arn't the constraints boolean?
remove foo from secondary list
ordered search for insert point of foo into primary list
if foo in primary:
	insert foo into secondary list
else
	insert foo into primary list

ok I'm not getting it.
is this a fancy com-sci algorithm I should know about?

--mgross
