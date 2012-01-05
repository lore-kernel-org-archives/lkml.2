Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933008Ab2AEWrA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 17:47:00 -0500
Received: from mail.windriver.com ([147.11.1.11]:56104 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932235Ab2AEWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 17:46:59 -0500
Message-ID: <4F062846.50804@windriver.com>
Date: Thu, 5 Jan 2012 16:46:30 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        =?ISO-8859-1?Q?Am=E9rico_?= =?ISO-8859-1?Q?Wang?= 
	<xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] Correctly deal with make that has an argument which contains
 an "s"
References: <1272315374-11951-1-git-send-email-jason.wessel@windriver.com> <4BD6CECC.9080507@suse.cz>
In-Reply-To: <4BD6CECC.9080507@suse.cz>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/mixed;
	boundary="------------010501000307000409010403"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------010501000307000409010403
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit

On 04/27/2010 06:47 AM, Michal Marek wrote:
> On 26.4.2010 22:56, Jason Wessel wrote:
>> When using remake, which is based on gnumake, if you invoke
>> an example build as shown below, the build will become silent
>> due to the top level make file incorrectly guessing that
>> the end user wants a silent build because an argument that
>> contained an "s" was used.
>>
>> remake --no-extended-errors
> 
> BTW, make --warn-undefined-variables also triggers this (although no one
> will use this option on the kernel makefiles).
> 

Might as well add it to the commit header for clarity. 

>>  
>> -ifneq ($(findstring s,$(MAKEFLAGS)),)
>> +ifneq ($(filter s% -s% --silent --quiet,$(MAKEFLAGS)),)
> 
> I played a bit with GNU make 3.81. Checking for --silent and --quiet is
> not necessary, because make always stores the short option if available.
> Now I was wondering if the 's' option is always at the beginning,
> looking at make-3.81/main.c, it turns out that the order in which the
> options appear in $(MAKEFLAGS) is the reverse order of the switches
> array, where 's' is near the end of the array:
> 
[clip]
> 
> The only other single-letter options that come after 's' (before 's' in
> the $(MAKEFLAGS) variable) are 't', which doesn't work with the kernel,
> and 'w', which doesn't work either (the Makefile adds
> --no-print-directory). So we can indeed get away with s% and -s% (until
> the next make version changes the sort order, that is ;)).
> 

This might be nearly a whole year later, but the problem is still there so perhaps we can reach some closure and get it fixed since it is fairly minor in the first place.  :-)

Version 2 of the original patch is attached.

Thanks,
Jason.

--------------010501000307000409010403
Content-Type: text/x-diff;
	name="0001-Correctly-deal-with-make-that-has-an-argument-which-.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename*0="0001-Correctly-deal-with-make-that-has-an-argument-which-.pa";
	filename*1="tch"

From: Jason Wessel <jason.wessel@windriver.com>
Date: Thu, 5 Jan 2012 16:43:09 -0600
Subject: [PATCH] Correctly deal with make that has an argument which contains
 an "s"

When using remake, which is based on gnumake, if you invoke
an example build as shown below, the build will become silent
due to the top level make file incorrectly guessing that
the end user wants a silent build because an argument that
contained an "s" was used.  Here are two examples one with remake
and one with straight gnumake.

remake --no-extended-errors
make --warn-undefined-variables

Fix up the top level Makefile to use filter to parse the options
that mean silent instead of findstring catching other random
arguments containing an "s".

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
CC: Michal Marek <mmarek@suse.cz>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kbuild@vger.kernel.org
---
 Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index adddd11..4b8ae04 100644
--- a/Makefile
+++ b/Makefile
@@ -312,7 +312,7 @@ endif
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
 
-ifneq ($(findstring s,$(MAKEFLAGS)),)
+ifneq ($(filter s% -s%,$(MAKEFLAGS)),)
   quiet=silent_
 endif
 
-- 
1.7.5.4


--------------010501000307000409010403--
