Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756784Ab1ISWfQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 18:35:16 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59813 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1ISWfN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 18:35:13 -0400
Subject: Re: [RFC][PATCH 1/5] lib: add unpack_hex_byte()
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@google.com>
Cc: linux-security-module@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110919141911.e13569ab.akpm@google.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <20110919141911.e13569ab.akpm@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 18:35:08 -0400
Message-ID: <1316471708.3191.130.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-19 at 14:19 -0700, Andrew Morton wrote:
> On Fri, 16 Sep 2011 08:50:26 -0400
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Since converting 2 ascii hex digits into a byte with error checks
> > is commonly used, we can replace multiple hex_to_bin() calls with
> > a single call to unpack_hex_byte().
> > 
> > Changelog:
> > - Error checking added based on Tetsuo Handa's patch.
> > - Moved the hex2bin code here, making it into a static inline function.
> >   (Andy Shevchenko's request.)
> 
> Why, on earth?  Not for performance reasons - the code is already quite
> inefficient.
> 
> > Signed-off-by: Mimi Zohar <zohar@linux.vnet.ibm.com>
> > ---
> >  include/linux/kernel.h |   21 +++++++++++++++++++++
> >  1 files changed, 21 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index 46ac9a5..d8ea13b 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -385,6 +385,27 @@ extern int hex_to_bin(char ch);
> >  extern void hex2bin(u8 *dst, const char *src, size_t count);
> >  
> >  /*
> > + * unpack_hex_byte - convert 2 asii hex digits into a byte
> > + * @byte: binary result
> > + * @buf: ascii hexadecimal byte string
> > + */
> > +static inline bool unpack_hex_byte(u8 *byte, const char *buf)
> > +{
> > +	int hi, lo;
> > +
> > +	hi = hex_to_bin(buf[0]);
> > +	if (hi < 0)
> > +		return false;
> > +
> > +	lo = hex_to_bin(buf[1]);
> > +	if (lo < 0)
> > +		return false;
> > +
> > +	*byte = (hi << 4) | lo;
> > +	return true;
> > +}
> 
> Putting the return value into *byte is inefficient too - it forces the
> compiler to place the return value into addressible storage (ie: into a
> stack temporary).  Maybe the compiler can avoid doing that if the code
> is inlined, but the code shouldn't be inlined :(

> The return value is undocumented.

Ok, will update.

> Why not copy the hex2bin return value semantics rather than creating a
> new scheme?  Returning "bool false" in response to an error is very
> unconventional and unexpected.  Kernel code returns a negative value on
> error.

ok

> Wouldn't it be better to fix hex2bin() so that it returns -1 on error?

Yes, that was the original idea, but in order to return a result, it
needs to validate the input.  The above code, or something similar,
needs to exist somewhere, either in the new function or in hex2bin().
Would something like this be any better?

int hex2bin(u8 *dst, const char *src, size_t count)
{
	while (count--) {
                int hi = hex_to_bin(*src++);
                int lo = hex_to_bin(*src++);

                if ((hi < 0) || (lo < 0))
                        return -1;

                *dst++ = (hi << 4) | lo;
        }
	return 0;
}


> Then the above function becomes a one-liner:
> 
> 	return hex2bin(dst, src, 2);

Why bother?  With something like this, there isn't a need for the new
function.  :-)

> Finally, the name is poor.  It starts with "unpack_", so it belongs to
> the "unpack" subsystem.  There's no such thing.  Something like
> hex_byte_to_bin() would be better.

agreed.  It was suppose to parallel the existing pack_hex_byte().

Mimi

