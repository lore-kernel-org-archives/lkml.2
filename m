Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754459Ab2A0WqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:46:16 -0500
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:36216
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751920Ab2A0WqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:46:15 -0500
X-IronPort-AV: E=Sophos;i="4.71,583,1320620400"; 
   d="scan'208";a="129158973"
Date: Fri, 27 Jan 2012 23:46:11 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Ryan Mallon <rmallon@gmail.com>
cc: Joe Perches <joe@perches.com>, Dan Carpenter <dan.carpenter@oracle.com>,
        Jiri Kosina <trivial@kernel.org>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next V2] drivers: Use NULL not zero pointer assignments
In-Reply-To: <4F2324EB.1030109@gmail.com>
Message-ID: <alpine.DEB.2.02.1201272337580.1993@hadrien>
References: <20120126061330.GA15856@elgon.mountain>  <1327559803.28707.6.camel@joe2Laptop> <1327642391.4846.36.camel@joe2Laptop>  <4F22421A.5020501@gmail.com> <1327649890.12089.20.camel@joe2Laptop> <4F2324EB.1030109@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 28 Jan 2012, Ryan Mallon wrote:

> On 27/01/12 18:38, Joe Perches wrote:
>> On Fri, 2012-01-27 at 17:20 +1100, Ryan Mallon wrote:
>>> On 27/01/12 16:33, Joe Perches wrote:
>>>> Using NULL pointer assignments is more kernel-style standard.
>>>> Uncompiled, untested.
>>>> Done via cocinelle script:
>>>> @@
>>>> type T;
>>>> T *pointer;
>>>> @@
>>>> -pointer = 0
>>>> +pointer = NULL
>>> Hi Joe,
>> Hi Ryan.
>>
>>> I think you can drop a lot of the initialisations completely rather than
>>> convert them. I've pointed some out below. I'm just scanning through for
>>> likely candidates and I didn't bother looking at the staging drivers, so
>>> this list is not comprehensive.
>> I'll try a more generic solution.
>> Here's a possible cocci script that looks for declarations with
>> initializations that are later overwritten.
>
> I think you need to be careful with this. I don't know enough about 
> Coccinelle, but in general control flow makes this a difficult problem. 
> This are also the cases where a variable is assigned on all control 
> paths before being used, but also has an (seemingly useless) initialiser 
> because gcc occasionally cannot determine that the variable is always 
> initialised (because in general it is undecidable) and so the 
> initialisation is there to prevent a compiler warning.

Coccinelle follows control-flow paths.  But it is not likely to be more 
clever about this than gcc.  It is unaware of the value of anything, so it 
does not realize that some control-flow paths are impossible.  So I don't 
think there would be big problems here.

> There were also a couple of cases I pointed out where the assignment of 
> zero to a pointer variable was actually masking some other bug, and so 
> replacing the assignment with NULL, or removing the initialisation is 
> not necessarily the correct fix.

But in this case it doesn't seem like it would hurt?  Having 0 or NULL 
would probably not make someone more or less likely to think about the 
function as a whole?

For example, in the container_of case, having NULL is probably better than 
0, because someone else is more likely to look for container_of's of NULL 
than container_of's of 0.

On the other hand, converting the 0 to NULL in the handle/*handle case 
might indeed hurt subsequent debuggability.

> A script might be useful for identifying potential cases, but I think it 
> is worth looking at each one individually to determine what the correct 
> fix is.

100% agreed on this point :)

julia
