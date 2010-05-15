Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab0EOQ3g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 May 2010 12:29:36 -0400
Received: from cpoproxy2-pub.bluehost.com ([67.222.39.38]:60486 "HELO
	outbound-mail-158.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752930Ab0EOQ3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 May 2010 12:29:35 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Ed34jTZNfIr9jZI4T2StIGPYiIqP+yJ14Nqg8P6lUQ6/Har6asUZtQyk9qVQz0I9xmttBcCKF/kmRJYX51Lohz9zf/pgKnOAaIjTEjTvdrm+6S51DYKhbuCZRd5GGNcp;
Date: Sat, 15 May 2010 09:29:08 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Andy Isaacson <adi@hexapodia.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       intel-gfx@lists.freedesktop.org, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 2/2] x86 platform driver: intelligent power sharing
 driver
Message-ID: <20100515092908.02cc71ba@blake>
In-Reply-To: <20100515085456.GB7125@hexapodia.org>
References: <20100510142521.5a705dea@virtuousgeek.org>
	<20100510142652.12ca0824@virtuousgeek.org>
	<20100510220046.3f7cd9bf.akpm@linux-foundation.org>
	<20100515085456.GB7125@hexapodia.org>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010 01:54:56 -0700
Andy Isaacson <adi@hexapodia.org> wrote:

> On Mon, May 10, 2010 at 10:00:46PM -0400, Andrew Morton wrote:
> > > +	int i;
> > > +	u16 avg;
> > > +
> > > +	for (i = 0; i < IPS_SAMPLE_COUNT; i++)
> > > +		total += (u64)(array[i] * 100);
> > 
> > Actually, that does work.  Somehow the compiler will promote
> > array[i] to u64 _before_ doing the multiplication.  I think.
> > Still, it looks like a deliberate attempt to trick the compiler
> > into doing a multiplicative overflow ;)
> 
> It seems to promote to int, probably due to the implicit type of
> "100".  Aind since array is u16, * 100 can't overflow int.  So yes,
> it's safe, but it does catch the eye as potentially unsafe.

Newest version uses do_div, I think I got it right there.

> 
> > > +		cur_seqno = (thm_readl(THM_ITV) &
> > > ITV_ME_SEQNO_MASK) >>
> > > +			ITV_ME_SEQNO_SHIFT;
> > > +		if (cur_seqno == last_seqno &&
> > > +		    time_after(jiffies, seqno_timestamp + HZ)) {
> > > +			dev_warn(&ips->dev->dev, "ME failed to
> > > update for more than 1s, likely hung\n");
> > > +		} else {
> > > +			seqno_timestamp = get_jiffies_64();
> > > +			last_seqno = cur_seqno;
> > > +		}
> > > +
> > > +		last_msecs = jiffies_to_msecs(jiffies);
> 
> Once it triggers, this will print the "likely hung" message every
> second until the end of time, won't it?

The ME should eventually reset itself, but in the interim we can't
trust its data.  So I should add some better handling for that case
(e.g. disable turbo); however this was more of a debug feature for
early MEs, I don't think it'll happen on production hardware.

Jesse
