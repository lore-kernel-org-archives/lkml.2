Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756488Ab2A0W0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:26:37 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46040 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755253Ab2A0W0g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:26:36 -0500
Message-ID: <4F2324EB.1030109@gmail.com>
Date: Sat, 28 Jan 2012 09:27:55 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Thunderbird/3.1.16
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Dan Carpenter <dan.carpenter@oracle.com>, Jiri Kosina <trivial@kernel.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH next V2] drivers: Use NULL not zero pointer assignments
References: <20120126061330.GA15856@elgon.mountain>	 <1327559803.28707.6.camel@joe2Laptop> <1327642391.4846.36.camel@joe2Laptop>	 <4F22421A.5020501@gmail.com> <1327649890.12089.20.camel@joe2Laptop>
In-Reply-To: <1327649890.12089.20.camel@joe2Laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/12 18:38, Joe Perches wrote:
> On Fri, 2012-01-27 at 17:20 +1100, Ryan Mallon wrote:
>> On 27/01/12 16:33, Joe Perches wrote:
>>> Using NULL pointer assignments is more kernel-style standard.
>>> Uncompiled, untested.
>>> Done via cocinelle script:
>>> @@
>>> type T;
>>> T *pointer;
>>> @@
>>> -pointer = 0
>>> +pointer = NULL
>> Hi Joe,
> Hi Ryan.
>
>> I think you can drop a lot of the initialisations completely rather than
>> convert them. I've pointed some out below. I'm just scanning through for
>> likely candidates and I didn't bother looking at the staging drivers, so
>> this list is not comprehensive.
> I'll try a more generic solution.
> Here's a possible cocci script that looks for declarations with
> initializations that are later overwritten.

I think you need to be careful with this. I don't know enough about Coccinelle, but in general control flow makes this a difficult problem. This are also the cases where a variable is assigned on all control paths before being used, but also has an (seemingly useless) initialiser because gcc occasionally cannot determine that the variable is always initialised (because in general it is undecidable) and so the initialisation is there to prevent a compiler warning.

There were also a couple of cases I pointed out where the assignment of zero to a pointer variable was actually masking some other bug, and so replacing the assignment with NULL, or removing the initialisation is not necessarily the correct fix.

A script might be useful for identifying potential cases, but I think it is worth looking at each one individually to determine what the correct fix is.

~Ryan

> $ cat multi_set.cocci
> @@
> type T;
> identifier x;
> expression y;
> expression z;
> @@
> -T x = y;
> +T x;
> ...
> x = z
> $
>
> This script has a defect because expression z may
> use identifier x.
>
> Anyway, if the script can be tweaked appropriately,
> it might be useful to remove these unnecessary
> initializations.
>
> cheers, Joe
>

