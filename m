Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab2DWSS6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:18:58 -0400
Received: from mx.scalarmail.ca ([98.158.95.75]:33997 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752687Ab2DWSS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:18:57 -0400
Date: Mon, 23 Apr 2012 14:18:53 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Add kabs()
Message-ID: <20120423181853.GA13863@elliptictech.com>
References: <20120423131106.GA27574@p183.telecom.by>
 <20120423132206.GA2516@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423132206.GA2516@p183.telecom.by>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-23 16:22 +0300, Alexey Dobriyan wrote:
> There is abs() and abs64().
> They have following unwanted or suprising properties:
[...]
> 2) In finest Unix tradition they do not work reliably.
>    Quoting abs(3).
> 	"Trying to take the absolute value of the most negative integer is not defined."

Unforunately, your version does not actually fix this problem,
because...

> +#define kabs(x)								\
> +({									\
> +	typeof(x) _x = (x);						\
> +									\
[...]
> +		__builtin_types_compatible_p(typeof(_x), int),		\
> +		(unsigned int)({ _x < 0 ? -_x : _x; }),			\

... here, if x == INT_MIN, then evaluating -x results in signed overflow
and thus undefined behaviour.  The problem is that the conversion to
unsigned int happens too late.

It needs to be (untested):

  _x == INT_MIN ? (unsigned)_x : (unsigned)(_x < 0 ? -_x : _x)

This version assumes a couple things about the representation of
signed/unsigned types, in particular that INT_MIN is exactly one less
than -INT_MAX, and that UINT_MAX is exactly one more than 2u*INT_MAX.
I presume this is true for everything that Linux targets.

Ditto for the other types, although types "smaller" than int will be
promoted to int before being negated, so the overflow probably won't
happen for them.

[...]
> +	_x))))));							\
> +})

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

