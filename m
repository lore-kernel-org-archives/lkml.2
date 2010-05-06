Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab0EFOwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 10:52:42 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36329 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753700Ab0EFOwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 10:52:39 -0400
Subject: Re: kbuild: fixing the select problem
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-arch@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Vegard Nossum <vegard.nossum@gmail.com>
In-Reply-To: <4BE2D10D.4070706@suse.cz>
References: <1273096160.23208.35.camel@mulgrave.site>
	 <4BE2D10D.4070706@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 09:52:34 -0500
Message-ID: <1273157554.23208.69.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 16:24 +0200, Michal Marek wrote:
> On 5.5.2010 23:49, James Bottomley wrote:
> > [Sam: I know you don't maintain kbuild anymore, but since you have the
> > most experience, if you could find time to comment, I'd be grateful]
> > 
> > The select problem is that the kbuild select directive will turn a
> > symbol on without reference to its dependencies.  This, in turn, means
> > that either selected symbols must select their dependencies, or that
> > people using select have to be aware of the selected symbol's dependency
> > and build those dependencies into their symbol (leading to duplication
> > and the possibility of getting the dependencies out of sync).  We use
> > select for the scsi transport classes, so we run into this problem in
> > SCSI quite a lot.
> > 
> > I think the correct fix is to make a symbol that selects another symbol
> > automatically inherit all of the selected symbol's dependencies.
> > 
> > There seems to be a fairly easy way to do this in kbuild.  Right at the
> > moment, select is handled as additional symbol values as the last point
> > in the symbol tree evaluation process.  Instead, what I propose doing is
> > for every select symbol, we add an extra unconditional default for the
> > selected symbol of the selecting symbol's current value (this breaks a
> > possible dependency cycle) and add to the dependencies of the selecting
> > symbol, the symbol it's currently selecting.
> 
> Nice trick :-).
> 
> 
> > There's one wrinkle to all of this in that the current parser for
> > default values stops when it finds the first valid (i.e. whose if clause
> > evaluates to true) default.  To make the above scheme work, I need to
> > modify the default parser so it takes the highest tristate of all the
> > valid defaults (and bumps m to y for bool).
> 
> We should check if some Kconfig file doesn't rely on this "first hit"
> behavior and fix it to explicitly list the condition for a given
> default.

I actually asked kconfig to generate the list of symbols (in my config)
with multiple defaults.  It's pretty small and the default y seems to be
the thing with multiple if clauses, so they act like or statements.

The list is

USB_ARCH_HAS_HCD has 4 defaults
DEFCONFIG_LIST has 5 defaults
MAC80211_RC_DEFAULT has 2 defaults
X86_L1_CACHE_SHIFT has 2 defaults
SPLIT_PTLOCK_CPUS has 2 defaults
X86_MINIMUM_CPU_FAMILY has 3 defaults
DEFAULT_TCP_CONG has 2 defaults
DEFCONFIG_LIST has 5 defaults
USB_ARCH_HAS_HCD has 4 defaults
X86_L1_CACHE_SHIFT has 2 defaults
X86_MINIMUM_CPU_FAMILY has 3 defaults
SPLIT_PTLOCK_CPUS has 2 defaults
DEFAULT_TCP_CONG has 2 defaults
MAC80211_RC_DEFAULT has 2 defaults

>  Another option would be to add
> default SYM1 || SYM2
> to a symbol selected by SYM1 and SYM2.

Well, that's effectively what the proposal does (it or's the states).

> > Does this look acceptable to people?  I think it should give the desired
> > result and has the added benefit that we can then strip the extra select
> > overlay out of the kbuild system (making the parser slightly simpler).
> > 
> > If this looks like a good idea to people, I think I can code up a quick
> > patch.
> 
> Other than the above, right now I don't see any issues with such approach.
> 
> On a related note, I see Vegard's GSoC project to use a sat solver for
> kconfig got accepted [1]. Vegard, how is the project progressing?
> 
> [1]
> http://socghop.appspot.com/gsoc/student_project/show/google/gsoc2010/psu_home/t127230762803
> 
> Michal

James


