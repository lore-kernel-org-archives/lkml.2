Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab0LPCeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 21:34:46 -0500
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:46750 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754953Ab0LPCeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 21:34:44 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAIYHCU15Lc+z/2dsb2JhbACkM3TBfIVKBA
Date: Thu, 16 Dec 2010 13:34:38 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Tony Luck <tony.luck@intel.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Message-ID: <20101216023438.GA3216@amd>
References: <20101209070938.GA3949@amd>
 <AANLkTim=Hd_xhk4egrTq96rk0eCQRWOxEjcfxM53HwXq@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTim=Hd_xhk4egrTq96rk0eCQRWOxEjcfxM53HwXq@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 03:09:26PM -0800, Tony Luck wrote:
> On Wed, Dec 8, 2010 at 11:09 PM, Nick Piggin <npiggin@kernel.dk> wrote:
> > +static inline int dentry_memcmp(const unsigned char *cs,
> > +                               const unsigned char *ct, size_t count)
> > +{
> > +       while (count) {
> > +               int ret = (*cs != *ct);
> > +               if (ret)
> > +                       return ret;
> > +               cs++;
> > +               ct++;
> > +               count--;
> > +       }
> > +       return 0;
> > +}
> 
> Since you are proposing a routine that only compares file
> names - I wonder whether it would be faster to start at the
> end and work backwards? If the filenames are the same,
> it makes no difference - you have to look at all the bytes.
> But if they are different you might bail out earlier. There
> are many applications that stick a common prefix onto
> the start of filenames (just look in "/lib" !), but I think it is
> less common to add a suffix (longer than "." single letter).

That's true, and an interesting point. However I have managed to fit
the first 8 bytes of the name (in the case of shortnames) into the
same single dentry cacheline that is used for path walking. So that
might negate some of the benefits of walking backwards.

I would encourage anybody to grab the branch and try out any tweaks,
though...

