Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab1DGT5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 15:57:09 -0400
Received: from mga02.intel.com ([134.134.136.20]:4965 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756719Ab1DGT5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 15:57:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,318,1299484800"; 
   d="scan'208";a="730486210"
Message-ID: <4D9E1712.5090600@linux.intel.com>
Date: Thu, 07 Apr 2011 12:57:06 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        Len Brown <lenb@kernel.org>, Nicole Chalhoub <n-chalhoub@ti.com>,
        Vincent Bour <v-bour@ti.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] nohz: delay going tickless under CPU load to favor deeper
 C states
References: <1302200311-24263-1-git-send-email-khilman@ti.com>
In-Reply-To: <1302200311-24263-1-git-send-email-khilman@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/7/2011 11:18 AM, Kevin Hilman wrote:
> From: Nicole Chalhoub<n-chalhoub@ti.com>
>
> While there is CPU load, continue the periodic tick in order to give
> CPUidle another opportunity to pick a deeper C-state instead of
> spending potentially long i


so I don't really like this patch. It's actually a pretty bad hack (I'm 
sure it'll work somewhat)
[and I mean that in the most positive sense of the word ;-) ]

what we really need instead, and this is inside cpuidle, is the option 
to set a timer when we enter the non-deepest C state,
so that if that timer fires we then reevaluate.
The duration of that timer will be dependent on the C state (so should 
come from the C state structure of the state we pick).

For the most shallow one this will be a relatively short time, but for 
the deepest-but-one this might be a lot longer time.


your patch abuses a completely different, unrelated timer for this, with 
a pretty much unspecified frequency, that also has other side effects 
that we probably don't want.


it shouldn't be hard to do the right thing instead and make it a 
separate timer with a per C state timeout.

(and I would say a default timeout of 10x the break even time that we 
already have in the structure)



