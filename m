Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1EEMkC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:40:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58777 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753901Ab1EEMkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:40:00 -0400
Date: Thu, 5 May 2011 08:39:59 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, Markus Trippelsdorf <markus@trippelsdorf.de>,
        Bruno Pr?mont <bonbons@linux-vserver.org>, xfs-masters@oss.sgi.com,
        xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>,
        Alex Elder <aelder@sgi.com>, Dave Chinner <dchinner@redhat.com>
Subject: Re: 2.6.39-rc3, 2.6.39-rc4: XFS lockup - regression since 2.6.38
Message-ID: <20110505123959.GA21098@infradead.org>
References: <20110423224403.5fd1136a@neptune.home>
 <20110427050850.GG12436@dastard>
 <20110427182622.05a068a2@neptune.home>
 <20110428194528.GA1627@x4.trippels.de>
 <20110429011929.GA13542@dastard>
 <20110504005736.GA2958@cucamonga.audible.transient.net>
 <20110505002126.GA26797@dastard>
 <20110505022613.GA26837@dastard>
 <20110505122117.GB26837@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505122117.GB26837@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The third problem is that updating the push target is not safe on 32
> bit machines. We cannot copy a 64 bit LSN without the possibility of
> corrupting the result when racing with another updating thread. We
> have function to do this update safely without needing to care about
> 32/64 bit issues - xfs_trans_ail_copy_lsn() - so use that when
> updating the AIL push target.

But reading xa_target without xa_lock isn't safe on 32-bit either, is it?

For the first read it can trivially be moved into the critical
section a few lines below, and the second one should probably use
XFS_LSN_CMP.

> @@ -482,19 +481,24 @@ xfs_ail_worker(
>  	/* assume we have more work to do in a short while */
>  	tout = 10;
>  	if (!count) {
> +out_done:

Jumping into conditionals is really ugly.  By initializing count a bit
earlier you can just jump in front of the if/else clauses.  And while
you're there maybe moving the tout = 10; into an else clause would
also make the code more readable.
an uninitialied used of tout.

> +		if (ailp->xa_target == target ||
> +		    (test_and_set_bit(XFS_AIL_PUSHING_BIT, &ailp->xa_flags)))

no need for braces around the test_and_set_bit call.

