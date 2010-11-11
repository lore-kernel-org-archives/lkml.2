Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab0KKVC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:02:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53406 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756393Ab0KKVC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:02:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NLe8UfPGJtBpcNNoIAt4RIDghDouB8W+mArojyRsvsn1uadnzKoAr03SEKfBioloNX
         kU8C6DVBZ7MAuvJ0XNh4DdoIP9xhcfpxexmSAf1oUpDDL414PPoj1R4GIEUN12TnmKRq
         uM/ff89T+djwUKiNo0lc/hmkVIpADLRuW6PpY=
Date: Fri, 12 Nov 2010 00:02:51 +0300
From: Vasiliy Kulikov <segooon@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-janitors@vger.kernel.org,
        =?iso-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: fix invalid arg check
Message-ID: <20101111210251.GA26283@albatros>
References: <1289421490-23950-1-git-send-email-segooon@gmail.com>
 <20101110130834.02496b48.akpm@linux-foundation.org>
 <alpine.DEB.2.00.1011101335410.7756@chino.kir.corp.google.com>
 <20101111083408.GA3471@albatros>
 <alpine.DEB.2.00.1011111224161.25829@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1011111224161.25829@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 12:38 -0800, David Rientjes wrote:
> On Thu, 11 Nov 2010, Vasiliy Kulikov wrote:
> 
> > > > > "size" is size_t.  If we want to check whether it was underflowed
> > > > > then we should cast it to ssize_t instead of int.  When
> > > > > sizeof(size_t) > sizeof(int) the code sees UINT_MAX as underflow,
> > > > > but it is not.
> > > > > 
> > > > 
> > > > Does this patch fix any actual observed problem?
> > 
> > I don't think so, this fix is more theoretical than practical.
> > However, maybe there is some crazy driver that fills array of 2GB with
> > s*printf().
> > 
> 
> All sizes passed to vsprintf() greater than INT_MAX are invalid; that's 
> what the original code is testing, warning, and handling correctly.

Not always correctly:

(int)(0xFFFFFFFFL + 2) = 1 is positive.

> No, it shouldn't, these functions return int.  INT_MAX is the largest 
> value we can handle successfully and that's why it is the special case for 
> sprintf() and vsprintf().
> 
> The code as it stands is correct not because of the type of the size but 
> rather the type of the return value.

OK, if the main reason here is return value type, then the correct
handling should be:

	/* Reject out-of-range values early.  Large positive sizes are
	   used for unknown buffer sizes. */
-	if (WARN_ON_ONCE((int) size < 0))
+	if (WARN_ON_ONCE(size > INT_MAX)
		return 0;

This should catch all underflows and too big integers.

-- 
Vasiliy
