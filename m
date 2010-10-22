Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0JVIsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 04:48:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57078 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0JVIsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 04:48:41 -0400
Date: Fri, 22 Oct 2010 10:48:00 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        hch@infradead.org, zohar@us.ibm.com, warthog9@kernel.org,
        david@fromorbit.com, jmorris@namei.org, kyle@mcmartin.ca,
        hpa@zytor.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/3] IMA: move read/write counters into struct inode
Message-ID: <20101022084800.GB9722@elte.hu>
References: <20101019011650.25346.99614.stgit@paris.rdu.redhat.com>
 <AANLkTimGdjPyLXuknDNa7WNthDT9+2FdOuPdxwjRiMHD@mail.gmail.com>
 <1287506215.2530.187.camel@localhost.localdomain>
 <20101019165530.GT19804@ZenIV.linux.org.uk>
 <AANLkTimL=eChoCQHGoiouE5s6dGG=n9ZAQGhW-RW+gDj@mail.gmail.com>
 <1287528546.2530.277.camel@localhost.localdomain>
 <20101020143845.GB22271@elte.hu>
 <1287585996.2530.294.camel@localhost.localdomain>
 <20101020151555.GC22271@elte.hu>
 <4CC06721.8020308@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC06721.8020308@schaufler-ca.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Casey Schaufler <casey@schaufler-ca.com> wrote:

>  On 10/20/2010 8:15 AM, Ingo Molnar wrote:
> > * Eric Paris <eparis@redhat.com> wrote:
> >
> >> On Wed, 2010-10-20 at 16:38 +0200, Ingo Molnar wrote:
> >>> * Eric Paris <eparis@redhat.com> wrote:
> >>>
> >>>> Executive summary of the day's work:
> >>>> Yesterday morning: 944 bytes per inode in core
> >>>> Yesterday night: 24 bytes per inode in core
> >>>> Tonight: 4 bytes per inode in core.
> >>>>
> >>>> That's a x236 time reduction in memory usage.  No I didn't even start looking 
> >>>> at a freezer.  Which could bring that 4 down to 0, but would add a scalability 
> >>>> penalty on all inodes when IMA was enabled.
> >>> Why not use inode->i_security intelligently? That already exists so that way 
> >>> it's 0 bytes.
> >>>
> >>> Thanks,
> >> It still wouldn't be 0 bytes since there would be a 1-1 mapping from inode to 
> >> i_security structs. [...]
> > Only for IMA-affected files, right?
> >
> > My point is to keep it 0 overhead for the _non IMA common case_.
> >
> >> The real reason I don't pursue this route is because of the litany of different 
> >> ways this pointer is used in different LSMs (or not used at all.)  And we all know 
> >> that LSM authors aren't known for seeing the world the same way as each other.  As 
> >> a maintainer of one of those LSMs even I'm scared to try pushing that forward....
> > Ugh. That's a perfect reason to do it exactly like i suggested.
> 
> If you would like to make a proposal on LSM stacking other than the traditional 
> "rip the LSM out" I am sure that everyone in the IMA, SELinux, TOMOYO, AppArmor 
> and Smack communities would be happy to have a look. Short of having a viable 
> mechanism for multiple LSMs to coexist IMA needs its separate space. Yes, people 
> do use both IMA and LSMs on the same machine at the same time.

Yes, that's the essence of what i suggested: if various security concepts can be 
present at once then inode->security should not be a stupid pointer to a single, 
exclusive data structure (because that hardwires a "only a single security subsystem 
active" assumption), but should be a pointer to a linked list of security structures 
- as many as there are security subsystems interested in that inode.
 
Thanks,

	Ingo
