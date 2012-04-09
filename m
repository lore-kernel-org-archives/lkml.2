Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab2DIHEw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 03:04:52 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:55959 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752292Ab2DIHEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 03:04:51 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX18B2sAs5EEBpitgug/a2xad8T4BlzuGb47lTzFqLO
	lifYADZ+YgInu4
From: Sven Joachim <svenjoac@gmx.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        David Rientjes <rientjes@google.com>, Rik van Riel <riel@redhat.com>,
        Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1 sticks-and-crashs)
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com>
	<20120408195044.13ea6c8e.akpm@linux-foundation.org>
	<CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
Date: Mon, 09 Apr 2012 09:04:46 +0200
In-Reply-To: <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com>
	(Linus Torvalds's message of "Sun, 8 Apr 2012 20:11:04 -0700")
Message-ID: <8762d9v10x.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-04-09 05:11 +0200, Linus Torvalds wrote:

> On Sun, Apr 8, 2012 at 7:50 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Sun, 8 Apr 2012 19:42:31 -0700 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>> > Apr __8 20:29:11 werner kernel: Normal free:44004kB min:44012kB low:55012kB
>>> > high:66016kB active_anon:0kB inactive_anon:0kB active_file:132kB
>>> > inactive_file:140kB unevictable:0kB isolated(anon):0kB isolated(file):0kB
>>> > present:885944kB mlocked:0kB dirty:0kB writeback:0kB mapped:0kB shmem:0kB
>>> > slab_reclaimable:13068kB slab_unreclaimable:147784kB kernel_stack:628952kB
>>> > pagetables:0kB unstable:0kB bounce:0kB writeback_tmp:0kB pages_scanned:1376
>>> > all_unreclaimable? yes
>>
>> That's claiming that 600MB of ZONE_NORMAL is being used for kernel stacks.
>
> Well, that would certainly eat up memory that is hard to get back.

While I did not experience any crashes or instabilities (yet?), I'm also
seeing memory leaks.  On a system started this morning, with hardly
anything running:

,----
| $ pstree
| init-+-acpid
|      |-atd
|      |-cron
|      |-dbus-daemon
|      |-dhclient
|      |-dictd
|      |-5*[getty]
|      |-gpm
|      |-login---zsh---pstree
|      |-lpd
|      |-master-+-pickup
|      |        `-qmgr
|      |-named---4*[{named}]
|      |-rpc.statd
|      |-rpcbind
|      |-rsyslogd---3*[{rsyslogd}]
|      |-timidity
|      |-udevd---2*[udevd]
|      `-wpa_supplicant
`----

where I would expect no more than 50 MB used, 400 MB are actually in use:

,----
| $ free
|              total       used       free     shared    buffers     cached
| Mem:       3348400    1849712    1498688          0     328960    1119180
| -/+ buffers/cache:     401572    2946828
| Swap:      3719040          0    3719040
`----

Cheers,
       Sven

> Werner - if you can reproduce this, can you get a "ps axl" or similar
> when it starts happening? Or probably even long before, since it
> probably starts long long earlier.
>
> Or does anybody see anything that keeps thread counts raised so that
> "free_task()" doesn't get done. kernel/profoe.c does that
> "profile_handoff_task()" thing - but only oprofile and the android
> low-memory-killer logic seems to use it though. But that's exactly the
> kind of thing that Werner's "configure everything" might enable -
> Werner?
>
> What else would do this? I'd suspect the /proc code, but that grabs
> the mm_struct, and those particular changes were pre-3.3 anyway.
>
> Adding Oleg just in case he has any ideas about process code changes
> (or some usermodehelper thing that leaks processes, or whatever).

