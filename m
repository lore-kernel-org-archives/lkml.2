Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2DNUum (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 16:50:42 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:42206 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999Ab2DNUul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 16:50:41 -0400
Message-ID: <4F89E303.1060603@linux.vnet.ibm.com>
Date: Sun, 15 Apr 2012 02:20:11 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com> <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com> <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com> <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com> <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com> <CA+55aFztPW2x1grh2Z7RTOxKZ29_Ha6-kDkJXgdghFHQ61EZOQ@mail.gmail.com> <alpine.DEB.2.00.1204091603430.21813@chino.kir.corp.google.com> <CA+55aFwa40cv_TYdU3dKHPPJQo2omLpi8y6k6KBhJ5uP12f29A@mail.gmail.com>
In-Reply-To: <CA+55aFwa40cv_TYdU3dKHPPJQo2omLpi8y6k6KBhJ5uP12f29A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041420-5564-0000-0000-000002346046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2012 05:25 AM, Linus Torvalds wrote:

> On Mon, Apr 9, 2012 at 4:25 PM, David Rientjes <rientjes@google.com> wrote:
>>
>> You could that if you also turned the check for "ret == NOTIFY_OK" in
>> profile_handoff_task() into "ret & NOTIFY_OK" in your patch, otherwise you
>> get a double free from __put_task_struct() and oprofile.
> 
> Why? NOTIFY_DONE is zero.
> 
> I do agree that we *also* could do the "& NOTIFY_OK" and make it
> clearer that we're oring bits together. And we could document the
> stupid notifier interfaces to do this all, and just make the rules be
> *sane* when you have multiple notifiers.
> 
> And sane rules would be either:
> 
>  - you always return an error return, and notifiers all return either
> 0 or a negative error number, and we stop on the first error and
> return that.
> 
>  - you return a bitmask, and we or all bits together (and we can
> certainly continue to have a "stop here" bit)
> 


Even I think 'or'ing the bits makes more sense than returning the last
return value.

CPU hotplug and suspend/resume are two of the things that I know of,
that use notifiers quite a bit. However, neither of them actually care
about the exact return value - if it is an error return, no matter which
one or for what reason, they do the same error handling; and it works
for them. IOW, if we change the documented behaviour of notifiers to
return 'or' of all return values, that would continue to work well
with these users.

Of course, there are other users like profile_handoff_task() that do
care about exactly what the return value was, but I guess we can
gradually adapt such users to the better, saner rules for the notifier
return values, as you proposed.

> But the current notifier semantics are just insane. The whole "we
> return the last return value" is crazy. It's by definition a random
> number, since the whole point of notifiers is that there can be
> multiple, and they aren't "ordered". So the whole "last return value"
> is something I just look at and say: "Whoever designed that is a
> f*cking moron".
> 

[...]

> 
> Again, almost every notifier user has always been total crap. It's
> just a stupid abstraction.



> "Something happened". "Oh, ok".
> 


Never saw such a concise and apt definition of notifiers before ;-)

However, unfortunately, what other better mechanism do we have, to
deal with things that affect stuff across multiple subsystems, like
some of the users mentioned above?  Hmm...

Regards,
Srivatsa S. Bhat

