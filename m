Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933948Ab1D2V7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 17:59:43 -0400
Received: from mx2.proofpoint.com ([208.86.202.10]:15600 "EHLO
	mx2.proofpoint.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933926Ab1D2V70 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 17:59:26 -0400
Message-ID: <4DBB3480.9020708@proofpoint.com>
Date: Fri, 29 Apr 2011 14:58:24 -0700
From: John Gardiner Myers <jgmyers@proofpoint.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kuznet@ms2.inr.ac.ru, pekkas@netcore.fi, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv6: fix incorrect unregistration of sysctl when last
 ip deleted
References: <201104272312.p3RNCcl6002068@jgmyers-vm1.eng.proofpoint.com> <20110429.134524.116375005.davem@davemloft.net>
In-Reply-To: <20110429.134524.116375005.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Apr 2011 21:58:25.0280 (UTC) FILETIME=[905F1000:01CC06B8]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-04-29_08:2011-04-29,2011-04-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=0
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1104290159
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2011 1:45 PM, David Miller wrote:
> First of all, when the machine boots up, you already have the problem
> that you cannot set the accept_ra and addrconf sysctl settings before
> the first ipv6 address is added to the interface.
What do you mean? I see no problem.

One does not need to set the accept_ra and addrconf sysctl settings 
before the first ipv6 address is added to the interface, one needs to 
set them before the interface is brought up. DAD (and thus router 
solicitation) does not happen on down interfaces.

When the machine boots up and the interface is discovered, it starts in 
the down state but with the sysctls registered. There is no problem 
adjusting the settings before bringing the interface up.

> So by definition you already cannot make the settings before it is
> "too late" and the device is already engaging in ipv6 activity.
>
> Giving you the capability to handle this across full ipv6 address
> deletions on the device later on doesn't add anything, and at best it
> gives people a false sense of security about being able to preserve
> these settings across an ipv6 disable on the device.
>
> If people are going to use this new behavior to do some trick like:
>
> 1) Let device come up and assign ipv6 addresses so that sysctls appear
> 2) Set ipv6 sysctls how actually desired
> 3) Delete all ipv6 addresses
> 4) Add them all back
>
> Then I doubly do not want to set a precedent for this kind of usage
> by applying this patch.  Fix the real problem.
This is all nonsense.
> This behavior has been here, and intentionally so, since Alexey added
> the "how" parameter to addrconf_ifdown() back in 1997.
The "how" parameter indicates the device is being deleted. In this case, 
the device is not being deleted.

This does bring up the issue that the call to addrconf_ifdown() when the 
MTU goes below IPV6_MIN_MTU probably also needs to be fixed.
Furthermore, there are other side effects to changing the 'how' parameter
> to zero in this case and I haven't seen any analysis that those won't
> cause any other undesirable side effects either.
If the device isn't going away, then the ip6_ptr shouldn't be zeroed, 
the /proc/net/dev_snmp6 entry shouldn't be deregistered, the stateless 
addrconf flags should be cleared, the regen timer shouldn't be deleted, 
ipv6 multicast shouldn't mark the device down instead of being 
destroyed, and the nd_parms shouldn't be freed.


