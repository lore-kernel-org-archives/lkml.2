Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab0K0M5x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 07:57:53 -0500
Received: from solo.fdn.fr ([80.67.169.19]:41244 "EHLO solo.fdn.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984Ab0K0M5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 07:57:51 -0500
Date: Sat, 27 Nov 2010 13:57:42 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: microcai@fedoraproject.org
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        brad@neruo.com
Subject: Re: [PATCH] Kernel fbcon UNICODE font support
Message-ID: <20101127125742.GD4865@const.famille.thibault.fr>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	microcai@fedoraproject.org, torvalds@linux-foundation.org,
	linux-kernel@vger.kernel.org, brad@neruo.com
References: <1290750825.2372.59.camel@cai.gentoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1290750825.2372.59.camel@cai.gentoo>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Microcai, le Fri 26 Nov 2010 13:53:45 +0800, a écrit :
>  I know there are most people speaking only English, and never meet
> non-ASCII characters on console. But, hey , what about others ?

Well, you can't deny that there _is_ some support for non-ASCII. But
just at most 512 glyphs and single width, indeed.

>  The first thing I need to handle is that, currently there is no room
> for adding UNICODE font, only 8bit for characters, how can you do?

(or 9bit, but no more indeed)

>  Also , some characters are double-width. So the solution is  make an
> backing store. 0xFE and 0xFF stands for character value store else
> where, and 0xFF means , left-half of the else where character, and 0xFE
> means right-half of the else where character. 
> 
>  This is a basic solution, the best is that making vc->vc_screenbuf
> store full UNICODE/attribute value, But changing it may break some
> drivers, so , currently I won't try that way. 

I'd much prefer the full unicode way, however.  Trying to hack around
with 0xFE/0xFF will just bring hard-to-fix bugs, while it's quite easy
to make sure we capture not-up-to-date drivers by changing field names
for instance.  I'd say we should first do that, and then it'll be
easy to move the old vgaposition/glyph translation cruft into the few
drivers that need it.  Yes, this seems to be the hard way.  But that's
the short-term hard then mid-term easy way, which is way easier to
accept than the short-term easy then mid/long-term tedious way that you
propose.

> The UNICODE font just too large to be included in e-mail, please follow

There is no way we want to include a big unicode font in the kernel :)

> In future, we don't have to compile  that big font into kernel, we
> should use setfont to load UNICODE font.

Yes.

> But, .psf does not support that much charcount (or maybe yes, and  I
> need some search? )

That's just a matter of fixing tools: the newer version of the psf
format already supports 2^16 glyphs.

> So, here is the patch that add UNICODE font handling functionary.

I've just had a quick glance over it, and there are quite a few things
that bother me, including:

> @@ -296,6 +295,8 @@ int set_selection(const struct tiocl_selection
> __user *sel, struct tty_struct *t
>  			}
>  			obp = bp;
>  		}
> +		if (c > 0x80)
> +			i += 2;
>  	}
>  	sel_buffer_lth = bp - sel_buffer;
>  	return 0;

That is the kind of hack that really shows your current approach will
most probably just bring us bugs.

> @@ -2171,6 +2205,8 @@ static int do_con_write(struct tty_struct *tty,
> const unsigned char *buf, int co
>  		rescan = 0;
>  		inverse = 0;
>  		width = 1;
> +		vc->vc_utf = 1;

?!
There is now way we can accept to systematically switch to utf-8.

> -		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size, GFP_NOWAIT);
> +		vc->vc_screenbuf = kzalloc(vc->vc_screenbuf_size * 2, GFP_NOWAIT);

With a proper switch to a "unicode character" type, this would rather be
"* sizeof(something)", so that choosing between 16bit unicode and 32bit
unicode would even be trivial.

Samuel
