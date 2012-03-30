Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760282Ab2C3Mbg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 08:31:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50143 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759470Ab2C3Mb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 08:31:29 -0400
Date: Fri, 30 Mar 2012 16:31:22 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [rfc] fcntl: Add F_GETOWNER_UIDS option
Message-ID: <20120330123122.GB2024@moon>
References: <m162dpo45j.fsf@fess.ebiederm.org>
 <20120328064838.GA2286@moon>
 <m1k425mae1.fsf@fess.ebiederm.org>
 <20120328075549.GA2204@moon>
 <20120328081639.GB2286@moon>
 <20120328194312.GA22211@mail.hallyn.com>
 <20120328194613.GA3678@redhat.com>
 <20120328213044.GA26190@peqn>
 <20120328213736.GM2204@moon>
 <20120329023053.GA10187@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329023053.GA10187@mail.hallyn.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 02:30:53AM +0000, Serge E. Hallyn wrote:
> Quoting Cyrill Gorcunov (gorcunov@openvz.org):
> > On Wed, Mar 28, 2012 at 04:30:44PM -0500, Serge Hallyn wrote:
> > > Quoting Oleg Nesterov (oleg@redhat.com):
> > > > On 03/28, Serge E. Hallyn wrote:
> > > > >
> > > > > If you want to
> > > > > just add the struct cred to the f_owner and do proper uid conversion,
> > > > > I'll support that too.  (Just grab a ref to the cred in
> > > > > fs/fcntl.c:f_modown(), and drop the ref in fs/file_table.c:__fput() ).
> > > > 
> > > > In this case f_owner.*uid should go away, I guess.
> > > 
> > > Yup.
> > > 
> > > Which I guess is all the more reason *not* to do this unless we end up
> > > not going with Eric's userns mapping patchset (which is unlikely).
> > > 
> > > > And sigio_perm()
> > > > should be unified with kill_ok_by_cred() somehow (modulo
> > > > security_file_send_sigiotask).
> > > > 
> > > > Right?
> > > 
> > > Maybe, but other differences include current being the signal sender in
> > > one and recipient in the other, and CAP_KILL being relevent in only
> > > one.
> > 
> > Hi Serge, thanks a lot for comments! Replying to prev email --
> > I've skipped cred part intentionally, I guess we need to wait
> > until Eric's patches hit LKML (if I understand all right) then
> > I'll expand the patch. I'll think a bit more tomorrow, ok?
> 
> Sure.
> 
> Thinking about it, the cred being stored right now is the cred in the
> container.  That's what you want for checkpoint, right?  So if someone

Hi Serge, sorry for delay, the stored creds are the ones a task has
at checkpoint time (we parse /proc/pid/status), and the dumper/restorer
works with root privileges so they should be able to change creds to
the former values on restore procedure.

> with the privs to do it checkpoints a task in a child userns, and restarts
> that without doing so in a child user ns, he should be allowed to do so.

I think so. Basically we require both checkpointer and restorer
to have admin rights before they do c/r (it might be relaxed in
future probably) and actually I think we're more oriented to
achieve stable c/r from init-namespace first (once this accomplished
then c/r from inside nested namespaces could be considered).

> So what I'm saying is that it's not in-defensible to just not change
> anything in your original patch until we can discuss Eric's set.
> 

Yes, I wanna take a look on Eric's set first just to get right
"picture" of everything. And I wanted to find a minimal solution
with current kernel code base which could be extended in future.

That said I guess the current init-ns-only approach should do the
trick for a while. And (thanks for pointing) I need to add a test
if a caller which tries to obtain uids has enought credentials
for that (probably CAP_FOWNER), right?

> If we were to *not* go with Eric's set, then when using your proposed
> patch for debugging purposes, would we want to show a list of uids,
> starting with the uid in the reader's user namespace, up to the
> container being investigated?  So for instance if init_user_ns spawned
> userns1, and that spawned userns2, and root in userns1 is seeking this
> info for a f_owner in userns2, then he should see two userids, the one
> mapped into usern1, and the one in userns2.
> 
> In Eric's set, we may want to show only the kuid (since the mapped
> userid can be found other ways), or for convenience we may want to show
> both the kuid and the mapped uid.

I suspect operating with kuid's will be a way more easier.

	Cyrill
