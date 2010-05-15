Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753456Ab0EOIy6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 04:54:58 -0400
Received: from straum.hexapodia.org ([207.7.131.186]:34828 "EHLO
	straum.hexapodia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753221Ab0EOIy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 04:54:56 -0400
Date: Sat, 15 May 2010 01:54:56 -0700
From: Andy Isaacson <adi@hexapodia.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       intel-gfx@lists.freedesktop.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
	driver
Message-ID: <20100515085456.GB7125@hexapodia.org>
References: <20100510142521.5a705dea@virtuousgeek.org> <20100510142652.12ca0824@virtuousgeek.org> <20100510220046.3f7cd9bf.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100510220046.3f7cd9bf.akpm@linux-foundation.org>
X-GPG-Fingerprint: 1914 0645 FD53 C18E EEEF C402 4A69 B1F3 68D2 A63F
X-GPG-Key-URL: http://web.hexapodia.org/~adi/gpg.txt
X-Domestic-Surveillance: money launder bomb tax evasion
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 10, 2010 at 10:00:46PM -0400, Andrew Morton wrote:
> > +	int i;
> > +	u16 avg;
> > +
> > +	for (i = 0; i < IPS_SAMPLE_COUNT; i++)
> > +		total += (u64)(array[i] * 100);
> 
> Actually, that does work.  Somehow the compiler will promote array[i]
> to u64 _before_ doing the multiplication.  I think.  Still, it looks
> like a deliberate attempt to trick the compiler into doing a
> multiplicative overflow ;)

It seems to promote to int, probably due to the implicit type of
"100".  Aind since array is u16, * 100 can't overflow int.  So yes, it's
safe, but it does catch the eye as potentially unsafe.

> > +		cur_seqno = (thm_readl(THM_ITV) & ITV_ME_SEQNO_MASK) >>
> > +			ITV_ME_SEQNO_SHIFT;
> > +		if (cur_seqno == last_seqno &&
> > +		    time_after(jiffies, seqno_timestamp + HZ)) {
> > +			dev_warn(&ips->dev->dev, "ME failed to update for more than 1s, likely hung\n");
> > +		} else {
> > +			seqno_timestamp = get_jiffies_64();
> > +			last_seqno = cur_seqno;
> > +		}
> > +
> > +		last_msecs = jiffies_to_msecs(jiffies);

Once it triggers, this will print the "likely hung" message every second
until the end of time, won't it?

-andy
