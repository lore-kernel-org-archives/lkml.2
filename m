Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2KHMRp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:17:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755391Ab2KHMRn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:17:43 -0500
Message-ID: <509BA2B0.2080204@redhat.com>
Date: Thu, 08 Nov 2012 12:16:48 +0000
From: Pedro Alves <palves@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Chris Evans <scarybeasts@gmail.com>,
        David Howells <dhowells@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>, u3557@dialix.com.au,
        security@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: PT_EXITKILL (Was: pdeath_signal)
References: <20121106152050.GA18218@sergelap> <20121106201428.9D72959201A@miso.sublimeip.com> <20121107150934.GA27606@redhat.com>
In-Reply-To: <20121107150934.GA27606@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2012 03:09 PM, Oleg Nesterov wrote:

>> > > > > What I would IDEALLY like to have is a call, probably a ptrace option,
>> > > > > where the parent can request: "If I am ever to terminate or be killed,
>> > > > > then my ptraced son MUST die as well".
>> > >
>> > > Perhaps this makes sense...
>> > >
>> > > Chris, iirc you also suggested something like this? And the patch is
>> > > trivial.

(...)

> OK. Please see the untested/uncompiled (but trivial) patch below
> 
> 	- it adds PTRACE_O_EXITKILL. A better name?
> 
> 	- A better numeric value? Note that the new option is not equal to
> 	  the last-ptrace-option << 1. Because currently all options have
> 	  the event, and the new one starts the eventless group. 1 << 16
> 	  means we have the room for 8 more events.
> 
> 	- it needs the convincing changelog for akpm


If this isn't inherited by the ptrace child's children, a fork child can
end up detached if the tracer dies before it had a chance of setting
the PTRACE_O_EXITKILL on the new auto-attached child.

Which sounds like another argument for PTRACE_O_INHERIT, as in:
http://sourceware.org/ml/archer/2011-q1/msg00026.html

(it sounds like you need to use PTRACE_SEIZE+options too to plug
the race between PTRACE_ME/PTRACE_ATTACH and
setting PTRACE_SETOPTIONS).

(For completeness, Windows' age old equivalent,
DebugSetProcessKillOnExit, it a tracer option, not tracee option, though
that's not as flexible.)

-- 
Pedro Alves

