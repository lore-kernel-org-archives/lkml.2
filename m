Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab1LUMKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 07:10:38 -0500
Received: from mail1-relais-roc.national.inria.fr ([192.134.164.82]:3836 "EHLO
	mail1-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751629Ab1LUMKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 07:10:35 -0500
X-IronPort-AV: E=Sophos;i="4.71,387,1320620400"; 
   d="scan'208";a="136314016"
Date: Wed, 21 Dec 2011 13:10:32 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Lars-Peter Clausen <lars@metafoo.de>
cc: Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <npalix.work@gmail.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk, mmarek@suse.cz
Subject: Re: [Cocci] [PATCH 2/2] coccinelle: Add patch for replacing open-coded
 IS_ERR_OR_NULL
In-Reply-To: <4EF1C7D3.7080301@metafoo.de>
Message-ID: <alpine.DEB.2.02.1112211308290.1826@localhost6.localdomain6>
References: <1324301063-16117-1-git-send-email-lars@metafoo.de> <1324301063-16117-2-git-send-email-lars@metafoo.de> <alpine.DEB.2.02.1112202321220.1933@hadrien> <4EF1C7D3.7080301@metafoo.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011, Lars-Peter Clausen wrote:

> On 12/20/2011 11:24 PM, Julia Lawall wrote:
>> For this one, I made quite a number of changes, some of which required
>> fixing a bug in Coccinelle...  I will try to release the bug fix
>> shortly. In general, though, I have added ... between the two tests.  I
>> also got rid of the focus on ifs in the org and report rules.
>>
>
> Ok, thanks. Was the removing of the ifs in related to the Coccinelle bug? I
> always get an error if I start a match with a conditional.

Not at all.  The bug was that a patterm like:

  @depends on patch@
  expression x;
  @@
  - IS_ERR(x)
  + IS_ERR_OR_NULL(x)
    || ...
  - || x == NULL

thought that it should be applied in two ways, giving an error about a 
double transformation of the IS_ERR call.

Could you reproduce the example that caused problems?

thanks,
julia

>> julia
>>
>> virtual context
>> virtual patch
>> virtual org
>> virtual report
>>
>> // Since the logical or operator by itself is not commutative we need
>> rules for
>> // both cases as well as for their De Morgan equivalents.
>>
>> @depends on context@
>> expression x;
>> @@
>> * IS_ERR(x)
>>   || ... ||
>> * x == NULL
>>
>> @depends on context@
>> expression x;
>> @@
>> * x == NULL
>>   || ... ||
>> * IS_ERR(x)
>>
>> @depends on context@
>> expression x;
>> @@
>> * !IS_ERR(x)
>>   && ... &&
>> * x != NULL
>>
>> @depends on context@
>> expression x;
>> @@
>> * x != NULL
>>   && ... &&
>> * !IS_ERR(x)
>>
>> @depends on patch@
>> expression x;
>> @@
>> - IS_ERR(x)
>> + IS_ERR_OR_NULL(x)
>>   || ...
>> - || x == NULL
>>
>> @depends on patch@
>> expression x;
>> @@
>> - x == NULL
>> + IS_ERR_OR_NULL(x)
>>   || ...
>> - || IS_ERR(x)
>>
>> @depends on patch@
>> expression x;
>> @@
>> - !IS_ERR(x)
>> + !IS_ERR_OR_NULL(x)
>>   && ...
>> - && x != NULL
>>
>> @depends on patch@
>> expression x;
>> @@
>> - x != NULL
>> + !IS_ERR_OR_NULL(x)
>>   && ...
>> - && !IS_ERR(x)
>>
>> @r depends on org || report@
>> expression x;
>> position p;
>> @@
>> (
>>  IS_ERR@p(x) || ... || x == NULL
>> |
>>  x == NULL || ... || IS_ERR@p(x)
>> |
>>  !IS_ERR@p(x) && ... && x != NULL
>> |
>>  x != NULL && ... && !IS_ERR@p(x)
>> )
>>
>> @script:python depends on org@
>> p << r.p;
>> x << r.x;
>> @@
>>
>> msg="IS_ERR_OR_NULL can be used with %s" % (x)
>> msg_safe=msg.replace("[","@(").replace("]",")")
>> coccilib.org.print_todo(p[0], msg_safe)
>>
>> @script:python depends on report@
>> p << r.p;
>> x << r.x;
>> @@
>>
>> msg="IS_ERR_OR_NULL can be used with %s" % (x)
>> coccilib.report.print_report(p[0], msg)
>
>
