Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757369Ab1K3KKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 05:10:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36079 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab1K3KKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 05:10:32 -0500
Date: Wed, 30 Nov 2011 11:10:28 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org
Subject: Re: [3.2-rc3] 100% CPU usage while in del_timer_sync from
 iwl3945_rs_free_sta
Message-ID: <20111130101028.GA2906@tiehlicka.suse.cz>
References: <20111129100727.GD2675@tiehlicka.suse.cz>
 <20111129113906.GA7299@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129113906.GA7299@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 29-11-11 12:39:07, Stanislaw Gruszka wrote:
> Hi Michal
> 
> On Tue, Nov 29, 2011 at 11:07:27AM +0100, Michal Hocko wrote:
> > [I am not sure whether this is ieee80211 or iwl3945 issue so put both
> > maintainers into loop]
> The only changed we had in iwlegacy between 3.1 and 3.2-rc, was only 
> adjustment to mac80211 changes. However I think this is iwlegacy issue,
> just for some reason bug did not trigger before.

I have double checked 3.1 and cannot reproduce it.
Anyway, I have put:

diff --git a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
index 8faeaf2..9221ed4 100644
--- a/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-3945-rs.c
@@ -432,6 +432,7 @@ static void iwl3945_rs_free_sta(void *iwl_priv, struct ieee80211_sta *sta,
 	 * to use iwl_priv to print out debugging) since it may not be fully
 	 * initialized at this point.
 	 */
+	printk("XXX: deleting time: %x\n", rs_sta->rate_scale_flush.base);
 	del_timer_sync(&rs_sta->rate_scale_flush);
 }
 
And the timer base is really NULL when the issue happens. So, somebody
probably removed the timer already?

> Is this problem 100% reproducible for you ? 

Yes, it seems to be sufficient to suspend to RAM while associated and
turn off the AP before waking up the machine.
I wasn't able to reproduce just by turning of the AP while associated
without suspend.

> If so I'll try to reproduce it locally, otherwise I'll review related
> code to find reason of that problem.
> 
> Thanks
> Stanislaw 

Thanks

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
