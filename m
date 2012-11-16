Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2KPXZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:25:12 -0500
Received: from nm4.access.bullet.mail.sp2.yahoo.com ([98.139.44.131]:28746
	"EHLO nm4.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753653Ab2KPXZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:25:10 -0500
X-Yahoo-Newman-Id: 232361.32378.bm@smtp111.sbc.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Lk2Wtk4VM1mirP4VEbtv3KUrW.VmthExgPdc0r6XypbOPNj
 vjaFB7wCtUQXc5HSsNcWFXE3sI_jAEZNC3tpt5j20CyFR4dlDRBH6cqZmiLV
 D76SQ3aXcsIWZpt82u7QfwPeyvgaFhgMvuGnF119rAa6pHNtTsZrE_CdZ7eY
 KJ1ZnEwA_LQHMGZGu9ixZAUUK6_.yzo_5nzBsil6g95YlQWaIby6fmhU2nt1
 fZbC79JJkf_wGRsI_ra_A01u.QAeCvGyIoxnJAo0Zu49ozuBBnIxDU2Ss8ie
 ZvjXRYG7hKfAY71SCPhMWzltABQAf1At2kCLYK6LkRxxRB3Lk9_6sQRRu08B
 ePokxwRni5gMWizHdqGVpcew0D.o7TjKWts7CEpLaBluR5uyX04LUF9aBMcO
 KHTEwF8xeA2rE9vsTQAGduIfZJkn4Kc9oOsqKsa8ZB_PaBOx69c6dLN...u_
 BDZWeyUk5glzszKNN.xsZkeIcvg--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <50A6CB55.7070706@att.net>
Date: Fri, 16 Nov 2012 17:25:09 -0600
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>, Joe Perches <joe@perches.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v5 9/9] bug.h, compiler.h: Introduce compiletime_assert
 & BUILD_BUG_ON_MSG
References: <1352844568-18826-1-git-send-email-daniel.santos@pobox.com> <1352844821-18952-9-git-send-email-daniel.santos@pobox.com>
In-Reply-To: <1352844821-18952-9-git-send-email-daniel.santos@pobox.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 04:13 PM, danielfsantos@att.net wrote:
> +#define __compiletime_assert(condition, msg, __func)			\
> +	do {								\
> +		bool __cond = !(condition);				\
> +		extern void __func(void) __compiletime_error(msg);	\
> +		if (__cond)						\
> +			__func();					\
> +		__compiletime_error_fallback(__cond);			\
> +	} while (0)
> +
> +#define _compiletime_assert(condition, msg, __func) \
> +	__compiletime_assert(condition, msg, __func)
> +
> +/**
> + * compiletime_assert - break build and emit msg if condition is false
> + * @condition: a compile-time constant condition to check
> + * @msg:       a message to emit if condition is false
> + *
> + * In tradition of POSIX assert, this macro will break the build if the
> + * supplied condition is *false*, emitting the supplied error message if the
> + * compiler has support to do so.
> + */
> +#define compiletime_assert(condition, msg) \
> +	_compiletime_assert(condition, msg, __compiletime_assert_ ## __LINE__)
> +

Whoops, this implementation pastes the tokens before allowing them to
expand, it should be something like this:

#define __compiletime_assert(condition, msg, __func) .... stuff
#define _compiletime_assert(condition, msg, prefix, suffix) \
        __compiletime_assert(condition, msg, prefix ## suffix)
#define compiletime_assert(condition, msg) \
        _compiletime_assert(condition, msg, __compiletime_assert_, __LINE__)

I'll fix that as well.

Daniel
