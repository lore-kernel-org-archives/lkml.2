Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab2KDWZx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 17:25:53 -0500
Received: from science.horizon.com ([71.41.210.146]:37594 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751769Ab2KDWZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 17:25:50 -0500
Date: 4 Nov 2012 17:25:48 -0500
Message-ID: <20121104222548.20107.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, andrei.emeltchenko@intel.com,
        andriy.shevchenko@linux.intel.com, jbeulich@suse.com,
        linux-kernel@vger.kernel.org, linux@horizon.com, namit2010@gmail.com
Subject: Re: [PATCH] Lib:The patch include fix for "-" during string to long conversion
In-Reply-To: <CAKMXDJXssksA0dtyfe5dTt0RerZzTWOORWCZCZdJF7WAp56=Ng@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namit Gupta <namit2010@gmail.com> wrote:
> API simple_strtol() and simple_strtoul() are giving incorrect result for
> string "-".
> These API's consider "-" as a '-' (negative integer) and return incorrect
> string pointer.
> The API returns pointer next to '-' character. However it should return
> starting pointer of the string.
> Below I have included possible solution for that issue.
> Please review.

tl;dr: Interesting issue.  Arguably, but not toally clear that, this is
a bug.  However, the proposed fix is broken; better fix below.


Just to clarify, the issue is that when fed the string "-", simple_strtol
is setting endp to cp+1 (and returning 0).  I don't think there's actually
anything wrong with simple_strtoul; did you mean simple_strtoull()?

glibc's strtol, for example, returns 0 digits converted when fed strings
that consist of a valid prefix (whitespace plus optional sign) if not
followed by valid digits.  (I just checked.)

If you want to follow C89 exactly (even though, by not permitting leading
whitespace or + signs, simple_strtol() obviously *doesn't*), returning
*endp = cp is required.  The question is what simple_strtol *should* do.

C89 talks about breaking the input into leading whitespace, a "subject
sequence" of characters beginning with the first non-whitespace, and a
final string of unrecognized characters.

Then C89 defines the "expected form" of the subject sequence as "that
of an integer constant as described in §3.1.3.2, optionally preceded by
a plus or minus sign, but not including an integer suffix."  The grammar
in the given section does not permit 0-length strings.

(The above is if base=0; if base != 0, the validity of 0-length
strings is not clear.)

Finally, we get to:
#    If the subject sequence is empty or does not have the expected
# form, no conversion is performed; the value of nptr is stored in the
# object pointed to by endptr, provided that endptr is not a null
# pointer.

Thus, since "-" is not of the expected form, *endp = cp is required.


The question is whether a "simple_" variant should be expected to do
lookahead like this, or if it should just do what the strtol man page
says: "strtol() stores the address of the first invalid character in
*endptr."

An important point is that lookahead already exists in the handling of
"0x" prefixes.  "0x0" through "0xf" are valid hex numbers, but "0xg"
and the like are 1-digit numbers followed by an unparsed string.
(See _parse_integer_fixup_radix() in lib/kstrtox.c.)


Independent of the above discussion, the proposed fix is definitely
not okay.  If you're going to consider this a bug, fix it properly
and also return 0 for "-z" as well; don't special-case the NUL byte.

It's awkward to do by pre-validating cp[1], because the range of valid
digits depends on the base.  A simpler fix would let simple_strotul make
that determination:

long simple_strtol(const char *cp, char **endp, unsigned int base)
{
	long l;

	if (cp[0] != '-')
		return simple_strtoul(cp, endp, base);
	l = -simple_strtoul(cp+1, endp, base);
	/* Return 0 digits converted if - sign is followed by 0 valid digits */
	if (endp && *endp == cp+1)
		*endp = cp;
	return l;
}

(Signed-off-by: George Spelvin <linux@horizon.com> if anyone wants to
copy this logic to simple_strtoll and turn it into a proper patch.)
