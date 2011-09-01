Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1IABiM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:38:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63752 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756900Ab1IABiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:38:07 -0400
Subject: Re: [PATCH 01/24] fix default __strnlen_user macro
From: Mark Salter <msalter@redhat.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 31 Aug 2011 21:38:03 -0400
In-Reply-To: <4E5EC3FE.10307@gmail.com>
References: <1314826019-22330-1-git-send-email-msalter@redhat.com>
	 <1314826019-22330-2-git-send-email-msalter@redhat.com>
	 <4E5EC3FE.10307@gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <1314841084.2344.113.camel@deneb.redhat.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-01 at 09:30 +1000, Ryan Mallon wrote:
> On 01/09/11 07:26, Mark Salter wrote:
> > The existing __strnlen_user macro simply resolved to strnlen. However, the
> > count returned by strnlen_user should include the NULL byte. This patch
> > fixes the __strnlen_user macro to include the NULL byte in the count.
> >
> > Signed-off-by: Mark Salter<msalter@redhat.com>
> > ---
> >   include/asm-generic/uaccess.h |    2 +-
> >   1 files changed, 1 insertions(+), 1 deletions(-)
> >
> > diff --git a/include/asm-generic/uaccess.h b/include/asm-generic/uaccess.h
> > index ac68c99..1d0fdf8 100644
> > --- a/include/asm-generic/uaccess.h
> > +++ b/include/asm-generic/uaccess.h
> > @@ -289,7 +289,7 @@ strncpy_from_user(char *dst, const char __user *src, long count)
> >    * Return 0 on exception, a value greater than N if too long
> >    */
> >   #ifndef __strnlen_user
> > -#define __strnlen_user strnlen
> > +#define __strnlen_user(s, n) (strnlen((s), (n)) + 1)
> >   #endif
> 
> I don't think this is correct because if you hit maxlen you will add one 
> to it. e.g. __strnlen_user("abcd\0", 3) would return 4 instead of 3.

Yes, one would think so, but that doesn't seem to be the case. Looking
at various places that call strnlen_user, you'll find checks for that.
For one example, mm/util.c:

    char *strndup_user(const char __user *s, long n)
    {
	char *p;
	long length;

	length = strnlen_user(s, n);

	if (!length)
		return ERR_PTR(-EFAULT);

	if (length > n)
		return ERR_PTR(-EINVAL);

> 
> It should probably be something like this:
> 
> #define __strnlen_user(s, n) ({		\
> 	size_t k = strnlen(s, n);	\
> 	k<  n ? k + 1 : n; })
> 
> 
> I wonder if this change will break anything since it has been incorrect 
> (according to the comment in uaccess.h at least) for a while. Why does 
> __strnlen_user have different semantics to strnlen anway?

I think the C6X port I'm in the process of pushing upstream is the only
port to actually use the definition in asm-generic/uaccess.h and I can
assure you that the existing definition causes a failure to boot as it
stands. No idea why the semantics are different, but you're not the
first to note that fact. I thought briefly about changing the kernel to
make the strnlen_user have the same semantics as strnlen, but that means
touching every arch, every one of which defines their own. Kinda makes
me feel inadequate for wanting to use the generic one. :)

--Mark


