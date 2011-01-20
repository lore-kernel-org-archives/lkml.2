Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab1ATPAP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 10:00:15 -0500
Received: from smtp110.prem.mail.ac4.yahoo.com ([76.13.13.93]:45642 "HELO
	smtp110.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755736Ab1ATPAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 10:00:13 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: _k5HKLUVM1mP.bxTMyHNBkcK6e4m_r8.Kz_2uEBrO604bUA
 uFkFyWtZO6lC2e7N3iXOsX7YKgehpvDdJvPnrxXgjS1ul1RYjCEF.8r05sHt
 BY7vspf5axUQzDmIWsYFsVidY9XVvqePDWCH30OFbAYMvPn.cyFTpqaTnObX
 DHstFZ6.Pq567iIKj3KxV942E.gR7yKVGgiJ9p7UvaI5Sd4W2ju6g0nbAdWs
 .C7aIoPwjLyE-
X-Yahoo-Newman-Property: ymail-3
Date: Thu, 20 Jan 2011 09:00:09 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Balbir Singh <balbir@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, akpm@linux-foundation.org, npiggin@kernel.dk,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [REPOST] [PATCH 3/3] Provide control over unmapped pages (v3)
In-Reply-To: <20110120123649.30481.93286.stgit@localhost6.localdomain6>
Message-ID: <alpine.DEB.2.00.1101200856310.10695@router.home>
References: <20110120123039.30481.81151.stgit@localhost6.localdomain6> <20110120123649.30481.93286.stgit@localhost6.localdomain6>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Jan 2011, Balbir Singh wrote:

> +	unmapped_page_control
> +			[KNL] Available if CONFIG_UNMAPPED_PAGECACHE_CONTROL
> +			is enabled. It controls the amount of unmapped memory
> +			that is present in the system. This boot option plus
> +			vm.min_unmapped_ratio (sysctl) provide granular control

min_unmapped_ratio is there to guarantee that zone reclaim does not
reclaim all unmapped pages.

What you want here is a max_unmapped_ratio.


>  {
> @@ -2297,6 +2320,12 @@ loop_again:
>  				shrink_active_list(SWAP_CLUSTER_MAX, zone,
>  							&sc, priority, 0);
>
> +			/*
> +			 * We do unmapped page reclaim once here and once
> +			 * below, so that we don't lose out
> +			 */
> +			reclaim_unmapped_pages(priority, zone, &sc);
> +
>  			if (!zone_watermark_ok_safe(zone, order,

Hmmmm. Okay that means background reclaim does it. If so then we also want
zone reclaim to be able to work in the background I think.
max_unmapped_ratio could also be useful to the zone reclaim logic.

