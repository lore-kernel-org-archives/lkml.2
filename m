Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756252Ab1K3ODZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 09:03:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756005Ab1K3ODU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 09:03:20 -0500
Date: Wed, 30 Nov 2011 15:03:16 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111130140316.GA4153@tiehlicka.suse.cz>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
 <20111130101028.GA2906@tiehlicka.suse.cz>
 <20111130142316.GA2466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130142316.GA2466@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-11-11 15:23:16, Stanislaw Gruszka wrote:
> On Wed, Nov 30, 2011 at 11:10:28AM +0100, Michal Hocko wrote:
> > On Tue 29-11-11 12:39:07, Stanislaw Gruszka wrote:
> > > On Tue, Nov 29, 2011 at 11:07:27AM +0100, Michal Hocko wrote:
> > > > [I am not sure whether this is ieee80211 or iwl3945 issue so put both
> > > > maintainers into loop]
> > > The only changed we had in iwlegacy between 3.1 and 3.2-rc, was only 
> > > adjustment to mac80211 changes. However I think this is iwlegacy issue,
> > > just for some reason bug did not trigger before.
> > 
> > I have double checked 3.1 and cannot reproduce it.
> > Anyway, I have put:
> > 
> > diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
> > index 8faeaf2..9221ed4 100644
> > --- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
> > +++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
> > @@ -432,6 +432,7 @@ static void iwl3945_rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
> >  	 * to use iwl_priv to print out debugging) since it may not be fully
> >  	 * initialized at this point.
> >  	 */
> > +	printk("XXX: deleting time: %x\n", rs_sta->rate_scale_flush.base);
> >  	del_timer_sync(&rs_sta->rate_scale_flush);
> >  }
> >  
> > And the timer base is really NULL when the issue happens. So, somebody
> > probably removed the timer already?
> 
> I think we call rs_ops->free_sta without rs_ops->alloc_sta, otherwise
> I don't know how it could be NULL in iwl3945_rs_free_sta (excluding memory
> corruption or bug in timer internals).
> 
> I suspect this could be a regression introduced by commit:
> 
> commit 07ba55d7f1d0da174c9bc545c713b44cee760197
> Author: Arik Nemtsov <arik@wizery.com>
> Date:   Wed Sep 28 14:12:53 2011 +0300
> 
>     nl80211/mac80211: allow adding TDLS peers as stations
> 
> I'm attaching patch with revert of relevant hunk, because full revert
> would be hard currently. Does it workaround problem for you?

No, didn't help unfortunately...

> 
> > > Is this problem 100% reproducible for you ? 
> > 
> > Yes, it seems to be sufficient to suspend to RAM while associated and
> > turn off the AP before waking up the machine.
> > I wasn't able to reproduce just by turning of the AP while associated
> > without suspend.
> 
> I'm not able to recreate, but I'm not using your config as my system
> user-space has problem to startup with it :-(
> 
> Stanislaw

> diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> index b1b1bb3..f773dbb 100644
> --- a/net/mac80211/mlme.c
> +++ b/net/mac80211/mlme.c
> @@ -1144,9 +1144,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
>  	changed |= BSS_CHANGED_BSSID | BSS_CHANGED_HT;
>  	ieee80211_bss_info_change_notify(sdata, changed);
>  
> -	/* remove AP and TDLS peers */
>  	if (remove_sta)
> -		sta_info_flush(local, sdata);
> +		sta_info_destroy_addr(sdata, bssid);
>  
>  	del_timer_sync(&sdata->u.mgd.conn_mon_timer);
>  	del_timer_sync(&sdata->u.mgd.bcn_mon_timer);


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
