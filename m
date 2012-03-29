Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab2C2Ca7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:30:59 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39978 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753875Ab2C2Cax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:30:53 -0400
Date: Thu, 29 Mar 2012 02:30:53 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Oleg Nesterov <oleg@redhat.com>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120329023053.GA10187@mail.hallyn.com>
References: <20120327224640.GA5328@mail.hallyn.com>
 <m162dpo45j.fsf@fess.ebiederm.org>
 <20120328064838.GA2286@moon>
 <m1k425mae1.fsf@fess.ebiederm.org>
 <20120328075549.GA2204@moon>
 <20120328081639.GB2286@moon>
 <20120328194312.GA22211@mail.hallyn.com>
 <20120328194613.GA3678@redhat.com>
 <20120328213044.GA26190@peqn>
 <20120328213736.GM2204@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120328213736.GM2204@moon>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> On Wed, Mar 28, 2012 at 04:30:44PM -0500, Serge Hallyn wrote:
> > Quoting Oleg Nesterov (oleg@redhat.com):
> > > On 03/28, Serge E. Hallyn wrote:
> > > >
> > > > If you want to
> > > > just add the struct cred to the f_owner and do proper uid conversion,
> > > > I'll support that too.  (Just grab a ref to the cred in
> > > > fs/fcntl.c:f_modown(), and drop the ref in fs/file_table.c:__fput() ).
> > > 
> > > In this case f_owner.*uid should go away, I guess.
> > 
> > Yup.
> > 
> > Which I guess is all the more reason *not* to do this unless we end up
> > not going with Eric's userns mapping patchset (which is unlikely).
> > 
> > > And sigio_perm()
> > > should be unified with kill_ok_by_cred() somehow (modulo
> > > security_file_send_sigiotask).
> > > 
> > > Right?
> > 
> > Maybe, but other differences include current being the signal sender in
> > one and recipient in the other, and CAP_KILL being relevent in only
> > one.
> 
> Hi Serge, thanks a lot for comments! Replying to prev email --
> I've skipped cred part intentionally, I guess we need to wait
> until Eric's patches hit LKML (if I understand all right) then
> I'll expand the patch. I'll think a bit more tomorrow, ok?

Sure.

Thinking about it, the cred being stored right now is the cred in the
container.  That's what you want for checkpoint, right?  So if someone
with the privs to do it checkpoints a task in a child userns, and restarts
that without doing so in a child user ns, he should be allowed to do so.

So what I'm saying is that it's not in-defensible to just not change
anything in your original patch until we can discuss Eric's set.

If we were to *not* go with Eric's set, then when using your proposed
patch for debugging purposes, would we want to show a list of uids,
starting with the uid in the reader's user namespace, up to the
container being investigated?  So for instance if init_user_ns spawned
userns1, and that spawned userns2, and root in userns1 is seeking this
info for a f_owner in userns2, then he should see two userids, the one
mapped into usern1, and the one in userns2.

In Eric's set, we may want to show only the kuid (since the mapped
userid can be found other ways), or for convenience we may want to show
both the kuid and the mapped uid.

-serge
