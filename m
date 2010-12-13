Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab0LMVCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 16:02:14 -0500
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:54592
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755855Ab0LMVCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 16:02:13 -0500
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Dec 2010 16:02:13 EST
Message-ID: <4D068869.7040305@xyzw.org>
Date: Mon, 13 Dec 2010 12:56:09 -0800
From: Brian Rogers <brian@xyzw.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14pre) Gecko/20101211 Shredder/3.1.8pre
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: balbir@linux.vnet.ibm.com, Dan Carpenter <error27@gmail.com>,
        linux-kernel@vger.kernel.org, Guillaume Chazarain <guichaz@gmail.com>
Subject: Re: delayacct: alignment changes break iotop
References: <20101213113745.GE1620@bicker> <20101213125709.GB14178@balbir.in.ibm.com> <4D0639B2.4060903@suse.com>
In-Reply-To: <4D0639B2.4060903@suse.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2010 07:20 AM, Jeff Mahoney wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> On 12/13/2010 07:57 AM, Balbir Singh wrote:
>> * Dan Carpenter<error27@gmail.com>  [2010-12-13 14:37:45]:
>>
>>> Iotop uses hardcoded offsets to find the taskstats struct members.
>>> This got changed in 2.6.37 so it now iotop doesn't work on amd64.  The
>>> offending commit is:
>>>
>>> commit 85893120699f8bae8caa12a8ee18ab5fceac978e
>>> Author: Jeff Mahoney<jeffm@suse.com>
>>> Date:   Wed Oct 27 15:34:43 2010 -0700
>>>
>>>      delayacct: align to 8 byte boundary on 64-bit systems
>>>
>>> Brian Rogers gets the reported-by tag.  The bugzilla entry is:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=24272
>>>
>> Thanks for the report, looks like the change did not even bump the
>> version field. Sorry, its my fault, I should have caught it earlier.
>> iotop hard coding member offsets is not bad as long as we don't break
>> ABI (expected from us). Any chance you could dump the offsets before
>> and after the change?
> In your February response and again in September, you did suggest a
> version bump. I'm not sure why that didn't get integrated but I still
> don't see how it's necessary for code that actually follows the interface.
>
> iotop doesn't. It's broken. It doesn't even honor that version field and
> worse yet, it doesn't even honor the packet format which specifically
> doesn't define hard offsets. Rather it defines a protocol that tags
> fields and supplies the offsets in the packet.
>
> The getdelays.c code that ships with the kernel even demonstrates this,
> so there's no excuse for half-assing it like this.

 From a cursory glance, it looks to me like iotop (mostly) does the 
correct thing. The taskstats struct is received as one big chunk, so the 
table of fixed offsets (within struct taskstats) is necessary.

There's a bug fix in the git repo that fixes the cause of misalignment:

commit 08211d209ae8fc7e67ea3bebb09979ff61c70f97
Author: Guillaume Chazarain <guichaz@gmail.com>
Date:   Sat Sep 4 13:57:43 2010 +0200

     Instead of assuming the pid field is 4 bytes long, take its length 
from the header.
     This is needed for http://lkml.org/lkml/2010/2/12/167
     [PATCH] delayacct: align to 8 byte boundary on 64-bit systems


With this version of iotop, there is no problem with the latest kernel. 
I'm CCing the iotop author. It would be nice to have a release with this 
fix.

Brian

