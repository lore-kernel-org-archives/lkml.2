Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754154Ab1DVJAL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 05:00:11 -0400
Received: from mx04.teleca.com ([212.92.145.6]:41441 "EHLO mx04.teleca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754064Ab1DVJAG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 05:00:06 -0400
Message-ID: <4DB1440C.8080000@nokia.com>
Date: Fri, 22 Apr 2011 13:02:04 +0400
From: Roman Borisov <ext-roman.borisov@nokia.com>
MIME-Version: 1.0
To: ext Andrew Morton <akpm@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] fs: bound mount propagation fix
References: <20110419140400.23367a16.akpm@linux-foundation.org>	<a5c94bcf545fe78cc600402a5234a6bbc1dece97.1303304011.git.ext-roman.borisov@nokia.com> <20110421130412.ea953cbc.akpm@linux-foundation.org>
In-Reply-To: <20110421130412.ea953cbc.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 22 Apr 2011 09:00:01.0415 (UTC) FILETIME=[A9CE9170:01CC00CB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2011 12:04 AM, ext Andrew Morton wrote:
> On Thu, 21 Apr 2011 16:37:28 +0400
> Roman Borisov<ext-roman.borisov@nokia.com>  wrote:
>
>> MS_SILENT flag cleaning up added to flags_to_propagation_type function.
>> It was reported that bound mount propagation doesn't work in busybox as by
>> default busybox mount applet sets the MS_SILENT flag for any mount operation.
>> Moreover recently added flags_to_propagation_type function doesn't allow to
>> do such operations as --make-[r]private --make-[r]shared etc. when MS_SILENT
>> is on.
>> The idea to clean MS_SILENT flag belongs to Denys Vlasenko<vda.linux@googlemail.com>
>>
>
> This is not an adequate changelog, IMO.  It has almost no description
> of the errant user-visible kernel behaviour and almost no description
> of what was wrong with the kernel code - ie, why the kernel was doing
> the wrong thing.
>
Hello,

I understand that description I've sent is not so clear for end-user. 
But there are two issues:
1. This is busybox related issue; only in busybox MS_SILENT is on for 
all mount operations; I don't know how to reproduce it in 
util-linux->mount without hardcoding;
2. initial scenario didn't consider "VFS: Sanity check mount flags 
passed to change_mnt_propagation()" patch (commit 
7a2e8a8faab76386d8eaae9ded739ee5615be174);

> I've pieced together a fix for the first problem but then got lazy.
Previously we used such script:

# mkdir -p mount.dir mount.shared1 mount.shared2
# touch mount.dir/a mount.dir/b
# mount -vv --bind mount.shared1 mount.shared1
# mount -vv --make-rshared mount.shared1
# mount -vv --bind mount.shared2 mount.shared2
# mount -vv --make-rshared mount.shared2
# mount -vv --bind mount.shared2 mount.shared1
# mount -vv --bind mount.dir     mount.shared2
# ls -R mount.dir mount.shared1 mount.shared2
mount.dir:
a  b
mount.shared1:
mount.shared2:
a  b
#

but expected result is:

# ls -R mount.dir mount.shared1 mount.shared2
mount.dir:
a  b
mount.shared1:
a  b
mount.shared2:
a  b
#

My "[PATCH] fs: bound mount propagation fix" fixed this issue but as I 
said I didn't consider Valerie's patch;

After I've applied the "VFS: Sanity check mount flags passed to 
change_mnt_propagation()" patch I have *another wrong result*:

# mkdir -p mount.dir mount.shared1 mount.shared2
# touch mount.dir/a mount.dir/b
# mount -vv --bind mount.shared1 mount.shared1
# mount -vv --make-rshared mount.shared1
mount: mount.shared1: Invalid argument
#

> Please can someone provide an analysis of what was causing this bug?
>
Now the debugging shows that MS_SILENT came to 
flags_to_propagation_type() and causes the error return after the 
is_power_of_2 checking; clearing the MS_SILENT flag fixes this issue.

> And has this v3 patch been tested with Denys's reproducer?
>
Yes I've applied Valerie's and my patches and tested the scenario in 
busybox environment; the verdict is passed;
I'll post [PATCH v4] with full description today.

--
Roman
