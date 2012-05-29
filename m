Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753455Ab2E2OTM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 10:19:12 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:38515 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752605Ab2E2OTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 10:19:10 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: TfLIKggVM1mZo0GGrOzXs3m4ajrZRzZwSwoshJ2DBaVXxi6
 BlPlE_C.QlcUk9vbbBagQYLild2N5ocXm9r1fdrlR9NvzgxTEZSg6_wWKv2_
 u0fBCpMGIEbt.BXq25qC4DfmxcD42ALOxDpqO.KvRootu2VTHCvbEEiDAk9S
 nJsm1f6kR..VJeb1X6R40WSMTLAilK0p3nZRgac7o7dMxiFv4xHS0tPFcKL9
 ABoIEeiC76Cv_l_Mj29o8CaP8LYwK3HQ0tO_JBw7doI1olXygP9aNJJ7Qr_D
 eksnKgmPwpjT6UicaZ6U0IuAnydsee8TLmfwIGY5J_9mqev6bvK1928MGBdR
 XfYCfNG0oif0dGsPISvwFXSyf2kLQNM4_SWnr3D.IHKk9u4NwQDIVfTTNlNU
 S
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 29 May 2012 09:19:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Glauber Costa <glommer@parallels.com>
cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, Tejun Heo <tj@kernel.org>,
        Li Zefan <lizefan@huawei.com>, Greg Thelen <gthelen@google.com>,
        Suleiman Souhlal <suleiman@google.com>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, devel@openvz.org,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 05/28] memcg: Reclaim when more than one page
 needed.
In-Reply-To: <1337951028-3427-6-git-send-email-glommer@parallels.com>
Message-ID: <alpine.DEB.2.00.1205290917230.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-6-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Glauber Costa wrote:

> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>
> mem_cgroup_do_charge() was written before slab accounting, and expects
> three cases: being called for 1 page, being called for a stock of 32 pages,
> or being called for a hugepage.  If we call for 2 pages (and several slabs
> used in process creation are such, at least with the debug options I had),
> it assumed it's being called for stock and just retried without reclaiming.

Slab pages are allocated up to order 3 (PAGE_ALLOC_COSTLY_ORDER). That is
8 pages.

>  	 * unlikely to succeed so close to the limit, and we fall back
>  	 * to regular pages anyway in case of failure.
>  	 */
> -	if (nr_pages == 1 && ret)
> +	if (nr_pages <= (PAGE_SIZE << PAGE_ALLOC_COSTLY_ORDER) && ret) {
> +		cond_resched();
>  		return CHARGE_RETRY;
> +	}
>
>  	/*
>  	 * At task move, charge accounts can be doubly counted. So, it's

Ok. That looks correct.

