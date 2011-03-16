Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530Ab1CPSmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 14:42:43 -0400
Received: from smtp-out.google.com ([74.125.121.67]:36861 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752483Ab1CPSmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 14:42:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=sYwt5K7vrkWyfVEwdJ2vpqS/gj2DxB1MTQta7rtjpVYBw52Ta67bR46aZyzK/1Guk5
         +i5AKp0mh08DVg7zXbWw==
Date: Wed, 16 Mar 2011 11:42:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: George Spelvin <linux@horizon.com>
cc: herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, mpm@selenic.com, penberg@cs.helsinki.fi
Subject: Re: [PATCH 1/8] drivers/random: Cache align ip_random better
In-Reply-To: <20110316181023.2090.qmail@science.horizon.com>
Message-ID: <alpine.LSU.2.00.1103161123360.14076@sister.anvils>
References: <20110316181023.2090.qmail@science.horizon.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, George Spelvin wrote:

> > I'm intrigued: please educate me.  On what architectures does cache-
> > aligning a 48-byte buffer (previously offset by 4 bytes) speed up
> > copying from it, and why?  Does the copying involve 8-byte or 16-byte
> > instructions that benefit from that alignment, rather than cacheline
> > alignment?
> 
> I had two thoughts in my head when I wrote that:
> 1) A smart compiler could note the alignment and issue wider copy
>    instructions.  (Especially on alignment-required architectures.)

Right, that part of it would benefit from stronger alignment,
but does not generally need cacheline alignment.

> 2) The cacheline fetch would get more data faster.  The data would
>    be transferred in the first 6 beats of the load from RAM (assuming a
>    64-bit data bus) rather than waiting for 7, so you'd finish the copy
>    1 ns sooner or so.  Similar 1-cycle win on a 128-bit Ln->L(n-1) cache
>    transfer.

That argument worries me.  I don't know enough to say whether you are
correct or not.  But if you are correct, then it worries me that your
patch will be the first of a trickle growing to a stream to an avalanche
of patches where people align and reorder structures so that the most
commonly accessed fields are at the beginnng of the cacheline, so that
those can then be accessed minutely faster.

Aargh, and now I am setting off the avalanche with that remark.
Please, someone, save us by discrediting George's argument.

> 
> As I said, "infinitesimal".  The main reason that I bothered to
> generate a patch was that it appealed to my sense of neatness to
> keep the 3x16-byte buffer 16-byte aligned.

Ah, now you come clean!  Yes, it does feel neater to me too;
but I doubt that would be sufficient justification by itself.

Hugh
