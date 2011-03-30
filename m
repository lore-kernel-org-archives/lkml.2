Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378Ab1C3KQg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 06:16:36 -0400
Received: from mx2.parallels.com ([64.131.90.16]:58549 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755760Ab1C3KQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 06:16:34 -0400
Message-ID: <4D9302F3.6080206@parallels.com>
Date: Wed, 30 Mar 2011 05:16:19 -0500
From: Rob Landley <rlandley@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <stable@kernel.org>
Subject: Re: 2.6.38 containers bug: Infinite loop in /proc/sys/net/ipv6/neigh/neigh/neigh...
References: <4D92E9DC.3070405@parallels.com> <20110330.020120.02272125.davem@davemloft.net>
In-Reply-To: <20110330.020120.02272125.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 04:01 AM, David Miller wrote:
> From: Rob Landley <rlandley@parallels.com>
> Date: Wed, 30 Mar 2011 03:29:16 -0500
> 
>> In the host context a find on /proc completes, but inside an lxc
>> container a find on /proc never completes, due to the endless loop in
>> the title.  (It's not a symlink, it seems to be a cross linked directory.)
>>
>> This is vanilla 2.6.38, I can attach my .config if you think it'd help.
>>  (The container's the lxc debian sid template but that's probably not
>> relevant.)
> 
> Please CC: netdev@vger.kernel.org when a bug might be related to
> networking, as is obviously the case here.
> 
> This bug should be fixed by the following patch:
> 
> --------------------
> commit 9d2a8fa96a44ba242de3a6f56acaef7a40a97b97
> Author: Eric W. Biederman <ebiederm@aristanetworks.com>
> Date:   Mon Mar 21 18:23:34 2011 -0700
> 
>     net ipv6: Fix duplicate /proc/sys/net/ipv6/neigh directory entries.
>     
>     When I was fixing issues with unregisgtering tables under /proc/sys/net/ipv6/neigh
>     by adding a mount point it appears I missed a critical ordering issue, in the
>     ipv6 initialization.  I had not realized that ipv6_sysctl_register is called
>     at the very end of the ipv6 initialization and in particular after we call
>     neigh_sysctl_register from ndisc_init.
>     
>     "neigh" needs to be initialized in ipv6_static_sysctl_register which is
>     the first ipv6 table to initialized, and definitely before ndisc_init.
>     This removes the weirdness of duplicate tables while still providing a
>     "neigh" mount point which prevents races in sysctl unregistering.
>     
>     This was initially reported at https://bugzilla.kernel.org/show_bug.cgi?id=31232
>     Reported-by: sunkan@zappa.cx
>     Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>


Yes, that fixed it.  Pinging the stable guys to make sure this goes in a
dot release.

Thanks,

Rob
