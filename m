Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932321Ab1FAWCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 18:02:12 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:36521 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756354Ab1FAWCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 18:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=JLzcHMyagkQu+1EdOLSEy4wQdf3/VORd
	EhxFRRQUsdm+GWXaPwV5Pa7V+KWvKfrNTpEfirsLJejvxmqimkGQ9cjSNPP6kf/j
	O7QX+qcyRt1Kakzxlf1NfbLuRWQHnJcKhqTFBdfnshuH66nt+MWVUsePm+2QbHVZ
	7GfAj2gMrOk=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>, axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ide: Fix bug caused by git merge
References: <1306956328.10135.36.camel@gandalf.stny.rr.com>
 <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com>
 <7vr57dfc8x.fsf@alter.siamese.dyndns.org>
Date: Wed, 01 Jun 2011 15:01:51 -0700
In-Reply-To: <7vr57dfc8x.fsf@alter.siamese.dyndns.org> (Junio C. Hamano's
 message of "Wed, 01 Jun 2011 14:55:10 -0700")
Message-ID: <7vmxi1fbxs.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 1420BE08-8C9B-11E0-83A2-D6B6226F3D4C-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <gitster@pobox.com> writes:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> Junio - what made it harder for Steven to see the reason may be due
>> the default history simplification. I do wonder if we should just make
>> "--simplify-merges" the default, because the aggressive and simple
>> default culling makes it hard to see merge commits like this that just
>> pick one side  over the other. --simplify-merges is more expensive,
>> but doesn't have some of the problems the aggressive simplification
>> has.
>
> It is more expensive not just in computation cycles but in latency, as it
> is inherently a "limited" operation that needs to first walk the history
> and then post-process.
>
>   $ time sh -c 'git log drivers/ide/ide-cd.c | head -n 200 >/dev/null'
>
> with and without "--simplify-merges" shows more than 50-fold differences
> (0.15s vs 8s).
>
> I am more disturbed by the fact that "git show 698567f3fa7" does not show
> the mismerge (even with -c). Of course I know that not showing "taking
> from one side" is by design of -c/--cc, but I still feel there should be
> something we could do about it.

Your comment was about digging history after problem happened, so this is
a tangent in that sense, but I am wondering if it makes sense to advertise
and encourage the use of --conflict=diff3 even more, to prevent accidents
like this from happening in the first place. 

Here is how our default merge conflict marker (modelled after RCS and CVS
output) look like when recreating the merge:

diff --cc drivers/ide/ide-cd.c
index 6e5123b,a5ec5a7..0000000
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@@ -1781,8 -1781,7 +1781,12 @@@ static int ide_cd_probe(ide_drive_t *dr
  
        ide_cd_read_toc(drive, &sense);
        g->fops = &idecd_ops;
++<<<<<<< HEAD
 +      g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 +      g->events = DISK_EVENT_MEDIA_CHANGE;
++=======
+       g->flags |= GENHD_FL_REMOVABLE;
++>>>>>>> 61c4f2c
        add_disk(g);
        return 0;

With --conflict=diff3, it becomes crystal clear that g->events assignment
needs to be removed for even somebody who does not know the history of
this part of the kernel at all (like me).

diff --cc drivers/ide/ide-cd.c
index 6e5123b,a5ec5a7..0000000
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@@ -1781,8 -1781,7 +1781,15 @@@ static int ide_cd_probe(ide_drive_t *dr
  
        ide_cd_read_toc(drive, &sense);
        g->fops = &idecd_ops;
++<<<<<<< ours
 +      g->flags |= GENHD_FL_REMOVABLE | GENHD_FL_BLOCK_EVENTS_ON_EXCL_WRITE;
 +      g->events = DISK_EVENT_MEDIA_CHANGE;
++||||||| base
+       g->flags |= GENHD_FL_REMOVABLE;
++      g->events = DISK_EVENT_MEDIA_CHANGE;
++=======
++      g->flags |= GENHD_FL_REMOVABLE;
++>>>>>>> theirs
        add_disk(g);
        return 0;

