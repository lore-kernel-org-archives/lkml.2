Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933070Ab2ASUwy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 15:52:54 -0500
Received: from alice.et.bocholt.fh-gelsenkirchen.de ([193.175.197.63]:56813
	"EHLO alice.et.bocholt.fh-gelsenkirchen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932718Ab2ASUww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 15:52:52 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 alice.et.bocholt.fh-gelsenkirchen.de q0JKqkIL002281
From: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Problem] kernel hangs at boot (bisected 892d208bcf)
In-Reply-To: <gimx9jv50u.fsf@mx10.gouders.net> (Dirk Gouders's message of
	"Thu, 19 Jan 2012 20:58:09 +0100")
References: <gi39bcyff8.fsf@mx10.gouders.net> <20120119110121.GC9268@arm.com>
	<gi1uqvsx8n.fsf@karga.hank.lab> <20120119140058.GA19036@arm.com>
	<gik44nrc52.fsf@karga.hank.lab> <20120119153732.GB20558@arm.com>
	<gi1uqvwpt2.fsf@mx10.gouders.net> <gimx9jv50u.fsf@mx10.gouders.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
Date: Thu, 19 Jan 2012 21:52:44 +0100
Message-ID: <giipk7v2hv.fsf@mx10.gouders.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Greylist: Sender succeeded STARTTLS authentication, not delayed by milter-greylist-4.2.3 (alice.et.bocholt.fh-gelsenkirchen.de [192.168.0.63]); Thu, 19 Jan 2012 21:52:46 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:

> Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de> writes:
>
>> Catalin Marinas <catalin.marinas@arm.com> writes:
>>
>>> On Thu, Jan 19, 2012 at 02:38:01PM +0000, Dirk Gouders wrote:
>>>> Catalin Marinas <catalin.marinas@arm.com> writes:
>>>> > On Thu, Jan 19, 2012 at 12:16:56PM +0000, Dirk Gouders wrote:
>>>> >> Catalin Marinas <catalin.marinas@arm.com> writes:
>>>> >> > On Wed, Jan 18, 2012 at 07:32:59PM +0000, Dirk Gouders wrote:
>>>> >> >> Freeing unused kernel memory: 608k freed
>>>> >> >> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>>>> >> >> BUG: unable to handle kernel paging request at ffffffff818b232b
>>>> >> >> IP: [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>>>> > ...
>>>> >> >> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <cc> cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc
>>>> >> >> RIP  [<ffffffff818b232b>] kmemleak_late_init+0x8a/0x8a
>>>> >> >
>>>> >> > I don't really see how kmemleak could cause such error (or any of the
>>>> >> > recent changes I have made). It looks like some of the code in the
>>>> >> > .init.text section is not executable.
>>>> >
>>>> > Ah, the interesting part - 0xcc is the poison value for freed initmem.
>>>> > And from the kernel logs you posted Linux frees the initmem and later
>>>> > calls kmemleak_late_init() which should have been in the .init.text
>>>> > section.
>>>> >
>>>> > The kmemleak_late_init() function is defined as:
>>>> >
>>>> > static int __init kmemleak_late_init(void)
>>>> > {
>>>> > ...
>>>> > }
>>>> > late_initcall(kmemleak_late_init);
>>>> >
>>>> > and it must *not* be called after the initmem has been freed. Was there
>>>> > any change in the x86 or generic code with regards to the freeing of the
>>>> > init memory?
>>>> 
>>>> I tried to re-bisect this problem by marking commit
>>>> 029aeff5db879afd7760f11214b6fea45f76b58e
>>>> "kmemleak: Add support for memory hotplug" (that I previously considered
>>>> good, because it produces a different output) bad.  The attached output
>>>> shows that kmemleak_late_init is also involved but bisect did not bring
>>>> me a step further:
>>>> 
>>>> $ git bisect good f1c84dae0e
>>>> Bisecting: a merge base must be tested
>>>> [c3b92c8787367a8bb53d57d9789b558f1295cc96] Linux 3.1
>>>
>>> If you bisect to one of the kmemleak commits, they are based on 3.2-rc4
>>> so you miss any commits that may have been merged during the merge
>>> window.
>>
>> Hmm, I thought that the above was an error message but when I ignored it
>> and just continued bisecting (whith a huge set of commits), it ended in:
>>
>> b66930052abf2e41b8a978ae265303917cbe6fa0 is the first bad commit
>> commit b66930052abf2e41b8a978ae265303917cbe6fa0
>> Author: Catalin Marinas <catalin.marinas@arm.com>
>> Date:   Wed Sep 28 17:22:56 2011 +0100
>>
>>     kmemleak: When the early log buffer is exceeded, report the actual number
>>     
>>     Just telling that the early log buffer has been exceeded doesn't mean
>>     much. This patch moves the error printing to the kmemleak_init()
>>     function and displays the actual calls to the kmemleak API during early
>>     logging.
>>     
>>     Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
>>
>> :040000 040000 6b16996be5be3f428eceb5ca8a153ac72f1848b3 246cccb0645241d4a1e1c392aaea3e2ea3e34da5 M      mm
>>
>>>> ------------------------------------------------------------------------
>>>> Freeing unused kernel memory: 676k freed
>>>> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
>>>> BUG: unable to handle kernel paging request at ffffffff81892482
>>>> IP: [<ffffffff81892482>] kmemleak_late_init+0x8a/0x8a
>>>> PGD 17cd067 PUD 17d1063 PMD 3c5c8063 PTE 8000000001892163
>>>> Oops: 0011 [#1] SMP 
>>>
>>> Similar behaviour, the init memory is freed before the initcalls, so
>>> doesn't look like a kmemleak problem.
>>>
>>> Could you pass initcall_debug on the kernel command line and see how may
>>> commits are called before and after the free_initmem() call?
>>>
>>> You could also try to revert (git revert) the kmemleak commits from the
>>> latest git tree, without bisecting.
>>
>> OK, I added initcall_debug to a bad kernel I saved while bisecting and
>> attach the console output of the serial console - the output on the
>> graphical console was more complete.
>>
>> Further, I tested Linus' current master with b66930052abf2 reverted 
>>
>> ------------------------------------------------------------------------
>> commit 27e8880932050e77d2822a19fb9f39230f6363e9
>> Author: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
>> Date:   Thu Jan 19 18:31:40 2012 +0100
>>
>>     Revert "kmemleak: When the early log buffer is exceeded, report the actual number"
>>     
>>     This reverts commit b66930052abf2e41b8a978ae265303917cbe6fa0.
>>
>> commit ccb19d263fd1c9e34948e2158c53eacbff369344
>> Merge: 6a48897 c3b5003
>> Author: Linus Torvalds <torvalds@linux-foundation.org>
>> Date:   Tue Jan 17 22:26:41 2012 -0800
>> ------------------------------------------------------------------------
>>
>> and that kernel works here.
>
> Hi Catlin,
>
> I did some more testing and it turns out that I have to revert a single
> line of commit b66930052abf2 to make the kernel boot:
>
> diff --git a/mm/kmemleak.c b/mm/kmemleak.c
> index c833add..d8bbb68 100644
> --- a/mm/kmemleak.c
> +++ b/mm/kmemleak.c
> @@ -1710,6 +1710,7 @@ static void kmemleak_disable(void)
>                 return;
>  
>         /* stop any memory operation tracing */
> +       atomic_set(&kmemleak_early_log, 0);
>         atomic_set(&kmemleak_enabled, 0);
>  
>         /* check whether it is too early for a kernel thread */
>
> I started that kernel with initcall_debug and attach the dmesg output.

Hi Catlin,

I want to note that in my config CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF is
set which causes kmemleak_disable() to be called in kmemleak_init().

/*
 * Kmemleak initialization.
 */
void __init kmemleak_init(void)
{
	int i;
	unsigned long flags;

#ifdef CONFIG_DEBUG_KMEMLEAK_DEFAULT_OFF
	if (!kmemleak_skip_disable) {
		kmemleak_disable();
		return;
	}
#endif

Perhaps, this in combination with

/* enables or disables early logging of the memory operations */
static atomic_t kmemleak_early_log = ATOMIC_INIT(1);

causes problems?

Dirk
