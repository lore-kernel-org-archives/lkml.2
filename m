Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690Ab1L0Xs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 18:48:56 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:40750 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751508Ab1L0Xsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 18:48:54 -0500
Message-ID: <4EFA6751.3060502@xenotime.net>
Date: Tue, 27 Dec 2011 16:48:17 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Cyrill Gorcunov <gorcunov@openvz.org>, linux-kernel@vger.kernel.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>, Pekka Enberg <penberg@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [patch 1/4] Add routine for generating an ID for kernel pointer
References: <20111223124741.711871189@openvz.org>	<20111223124920.661126615@openvz.org> <20111227153304.c585c5f6.akpm@linux-foundation.org>
In-Reply-To: <20111227153304.c585c5f6.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2011 03:33 PM, Andrew Morton wrote:
> On Fri, 23 Dec 2011 16:47:42 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
>> The routine XORs the given pointer with a random value
>> producing an ID (32 or 64 bit, depending on the arch).
>>
>> Since it's a valuable information -- only CAP_SYS_ADMIN
>> is allowed to obtain it.
>>
>>  - Tejun worried about the single poison value was a weak side -
>>    leaking one makes all the IDs vulnerable. To address this
>>    several poison values - one per object type - are introduced.
>>    They are stored in a plain array.
>>  - Pekka proposed to initialized poison values in the late_initcall callback
>>  - ... and move the code to mm/util.c
>>
>> ...
>>
> 
> The code in general looks simple and reasonable to me.  I'm too much of
> a security weenie to pass judgement on the security aspects.
> 
>>
>> ...
>>
>> --- linux-2.6.git.orig/mm/Kconfig
>> +++ linux-2.6.git/mm/Kconfig
>> @@ -373,3 +373,19 @@ config CLEANCACHE
>>  	  in a negligible performance hit.
>>  
>>  	  If unsure, say Y to enable cleancache
>> +
>> +config GENERIC_OBJECT_ID
>> +	bool "Enable generic object ID infrastructure"
>> +	depends on CHECKPOINT_RESTORE
> 
> Is c/r useless without GENERIC_OBJECT_ID?  If so, perhaps a `select'
> would be good here.

Is GENERIC_OBJECT_ID useful elsewhere?  If so, then it shouldn't depend
on CHECKPOINT_RESTORE -- it should just live in lib/ instead of in mm/
and CHECKPOINT_RESTORE should select it.

>> +	default n
>> +	help
>> +	  Turn on the functionality that can generate IDs for kernel
>> +	  objects, which are exported to userspace via /proc filesystem.
>> +
>> +	  It is useful if you need to examinate kernel objects and test
>> +	  if they are shared between several tasks. These IDs should never
>> +	  be used for anything but the "sameness" test. Besides, the IDs are
>> +	  dynamic and valid only while object is alive, once it get freed or
>> +	  kernel is rebooted -- the IDs will be changed.
>> +
>> +	  If unsure, say N here.


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
