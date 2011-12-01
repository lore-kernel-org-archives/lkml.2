Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab1LAQuV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:50:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442Ab1LAQuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:50:20 -0500
Date: Thu, 1 Dec 2011 11:50:09 -0500
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-ID: <20111201165009.GB2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
 <20111201154036.GA2443@redhat.com>
 <1322756898.4699.30.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322756898.4699.30.camel@twins>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 05:28:18PM +0100, Peter Zijlstra wrote:
> On Thu, 2011-12-01 at 10:40 -0500, Jason Baron wrote:
> > I should probably rename
> > static_branch() -> 'static_branch_default_false()' to make that clear.
> 
> The rename doesn't really make sense until you can also provide
> static_branch_true() also:

I think its just a matter of reversing the true and false returns.
That is, instead of:

static __always_inline bool arch_static_branch_default_false(struct jump_label_key
*key)
{
        asm goto("1:"
                JUMP_LABEL_INITIAL_NOP
                ".pushsection __jump_table,  \"aw\" \n\t"
                _ASM_ALIGN "\n\t"
                _ASM_PTR "1b, %l[l_yes], %c0 \n\t"
                ".popsection \n\t"
                : :  "i" (key) : : l_yes);
        return false;
l_yes:
        return true;
}

We just have (untested):

static __always_inline bool arch_static_branch_default_true(struct jump_label_key
*key)
{
        asm goto("1:"
                JUMP_LABEL_INITIAL_NOP
                ".pushsection __jump_table,  \"aw\" \n\t"
                _ASM_ALIGN "\n\t"
                _ASM_PTR "1b, %l[l_no], %c0 \n\t"
                ".popsection \n\t"
                : :  "i" (key) : : l_no);
        return true;
l_no:
        return false;
}

jump_label_inc/dec(), don't need to be changed, they just mean reverse
the branch on 0, 1 transitions. Although using the same key in both
static_branch_true, and static_branch_false, might be confusing. Maybe
we rename jump_label_inc/dec to static_branch_reverse_inc()/dec()?

> 
> > Maybe we need an unbiased static_branch() too, but I'm not sure excatly
> > how to implement it... 
> 
> I'd think the same way we got in this situation in the first place, go
> kick some GCC people ;-)

If you think this is a useful case, I'll try and see how to implement it.
Then we can add static_branch_default_true/false_unbiased() :)

-Jason
