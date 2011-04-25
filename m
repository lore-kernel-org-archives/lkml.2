Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab1DYLr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 07:47:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33734 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758286Ab1DYLr4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 07:47:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jAk51c2H0BGKnhuH1CjJp6AtC6KHXaQ2KorP88BOzjCFk3yFnTrC26kQzBoXblPmIl
         MuyNt0nZ+mmeAssrCawwYYN+4N3KquUX9YS6LJp3V0LExq3R4frW5CTq5sY9BUxdZdvr
         N05swO3qf+6iZrR9CnfhLd9D8890R2DOCFMk0=
MIME-Version: 1.0
In-Reply-To: <20110425134145.048f7cc1@neptune.home>
References: <20110424202158.45578f31@neptune.home>
	<20110424235928.71af51e0@neptune.home>
	<20110425114429.266A.A69D9226@jp.fujitsu.com>
	<BANLkTinVQtLbmBknBZeY=7w7AOyQk61Pew@mail.gmail.com>
	<20110425111705.786ef0c5@neptune.home>
	<BANLkTi=2DK+iq-5NEFKexe0QhpW8G0RL8Q@mail.gmail.com>
	<20110425123444.639aad34@neptune.home>
	<20110425134145.048f7cc1@neptune.home>
Date: Mon, 25 Apr 2011 14:47:53 +0300
X-Google-Sender-Auth: tKsZTAKTR_-rrUoHwZdPjhZGIIk
Message-ID: <BANLkTikpt7E5eE9vv9NFbNAwT_O6sHnQvA@mail.gmail.com>
Subject: Re: 2.6.39-rc4+: Kernel leaking memory during FS scanning, regression?
From: Pekka Enberg <penberg@kernel.org>
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
Cc: Mike Frysinger <vapier.adi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 2:41 PM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> On Mon, 25 April 2011 Bruno Prémont wrote:
>> On Mon, 25 April 2011 Pekka Enberg wrote:
>> > On Mon, Apr 25, 2011 at 12:17 PM, Bruno Prémont wrote:
>> > > On Mon, 25 April 2011 Mike Frysinger wrote:
>> > >> On Sun, Apr 24, 2011 at 22:42, KOSAKI Motohiro wrote:
>> > >> >> On Sun, 24 April 2011 Bruno Prémont wrote:
>> > >> >> > On an older system I've been running Gentoo's revdep-rebuild to check
>> > >> >> > for system linking/*.la consistency and after doing most of the work the
>> > >> >> > system starved more or less, just complaining about stuck tasks now and
>> > >> >> > then.
>> > >> >> > Memory usage graph as seen from userspace showed sudden quick increase of
>> > >> >> > memory usage though only a very few MB were swapped out (c.f. attached RRD
>> > >> >> > graph).
>> > >> >>
>> > >> >> Seems I've hit it once again (though detected before system was fully
>> > >> >> stalled by trying to reclaim memory without success).
>> > >> >>
>> > >> >> This time it was during simple compiling...
>> > >> >> Gathered info below:
>> > >> >>
>> > >> >> /proc/meminfo:
>> > >> >> MemTotal:         480660 kB
>> > >> >> MemFree:           64948 kB
>> > >> >> Buffers:           10304 kB
>> > >> >> Cached:             6924 kB
>> > >> >> SwapCached:         4220 kB
>> > >> >> Active:            11100 kB
>> > >> >> Inactive:          15732 kB
>> > >> >> Active(anon):       4732 kB
>> > >> >> Inactive(anon):     4876 kB
>> > >> >> Active(file):       6368 kB
>> > >> >> Inactive(file):    10856 kB
>> > >> >> Unevictable:          32 kB
>> > >> >> Mlocked:              32 kB
>> > >> >> SwapTotal:        524284 kB
>> > >> >> SwapFree:         456432 kB
>> > >> >> Dirty:                80 kB
>> > >> >> Writeback:             0 kB
>> > >> >> AnonPages:          6268 kB
>> > >> >> Mapped:             2604 kB
>> > >> >> Shmem:                 4 kB
>> > >> >> Slab:             250632 kB
>> > >> >> SReclaimable:      51144 kB
>> > >> >> SUnreclaim:       199488 kB   <--- look big as well...
>> > >> >> KernelStack:      131032 kB   <--- what???
>> > >> >
>> > >> > KernelStack is used 8K bytes per thread. then, your system should have
>> > >> > 16000 threads. but your ps only showed about 80 processes.
>> > >> > Hmm... stack leak?
>> > >>
>> > >> i might have a similar report for 2.6.39-rc4 (seems to be working fine
>> > >> in 2.6.38.4), but for embedded Blackfin systems running gdbserver
>> > >> processes over and over (so lots of short lived forks)
>> > >>
>> > >> i wonder if you have a lot of zombies or otherwise unclaimed resources
>> > >> ?  does `ps aux` show anything unusual ?
>> > >
>> > > I've not seen anything special (no big amount of threads behind my about 80
>> > > processes, even after kernel oom-killed nearly all processes the hogged
>> > > memory has not been freed. And no, there are no zombies around).
>> > >
>> > > Here it seems to happened when I run 2 intensive tasks in parallel, e.g.
>> > > (re)emerging gimp and running revdep-rebuild -pi in another terminal.
>> > > This produces a fork rate of about 100-300 per second.
>> > >
>> > > Suddenly kmalloc-128 slabs stop being freed and things degrade.
>> > >
>> > > Trying to trace some of the kmalloc-128 slab allocations I end up seeing
>> > > lots of allocations like this:
>> > >
>> > > [ 1338.554429] TRACE kmalloc-128 alloc 0xc294ff00 inuse=30 fp=0xc294ff00
>> > > [ 1338.554434] Pid: 1573, comm: collectd Tainted: G        W   2.6.39-rc4-jupiter-00187-g686c4cb #1
>> > > [ 1338.554437] Call Trace:
>> > > [ 1338.554442]  [<c10aef47>] trace+0x57/0xa0
>> > > [ 1338.554447]  [<c10b07b3>] alloc_debug_processing+0xf3/0x140
>> > > [ 1338.554452]  [<c10b0972>] T.999+0x172/0x1a0
>> > > [ 1338.554455]  [<c10b95d8>] ? get_empty_filp+0x58/0xc0
>> > > [ 1338.554459]  [<c10b95d8>] ? get_empty_filp+0x58/0xc0
>> > > [ 1338.554464]  [<c10b0a52>] kmem_cache_alloc+0xb2/0x100
>> > > [ 1338.554468]  [<c10c08b5>] ? path_put+0x15/0x20
>> > > [ 1338.554472]  [<c10b95d8>] ? get_empty_filp+0x58/0xc0
>> > > [ 1338.554476]  [<c10b95d8>] get_empty_filp+0x58/0xc0
>> > > [ 1338.554481]  [<c10c323f>] path_openat+0x1f/0x320
>> > > [ 1338.554485]  [<c10a0a4e>] ? __access_remote_vm+0x19e/0x1d0
>> > > [ 1338.554490]  [<c10c3620>] do_filp_open+0x30/0x80
>> > > [ 1338.554495]  [<c10b0a30>] ? kmem_cache_alloc+0x90/0x100
>> > > [ 1338.554500]  [<c10c16f8>] ? getname_flags+0x28/0xe0
>> > > [ 1338.554505]  [<c10cd522>] ? alloc_fd+0x62/0xe0
>> > > [ 1338.554509]  [<c10c1731>] ? getname_flags+0x61/0xe0
>> > > [ 1338.554514]  [<c10b781d>] do_sys_open+0xed/0x1e0
>> > > [ 1338.554519]  [<c10b7979>] sys_open+0x29/0x40
>> > > [ 1338.554524]  [<c1391390>] sysenter_do_call+0x12/0x26
>> > > [ 1338.556764] TRACE kmalloc-128 alloc 0xc294ff80 inuse=31 fp=0xc294ff80
>> > > [ 1338.556774] Pid: 1332, comm: bash Tainted: G        W   2.6.39-rc4-jupiter-00187-g686c4cb #1
>> > > [ 1338.556779] Call Trace:
>> > > [ 1338.556794]  [<c10aef47>] trace+0x57/0xa0
>> > > [ 1338.556802]  [<c10b07b3>] alloc_debug_processing+0xf3/0x140
>> > > [ 1338.556807]  [<c10b0972>] T.999+0x172/0x1a0
>> > > [ 1338.556812]  [<c10b95d8>] ? get_empty_filp+0x58/0xc0
>> > > [ 1338.556817]  [<c10b95d8>] ? get_empty_filp+0x58/0xc0
>> > > [ 1338.556821]  [<c10b0a52>] kmem_cache_alloc+0xb2/0x100
>> > > [ 1338.556826]  [<c10b95d8>] ? get_empty_filp+0x58/0xc0
>> > > [ 1338.556830]  [<c10b95d8>] get_empty_filp+0x58/0xc0
>> > > [ 1338.556841]  [<c121fca8>] ? tty_ldisc_deref+0x8/0x10
>> > > [ 1338.556849]  [<c10c323f>] path_openat+0x1f/0x320
>> > > [ 1338.556857]  [<c11e2b3e>] ? fbcon_cursor+0xfe/0x180
>> > > [ 1338.556863]  [<c10c3620>] do_filp_open+0x30/0x80
>> > > [ 1338.556868]  [<c10b0a30>] ? kmem_cache_alloc+0x90/0x100
>> > > [ 1338.556873]  [<c10c5e8e>] ? do_vfs_ioctl+0x7e/0x580
>> > > [ 1338.556878]  [<c10c16f8>] ? getname_flags+0x28/0xe0
>> > > [ 1338.556886]  [<c10cd522>] ? alloc_fd+0x62/0xe0
>> > > [ 1338.556891]  [<c10c1731>] ? getname_flags+0x61/0xe0
>> > > [ 1338.556898]  [<c10b781d>] do_sys_open+0xed/0x1e0
>> > > [ 1338.556903]  [<c10b7979>] sys_open+0x29/0x40
>> > > [ 1338.556913]  [<c1391390>] sysenter_do_call+0x12/0x26
>> > >
>> > > Collectd is system monitoring daemon that counts processes, memory
>> > > usage an much more, reading lots of files under /proc every 10
>> > > seconds.
>> > > Maybe it opens a process related file at a racy moment and thus
>> > > prevents the 128 slabs and kernel stacks from being released?
>> > >
>> > > Replaying the scenario I'm at:
>> > > Slab:              43112 kB
>> > > SReclaimable:      25396 kB
>> > > SUnreclaim:        17716 kB
>> > > KernelStack:       16432 kB
>> > > PageTables:         1320 kB
>> > >
>> > > with
>> > > kmalloc-256           55     64    256   16    1 : tunables    0    0    0 : slabdata      4      4      0
>> > > kmalloc-128        66656  66656    128   32    1 : tunables    0    0    0 : slabdata   2083   2083      0
>> > > kmalloc-64          3902   3904     64   64    1 : tunables    0    0    0 : slabdata     61     61      0
>> > >
>> > > (and compiling process tree now SIGSTOPped in order to have system
>> > > not starve immediately so I can look around for information)
>> > >
>> > > If I resume one of the compiling process trees both KernelStack and
>> > > slab (kmalloc-128) usage increase quite quickly (and seems to never
>> > > get down anymore) - probably at same rate as processes get born (no
>> > > matter when they end).
>> >
>> > Looks like it might be a leak in VFS. You could try kmemleak to narrow
>> > it down some more. See Documentation/kmemleak.txt for details.
>>
>> Hm, seems not to be willing to let me run kmemleak... each time I put
>> on my load scenario I get "BUG: unable to handle kernel " on console
>> as a last breath from the system. (the rest of the trace never shows up)
>>
>> Going to try harder to get at least a complete trace...
>
> After many attempts I got something from kmemleak (running on VESAfb
> instead of vgacon or nouveau KMS), netconsole disabled.
> For the crashes my screen is just too small to display the interesting
> part of it (maybe I can get it via serial console at a later attempt)
>
> What kmemcheck finds does look very repetitive:
> unreferenced object 0xdd294540 (size 328):
>  comm "collectd", pid 1541, jiffies 4294940278 (age 699.510s)
>  hex dump (first 32 bytes):
>    40 57 d2 dc 00 00 00 00 00 00 00 00 00 00 00 00  @W..............
>    00 00 00 00 00 00 00 00 6d 41 00 00 00 00 00 00  ........mA......
>  backtrace:
>    [<c138aae7>] kmemleak_alloc+0x27/0x50
>    [<c10b0b28>] kmem_cache_alloc+0x88/0x120
>    [<c10f452e>] proc_alloc_inode+0x1e/0x90
>    [<c10cd0ec>] alloc_inode+0x1c/0x80
>    [<c10cd162>] new_inode+0x12/0x40
>    [<c10f54bc>] proc_pid_make_inode+0xc/0xa0
>    [<c10f6835>] proc_pident_instantiate+0x15/0xa0
>    [<c10f693d>] proc_pident_lookup+0x7d/0xb0
>    [<c10f69a7>] proc_tgid_base_lookup+0x17/0x20
>    [<c10c1f52>] d_alloc_and_lookup+0x32/0x60
>    [<c10c23b4>] do_lookup+0xa4/0x250
>    [<c10c3653>] do_last+0xe3/0x700
>    [<c10c4882>] path_openat+0x92/0x320
>    [<c10c4bf0>] do_filp_open+0x30/0x80
>    [<c10b8ded>] do_sys_open+0xed/0x1e0
>    [<c10b8f49>] sys_open+0x29/0x40
> unreferenced object 0xdd0fa180 (size 128):
>  comm "collectd", pid 1541, jiffies 4294940278 (age 699.510s)
>  hex dump (first 32 bytes):
>    1c c0 00 00 04 00 00 00 00 00 00 00 00 02 20 00  .............. .
>    00 5e 24 dd 65 f6 12 00 03 00 00 00 a4 a1 0f dd  .^$.e...........
>  backtrace:
>    [<c138aae7>] kmemleak_alloc+0x27/0x50
>    [<c10b0b28>] kmem_cache_alloc+0x88/0x120
>    [<c10cb95e>] d_alloc+0x1e/0x180
>    [<c10f5027>] proc_fill_cache+0xd7/0x140
>    [<c10f7b27>] proc_task_readdir+0x237/0x300
>    [<c10c7cf4>] vfs_readdir+0x84/0xa0
>    [<c10c7d74>] sys_getdents64+0x64/0xb0
>    [<c13945d0>] sysenter_do_call+0x12/0x26
>    [<ffffffff>] 0xffffffff
> unreferenced object 0xdd294690 (size 328):
>  comm "collectd", pid 1541, jiffies 4294940278 (age 699.510s)
>  hex dump (first 32 bytes):
>    40 57 d2 dc 00 00 00 00 00 00 00 00 00 00 00 00  @W..............
>    00 00 00 00 00 00 00 00 6d 41 00 00 00 00 00 00  ........mA......
>  backtrace:
>    [<c138aae7>] kmemleak_alloc+0x27/0x50
>    [<c10b0b28>] kmem_cache_alloc+0x88/0x120
>    [<c10f452e>] proc_alloc_inode+0x1e/0x90
>    [<c10cd0ec>] alloc_inode+0x1c/0x80
>    [<c10cd162>] new_inode+0x12/0x40
>    [<c10f54bc>] proc_pid_make_inode+0xc/0xa0
>    [<c10f6791>] proc_task_instantiate+0x11/0xa0
>    [<c10f506d>] proc_fill_cache+0x11d/0x140
>    [<c10f7b27>] proc_task_readdir+0x237/0x300
>    [<c10c7cf4>] vfs_readdir+0x84/0xa0
>    [<c10c7d74>] sys_getdents64+0x64/0xb0
>    [<c13945d0>] sysenter_do_call+0x12/0x26
>    [<ffffffff>] 0xffffffff
> unreferenced object 0xdd22df80 (size 128):
>  comm "collectd", pid 1541, jiffies 4294940278 (age 699.510s)
>  hex dump (first 32 bytes):
>    1c c0 00 00 04 00 00 00 00 00 00 00 00 02 20 00  .............. .
>    80 2c 13 dd 23 c5 6f d6 06 00 00 00 a4 df 22 dd  .,..#.o.......".
>  backtrace:
>    [<c138aae7>] kmemleak_alloc+0x27/0x50
>    [<c10b0b28>] kmem_cache_alloc+0x88/0x120
>    [<c10cb95e>] d_alloc+0x1e/0x180
>    [<c10c1f40>] d_alloc_and_lookup+0x20/0x60
>    [<c10c23b4>] do_lookup+0xa4/0x250
>    [<c10c3653>] do_last+0xe3/0x700
>    [<c10c4882>] path_openat+0x92/0x320
>    [<c10c4bf0>] do_filp_open+0x30/0x80
>    [<c10b8ded>] do_sys_open+0xed/0x1e0
>    [<c10b8f49>] sys_open+0x29/0x40
>    [<c13945d0>] sysenter_do_call+0x12/0x26
>    [<ffffffff>] 0xffffffff
>
> All I could fetch from the system (300k, expands to ~16MB
> for some portion of announced 6k entries):
>  http://homepage.internet.lu/BrunoP/jupiter.kmemleak.bz2

VFS and procfs are all over the traces - I'm adding some more people
to CC. Btw, did you manage to grab any kmemleak related crashes? It
would be good to get them fixed as well.

                        Pekka
