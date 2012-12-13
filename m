Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755395Ab2LMVUM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 16:20:12 -0500
Received: from nm27.access.bullet.mail.mud.yahoo.com ([66.94.237.92]:29858
	"EHLO nm27.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752978Ab2LMVUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 16:20:11 -0500
X-Yahoo-Newman-Id: 802513.96350.bm@smtp110.sbc.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: uUwkPEkVM1k4UGwVuIbu_7YIDDxDOhBz_qmkwy5NdQ0NlZQ
 ZTD0KDYPoBpglW1p7UyJ6jVAlQLpvRvEwz.7UiU01mzfqa2UWIjJe5vQU3tY
 NVG_gStCv.QznhNFImK8dt3FBWPnfGVne58yTNHnl9JJBz6PlF08hhPRQMIR
 cRG8_lilGM_Zx0b63T3TYd8OAwSSM9dj2wu.rB8Kqd18qC55yGIVFEPIKYTY
 hm1zuwlnIzXdws8IxQlGG4eFzTrLPSl2jhVEMMy5jIi_p_s7nzXGIeacqWQt
 HQpa5q.jXe1KNUwvBIHiBuvnERdQRbO8Sbp9D..q8KSaOAmAc7jiJKQE9yT8
 n8lhirEQtkWKtJaz2jyG1DPYcd106HquDQDbVVdEJsvYz8kGfkIRrfwT0eho
 NjeCKdkDS.4HZM_h1AxHuI.oyCPvAlCoa2o4_p.4yMJXyQxq9wBoCITvRfS8
 zZvyWE8UeD6yZyiYyeO4dHkdkCiNuSS5WgV.U1T8JruqOjWgD506M2c1mJZe
 bII.7RgUY7L5B3e2RUjHF1dnj1A64gXPRdZGZ0ARvD6NtXO0mcYFaFkbM5oL
 vL72uhGJbIX0DxSXc6O6aeK_SeL07uwg.84Mo_qFc0DvoRo5FVwjdmmnO0w0
 D
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50CA468D.2020403@att.net>
Date: Thu, 13 Dec 2012 15:20:13 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121128 Thunderbird/10.0.11
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Daniel Santos <daniel.santos@pobox.com>,
        Rusty Russell <rusty@rustcorp.com.au>, david.daney@cavium.com,
        kosaki.motohiro@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utilize _Static_assert() for BUILD_BUG_ON() when the
 compiler supports it
References: <5093EB1C02000078000A61D7@nat28.tlf.novell.com> <20121105142944.7b16e6a4.akpm@linux-foundation.org> <877gpz5wi4.fsf@rustcorp.com.au> <5098E50402000078000A698C@nat28.tlf.novell.com> <87ehk6443a.fsf@rustcorp.com.au> <509A245202000078000A6E8F@nat28.tlf.novell.com> <87zk2t2dzp.fsf@rustcorp.com.au> <50C9217B.1010801@att.net> <50C9B14602000078000B00C3@nat28.tlf.novell.com>
In-Reply-To: <50C9B14602000078000B00C3@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 03:43 AM, Jan Beulich wrote:
>>>> On 13.12.12 at 01:29, Daniel Santos<danielfsantos@att.net>  wrote:
>> Wow, it's really easy to miss parallel development on the same issue.
>> Sorry for my late response to this thread.  I started another thread
>> addressing these issues (as well as a few others) back in September
>> (https://lkml.org/lkml/2012/9/28/1136).  I've finally gotten ACKs from
>> maintainers with v6 of the patches (here
>> https://lkml.org/lkml/2012/11/20/621) and I'm just waiting for 3.8-rc1
>> to re-submit them.  I actually submitted these patches back in June as
>> part of a larger patch set, but broke it apart in September (I had way
>> to many changes for one patch set)
> Since yours is apparently ready to go in, but doesn't use
> _Static_assert, I guess I'll wait for it to appear until I re-work
> whatever might be left to actually make use of _Static_assert.
>
> Jan
>
Interesting! They've enabled it by default (I suppose as an extension?) 
in every standard (except -pedantic of course). One minor draw-back is 
that it appears to enjoy escaping tickmarks in the error message.  I've 
opened a bug for it (http://gcc.gnu.org/bugzilla/show_bug.cgi?id=55678)

But realistically, the "compiletime_assert" macro I wrote in compiler.h 
can be renamed to "static_assert", analogous to C11's static_assert from 
assert.h (§7.2 of C11) and it can expand to the _Static_assert keyword, 
when that is available.

Something else that I didn't consider too much before was support for 
compiling -O0 or -O1, which will cause many expressions that are 
otherwise evaluated as compile-time constants to become non-constant and 
result in failed assertions.  This isn't anything new however, building 
-O0 has been broken for quite some time, but I presume it could help 
some development of out of tree modules.

