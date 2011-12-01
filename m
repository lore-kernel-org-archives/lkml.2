Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1LAQAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:00:49 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59857 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab1LAQAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:00:47 -0500
Date: Thu, 1 Dec 2011 10:45:30 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Michal Hocko <mhocko@suse.cz>, Stanislaw Gruszka <sgruszka@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111201154530.GA24074@tuxdriver.com>
References: <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
 <20111130140316.GA4153@tiehlicka.suse.cz>
 <20111130153929.GA2144@redhat.com>
 <20111201085845.GA4602@tiehlicka.suse.cz>
 <20111201105538.GA4504@tiehlicka.suse.cz>
 <20111201115911.GA5706@redhat.com>
 <20111201124440.GB25614@tiehlicka.suse.cz>
 <20111201140500.GA4269@tiehlicka.suse.cz>
 <CAB3XZEd1D7mR3Q_vweNHYUbZxmywbMi3FomQbdSy=1DB8Y0KzA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAB3XZEd1D7mR3Q_vweNHYUbZxmywbMi3FomQbdSy=1DB8Y0KzA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 04:23:19PM +0200, Eliad Peller wrote:
> On Thu, Dec 1, 2011 at 4:05 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > On Thu 01-12-11 13:44:40, Michal Hocko wrote:
> >> On Thu 01-12-11 12:59:12, Stanislaw Gruszka wrote:
> >> > On Thu, Dec 01, 2011 at 11:55:38AM +0100, Michal Hocko wrote:
> >> > > [  349.316070] iwl3945_rs_free_sta rs_sta f4be1ac0
> >> > > [  349.316076] ------------[ cut here ]------------
> >> > > [  349.316097] WARNING: at drivers/net/wireless/iwlegacy/iwl-3945-rs.c:438 iwl3945_rs_free_sta+0x33/0x42 [iwl3945]()
> >> >
> >> > Johannes pointed on irc that this problem is most likely caused by:
> >> >
> >> > commit f785d83a19bca326f79d127a413e35769afc0105
> >> > Author: Eliad Peller <eliad@wizery.com>
> >> > Date:   Mon Aug 8 16:50:22 2011 +0300
> >> >
> >> >     mac80211: clear sta.drv_priv on reconfiguration
> >> >
> >> > Michal, could you confirm that? If that is the root of the problem, we
> >> > need patch for iwlegacy (and iwlwifi) that allocate separate memory for
> >> > rc structures.
> >>
> >> Should I just revert it?
> >
> > Reverted and guess what ;)
> > Yeah, it works. So feel free to add
> > Reported-adn-Tested-by: Michal Hocko <mhocko@suse.cz>
> > to the revert.
> >
> cool. after giving it a second look, i agree with Stanislaw - let's
> continue with the revert.

I'm reverting it now.

> > Anyway, I have really no idea about the 80211 stack but the patch
> > doesn't seem to be correct from the layering POV. Why should generic
> > layer clear something that is driver private data (or at least the
> > naming suggests that it is driver specific data)?
> 
> the driver should "know" the station (and its private data) only
> between the .sta_add() and .sta_remove() callbacks.
> on suspend, we do call sta_remove(), so it's valid to clear the private data.
> 
> the problem is that the rate control also uses the same private data,
> and is valid also after sta_remove() was called. i think the right
> solution is to split the generic private data and the rate control
> private data.

Sounds like a reasonable plan to me -- thanks for volunteering! :-)

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
