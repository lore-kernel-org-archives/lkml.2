Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755102Ab0HaTVb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 15:21:31 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:39506 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab0HaTVa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 15:21:30 -0400
X-Auth-Info: GQ8d6v3fqUCCqai9BAw6YhoqSw/YPFXJnvP0iShNWoY=
Message-ID: <4C7D565F.307@grandegger.com>
Date: Tue, 31 Aug 2010 21:22:07 +0200
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Julia Lawall <julia@diku.dk>, kernel-janitors@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 3/4] drivers/net/can/mscan/mpc5xxx_can.c: Add	of_node_put
 to avoid memory leak
References: <1283269738-14612-1-git-send-email-julia@diku.dk> <1283269738-14612-4-git-send-email-julia@diku.dk> <20100831165153.GB28015@pengutronix.de> <Pine.LNX.4.64.1008311943280.2668@ask.diku.dk> <20100831191014.GA9603@pengutronix.de>
In-Reply-To: <20100831191014.GA9603@pengutronix.de>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/31/2010 09:10 PM, Wolfram Sang wrote:
> On Tue, Aug 31, 2010 at 07:44:00PM +0200, Julia Lawall wrote:
>> Add a call to of_node_put in the error handling code following a call to
>> of_find_matching_node.
>>
>> This patch also moves the existing call to of_node_put after the call to
>> iounmap in the error handling code, to make it possible to jump to
>> of_node_put without doing iounmap.  These appear to be disjoint operations,
>> so the ordering doesn't matter.
>>
>> This patch furthermore changes the -ENODEV result in the error handling
>> code for of_find_matching_node to a return of 0, as found in the error
>> handling code for of_iomap, because the return type of the function is
>> unsigned.
>>
>> The semantic match that finds this problem is as follows:
>> (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> @r exists@
>> local idexpression x;
>> expression E,E1,E2;
>> statement S;
>> @@
>>
>> *x = 
>> (of_find_node_by_path
>> |of_find_node_by_name
>> |of_find_node_by_phandle
>> |of_get_parent
>> |of_get_next_parent
>> |of_get_next_child
>> |of_find_compatible_node
>> |of_match_node
>> |of_find_node_by_type
>> |of_find_node_with_property
>> |of_find_matching_node
>> |of_parse_phandle
>> )(...);
>> ...
>> if (x == NULL) S
>> <... when != x = E
>> *if (...) {
>>   ... when != of_node_put(x)
>>       when != if (...) { ... of_node_put(x); ... }
>> (
>>   return <+...x...+>;
>> |
>> *  return ...;
>> )
>> }
>> ...>
>> (
>> E2 = x;
>> |
>> of_node_put(x);
>> )
>> // </smpl>
>>
>> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> Reviewed-by: Wolfram Sang <w.sang@pengutronix.de>

Acked-by: Wolfgang Grandegger <wg@grandegger.com>
