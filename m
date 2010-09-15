Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab0IOAaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 20:30:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60504 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751683Ab0IOAae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 20:30:34 -0400
Message-ID: <4C90139A.1080809@redhat.com>
Date: Tue, 14 Sep 2010 20:30:18 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Deadlock possibly caused by too_many_isolated.
References: <20100915091118.3dbdc961@notabene>
In-Reply-To: <20100915091118.3dbdc961@notabene>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 07:11 PM, Neil Brown wrote:

> Index: linux-2.6.32-SLE11-SP1/mm/vmscan.c
> ===================================================================
> --- linux-2.6.32-SLE11-SP1.orig/mm/vmscan.c	2010-09-15 08:37:32.000000000 +1000
> +++ linux-2.6.32-SLE11-SP1/mm/vmscan.c	2010-09-15 08:38:57.000000000 +1000
> @@ -1106,6 +1106,11 @@ static unsigned long shrink_inactive_lis
>   		/* We are about to die and free our memory. Return now. */
>   		if (fatal_signal_pending(current))
>   			return SWAP_CLUSTER_MAX;
> +		if (!(sc->gfp_mask&  __GFP_IO))
> +			/* Not allowed to do IO, so mustn't wait
> +			 * on processes that might try to
> +			 */
> +			return SWAP_CLUSTER_MAX;
>   	}
>
>   	/*

Close.  We must also be sure that processes without __GFP_FS
set in their gfp_mask do not wait on processes that do have
__GFP_FS set.

Considering how many times we've run into a bug like this,
I'm kicking myself for not having thought of it :(

-- 
All rights reversed
