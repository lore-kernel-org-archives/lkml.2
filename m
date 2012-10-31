Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935905Ab2JaSVj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 14:21:39 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35779 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935867Ab2JaSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 14:21:35 -0400
Date: Wed, 31 Oct 2012 11:21:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wen Congyang <wency@cn.fujitsu.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jiang Liu <jiang.liu@huawei.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mgorman@suse.de>,
        Yinghai Lu <yinghai@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>
Subject: Re: [PART6 Patch] mempolicy: fix is_valid_nodemask()
In-Reply-To: <1351675458-11859-2-git-send-email-wency@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1210311119000.8809@chino.kir.corp.google.com>
References: <1351675458-11859-1-git-send-email-wency@cn.fujitsu.com> <1351675458-11859-2-git-send-email-wency@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Wen Congyang wrote:

> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> is_valid_nodemask() is introduced by 19770b32. but it does not match
> its comments, because it does not check the zone which > policy_zone.
> 
> Also in b377fd, this commits told us, if highest zone is ZONE_MOVABLE,
> we should also apply memory policies to it. so ZONE_MOVABLE should be valid zone
> for policies. is_valid_nodemask() need to be changed to match it.
> 
> Fix: check all zones, even its zoneid > policy_zone.
> Use nodes_intersects() instead open code to check it.
> 

This changes the semantics of MPOL_BIND to be considerably different than 
what it is today: slab allocations are no longer bound by such a policy 
which isn't consistent with what userspace expects or is specified by 
set_mempolicy() and there's no way, with your patch, to actually specify 
that we don't care about ZONE_MOVABLE and that the slab allocations 
_should_ actually be allocated on movable-only zones.  You have to respect 
cases where people aren't interested in node hotplug and not cause a 
regression.
