Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab1FAVza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:55:30 -0400
Received: from a-pb-sasl-sd.pobox.com ([64.74.157.62]:63319 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab1FAVz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=u1K41gNnM4wwselo0XrjhTF1SydyRzQy
	aTlN0HdZ5e4qQpdXgUhDiUpv3GIIQ75ja7HORTiEu3S6BZgspikH4avBlYp8VOqM
	YZ7ML06WeyQioOHatcuL1gpI65x117jLndlh5fzFuGroRzocrmVK/hjIF2QBKL2O
	EyIDjqfJ/aY=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Jens Axboe <jaxboe@fusionio.com>,
        LKML <linux-kernel@vger.kernel.org>, axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] ide: Fix bug caused by git merge
References: <1306956328.10135.36.camel@gandalf.stny.rr.com>
 <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com>
Date: Wed, 01 Jun 2011 14:55:10 -0700
In-Reply-To: <BANLkTimgjdFQcSfOOFFjmSC+Wt_xPXr4Xg@mail.gmail.com> (Linus
 Torvalds's message of "Thu, 2 Jun 2011 05:27:45 +0900")
Message-ID: <7vr57dfc8x.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: 2489600C-8C9A-11E0-A975-D6B6226F3D4C-77302942!a-pb-sasl-sd.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> Junio - what made it harder for Steven to see the reason may be due
> the default history simplification. I do wonder if we should just make
> "--simplify-merges" the default, because the aggressive and simple
> default culling makes it hard to see merge commits like this that just
> pick one side  over the other. --simplify-merges is more expensive,
> but doesn't have some of the problems the aggressive simplification
> has.

It is more expensive not just in computation cycles but in latency, as it
is inherently a "limited" operation that needs to first walk the history
and then post-process.

  $ time sh -c 'git log drivers/ide/ide-cd.c | head -n 200 >/dev/null'

with and without "--simplify-merges" shows more than 50-fold differences
(0.15s vs 8s).

I am more disturbed by the fact that "git show 698567f3fa7" does not show
the mismerge (even with -c). Of course I know that not showing "taking
from one side" is by design of -c/--cc, but I still feel there should be
something we could do about it.
