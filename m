Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291Ab2EVT2x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 15:28:53 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:62143 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760238Ab2EVT2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 15:28:52 -0400
X-IronPort-AV: E=Sophos;i="4.75,639,1330905600"; 
   d="scan'208";a="12611924"
Message-ID: <1337714930.3991.1.camel@dagon.hellion.org.uk>
Subject: RE: [PATCH] xen/netback: calculate correctly the SKB slots.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Simon Graham <simon.graham@citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Adnan Misherfi <adnan.misherfi@oracle.com>
Date: Tue, 22 May 2012 20:28:50 +0100
In-Reply-To: <F02ED76F3FCF8C468AD22A7618C05BBBB18DBFFE61@FTLPMAILBOX01.citrite.net>
References: <1337621793-12486-1-git-send-email-konrad.wilk@oracle.com>
	 <1337627640.2979.33.camel@bwh-desktop.uk.solarflarecom.com>
	 <1337678512.10118.40.camel@zakaz.uk.xensource.com>
	 <20120522180901.GC22488@phenom.dumpdata.com>
	 <F02ED76F3FCF8C468AD22A7618C05BBBB18DBFFE61@FTLPMAILBOX01.citrite.net>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-05-22 at 20:01 +0100, Simon Graham wrote:
> > >
> > > > >  	int i, copy_off;
> > > > >
> > > > >  	count = DIV_ROUND_UP(
> > > > > -			offset_in_page(skb->data)+skb_headlen(skb),
> > PAGE_SIZE);
> > > > > +			offset_in_page(skb->data + skb_headlen(skb)),
> > PAGE_SIZE);
> > > >
> > > > The new version would be equivalent to:
> > > > 	count = offset_in_page(skb->data + skb_headlen(skb)) != 0;
> > > > which is not right, as netbk_gop_skb() will use one slot per page.
> > >
> > > Just outside the context of this patch we separately count the frag
> > > pages.
> > >
> > > However I think you are right if skb->data covers > 1 page, since the
> > > new version can only ever return 0 or 1. I expect this patch papers
> > over
> > > the underlying issue by not stopping often enough, rather than
> > actually
> > > fixing the underlying issue.
> > 
> > Ah, any thoughts? Have you guys seen this behavior as well?
> 
> We ran into this same problem and the fix we've been running with for
> a while now (been meaning to submit it!) is:
> 
> diff --git a/drivers/net/xen-netback/netback.c b/drivers/net/xen-netback/netback.c
> index c2669b8..7925bd3 100644
> --- a/drivers/net/xen-netback/netback.c
> +++ b/drivers/net/xen-netback/netback.c
> @@ -312,8 +312,7 @@ unsigned int xen_netbk_count_skb_slots(struct xenvif *vif, struct sk_buff *skb)
>         unsigned int count;
>         int i, copy_off;
> 
> -       count = DIV_ROUND_UP(
> -                       offset_in_page(skb->data)+skb_headlen(skb), PAGE_SIZE);
> +       count = DIV_ROUND_UP(skb_headlen(skb), PAGE_SIZE);
> 
>         copy_off = skb_headlen(skb) % PAGE_SIZE;
> 
> The rationale for this is that if the header spanned a page boundary,
> you would calculate that it needs 2 slots for the header BUT
> netback_gop_skb copies the header into the start of the page so only
> needs one slot (and only decrements the count of inuse entries by 1).

That sounds very plausible indeed!

Please can format this as a commit message and resend with a
Signed-off-by.

many thanks,
Ian.

> 
> We found this running with a VIF bridged to a USB 3G Modem where
> skb->data started near the end of a page so the header would always
> span the page boundary.
> 
> It was very easy to get the VIF to stop processing frames with the old
> code and we have not seen any problems since applying this patch.
> 
> Simon
> 


