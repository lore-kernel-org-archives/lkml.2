Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab1JRIhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:37:00 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:25035 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab1JRIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:36:58 -0400
X-IronPort-AV: E=Sophos;i="4.69,364,1315180800"; 
   d="scan'208";a="8437877"
Subject: Re: [PATCH] Fix guest memory leak and panic
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Krishna Kumar <krkumar2@in.ibm.com>
CC: "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "mst@redhat.com" <mst@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Date: Tue, 18 Oct 2011 09:36:56 +0100
In-Reply-To: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com>
References: <20111018080523.16861.55402.sendpatchset@krkumar2.in.ibm.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1318927016.16132.49.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 09:05 +0100, Krishna Kumar wrote:
> The extra reference to the fragment pages causes those pages to
> not get freed in skb_release_data(). The following patch fixes
> the bug. I have not checked if any other converted driver has
> the same issue.

Damn. You are completely correct and I appear to have made this same
mistake several times. A quick look suggests that at least cxbg,
myriage, vmxnet, cassini and bnx2 may potentially have a similar
issue :-( (I stopped looking at that point, I'll obviously do a full
audit).

I considered quite carefully whether (__)skb_frag_set_page should take a
reference or not and decided yes but I'm starting to reconsider whether
I made the right choice. It seems that is just confusing and violates
the principal of least surprise to have a function called "set" take a
new reference. In reality all existing drivers expect that adding a page
to an SKB frag will just take over the existing reference.

I think the best thing might be to remove the additional ref taking from
the setter function and audit the previous changes to ensure they
conform. I'll do that right away and post a fixup patch ASAP.

> Signed-off-by: Krishna Kumar <krkumar2@in.ibm.com>

This change is correct as things stand today, so:

Acked-by: Ian Campbell <ian.campbell@citrix.com>

but perhaps it would be better to hold off and let me fix all of these
all at once.

Thanks for bringing this to my attention Krishna.

Ian.


