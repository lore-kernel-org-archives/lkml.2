Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab1GMBPJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 21:15:09 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:32981 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1GMBPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 21:15:07 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4E1CF1A3.3050401@jp.fujitsu.com>
Date: Wed, 13 Jul 2011 10:15:15 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.18) Gecko/20110616 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: mgorman@suse.de
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: page allocator: Initialise ZLC for first zone
 eligible for zone_reclaim
References: <1310389274-13995-1-git-send-email-mgorman@suse.de> <1310389274-13995-3-git-send-email-mgorman@suse.de>
In-Reply-To: <1310389274-13995-3-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/07/11 22:01), Mel Gorman wrote:
> The zonelist cache (ZLC) is used among other things to record if
> zone_reclaim() failed for a particular zone recently. The intention
> is to avoid a high cost scanning extremely long zonelists or scanning
> within the zone uselessly.
> 
> Currently the zonelist cache is setup only after the first zone has
> been considered and zone_reclaim() has been called. The objective was
> to avoid a costly setup but zone_reclaim is itself quite expensive. If
> it is failing regularly such as the first eligible zone having mostly
> mapped pages, the cost in scanning and allocation stalls is far higher
> than the ZLC initialisation step.
> 
> This patch initialises ZLC before the first eligible zone calls
> zone_reclaim(). Once initialised, it is checked whether the zone
> failed zone_reclaim recently. If it has, the zone is skipped. As the
> first zone is now being checked, additional care has to be taken about
> zones marked full. A zone can be marked "full" because it should not
> have enough unmapped pages for zone_reclaim but this is excessive as
> direct reclaim or kswapd may succeed where zone_reclaim fails. Only
> mark zones "full" after zone_reclaim fails if it failed to reclaim
> enough pages after scanning.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

If I understand correctly this patch's procs/cons is,

pros.
 1) faster when zone reclaim doesn't work effectively

cons.
 2) slower when zone reclaim is off
 3) slower when zone recliam works effectively


(2) and (3) are frequently happen than (1), correct?
At least, I think we need to keep zero impact when zone reclaim mode is off.

Thanks.


