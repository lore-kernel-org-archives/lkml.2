Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1BZKgX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 05:36:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56830 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab1BZKgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 05:36:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pHvGjmBY8u9V00QNYttKceIzxwy4Y4MAFfhhsDLyMkiMdjoUMw1VzBD1ZoFHn22m0P
         TnUOI+6jGI6Cn3Ij99NciyiZm/MOYyKplVtYlH+FMvEHfbQm2lIMK0E+P2Q6PkR2d8I/
         XLJ63ODUJGukI+YCOT2mbxU7QaSz+xv+OGtsE=
Date: Sat, 26 Feb 2011 11:36:16 +0100
From: Tejun Heo <tj@kernel.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] x86,mm,64bit: Round up memory boundary for
 init_memory_mapping_high()
Message-ID: <20110226103616.GA8701@htj.dyndns.org>
References: <20110223171945.GI26065@htj.dyndns.org>
 <4D656D1A.7030006@kernel.org>
 <20110223204656.GA27738@atj.dyndns.org>
 <4D657359.5060901@kernel.org>
 <20110223210326.GB27738@atj.dyndns.org>
 <AANLkTintYZ00-MZD5hv7p0zNeDJTyyzdR-C=7qWo78Ly@mail.gmail.com>
 <20110224091557.GD7840@htj.dyndns.org>
 <4D674A33.8000809@kernel.org>
 <20110225100336.GA26608@elte.hu>
 <4D686EB8.4080507@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D686EB8.4080507@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 07:08:40PM -0800, Yinghai Lu wrote:
> +	end_pfn = round_up(end_pfn, data->align>>PAGE_SHIFT);

And now you're mapping beyond max_pfn without even noting the behavior
change _anywhere_.  What the hell?  It's not like this point hasn't
been brought up before.  It has been mentioned _twice_ in this very
thread.  Come on.

<rant>
>From the previous responses, I suppose you wouldn't care for this
advice but well I'll give it anyway.  Spend time and effort
documenting the changes and their rationales you make in the comments
and changelog.  Putting those things in words will force _yourself_ to
think about whether the changes are accurate and justified in addition
to helping other people understand and review the changes.  And down
the road, after several years, when someone, even yourself, needs to
change the related code again, [s]he will be able to find out and
understand how and why things are implemented much more easily.

In the second patch, you added @tbl_end and your explanation was
@tbl_end could be shorter than @end.  What is that?  How is anyone
supposed to understand what that means?  You needed that change
because the code currently depends on memory range to do NUMA affine
allocation and when nodes are interleaved the rounding up may end up
allocating page table from a different node.  If you have put that in
words, you would probably have recognized how lame and cryptic that
piece of code is and other reviewers would also have much easier time
understanding what that is doing and say no.  And maybe this is too
much to ask but why not add a nice docbook comment while you're adding
an extra parameter?

At this point, I really find it difficult to take your patches
seriously.  They're cryptic, badly documented, and making behavior
changes left and right and even when advised you don't even try to
describe the changes and rationales.
</rant>

I know you know the code and hardware and have keen eyes for details.
_Please_ give it a bit more effort.

For this one, I think I'll just redo the patches and rip out the
memblock iteration code.  The complexity doesn't really seem
justified.

Thank you.

-- 
tejun
