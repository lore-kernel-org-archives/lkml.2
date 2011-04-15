Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755462Ab1DOD01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 23:26:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52358 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755350Ab1DOD0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 23:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <20110415035451@it-loops.com>
References: <20110415035451@it-loops.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 14 Apr 2011 20:25:33 -0700
Message-ID: <BANLkTi=50A4f_d0a0oESd3DMMaK1za5BWg@mail.gmail.com>
Subject: Re: 2.6.39 Block layer regression was [Bug] Boot hangs with 2.6.39-rc[123]]
To: Michael Guntsche <mike@it-loops.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 14, 2011 at 7:06 PM, Michael Guntsche <mike@it-loops.com> wrote:
>
> After talking to Dave Chinner I looked at the block layer merges. I ended
> up on
>
> 6c510389005 Merge branch 'for-2.6.39/core' of git://git.kernel.dk/linux-2.6-block
>
> Starting with this merge I see the problems.

Ok, so that's not very surprising. It's the new per-thread plugging,
and yes, there's clearly something broken with regards to MD/DM.

And I have a suspicion.

Jens - tell me if I'm wrong, but look at the crazy plug flushing code:

  void __blk_flush_plug(struct task_struct *tsk, struct blk_plug *plug)
  {
        __blk_finish_plug(tsk, plug);
        tsk->plug = plug;
  }

and explain that idiotic __blk_finish_plug() logic to me:

  static void __blk_finish_plug(struct task_struct *tsk, struct blk_plug *plug)
  {
          flush_plug_list(plug);

          if (plug == tsk->plug)
                  tsk->plug = NULL;
  }

and in particular the "set it to NULL, only to then set it back
again". That code makes no sense. __blk_finish_plug() is only ever
called with "plug" being "tsk->plug", and afaik nothing will ever
modify a non-NULL plug (if it is a nested plug, it would never be
added to the task) _except_ for that __blk_finish_plug(). No? So it
sets it to NULL, and then immediately the caller will set it back
again.

What's the thinking there? It looks very confused to me.

Now, clearly RAID seems to be involved in the problem? The main thing
with that would be that the execution of the requests would tend to
generate new requests, that go back on the plug queue. Yes? And the
loop in flush_plug_list() means that they all should get flushed out,
I assume. But something clearly isn't working, and it does seem to be
about the RAID kind of setup. So either they didn't get put on the
plug queue, or the task got a new plug (which _wasn't_ flushed).

Because we're clearly waiting for some request that hasn't completed.
Where in the plug queues would it be hiding?

The whole block layer plugging looks to be the major problem of the 39
cycle. Jens, pls explain.

                      Linus
