Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859Ab2LNCg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 21:36:26 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:33668 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab2LNCgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 21:36:25 -0500
MIME-Version: 1.0
In-Reply-To: <876245jrbc.fsf@xmission.com>
References: <87ip88uw4n.fsf@xmission.com> <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com> <87zk1hshk7.fsf_-_@xmission.com>
 <CALCETrXLLcUu8Rajjx7+3N_6j5E0T0CR1h=hD+gcc5_r4Umyqw@mail.gmail.com> <876245jrbc.fsf@xmission.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 13 Dec 2012 18:36:02 -0800
Message-ID: <CALCETrXRYOh2tkwB+U9ZjA5BNZwscWsq1WGzjP3wUiOXQUXOQg@mail.gmail.com>
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the parent
 user namespace to have caps.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 6:33 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>
> Andy thank you for your review.
>
> Andy Lutomirski <luto@amacapital.net> writes:
>> This is confusing enough that I can't immediately tell whether it's
>> correct.  I think it's close but out of order.
>
> Yeah.  That is the trick. Figuring out how to write that code so it is
> correct and obvious.
>
> I have added a comment at the top and removed the extra variable I was
> adding.
>
> The order except for verifying a user_ns->parent is valid by checking
> for targ_ns == &init_user_ns doesn't make a difference.  Because
> cred->user_ns can only be one of targ_ns or targ_ns->parent.
>
>> Should this be transitive?
>
> Yes.
>>  I.e. suppose uid 1 owns a child of
>> init_user_ns and uid 2 (mapped in the first ns as the identity) owns
>> an inner ns.  Does uid 2 in the root ns have all caps inside?  I'd say
>> no, but I don't have a great argument for that.
>
> I also say no.  It is more code and it doesn't fit my nice small
> definition.  You have to be the owner and you have to be in the parent
> of the target user namespace.  Being able to remember the rules in
> your head is important.
>
>> But uid 1 presumably
>> does have caps because it could enter the parent with setns, then
>> change uid, then enter the child.
>
> Yes. uid 1 does have caps.
>
>> How about (severely whitespace damaged):
>
> You know that makes the termination condition a bit clearer.  But it
> looses the nice place to put a comment when we loop again.  This loop
> is just subtle enough that I want to preserve my comments.
>
> I think I must have put -EPERM towards the end for the same reason to
> make it clear that is the termination condition.
>
> In practice I think it is important to have the cap_raised case first,
> as that is the common case, and if we can be clear and still test that
> case first it means the code will be faster.  With my reordering it is
> obvious that nothing strange happens in the initial user namespace with
> the owner test after the exit when we are the initial user namespace.

Ah.  You are correct about the ordering.  I read it slightly wrong.

I'd still suggest using a variable like "here" instead of "targ_ns".
The latter is confusing because it changes on the second and later
iterations.

--Andy
