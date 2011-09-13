Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab1IMHpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 03:45:08 -0400
Received: from smarthost1.greenhost.nl ([195.190.28.78]:34538 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1IMHpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 03:45:06 -0400
Message-ID: <b45dbb1b8a02ec6c5c52c95f62d887f2.squirrel@webmail.greenhost.nl>
In-Reply-To: <201109101636.37007.pedro@codesourcery.com>
References: <1315506333.18043.49.camel@dhcp-25-63.brq.redhat.com>
    <201109101340.16506.vda.linux@googlemail.com>
    <201109101312.39256.pedro@codesourcery.com>
    <201109101636.37007.pedro@codesourcery.com>
Date: Tue, 13 Sep 2011 09:45:00 +0200
Subject: Re: [PATCH v3] Make PTRACE_SEIZE set ptrace options specified in
 'data'
From: "Indan Zupancic" <indan@nul.nu>
To: "Pedro Alves" <pedro@codesourcery.com>
Cc: "Denys Vlasenko" <vda.linux@googlemail.com>,
        "Denys Vlasenko" <dvlasenk@redhat.com>,
        "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.22
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: bbdeaaa4d227adae8d620e69c05793d6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, September 10, 2011 17:36, Pedro Alves wrote:
> On Saturday 10 September 2011 13:12:38, Pedro Alves wrote:
>
>> (just-options-on-SEIZE scares me in terms of future expansion,
>> as it assumes only bitflags will ever be necessary.)
>
> The more I think of this, the more I think we could do this
> some other way --- why don't we allow setting the default
> options _on the ptracer_, and then tracee's inherit those
> options from the ptracer-set-of-default-options if their
> parent is not currently ptraced by own tracer?  That is, you'd make
> the ptracer set options on itself:
>
> options = PTRACE_O_TRACESYSGOOD | PTRACE_O_TRACECLONE|FORK|VFORK|EXEC ...;
> ptrace(PTRACE_SETOPTIONS, gettid(), 0, options);

Please just use a zero pid to set options on yourself, that's easier for
everyone.


> And then, in all of
>
>  ptrace(PTRACE_ATTACH, foo_pid, 0, 0);
>  ptrace(PTRACE_TRACEME, 0, 0, 0);
>  ptrace(PTRACE_SEIZE, foo_pid, 0, 0);
>
> you'd end up with the tracee already with your chosen options set.
>
> Clones, vforks and forks that are auto-attached would still inherit their
> options from their parent, just like today.
>
> Some pro points:
>
> - works for PTRACE_ATTACH AND PTRACE_TRACEME too.
>
> - most ptracers on earth will only need to set options once.
>
> - backwards compatible.  The "default ptrace options" default
> to 0, so old tracers on new kernels will still behave the same.
>
> - future proof.  If some other PTRACE_SET_NEAT_OPTION ptrace
> command appears in the future, we can make it work the same
> way, instead of getting stuck with PTRACE_SEIZE's `data'
> already being taken...
>
> - if ptrace(PTRACE_SETOPTIONS, gettid(), 0, 0) works, then
> we can stop gdb (and probably other tracers) from forking a new
> child just to check if PTRACE_O_TRACEFOO works before actually
> attaching/spawning the process of interest.
> (see code around linux_supports_tracefork_flag at
> <http://sourceware.org/cgi-bin/cvsweb.cgi/src/gdb/linux-nat.c?rev=1.215&content-type=text/x-cvsweb-markup&cvsroot=src>)

The forking a new child just to check the option is needed because aparently
some old ptrace version didn't return an error for unknown options (according
to the comment in that code), so trying it out is the only reliable way of
being sure if options are supported or not. Otherwise no extra forking would
be needed anyway.

> Cons:
>
> - is there any real con?
>
> Note the default ptrace options would _not_ conflict with
> the ptracer's own ptrace options in case the ptracer itself
> is being ptraced.
>
> WDYT?

I agree that this would probably be better than setting options at SEIZE
time.

Greetings,

Indan


