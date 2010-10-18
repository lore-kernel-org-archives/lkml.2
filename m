Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041Ab0JROE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:04:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755979Ab0JROE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:04:28 -0400
Date: Mon, 18 Oct 2010 10:03:39 -0400
From: Jason Baron <jbaron@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 5/9] jump label: Add
	register_jump_label_key/unregister_jump_label_key
Message-ID: <20101018140339.GA2814@redhat.com>
References: <20101015200949.134732894@goodmis.org> <20101015201036.923619508@goodmis.org> <1287176595.1998.116.camel@laptop> <1287176974.16971.3.camel@gandalf.stny.rr.com> <1287177215.1998.121.camel@laptop> <1287403521.29097.1554.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287403521.29097.1554.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 02:05:21PM +0200, Peter Zijlstra wrote:
> On Fri, 2010-10-15 at 23:13 +0200, Peter Zijlstra wrote:
> > On Fri, 2010-10-15 at 17:09 -0400, Steven Rostedt wrote:
> > > On Fri, 2010-10-15 at 23:03 +0200, Peter Zijlstra wrote:
> > > 
> > > > Urgh, this sucks.. :-(
> > > > 
> > > > So now we have to actually track all JUMP_LABEL() sites and call
> > > > register muck on them.. even though we already track them through the
> > > > special data section.
> > > > 
> > > > Is there really no way around this?
> > > 
> > > I'll take a look to see if we can monkey with magic and automate it.
> > 
> > So the problem is something like:
> > 
> > core kernel:
> > 
> >  jump_label_enable()
> > 
> > module:
> > 
> >  JUMP_LABEL()
> > 
> > And then because we don't have a proper __jump_table section, the
> > jump_label_enable() won't properly work?
> > 
> > Why not let jump_label_enable() add a dummy entry with the enabled bit
> > and once you load the module merge the real entry into it.
> 
> Or actually use the value of the key pointer.. it would mean either
> standardizing the size (int/atomic_t would work), or using a version of
> the fallback JUMP_LABEL implementation to sort out the type issues.


So I initially implmented this as 'jump_label_enable()' would add a new
entry for the key, if it didn't already exist. However, I was concerned
about the case where module 'a' defined the key variable, and then
module 'b' did the enable/disable, and then module 'a' was removed and
thus the key value could be re-used, and module's 'b' key would mean
something different.

However, I'm not sure that is possible - since module 'b' would have
symbol dependency on module 'a', and thus module 'a' could not be
unloaded before module 'b'.

Thus, when a module is freed, I think we can scan all the keys and check
if any key is contained within the text section of the module that is
about to be freed. If so, we simply remove that key entry. does this
make sense?

thanks,

-Jason
