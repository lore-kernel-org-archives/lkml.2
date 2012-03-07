Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab2CGNmx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:42:53 -0500
Received: from emvm-gh1-uea09.nsa.gov ([63.239.67.10]:53747 "EHLO nsa.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756222Ab2CGNmv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:42:51 -0500
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Mar 2012 08:42:51 EST
X-TM-IMSS-Message-ID: <125d37c20001ad47@nsa.gov>
Subject: Re: [PATCH] selinux: init target class when add avc callback
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Eric Paris <eparis@parisplace.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, gaowanlong@cn.fujitsu.com,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <jmorris@namei.org>
In-Reply-To: <1331080893.6253.1.camel@localhost>
References: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>
	 <4F56A4E2.5050001@cn.fujitsu.com>
	 <20120306161543.63c3fc54.akpm@linux-foundation.org>
	 <1331080893.6253.1.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: National Security Agency
Date: Wed, 07 Mar 2012 08:27:31 -0500
Message-ID: <1331126851.16697.16.camel@moss-pluto>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 19:41 -0500, Eric Paris wrote:
> On Tue, 2012-03-06 at 16:15 -0800, Andrew Morton wrote:
> > On Wed, 07 Mar 2012 07:59:30 +0800
> > Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> > 
> > > On 02/05/2012 09:53 AM, Wanlong Gao wrote:
> > > 
> > > > Target security class should be initialized when add avc callback.
> > > > Although tclass is userless in callbacks now, but it may be used
> > > > in the future .
> > > > 
> > > > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > > > ---
> > > >  security/selinux/avc.c |    1 +
> > > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > > 
> > > > diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> > > > index dca1c22..27495e6 100644
> > > > --- a/security/selinux/avc.c
> > > > +++ b/security/selinux/avc.c
> > > > @@ -576,6 +576,7 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
> > > >  	c->events = events;
> > > >  	c->ssid = ssid;
> > > >  	c->tsid = tsid;
> > > > +	c->tclass = tclass;
> > > >  	c->perms = perms;
> > > >  	c->next = avc_callbacks;
> > > >  	avc_callbacks = c;
> > 
> > Perhaps James can take a look at this?
> > 
> > avc_add_callback() looks a bit odd.  It uses GFP_ATOMIC, but that is
> > unnecessary because avc_add_callback() is only ever called from
> > module_init() code.  And if it isn't only ever called from
> > module_init() code then it needs some locking for that list.
> 
> I'm a bad maintainer.  I should have done something with this patch.
> Adding sds, the only other person who ever actually maintains this code,
> to the thread.
> 
> __initcall() functions aren't serialized?  I guess that would be bad and
> we would need a lock.  I wonder if there are other places I assumed
> __initcall() would be serialized (note that all of these call sites are
> built in and not modules if that makes a difference)
> 
> I'll probably just rip all of that ssid, tsid, tclass, perms, stuff out.
> If all these years noone uses callbacks for anything other than reset
> why do we have it at all.  Probably more simplification we can do around
> avc_update_node() too...
> 
> Stephen, thoughts on ripping stuff out?

Yes, you should be able to replace GFP_ATOMIC with GFP_KERNEL there and
rip out the other callback fields/arguments as they are presently
unused.  Legacy of the original Flask code, where there were other
avc_ss_* interfaces for revoke and friends.

-- 
Stephen Smalley
National Security Agency

