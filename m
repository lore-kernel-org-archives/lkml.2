Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab1HDTnk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 15:43:40 -0400
Received: from mx1.fusionio.com ([66.114.96.30]:52363 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753288Ab1HDTnd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 15:43:33 -0400
X-ASG-Debug-ID: 1312487012-03d6a510a6251740001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4E3AF65F.3080103@fusionio.com>
Date: Thu, 4 Aug 2011 21:43:27 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Paul Bolle <pebolle@tiscali.nl>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        "michal@harddata.com" <michal@harddata.com>
Subject: Re: Mysterious CFQ crash and RCU
References: <20110519222404.GG12600@redhat.com> <20110521210013.GJ2271@linux.vnet.ibm.com> <20110523152141.GB4019@redhat.com> <20110523153848.GC2310@linux.vnet.ibm.com> <1306401337.27271.3.camel@t41.thuisdomein> <20110603050724.GB2304@linux.vnet.ibm.com> <1307191830.23387.24.camel@t41.thuisdomein> <20110604160326.GA6093@linux.vnet.ibm.com> <1307227686.28359.23.camel@t41.thuisdomein> <20110604230633.GD6093@linux.vnet.ibm.com> <20110804150504.GB429@redhat.com>
X-ASG-Orig-Subj: Re: Mysterious CFQ crash and RCU
In-Reply-To: <20110804150504.GB429@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1312487012
X-Barracuda-URL: http://10.101.1.180:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using per-user scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.70907
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-08-04 17:05, Vivek Goyal wrote:
> On Sat, Jun 04, 2011 at 04:06:33PM -0700, Paul E. McKenney wrote:
>> On Sun, Jun 05, 2011 at 12:48:05AM +0200, Paul Bolle wrote:
>>> On Sat, 2011-06-04 at 09:03 -0700, Paul E. McKenney wrote:
>>>> More like "based on these diagnostics, I see no evidence of the RCU
>>>> implementation misbehaving."  Which is of course different than "I can
>>>> prove that the RCU implementation is not misbehaving".  That said, the
>>>> fact that you are running on a single CPU makes it hard for me to see
>>>> any latitude for RCU-implementation misbehavior.
>>>>
>>>> Clearly something is wrong somewhere.
>>>
>>> Yes.
>>>
>>>> Given the fact that on a single-CPU
>>>> system, synchronize_rcu() is a no-op, and given that you weren't able
>>>> to reproduce with CONFIG_TREE_PREEMPT_RCU=y, my guess is that there is
>>>> a synchronize_rcu() that occasionally (illegally) gets executed within
>>>> an RCU read-side critical section.
>>>
>>> I think I finally found it!
>>
>> Very cool!!!
>>
>>> The culprit seems to be io_context.ioc_data (not the most clear of
>>> names!). It seems to be a single entry "last-hit cache" of an hlist
>>> called cic_list. (There are three, subtly different, cic_lists in the
>>> CFQ code!) It is not entirely clear, but that last-hit cache can get out
>>> of sync with the hlist it is supposed to cache. My guess it that every
>>> now and then a member of the hlist gets deleted while it's still in that
>>> (single entry) cache. If it then gets retrieved from that cache it
>>> already points to poisoned memory. For some strange reason this only
>>> results in an Oops if one or more debugging options are set (as are set
>>> in the Fedora Rawhide non-stable kernels that I ran into this). I have
>>> no clue whatsoever, why that is ...
>>
>> Oooh...  If I understand you correctly, this is exactly analogous to my
>> first-ever RCU bug way back in the early 90s.  This was a hashed version
>> of a BSD-style routing table, where each hash bucket maintained a pointer
>> to the last routing entry used.  When I deleted a routing entry, I forgot
>> to check the last-entry pointer.
>>
>> The amazing thing is that the guy who found and fixed this bug generated
>> a correct fix despite having absolutely no idea what RCU was or how it
>> worked.  All he knew was that if he waited for the sun to reach Oregon,
>> his users were going to be way beyond upset.  ;-)
>>
>>> Anyhow, after ripping out ioc_data this bug seems to have disappeared!
>>> Jens, Vivek, could you please have a look at this? In the mean time I
>>> hope to pinpoint this issue and draft a small patch to really solve it
>>> (ie, not by simply ripping out ioc_data).
>>
>> Again, very cool!!!
> 
> Hi Paul,
> 
> Remember this CFQ issue where we suspected that we are freeing up an
> object before rcu period is over. We thought we fixed it. Guess what,
> it seems be to be back.
> 
> **************************************************************************
> [21265.163144] BUG: unable to handle kernel paging request at 6b6b6b43
> [21265.164022] IP: [<f7d55fe0>] cic_free_func+0x10/0x6c [cfq_iosched]
> [21265.164022] *pde = 00000000 
> [21265.164022] Oops: 0000 [#1] SMP 
> [21265.164022] Modules linked in: cfq_iosched tcp_lp fuse arc4 ppdev
> snd_intel8x0m snd_intel8x0 snd_ac97_codec ac97_bus snd_seq snd_seq_device
> microcode
>  snd_pcm joydev snd_timer ath5k pcspkr snd_page_alloc thinkpad_acpi
> i2c_i801
> ath mac80211 snd soundcore cfg80211 rfkill parport_pc parport e1000
> iTCO_wd
> t iTCO_vendor_support binfmt_misc uinput yenta_socket video radeon ttm
> drm_kms_helper drm i2c_algo_bit i2c_core [last unloaded: scsi_wait_scan]
> [21265.164022] 
> [21265.164022] Pid: 18514, comm: mandb Not tainted
> 3.0.0-1.local2.fc17.i686 #1
> IBM        /       
> [21265.164022] EIP: 0060:[<f7d55fe0>] EFLAGS: 00010286 CPU: 0
> [21265.164022] EIP is at cic_free_func+0x10/0x6c [cfq_iosched]
> [21265.164022] EAX: f242e400 EBX: 6b6b6b43 ECX: 00000246 EDX: 6b6b6b43
> [21265.164022] ESI: f242e400 EDI: f7d55fd0 EBP: df92df04 ESP: df92def0
> [21265.164022]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> [21265.164022] Process mandb (pid: 18514, ti=df92c000 task=ed1554c0
> task.ti=df92c000)
> [21265.164022] Stack:
> [21265.164022]  c0468df7 c0af0cb0 6b6b6b6b f242e400 f7d55fd0 df92df18
> f7d54510
> f242e400
> [21265.164022]  ed1554c0 ed155898 df92df20 f7d54530 df92df2c c05cc8ba
> f242e400
> df92df40
> [21265.164022]  c05cc94a ed1554c0 00000012 df92df74 df92df8c c04423e2
> eedf2b5c
> eedf2b00
> [21265.164022] Call Trace:
> [21265.164022]  [<c0468df7>] ? lock_is_held+0x73/0x7b
> [21265.164022]  [<f7d55fd0>] ? cfqq_process_refs+0x18/0x18 [cfq_iosched]
> [21265.164022]  [<f7d54510>] call_for_each_cic+0x3e/0x4c [cfq_iosched]
> [21265.164022]  [<f7d54530>] cfq_free_io_context+0x12/0x14 [cfq_iosched]
> [21265.164022]  [<c05cc8ba>] put_io_context+0x34/0x5c
> [21265.164022]  [<c05cc94a>] exit_io_context+0x68/0x6d
> [21265.164022]  [<c04423e2>] do_exit+0x62f/0x66a
> [21265.164022]  [<c0442634>] do_group_exit+0x63/0x86
> [21265.164022]  [<c044266f>] sys_exit_group+0x18/0x18
> [21265.164022]  [<c083b0df>] sysenter_do_call+0x12/0x38
> [21265.164022] Code: 5f 5d c3 55 89 e5 3e 8d 74 26 00 8b 50 3c 03 50 40 8b
> 00
> 29 d0 79 02 0f 0b 5d c3 55 89 e5 57 56 53 83 ec 08 3e 8d 74 26 00 89 d3 <8
> b> 12 89 c6 f6 c2 01 75 02 0f 0b 8d 78 08 89 f8 89 55 ec e8 c8 
> [21265.164022] EIP: [<f7d55fe0>] cic_free_func+0x10/0x6c [cfq_iosched]
> SS:ESP
> 0068:df92def0
> [21265.164022] CR2: 000000006b6b6b43
> [21265.363749] ---[ end trace a779435da6d0a152 ]---
> 
> **************************************************************************
> Again details have been added to old bz.
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=577968
> 
> Now two users have run into this issue. PaulB, again can reliably
> reproduce this issue even with 3.0 kernels.  He  just needs to run
> "mandb -c" on this machine.
> 
> He has again run the CFQ debug V2 patch which seems to be telling that
> cfq_io_context object was freed while in rcu read section.
> 
> **************************************************************************
> [  562.598881] debug: Will exit io context cic=0xf0469230, Next pointer is  
> (null)
> [  562.598881] debug: cic=0xf0469230 exit io context done. Next pointer is  
> (null)
> [  562.598881] debug: Will decouple-free cic cic=0xf0469230, Next pointer
> is  (null)
> [  562.633403] debug: cic=0xf0469230 decouple-free cic done. Next pointer
> is  (null)
> [  562.644949] debug: freeing up cic=f0469230
> [  562.652971] cic=f0469230 freed while in RCU read lock
> 
> *****************************************************************************
> 
> I am hoping that I have written the debug patch right. As usual i am
> running out of ideas on how to debug it further. Anything debug
> information you would like to have a look at?

Darn! Vivek, can you re-send the debug patch for inspection?

-- 
Jens Axboe

