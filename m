Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab0KWWNx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:13:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab0KWWNw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:13:52 -0500
Subject: Re: [PATCH] fanotify: on group destroy allow all waiters to bypass
 permission check
From: Eric Paris <eparis@redhat.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: linux-kernel@vger.kernel.org, agruen@suse.de,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20101119095807.GB22377@lsanfilippo.unix.rd.tt.avira.com>
References: <20101119095807.GB22377@lsanfilippo.unix.rd.tt.avira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Nov 2010 17:13:44 -0500
Message-ID: <1290550424.1443.65.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 10:58 +0100, Lino Sanfilippo wrote:
> When fanotify_release() is called, there may still be processes waiting for
> access permission. Currently only processes for which an event has already been
> queued into the groups access list will be woken up.  Processes for which no
> event has been queued will continue to sleep and thus cause a deadlock when
> fsnotify_put_group() is called.

I'm not sure what you mean by 'processes for which no event has been
queued.'  You must mean a process that is about to send a notify event
and is about to put itself on the wait queue...

> Furthermore there is a race allowing further processes to be waiting on the
> access wait queue after wake_up (if they arrive before clear_marks_by_group()
> is called).

This is what I think you meant in the above sentence but I'm not sure.
In any case I think I described all of the possibilities here:

Lets think about the 4 relevant code paths from the PoV of the
'operator' 'listener' 'responder' and 'closer'.  Where operator is the
process doing an action (like open/read) which could require permission.
Listener is the task (or in this case thread) slated with reading from
the fanotify file descriptor.  The 'responder' is the thread responsible
for responding to access requests.  'Closer' is the thread attempting to
close the fanotify file descriptor.

The 'operator' is going to end up in:
fanotify_handle_event()
  get_response_from_access()
    (THIS BLOCKS WAITING ON USERSPACE)

The 'listener' interesting code path
fanotify_read()
  copy_event_to_user()
    prepare_for_access_response()
      (THIS CREATES AN fanotify_response_event)

The 'responder' code path:
fanotify_write()
  process_access_response()
    (REMOVE A fanotify_response_event, SET RESPONSE, WAKE UP 'operator')

The 'closer':
fanotify_release()
  (SUPPOSED TO CLEAN UP THE REST OF THIS MESS)

What we have today is that in the closer we remove all of the
fanotify_response_events and set a bit so no more response events are
ever created in prepare_for_access_response().

The bug is that we never wake all of the operators up and tell them to
move along.  You fix that in fanotify_get_response_from_access().  You
also fix other operators which haven't gotten there yet.  So I agree
that's a good fix.

But then you do:

> Beside this it removes the unnecessary check for the bypass_perm flag in
> prepare_for_access_response(), since this function cant be called any more at
> the time release() is called and the flag is set.

Which I guess is also correct but I don't like it in the same patch.
It's dropping dead code rather than fixing this bug.  So it's
distracting to review the patch.

I'm going to split this into two patches, include my analysis in your
changelog and apply them separately.  I hope you don't mind.  I also
don't like the conversion to an atomic when I think a bool could work
just as well.  I might convert it back to a boolean after I put some
thought into it....

-Eric

