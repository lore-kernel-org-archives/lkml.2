Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752947Ab0FWSVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 14:21:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49448 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758Ab0FWSVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 14:21:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FvQu83vds4faFBTHFUb1Y3uynnB9QgwEcGyen0Kb1zIqGOBiId5JC2MA0jC8Y0DMRf
         J6TjK2Ucxb33aGed2lqjR8Ndd2DR5Drx4qVO+dXPpYI80lF9WIPvutObSGbGsxtJfcBH
         uanLkzqP4fME+gmJsSLwdM00QhpGwX+xzODxw=
Message-ID: <4C22508A.8060002@gmail.com>
Date: Wed, 23 Jun 2010 11:20:58 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100621 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?VGltbyBUZXLDpHM=?= <timo.teras@iki.fi>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
       "John W.Linville" <linville@tuxdriver.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       davem@davemloft.net
Subject: Re: BUG: unable to handle kernel NULL pointer dereference at 00000000000000a0
References: <AANLkTilf41JrFwN1veRDifNA78S2LQ6SO0g3YLOONd2W@mail.gmail.com>	 <20100623141622.GC15205@tuxdriver.com>  <4C223DCA.5090704@gmail.com> <1277314167.2469.1144.camel@edumazet-laptop> <4C224E06.40806@iki.fi>
In-Reply-To: <4C224E06.40806@iki.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/10 11:10, Timo Teräs wrote:
> On 06/23/2010 08:29 PM, Eric Dumazet wrote:
>    
>> Le mercredi 23 juin 2010 à 10:00 -0700, Justin P. Mattock a écrit :
>>      
>>> o.k. the bisect is pointing to the below results..
>>> (I tried git revert xxx but this commit is too big
>>> so I'll(hopefully)manually revert it on the latest HEAD to
>>> see if this is the actual problem im experiencing)
>>>
>>> 80c802f3073e84c956846e921e8a0b02dfa3755f is the first bad commit
>>> commit 80c802f3073e84c956846e921e8a0b02dfa3755f
>>> Author: Timo TerÃ¤s<timo.teras@iki.fi>
>>> Date:   Wed Apr 7 00:30:05 2010 +0000
>>>
>>>       xfrm: cache bundles instead of policies for outgoing flows
>>>
>>>       __xfrm_lookup() is called for each packet transmitted out of
>>>       system. The xfrm_find_bundle() does a linear search which can
>>>       kill system performance depending on how many bundles are
>>>       required per policy.
>>>
>>>       This modifies __xfrm_lookup() to store bundles directly in
>>>       the flow cache. If we did not get a hit, we just create a new
>>>       bundle instead of doing slow search. This means that we can now
>>>       get multiple xfrm_dst's for same flow (on per-cpu basis).
>>>
>>>       Signed-off-by: Timo Teras<timo.teras@iki.fi>
>>>       Signed-off-by: David S. Miller<davem@davemloft.net>
>>>
>>> :040000 040000 d8e60f5fa4c1329f450d9c7cdf98b34e6a177f22
>>> 9f576e68e5bf4ce357d7f0305aee5f410250dfe2 M      include
>>> :040000 040000 f2876df688ee36907af7b4123eea96592faaed3e
>>> a3f6f6f94f0309106856cd99b38ec90b024eb016 M      net
>>>        
>> Thanks a lot for bisecting Jutin, this is really appreciated.
>>
>> crash is in xfrm_bundle_ok()
>>
>> if (xdst->policy_genid != atomic_read(&xdst->pols[0]->genid))
>> 	return 0;
>>
>> xdst->pols[0] contains a NULL pointer
>>      
> That does not really make sense, if we get this far; there's a valid
> xfrm_state with the bundle. This means that there existed a policy with
> it too.
>
> I'll take a deeper look at this tomorrow. Would it be possible to see
> your xfrm policies?
>
> - Timo
>
>    

@Eric sure no problem doing the bisect...

as for the xfrm policy here is the link that I used to setup ipsec:
http://www.linuxfromscratch.org/hints/downloads/files/ipsec.txt
(just change the keys if doing real world work..(but for me just testing).

below is a temporary fix for me to get this working, tcpdump reports 
everything is doing what it should be
11:16:32.496166 IP xxxxx > xxxxx: AH(spi=0x00000200,seq=0x1090): 
ESP(spi=0x00000201,seq=0x1090), length 56
11:16:32.496212 IP xxxxx > xxxxx: AH(spi=0x00000200,seq=0x1091): 
ESP(spi=0x00000201,seq=0x1091), length 56
11:16:32.496259 IP xxxxx > xxxxx: AH(spi=0x00000200,seq=0x1092): 
ESP(spi=0x00000201,seq=0x1092), length 56

(tested a few mins ago, but not the right fix..)

 From a280d9048c8f8f5756f9f0dcc608b4499645593e Mon Sep 17 00:00:00 2001
From: Justin P. Mattock <justinmattock@gmail.com>
Date: Wed, 23 Jun 2010 11:10:28 -0700
Subject: [PATCH] fix ipsec
  Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
  net/xfrm/xfrm_policy.c |    2 --
  1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 4bf27d9..701d69a 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2300,8 +2300,6 @@ int xfrm_bundle_ok(struct xfrm_policy *pol, struct 
xfrm_dst *first,
              return 0;
          if (xdst->xfrm_genid != dst->xfrm->genid)
              return 0;
-        if (xdst->policy_genid != atomic_read(&xdst->pols[0]->genid))
-            return 0;

          if (strict && fl &&
              !(dst->xfrm->outer_mode->flags & XFRM_MODE_FLAG_TUNNEL) &&
-- 
1.7.1.rc1.21.gf3bd6


I've got the machine ready for any patches.. let me know  o.k...

Justin P. Mattock

