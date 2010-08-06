Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756945Ab0HFG5w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 02:57:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:59472 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab0HFG5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 02:57:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:in-reply-to:references:user-agent:x-face
         :face:x-url:x-pgp-fp:x-pgp:date:message-id:mime-version:content-type;
        b=RcYObmVNd4WtHuph8lLFPjXumlo2H2uiv59s+rCjw+FIzcHg3v5W50FwYwY5Q6Plve
         c6WwDJFNde75mmEmASSg4nd6337IOhfy5nrO3WIiFJ05nev02s/+aVZLNXdrLptM4n4T
         QDsn7FyYgb1yu35ZzCJdP95FzH3y5VPJs80/0=
From: Michal Nazarewicz <mina86@mina86.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, m.nazarewicz@samsung.com,
        "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] lib: vsprintf: optimised put_dec_trunc() and put_dec_full()
In-Reply-To: <201008060558.59019.vda.linux@googlemail.com> (Denys Vlasenko's
	message of "Fri, 6 Aug 2010 05:58:58 +0200")
References: <f894e94adccb940ef904983fa039a28e12217f48.1280872240.git.mina86@mina86.com>
	<201008060558.59019.vda.linux@googlemail.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Fri, 06 Aug 2010 08:56:52 +0200
Message-ID: <87k4o49qkr.fsf@erwin.mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denys Vlasenko <vda.linux@googlemail.com> writes:

> On Friday 06 August 2010 00:38, Michal Nazarewicz wrote:
>> The put_dec_trunc() and put_dec_full() functions were based on
>> a code optimised for processors with 8-bit ALU but even then
>> they failed to satisfy the same constraints
>
> "Failed"? Interesting wording. Yes, the code won't map easily
> onto 8-bit ALU, for the simple reason Linux kernel
> does not support any 8-bit CPUs, and by going to wider register
> I was able to process 5 decimal digits at once, not 4.
> It was done deliberately. It is not a "failure".

You're probably right. ;) I'll change the wording in the next patch.

> Your code isn't 8-bit ALU optimized either.

Yep, that was not my intention.

> Do you think a bit of smear of previous code
> would help your to be accepted?

I'm sorry if I sounded offencive, I just wanted to point out that we
don't have to and we in fact do not limit ourselves to 8-bit ALUs.

>> and in fact 
>> required at least 16-bit ALU (because at least one number they
>> operate in can take 9 bits).
>
> Yes, as explained above.
>
>> This version of those functions proposed by this patch goes
>> further and uses the full capacity of a 32-bit ALU and instead
>> of splitting the number into nibbles and operating on them it
>> performs the obvious algorithm for base conversion expect it
>> uses optimised code for dividing by ten (ie. no division is
>> actually performed).
>
> (1) "expect" is a typo

Fixed.

> (2) No, _this_ patch does not eliminate division. Next one does.
> Move this part of changelong to the next patch, where it belongs.

Probably right, the part in parens can be misleading.  Will fix.

>> + * Decimal conversion is by far the most typical, and is used for
>> + * /proc and /sys data. This directly impacts e.g. top performance
>> + * with many processes running.
>> + *
>> + * We optimize it for speed using ideas described at
>> + * <http://www.cs.uiowa.edu/~jones/bcd/divide.html>.
>
> Do you have author's permission to do it?
> Document it in the comment please.

OK, I'll send an email to Mr. Jones directly (unless he's actually
reading it, in which case, could you please give permission to use the
code?) In case of this patch I assumed the right to use because: (i) we
had permission for the previous code and (ii) I've used only one line of
code that is from the "Binary to Decimal Conversion in Limited
Precision" website (namely division).  In case of the next patch, only
(i) applies.

>> + * '(num * 0xcccd) >> 19' is an approximation of 'num / 10' that gives
>> + * correct results for num < 81920.  Because of this, we check at the
>> + * beginning if we are dealing with a number that may cause trouble
>> + * and if so, we make it smaller.
>
> This comment needs to be moved to the code line where the opration
> is performed.

Fixed.

>> + * (As a minor note, all operands are always 16 bit so this function
>> + * should work well on hardware that cannot multiply 32 bit numbers).
>> + *
>> + * (Previous a code based on
>
> English is a bit broken in the line above.

Fixed.

-- 
Best regards,                                         _     _
 .o. | Liege of Serenly Enlightened Majesty of      o' \,=./ `o
 ..o | Computer Science,  Michal "mina86" Nazarewicz   (o o)
 ooo +--<mina86-tlen.pl>--<jid:mina86-jabber.org>--ooO--(_)--Ooo--
