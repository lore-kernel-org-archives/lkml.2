Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276Ab0KXNTx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:19:53 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:57282 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754621Ab0KXNTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:19:50 -0500
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX184yi5NY1Q4avFRpGJQ6eRRTv0fRe7Jh5SGUyz9Mj
	SdbfpW9PetWAHr
Date: Wed, 24 Nov 2010 14:17:56 +0100
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fanotify: on group destroy allow all waiters to bypass
	permission check
Message-ID: <20101124131756.GD26499@lsanfilippo.unix.rd.tt.avira.com>
References: <20101119095807.GB22377@lsanfilippo.unix.rd.tt.avira.com> <1290550424.1443.65.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290550424.1443.65.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 23, 2010 at 05:13:44PM -0500, Eric Paris wrote:
> 
> I'm not sure what you mean by 'processes for which no event has been
> queued.'  You must mean a process that is about to send a notify event
> and is about to put itself on the wait queue...
> 

Hm, i admit i did not explain very well what i meant.

> In any case I think I described all of the possibilities here:
> 
> Lets think about the 4 relevant code paths from the PoV of the
> 'operator' 'listener' 'responder' and 'closer'.  Where operator is the
> process doing an action (like open/read) which could require permission.
> Listener is the task (or in this case thread) slated with reading from
> the fanotify file descriptor.  The 'responder' is the thread responsible
> for responding to access requests.  'Closer' is the thread attempting to
> close the fanotify file descriptor.
> 
> The 'operator' is going to end up in:
> fanotify_handle_event()
>   get_response_from_access()
>     (THIS BLOCKS WAITING ON USERSPACE)
> 
> The 'listener' interesting code path
> fanotify_read()
>   copy_event_to_user()
>     prepare_for_access_response()
>       (THIS CREATES AN fanotify_response_event)
> 
> The 'responder' code path:
> fanotify_write()
>   process_access_response()
>     (REMOVE A fanotify_response_event, SET RESPONSE, WAKE UP 'operator')
> 
> The 'closer':
> fanotify_release()
>   (SUPPOSED TO CLEAN UP THE REST OF THIS MESS)
> 
> What we have today is that in the closer we remove all of the
> fanotify_response_events and set a bit so no more response events are
> ever created in prepare_for_access_response().
> 
> The bug is that we never wake all of the operators up and tell them to
> move along.  

Right, we did not wake up the operators that generated events which have not
been moved to the access_list yet, but are still on the access_waitq (because 
the listener never read these events). 

> 
> > Beside this it removes the unnecessary check for the bypass_perm flag in
> > prepare_for_access_response(), since this function cant be called any more at
> > the time release() is called and the flag is set.
> 
> Which I guess is also correct but I don't like it in the same patch.
> It's dropping dead code rather than fixing this bug.  So it's
> distracting to review the patch.

Yes right, i should have split that.

> 
> I'm going to split this into two patches, include my analysis in your
> changelog and apply them separately.  I hope you don't mind.  

Absolutely ok :)

