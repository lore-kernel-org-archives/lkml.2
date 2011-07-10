Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939Ab1GJUXW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 16:23:22 -0400
Received: from dc.minian.org ([83.96.227.90]:52977 "EHLO dc.minian.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab1GJUXV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 16:23:21 -0400
Message-ID: <4E1A0A2F.6050800@minian.org>
Date: Sun, 10 Jul 2011 22:23:11 +0200
From: Edwin van Vliet <edwin@minian.org>
Organization: Minian
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: apw@canonical.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: added test for repeated lines
References: <1310321889-25943-1-git-send-email-edwin@cheatah.nl> <1310323798.3848.48.camel@Joe-Laptop>
In-Reply-To: <1310323798.3848.48.camel@Joe-Laptop>
X-Enigmail-Version: 1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10-7-2011 20:49, Joe Perches wrote:
> On Sun, 2011-07-10 at 20:18 +0200, Edwin van Vliet wrote:
>> Repeated lines may indicate a bug or code that needs clarification. If the
>> repeated line is intentional, an extra comment may be helpful for reviewers
>> since the repeated pattern is likely to draw attention.
> []
>> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> []
>> @@ -1479,6 +1479,11 @@ sub process {
>> +# check for repeated lines which may indicate bugs or lack of clarity
>> +		if ($rawline eq $prevrawline) {
>> +			WARN("repeated line\n" . $herecurr);
>> +		}
>> +
> 
> Interest concept, but I think it needs to check for
> comment lines and blank lines and such.
> 
> Also, there are uses of appropriate multiple close braces
> on consecutive lines like:
> 
> 	switch (foo) {
> 	case bar: {
> 		etc...
> 	}
> 	}

You might be correct about empty lines and comment lines, but there are
actually very few reasons to have a repeated line. Your example is a
good one, I actually ran a script on the entire kernel source, there are
now exactly 9271 occurances of repeated lines in all .c files, and a
double closing bracket on the same position occurs 147 times, which is
not very often.

Repeated lines draw (my) attention, and are likely to confuse. Even
empty lines and empty comment lines take up space, which means less code
is displayed on a screen.

Do you reckon this test would lead to programmers trying to "fool" the
test and actually insert extra tabs to work around it? It's only a
warning, just like there are for lines over 80 characters long.

If the final goal of the checkpatch.pl script is for the entire kernel
source code to not generate any warnings at all, then why are they only
warnings and not errors?

I understand your concerns and agree this might need a little testing
but still this may be helpful to spot comment junk like in
drivers/usb/serial/io_edgeport.c or the obvious double define error in
drivers/infiniband/hw/qib/qib_iba7322.c.
Or the undesired triple assignment in drivers/staging/bcm/nvm.c, since
psFlash2xBitMap->Reserved0 = 0; being called only once is quite enough,
and actually I think it's a possible bug which can happen if a
programmer copies a line a few times and thereafter alter them a little
bit, which in this case was probably forgotten.

Please have a look at fs/sync.c and look for "sync_filesystems(0)". It's
repeated twice, but right above two lines of comment clarify why this is
done. That's exactly what I think is necessary.
Now have a look at drivers/media/dvb/frontends/nxt200x.c and look for
"nxt200x_microcontroller_stop(state)" being repeated. I think this code
needs exactly the same kind of comment. Was the function being called
twice intentional? If so, then why? Or is it a bug?

Sure, double #endif's and closing brackets will cause a warning, quite a
number of false positives are inevitable. But it will hopefully help to
prevent or spot errors too, and it might lead to better documentation of
certain routines as well.

On the other hand, double closing brackets caused by wrong indentation
would have been spotted by another test, so you might be right to make a
few exceptions (closing bracket, #endif?).
