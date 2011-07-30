Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab1G3VZV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 17:25:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:39615 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366Ab1G3VZN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 17:25:13 -0400
MIME-Version: 1.0
In-Reply-To: <20110730182613.GA15151@ksplice.com>
References: <4E1FF63F.4040704@gmail.com>
	<20110715210420.GA22551@redhat.com>
	<1311249346.2098.12.camel@t41.thuisdomein>
	<1311965462.2351.28.camel@t41.thuisdomein>
	<20110730182613.GA15151@ksplice.com>
Date: Sat, 30 Jul 2011 17:25:10 -0400
Message-ID: <CAEuB=Apgx_nDz-oeKW8E3c96+3ZCuWVQymtbmeT3nJNvgph1SA@mail.gmail.com>
Subject: Re: recursive locking: epoll.
From: Nelson Elhage <nelhage@ksplice.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Davide Libenzi <davidel@xmailserver.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 2:26 PM, Nelson Elhage <nelhage@ksplice.com> wrote:
> Oof, this is kinda ugly.
>
> I *believe* that as of
>
>  22bacca4 epoll: prevent creating circular epoll structures
>
> the epoll locking is correct, with the rule that two ep->mtx's can be
> locked recursively iff ep1 contains ep2 (possibly indirectly), and
> that if ep1 contains ep2, ep1 will always be locked first. Since
> 22bacca4 eliminated the possibility of epoll cycles, this means there
> is a well-defined lock order.
>
> I *think* that for any static configuration of epoll file descriptors,
> we can fix the problem by doing something like using the "call_nests"
> parameter passed by ep_call_nested as the lock subkey, but I haven't
> thought this through completely.
>
> However, since that lock order is subject to change, and even
> reversal, at runtime, I think the following (pathological) sequence of
> userspace calls will trigger lockdep warnings, even though there is
> never any risk of deadlock:

Thinking about this more, I think that the "call_nests" approach won't
have this problem, since that lets the locks change subclasses exactly
as necessary. Unless someone beats me to it, I'll see if I can put
such a patch together.

- Nelson

>
>  - Create epoll fds ep1 and ep2
>  - Add ep1 to ep2
>  - Do some operations that result in recursive locking
>  - Remove ep1 from ep2
>  - Add ep2 to ep1
>  - Do some operations that result in recursive locking
>
> In fact, that program should trigger warnings even if we did the
> pathological thing of using the address of the 'struct eventpoll' as
> the subclass [1], since it is *literally the same two locks* that are
> getting acquired in different orders at different times.
>
> I also don't see a way to simplify the epoll locking without adding
> more restrictions to how the API can be used. As far as I can tell,
> the situation really is just that nasty.
>
> - Nelson
>
> [1] Never mind that the "subclass" is an unsigned int, so we can't
>    even do that directly on 64-bit systems.
>
> On Fri, Jul 29, 2011 at 08:50:55PM +0200, Paul Bolle wrote:
>> (Sent to the addresses get_maintainer.pl suggested and to Davide and
>> Nelson, because this is about code they cared about half a year ago.
>> CC'ed to the addresses involved until now.)
>>
>> On Thu, 2011-07-21 at 13:55 +0200, Paul Bolle wrote:
>> > That number turned out to be 722472
>> > ( https://bugzilla.redhat.com/show_bug.cgi?id=722472 ).
>>
>> 0) This seems to be a lockdep false alarm. The cause is an epoll
>> instance added to another epoll instance (ie, nesting epoll instances).
>> Apparently lockdep isn't supplied enough information to determine what's
>> going on here. Now there might be a number of ways to fix this. But
>> after having looked at this for quite some time and updating the above
>> bug report a number of times, I guessed that involving people outside
>> those tracking that report might move things forward towards a solution.
>> At least, I wasn't able to find a, well, clean solution.
>>
>> 1) The call chain triggering the warning with the nice
>>     *** DEADLOCK ***
>>
>> line can be summarized like this:
>>
>> sys_epoll_ctl
>>     mutex_lock                          epmutex
>>     ep_call_nested
>>         ep_loop_check_proc
>>             mutex_lock                      ep->mtx
>>             mutex_unlock                    ep->mtx
>>     mutex_lock                              ep->mtx
>>     ep_eventpoll_poll
>>         ep_ptable_queue_proc
>>         ep_call_nested
>>             ep_poll_readyevents_pro
>>                 ep_scan_ready_list
>>                     mutex_lock                  ep->mtx
>>                     ep_read_events_proc
>>                     mutex_unlock                ep->mtx
>>     mutex_unlock                            ep->mtx
>>     mutex_unlock                        epmutex
>>
>> 2) When ep_scan_ready_list() calls mutex_lock(), lockdep notices
>> recursive locking on ep->mtx. It is not supplied enough information to
>> determine that the lock is related to two separate epoll instances (the
>> outer instance and the nested instance). The solution appears to involve
>> supplying lockdep that information (ie, "lockdep annotation").
>>
>> 3) Please see the bugzilla.redhat.com report for further background.
>>
>>
>> Paul Bolle
>>
>
