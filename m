Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031618Ab2CGAli (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:41:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:46088 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759378Ab2CGAlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:41:36 -0500
Message-ID: <1331080893.6253.1.camel@localhost>
Subject: Re: [PATCH] selinux: init target class when add avc callback
From: Eric Paris <eparis@parisplace.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: gaowanlong@cn.fujitsu.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
        sds@tycho.nsa.gov
Date: Tue, 06 Mar 2012 19:41:33 -0500
In-Reply-To: <20120306161543.63c3fc54.akpm@linux-foundation.org>
References: <1328406808-11309-1-git-send-email-gaowanlong@cn.fujitsu.com>
	 <4F56A4E2.5050001@cn.fujitsu.com>
	 <20120306161543.63c3fc54.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16)
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-06 at 16:15 -0800, Andrew Morton wrote:
> On Wed, 07 Mar 2012 07:59:30 +0800
> Wanlong Gao <gaowanlong@cn.fujitsu.com> wrote:
> 
> > On 02/05/2012 09:53 AM, Wanlong Gao wrote:
> > 
> > > Target security class should be initialized when add avc callback.
> > > Although tclass is userless in callbacks now, but it may be used
> > > in the future .
> > > 
> > > Signed-off-by: Wanlong Gao <gaowanlong@cn.fujitsu.com>
> > > ---
> > >  security/selinux/avc.c |    1 +
> > >  1 files changed, 1 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/security/selinux/avc.c b/security/selinux/avc.c
> > > index dca1c22..27495e6 100644
> > > --- a/security/selinux/avc.c
> > > +++ b/security/selinux/avc.c
> > > @@ -576,6 +576,7 @@ int avc_add_callback(int (*callback)(u32 event, u32 ssid, u32 tsid,
> > >  	c->events = events;
> > >  	c->ssid = ssid;
> > >  	c->tsid = tsid;
> > > +	c->tclass = tclass;
> > >  	c->perms = perms;
> > >  	c->next = avc_callbacks;
> > >  	avc_callbacks = c;
> 
> Perhaps James can take a look at this?
> 
> avc_add_callback() looks a bit odd.  It uses GFP_ATOMIC, but that is
> unnecessary because avc_add_callback() is only ever called from
> module_init() code.  And if it isn't only ever called from
> module_init() code then it needs some locking for that list.

I'm a bad maintainer.  I should have done something with this patch.
Adding sds, the only other person who ever actually maintains this code,
to the thread.

__initcall() functions aren't serialized?  I guess that would be bad and
we would need a lock.  I wonder if there are other places I assumed
__initcall() would be serialized (note that all of these call sites are
built in and not modules if that makes a difference)

I'll probably just rip all of that ssid, tsid, tclass, perms, stuff out.
If all these years noone uses callbacks for anything other than reset
why do we have it at all.  Probably more simplification we can do around
avc_update_node() too...

Stephen, thoughts on ripping stuff out?

-Eric

