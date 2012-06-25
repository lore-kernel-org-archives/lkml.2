Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756040Ab2FYTha (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 15:37:30 -0400
Received: from nm35-vm7.bullet.mail.bf1.yahoo.com ([72.30.238.79]:34539 "HELO
	nm35-vm7.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750820Ab2FYTh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 15:37:29 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 25 Jun 2012 15:37:29 EDT
X-Yahoo-Newman-Id: 387948.53958.bm@omp1007.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 6z0JF4QVM1mNLJAD8d1ucI.TDTpjdDcHlOfcJ4xOjG2nIJg
 TY9X1YDY.Taxt38axFS2eaAvhr1VdQquMEykMI1QqlH4l0GkjX0C66v4nRu5
 JyMumNA4t2HYTrynP15hGXusCpgb8sf9XLr8_BdHNDSKwR0wD5hmDTX0Hhb6
 XRbZdBpUWSVUqP5R_gNYrYYpviu3o3J8OAPJjxwHdb6e56T.HzGOL3wFszFc
 .l2flKM99OzfXngNPsVhdRh43fy6upbDy.P6Bh8o903I4PiWKGab7CV21h7R
 E_PcFwJ2O9ns9lb3Oz26gksO3ANbMx3VTIPTvEx8ofADUN9tLTqNFiA.btk5
 S9KbZmAp1DgOBRYv6ZVqNGVh8aNBam0UlV54.G2iQed37SH0UEYkm2fV9BJt
 HCVpzytc-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <4FE8BC69.7000104@att.net>
Date: Mon, 25 Jun 2012 14:30:49 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: daniel.santos@pobox.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-doc@vger.kernel.org, linux-sparse@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Weinberger <richard@nod.at>, Rob Landley <rob@landley.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH v4 6/13] bug.h: Replace __linktime_error with __compiletime_error
References: <1340424048-7759-1-git-send-email-daniel.santos@pobox.com> <1340424048-7759-7-git-send-email-daniel.santos@pobox.com> <4FE8AAFC.1080306@windriver.com>
In-Reply-To: <4FE8AAFC.1080306@windriver.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25/2012 01:16 PM, Paul Gortmaker wrote:
>
> At a quick glance of the bug.h parts, I would think you need
> this commit _before_ #5 (that deleted __linktime_error) otherwise
> you'll have introduced a bisection build failure.  Or, alternatively
> you could combine #5 and #6 since they are clearly related, and
> their separation is more of a per-file CVS mentality than it is of
> any existence of distinct and separate/unrelated changesets.
>
> P.
Thanks, will do.

And after I thought about this more, I realized that both
__build_bug_failed and __build_bug_on_failed could just be declared
globally rather than being part of the macro. It may not be that big of
a deal, but it would reduce the size of pre-processed files at least
(something I look at a lot working with this patch set). But I'll let
you make the final call on that one

Oh, and as it turns out, adding the string-ized condition in the
BUILD_BUG_ON macro is useless (actually confusing) since gcc takes the
attributes of the first occurrence of an externed function in a
translation unit. Thus, the following code:

#include <linux/bug.h>
void func(void)
{
const int a = 0;
BUILD_BUG_ON(a == 1);
BUILD_BUG_ON(1) ;
}

would result in the error message:

call to ‘__build_bug_on_failed’ declared with attribute error:
BUILD_BUG_ON failed: a == 1

At least the line number is correct however. So my "declare a function
multiple times with with differing attributes" turns out to not work right.

