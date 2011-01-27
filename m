Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab1A0JJi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 04:09:38 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60841 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab1A0JJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 04:09:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 27 Jan 2011 18:03:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, balbir@linux.vnet.ibm.com,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, stable@kernel.org
Subject: Re: [PATCH] memsw: handle swapaccount kernel parameter correctly
Message-Id: <20110127180330.78585085.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110127082320.GA15500@tiehlicka.suse.cz>
References: <20110126152158.GA4144@tiehlicka.suse.cz>
	<20110126140618.8e09cd23.akpm@linux-foundation.org>
	<20110127082320.GA15500@tiehlicka.suse.cz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011 09:23:20 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Wed 26-01-11 14:06:18, Andrew Morton wrote:
> > On Wed, 26 Jan 2011 16:21:58 +0100
> > Michal Hocko <mhocko@suse.cz> wrote:
> > 
> > > I am sorry but the patch which added swapaccount parameter is not
> > > correct (we have discussed it https://lkml.org/lkml/2010/11/16/103).
> > > I didn't get the way how __setup parameters are handled correctly.
> > > The patch bellow fixes that.
> > > 
> > > I am CCing stable as well because the patch got into .37 kernel.
> > > 
> > > ---
> > > >From 144c2e8aed27d82d48217896ee1f58dbaa7f1f84 Mon Sep 17 00:00:00 2001
> > > From: Michal Hocko <mhocko@suse.cz>
> > > Date: Wed, 26 Jan 2011 14:12:41 +0100
> > > Subject: [PATCH] memsw: handle swapaccount kernel parameter correctly
> > > 
> > > __setup based kernel command line parameters handled in
> > > obsolete_checksetup provides the parameter value including = (more
> > > precisely everything right after the parameter name) so we have to check
> > > for =0 resp. =1 here. If no value is given then we get an empty string
> > > rather then NULL.
> > 
> > This doesn't provide a description of the bug which just got fixed.
> > 
> > From reading the code I think the current behaviour is
> > 
> > "swapaccount": works OK
> 
> Not really because the original test was !s || s="1" but as I am writing
> in the commit message we are getting an empty string rather than NULL in
> no parameter value case..
> So noswapaccount is actually the only thing that is working.
> 
> > "noswapaccount": works OK
> > "swapaccount=0": doesn't do anything
> > "swapaccount=1": doesn't do anything
> > 
> > but I might be wrong about that.  Please send a changelog update to
> > clarify all this.
> 
> Sorry for not being specific enough. What about somthing like this:
> ---
> From 317dec3d13ef7f11e8f2699331bc32fcd6a8ea0e Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.cz>
> Date: Wed, 26 Jan 2011 14:12:41 +0100
> Subject: [PATCH] memsw: handle swapaccount kernel parameter correctly
> 
> __setup based kernel command line parameters handlers which are handled in
> obsolete_checksetup are provided with the parameter value including =
> (more precisely everything right after the parameter name).
> 
> This means that the current implementation of swapaccount[=1|0] doesn't
> work at all because if there is a value for the parameter then we are
> testing for "0" resp. "1" but we are getting "=0" resp. "=1" and if
> there is no parameter value we are getting an empty string rather than
> NULL.
> 
> The original noswapccount parameter, which doesn't care about the value,
> works correctly.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

> ---
>  mm/memcontrol.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index db76ef7..cea2be48 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5013,9 +5013,9 @@ struct cgroup_subsys mem_cgroup_subsys = {
>  static int __init enable_swap_account(char *s)
>  {
>  	/* consider enabled if no parameter or 1 is given */
> -	if (!s || !strcmp(s, "1"))
> +	if (!(*s) || !strcmp(s, "=1"))
>  		really_do_swap_account = 1;
> -	else if (!strcmp(s, "0"))
> +	else if (!strcmp(s, "=0"))
>  		really_do_swap_account = 0;
>  	return 1;
>  }

Hmm, usual callser of __setup() includes '=' to parameter name, as

mm/hugetlb.c:__setup("hugepages=", hugetlb_nrpages_setup);
mm/hugetlb.c:__setup("default_hugepagesz=", hugetlb_default_setup);

How about moving "=" to __setup() ?


Thanks,
-Kame

