Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932982Ab0KSW2d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 17:28:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44513 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932527Ab0KSW2b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 17:28:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CMUSBNayOE3YLX4PR2wuyE5Ff070xANonDlNHRVQs8k8dCOt66TW4HbIsAMHADNEqk
         EQ/nTwdRDu2oUOhPGuxqKhy4uL3WhdWITeoLrZQ3ZN6jiT58giBWHAstV+N09dDsJGaf
         VRdTK2ZD94jvvoWg78ILxN5AUWD79vNti+zkQ=
Date: Fri, 19 Nov 2010 23:28:23 +0100
From: Michal Januszewski <michalj@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Rolf Eike Beer <eike-kernel@sf-tec.de>, linux-kernel@vger.kernel.org,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>
Subject: Re: abs() vs. abs64() (was: Re: [PATCH] fbdev: fix nearest mode
 search)
Message-ID: <20101119222823.GA28797@quadria>
Reply-To: michalj@gmail.com
References: <AANLkTimYDAJr9x00sjGGnDF2vOVXU12qmbnmfuzA5_0h@mail.gmail.com>
 <20101119140721.33576c61.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20101119140721.33576c61.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 19, 2010 at 02:07:21PM -0800, Andrew Morton wrote:
> On Thu, 18 Nov 2010 07:40:19 +0100
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> > > 'c' will end up with a value of 0xffffffff instead of the expected 0x1.
> > 
> > This happens on 64-bit only, right?

Absolutely, I should have mentioned it in the patch description.

> How does this look?
>
> [..]
> 
> Reported-by: Michal Januszewski <michalj@gmail.com>
> Cc: Rolf Eike Beer <eike-kernel@sf-tec.de
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/kernel.h |   13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff -puN include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit include/linux/kernel.h
> --- a/include/linux/kernel.h~include-linux-kernelh-abs-fix-handling-of-32-bit-unsigneds-on-64-bit
> +++ a/include/linux/kernel.h
> @@ -143,9 +143,16 @@ extern int _cond_resched(void);
>  
>  #define might_sleep_if(cond) do { if (cond) might_sleep(); } while (0)
>  
> -#define abs(x) ({				\
> -		long __x = (x);			\
> -		(__x < 0) ? -__x : __x;		\
> +#define abs(x) ({						\
> +		long ret;					\
> +		if (sizeof(x) == sizeof(long)) {		\
> +			long __x = (x);				\
> +			ret = (__x < 0) ? -__x : __x;		\
> +		} else {					\
> +			int __x = (x);				\
> +			ret = (__x < 0) ? -__x : __x;		\
> +		}						\
> +		ret;						\
>  	})
>  
>  #define abs64(x) ({				\
> _

Looks good to me.  I posted essentially the same thing some 3 months ago
(http://marc.info/?l=linux-kernel&m=128033094822201&w=2) but it then
failed to get any traction.  At any rate, I like your version better as
it seems more readable.

Michal
