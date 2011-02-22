Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1BVQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 11:25:59 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41125 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275Ab1BVQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 11:25:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eicwU2a31wuSW9BNXjtChquhwtgKMEvC52DgaaISov1bnTdc4seOHw9yMViB9JlPFU
         uJeVnPNFoDejOJAfa0DYYV4WCj7x8j0CB13r5Oidm6QNOyKRhXJqo38BEsLMjjxSZaUS
         0Dl7f7Z3dfbaR0/6d1z4wpBfeWD7f9B+OuJGI=
Date: Tue, 22 Feb 2011 17:24:54 +0100
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Roland McGrath <roland@redhat.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/1] ptrace: make sure do_wait() won't hang after
 PTRACE_ATTACH
Message-ID: <20110222162454.GB31267@htj.dyndns.org>
References: <20110204105343.GA12133@htj.dyndns.org>
 <20110207174821.GA1237@redhat.com>
 <20110209141803.GH3770@htj.dyndns.org>
 <201102132325.55353.vda.linux@googlemail.com>
 <20110214151340.GP18742@htj.dyndns.org>
 <AANLkTi=Djwcf9YoUrGtTEOp8W_YhsefzrNhMxVhtw_Lp@mail.gmail.com>
 <20110214173012.GA18742@htj.dyndns.org>
 <AANLkTinntVGcOdZSS3gWz39eq3EDiMxXgYfc6+M1Z0iE@mail.gmail.com>
 <20110221151619.GM31267@htj.dyndns.org>
 <20110221152855.GA20769@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221152855.GA20769@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Okay, I think I finally caught up with the discussion (hopefully).

On Mon, Feb 21, 2011 at 04:28:55PM +0100, Oleg Nesterov wrote:
> However, I am starting to agree that TASK_TRACED looks more clean.
> 
> What is important, I think ptrace should respect SIGNAL_STOP_STOPPED.
> IOW, when the tracee is group-stopped (TASK_STOPPED or TASK_TRACED,
> doesn't matter), ptrace_resume() should not wake it up, but merely
> do set_task_state(TASK_STATE) and make it resumeable by SIGCONT.

I don't think that's gonna fly.  It first is a very user-visible
change to how ptrace_resume() works and it removes a lot of debugging
capability.  As Jan's examples showed, there are things which the
debugger does behind group stop's back and some of them are quite
legitimate and useful things to do like running some code in the
tracee context for the tracer and adjusting where the task is stopped.

If you mix ptrace trap and group stop and then fix group stop
notification, not only multithreaded debugging becomes quite
cumbersome (suddenly ptracing becomes per-process thing instead of
per-thread), it becomes almost impossible to debug jctl behaviors.
Jctl becomes completely intertwined with ptracing and the real parent
would get numerous notifications during the course of debugging.

I think they belong to different layers and they should stack instead
of mix.  I'll try to write up a summary for how I think it can be done
later but in short I think we just need two more PTRACE calls (one for
combined SIGSTOPless attach + INTERRUPT and the other for jctl
monitoring) and there doesn't need to be any fundamental revolt in how
ptrace and jctl interact with each other.  The current ptrace behavior
is quirky and rough on the edges but I think the fundamentals are
correct in that it's something which is fundamentally bound to a task
(not task group) and operates below jctl.  We just need to iron out
the interactions so that the outcome makes sense.

That way, most current users won't notice (e.g. entering TASK_TRACED
directly on SIGSTOP doesn't make any different to strace or gdb, they
already issue PTRACE calls immediately afterwards) the difference
while newer ones can take of new features to show better jctl
behavior.

Thanks.

-- 
tejun
