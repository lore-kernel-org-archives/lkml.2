Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab1EXBMM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 21:12:12 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39834 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753953Ab1EXBMJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 21:12:09 -0400
Date: Mon, 23 May 2011 18:12:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110524011203.GK7428@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4DD6F4A2.1070401@kernel.org>
 <20110520231428.GN2366@linux.vnet.ibm.com>
 <4DD6F64C.3030402@kernel.org>
 <20110520234923.GQ2366@linux.vnet.ibm.com>
 <4DD70120.9090801@kernel.org>
 <20110521131844.GE2271@linux.vnet.ibm.com>
 <20110521140845.GA12157@linux.vnet.ibm.com>
 <4DDAC01E.7050602@kernel.org>
 <20110523212530.GF7428@linux.vnet.ibm.com>
 <4DDAD934.9010603@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <4DDAD934.9010603@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 03:01:24PM -0700, Yinghai Lu wrote:
> On 05/23/2011 02:25 PM, Paul E. McKenney wrote:
> > On Mon, May 23, 2011 at 01:14:22PM -0700, Yinghai Lu wrote:
> >> On 05/21/2011 07:08 AM, Paul E. McKenney wrote:
> >>> On Sat, May 21, 2011 at 06:18:44AM -0700, Paul E. McKenney wrote:
> >>>> On Fri, May 20, 2011 at 05:02:40PM -0700, Yinghai Lu wrote:
> >>>>> On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
> >>>>>> On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
> >>>>> ...
> >>>>>>>
> >>>>>>> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
> >>>>>>
> >>>>>> OK, just to make sure I understand...  You are compiling exactly the
> >>>>>> same kernel source tree with exactly the same .config, just with two
> >>>>>> different versions of gcc, correct?
> >>>>> yes.
> >>>>>>
> >>>>>> If so, it is quite possible that the slow one is the correct one.  :-/
> >>>>> yeah, new version always have problem.
> >>>>>
> >>>>> looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1
> >>>>
> >>>> OK, so fedora14 is the fast one (4.5.1) and opensuse11.3 is the slow
> >>>> one (4.5.0), correct?
> >>>
> >>> And does commit c7a3786030 help?  This commit (from Peter Zijlstra)
> >>> tidied up RCU kthreads' scheduler interactions.  The patch is below,
> >>> though it is probably more convenient to pull it from the rcu/next
> >>> branch of:
> >>>
> >>>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
> >>>
> > 
> > Thank you for testing this!
> 
> it's ok. don't want to see our servers have problem with newer kernel.
> 
> > This is with the same config that you emailed out on May 12th?
> 
> yes.
> 
> > 
> > In particular, CONFIG_TREE_RCU=y?
> > 
> >> [  337.132517] INFO: task rcun0:8 blocked for more than 120 seconds.
> >> [  337.133238] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> [  337.160396] rcun0           D 0000000000000000     0     8      2 0x00000000
> >> [  337.161232]  ffff882070d3fe90 0000000000000046 ffff882070d3e000 0000000000004000
> >> [  337.161291]  00000000001d1f80 ffff882070d3ffd8 00000000001d1f80 ffff882070d3ffd8
> >> [  337.161348]  0000000000004000 00000000001d1f80 ffff882070d18000 ffff882070d422b0
> >> [  337.161404] Call Trace:
> >> [  337.161433]  [<ffffffff810afab6>] ? __lock_release+0x166/0x16f
> >> [  337.161459]  [<ffffffff81c1dae1>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
> >> [  337.161486]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> >> [  337.161512]  [<ffffffff810add8a>] ? trace_hardirqs_on+0xd/0xf
> >> [  337.161533]  [<ffffffff810ce633>] ? rcu_cpu_kthread_should_stop+0x137/0x137
> >> [  337.161558]  [<ffffffff81099e41>] kthread+0x8c/0xa8
> >> [  337.161584]  [<ffffffff81c257d4>] kernel_thread_helper+0x4/0x10
> >> [  337.161606]  [<ffffffff81c1dd80>] ? retint_restore_args+0xe/0xe
> >> [  337.161627]  [<ffffffff81099db5>] ? __init_kthread_worker+0x5b/0x5b
> >> [  337.161645]  [<ffffffff81c257d0>] ? gs_change+0xb/0xb
> >> [  337.161651] no locks held by rcun0/8.
> > 
> > This is quite surprising.  The "rcun" kthreads invoke rcu_node_kthread(),
> > which does not call rcu_cpu_kthread_should_stop().
> > 
> > But perhaps the stack backtrace got confused.
> > 
> > Could you please try the following diagnostic patch to help me work out
> > where the rcun threads are getting stuck?

And this is also strange...

> [  275.679636] RAMDISK: gzip image found at block 0
> [  277.504381] rcun ffffffff82440b00 starting wait for work.
> [  277.504693] rcun ffffffff82440b00 completed wait for work.
> [  277.504951] rcun ffffffff82440b00 initiating boost.
> [  277.515920] rcun ffffffff82440b00 completed boost.
> [  277.516157] rcun ffffffff82440b00 awaking rcuc2.
> [  277.535818] rcun ffffffff82440b00 awakened rcuc2.
> [  277.536075] rcun ffffffff82440b00 starting wait for work.
> [  277.604609] EXT3-fs: barriers not enabled
> [  277.605278] kjournald starting.  Commit interval 5 seconds
> [  277.605473] EXT3-fs (ram0): warning: maximal mount count reached, running e2fsck is recommended
> [  277.605493] EXT3-fs (ram0): using internal journal
> [  277.605505] EXT3-fs (ram0): mounted filesystem with writeback data mode
> [  277.605555] VFS: Mounted root (ext3 filesystem) on device 1:0.
> [  277.605600] async_waiting @ 1
> [  277.605604] async_continuing @ 1 after 0 usec
> [  277.669722] Freeing unused kernel memory: 2892k freed
> INIT: version 2.86 booting
> System Boot Control: Running /etc/init.d/boot
> Mounting procfs at /proc                                             done
> Mounting sysfs at /sys                                               done
> Mounting debugfs at /sys/kernel/debug                                done
> Mounting tmpfs at /dev                                               done
> Initializing /dev                                                    done
> Mounting devpts at /dev/pts                                          done
> Boot logging started on /dev/ttyS0(/dev/console) at Wed May 25 13:43:55 2011
> FATAL: Could not load /lib/modules/2.6.39-tip-yh-05892-gb7b703b-dirty/modules.dep: No such file or directory
> Setting up the hardware clockmodprobe: FATAL: Could not load /lib/modules/2.6.39-tip-yh-05892-gb7b703b-dirty/modules.dep: No such file or directory
> 
> hwclock: With --noadjfile, you must specify either --utc or --localtime
> [8[  277.836052] udevd (18674): /proc/18674/oom_adj is deprecated, please use /proc/18674/oom_score_adj instead.
> fa[  277.845689] udevd version 128 started
> iled
> Disabling IP forwarding                                              done
>                                                                      done
> Starting udevd:                                                      done
> Loading drivers, configuring devices: [  278.019705] rcun ffffffff82441300 starting wait for work.
> [  278.020057] rcun ffffffff82441300 completed wait for work.
> [  278.020314] rcun ffffffff82441300 initiating boost.
> [  278.035052] rcun ffffffff82441300 completed boost.
> [  278.035383] rcun ffffffff82441300 awaking rcuc141.
> [  278.054945] rcun ffffffff82441300 awakened rcuc141.
> [  278.055197] rcun ffffffff82441300 starting wait for work.
> [  278.159361] rcun ffffffff82441100 starting wait for work.
> [  278.159666] rcun ffffffff82441100 completed wait for work.
> [  278.159949] rcun ffffffff82441100 initiating boost.
> [  278.174805] rcun ffffffff82441100 completed boost.
> [  278.175044] rcun ffffffff82441100 awaking rcuc111.
> [  278.194728] rcun ffffffff82441100 awakened rcuc111.
> [  278.194987] rcun ffffffff82441100 starting wait for work.
> [  278.303039] rcun ffffffff82440c00 starting wait for work.
> [  278.303323] rcun ffffffff82440c00 completed wait for work.
> [  278.303568] rcun ffffffff82440c00 initiating boost.
> [  278.314519] rcun ffffffff82440c00 completed boost.
> [  278.314750] rcun ffffffff82440c00 awaking rcuc31.
> [  278.334455] rcun ffffffff82440c00 awakened rcuc31.
> [  278.334687] rcun ffffffff82440c00 starting wait for work.
> [  278.498822] rcun ffffffff82441400 starting wait for work.
> [  278.499131] rcun ffffffff82441400 completed wait for work.
> [  278.499412] rcun ffffffff82441400 initiating boost.
> [  278.514295] rcun ffffffff82441400 completed boost.
> [  278.514632] rcun ffffffff82441400 awaking rcuc151.
> [  278.534082] rcun ffffffff82441400 awakened rcuc151.
> [  278.534338] rcun ffffffff82441400 starting wait for work.
> [  278.686359] rcun ffffffff82440e00 starting wait for work.
> [  278.686670] rcun ffffffff82440e00 completed wait for work.
> [  278.686927] rcun ffffffff82440e00 initiating boost.
> [  278.703910] rcun ffffffff82440e00 completed boost.
> [  278.704148] rcun ffffffff82440e00 awaking rcuc51.
> [  278.723778] rcun ffffffff82440e00 awakened rcuc51.
> [  278.724036] rcun ffffffff82440e00 starting wait for work.
> [  278.762564] rcun ffffffff82440e00 completed wait for work.
> [  278.762863] rcun ffffffff82440e00 initiating boost.
> [  278.763540] rcun ffffffff82440e00 completed boost.
> [  278.763782] rcun ffffffff82440e00 awaking rcuc51.
> [  278.764012] rcun ffffffff82440e00 awakened rcuc51.
> [  278.783768] rcun ffffffff82440e00 starting wait for work.
> [  278.784047] rcun ffffffff82440e00 completed wait for work.
> [  278.803684] rcun ffffffff82440e00 initiating boost.
> [  278.803937] rcun ffffffff82440e00 completed boost.
> [  278.823598] rcun ffffffff82440e00 awaking rcuc51.
> [  278.823851] rcun ffffffff82440e00 awakened rcuc51.
> [  278.843603] rcun ffffffff82440e00 starting wait for work.
> [  278.922171] rcun ffffffff82441300 completed wait for work.
> [  278.922498] rcun ffffffff82441300 initiating boost.
> [  278.922762] rcun ffffffff82441300 completed boost.
> [  278.934066] rcun ffffffff82441300 awaking rcuc131.
> [  278.934376] rcun ffffffff82441300 awakened rcuc131.
> [  278.953529] rcun ffffffff82441300 starting wait for work.
> [  279.017973] rcun ffffffff82440e00 completed wait for work.
> [  279.018288] rcun ffffffff82440e00 initiating boost.
> [  279.018515] rcun ffffffff82440e00 completed boost.
> [  279.033336] rcun ffffffff82440e00 awaking rcuc51.
> [  279.034041] rcun ffffffff82440e00 awakened rcuc51.
> [  279.053188] rcun ffffffff82440e00 starting wait for work.
> [  279.149846] rcun ffffffff82441300 completed wait for work.
> [  279.150185] rcun ffffffff82441300 initiating boost.
> [  279.150438] rcun ffffffff82441300 completed boost.
> [  279.163080] rcun ffffffff82441300 awaking rcuc131.
> [  279.163341] rcun ffffffff82441300 awakened rcuc131.
> [  279.183285] rcun ffffffff82441300 starting wait for work.
> [  279.313608] rcun ffffffff82441300 completed wait for work.
> [  279.313983] rcun ffffffff82441300 initiating boost.
> [  279.314216] rcun ffffffff82441300 completed boost.
> [  279.332841] rcun ffffffff82441300 awaking rcuc131.
> [  279.333359] rcun ffffffff82441300 awakened rcuc131.
> [  279.352563] rcun ffffffff82441300 starting wait for work.
> [  279.409412] rcun ffffffff82441300 completed wait for work.
> [  279.409775] rcun ffffffff82441300 initiating boost.
> [  279.410057] rcun ffffffff82441300 completed boost.
> [  279.422561] rcun ffffffff82441300 awaking rcuc131.
> [  279.422810] rcun ffffffff82441300 awakened rcuc131.
> [  279.442473] rcun ffffffff82441300 starting wait for work.
> [  279.932452] rcun ffffffff82441100 completed wait for work.
> [  279.932806] rcun ffffffff82441100 initiating boost.
> [  279.933047] rcun ffffffff82441100 completed boost.
> [  279.952298] rcun ffffffff82441100 awaking rcuc110.
> [  279.952658] rcun ffffffff82441100 awakened rcuc110.
> [  279.971749] rcun ffffffff82441100 starting wait for work.
> [  279.972249] rcun ffffffff82441100 completed wait for work.
> [  279.991659] rcun ffffffff82441100 initiating boost.
> [  279.992066] rcun ffffffff82441100 completed boost.
> [  280.011403] rcun ffffffff82441100 awaking rcuc110.
> [  280.011658] rcun ffffffff82441100 awakened rcuc110.
> [  280.012070] rcun ffffffff82441100 starting wait for work.
> [  280.112094] rcun ffffffff82440b00 completed wait for work.
> [  280.112427] rcun ffffffff82440b00 initiating boost.
> [  280.112674] rcun ffffffff82440b00 completed boost.
> [  280.131375] rcun ffffffff82440b00 awaking rcuc11.
> [  280.131651] rcun ffffffff82440b00 awakened rcuc11.
> [  280.151524] rcun ffffffff82440b00 starting wait for work.
> [  280.459704] rcun ffffffff82440b00 completed wait for work.
> [  280.459997] rcun ffffffff82440b00 initiating boost.
> [  280.460228] rcun ffffffff82440b00 completed boost.
> [  280.470779] rcun ffffffff82440b00 awaking rcuc0.
> [  280.471062] rcun ffffffff82440b00 awakened rcuc0.
> [  280.490721] rcun ffffffff82440b00 starting wait for work.
> [  280.567316] rcun ffffffff82441400 completed wait for work.
> [  280.567647] rcun ffffffff82441400 initiating boost.
> [  280.567897] rcun ffffffff82441400 completed boost.
> [  280.580815] rcun ffffffff82441400 awaking rcuc151.
> [  280.581116] rcun ffffffff82441400 awakened rcuc151.
> [  280.600382] rcun ffffffff82441400 starting wait for work.
> [  280.695170] rcun ffffffff82440f00 starting wait for work.
> [  280.695506] rcun ffffffff82440f00 completed wait for work.
> [  280.695847] rcun ffffffff82440f00 initiating boost.
> [  280.710661] rcun ffffffff82440f00 completed boost.
> [  280.711207] rcun ffffffff82440f00 awaking rcuc71.
> [  280.730198] rcun ffffffff82440f00 awakened rcuc71.
> [  280.730443] rcun ffffffff82440f00 starting wait for work.
> [  281.601394] rcun ffffffff82440c00 completed wait for work.
> [  281.601753] rcun ffffffff82440c00 initiating boost.
> [  281.602004] rcun ffffffff82440c00 completed boost.
> [  281.618891] rcun ffffffff82440c00 awaking rcuc30.
> [  281.619164] rcun ffffffff82440c00 awakened rcuc30.
> [  281.638755] rcun ffffffff82440c00 starting wait for work.
> [  281.729334] rcun ffffffff82441300 completed wait for work.
> [  281.729661] rcun ffffffff82441300 initiating boost.
> [  281.729920] rcun ffffffff82441300 completed boost.
> [  281.748587] rcun ffffffff82441300 awaking rcuc131.
> [  281.748871] rcun ffffffff82441300 awakened rcuc131.
> [  281.768287] rcun ffffffff82441300 starting wait for work.
> [  281.905078] rcun ffffffff82440b00 completed wait for work.
> [  281.905380] rcun ffffffff82440b00 initiating boost.
> [  281.905623] rcun ffffffff82440b00 completed boost.
> [  281.918170] rcun ffffffff82440b00 awaking rcuc11.
> [  281.918450] rcun ffffffff82440b00 awakened rcuc11.
> [  281.938055] rcun ffffffff82440b00 starting wait for work.
> [  282.240380] rcun ffffffff82441300 completed wait for work.
> [  282.240667] rcun ffffffff82441300 initiating boost.
> [  282.240890] rcun ffffffff82441300 completed boost.
> [  282.257498] rcun ffffffff82441300 awaking rcuc130.
> [  282.257772] rcun ffffffff82441300 awakened rcuc130.
> [  282.277380] rcun ffffffff82441300 starting wait for work.
> [  282.304255] rcun ffffffff82441300 completed wait for work.
> [  282.304551] rcun ffffffff82441300 initiating boost.
> [  282.304792] rcun ffffffff82441300 completed boost.
> [  282.317376] rcun ffffffff82441300 awaking rcuc130.
> [  282.317639] rcun ffffffff82441300 awakened rcuc130.
> [  282.337291] rcun ffffffff82441300 starting wait for work.
> [  282.427834] rcun ffffffff82440e00 completed wait for work.
> [  282.428165] rcun ffffffff82440e00 initiating boost.
> [  282.428404] rcun ffffffff82440e00 completed boost.
> [  282.447168] rcun ffffffff82440e00 awaking rcuc50.
> [  282.447398] rcun ffffffff82440e00 awakened rcuc50.
> [  282.467022] rcun ffffffff82440e00 starting wait for work.
> [  282.543751] rcun ffffffff82441300 completed wait for work.
> [  282.544030] rcun ffffffff82441300 initiating boost.
> [  282.544262] rcun ffffffff82441300 completed boost.
> [  282.556969] rcun ffffffff82441300 awaking rcuc130.
> [  282.557221] rcun ffffffff82441300 awakened rcuc130.
> [  282.576959] rcun ffffffff82441300 starting wait for work.
> [  282.651510] rcun ffffffff82440e00 completed wait for work.
> [  282.651859] rcun ffffffff82440e00 initiating boost.
> [  282.652115] rcun ffffffff82440e00 completed boost.
> [  282.666799] rcun ffffffff82440e00 awaking rcuc50.
> [  282.667062] rcun ffffffff82440e00 awakened rcuc50.
> [  282.686638] rcun ffffffff82440e00 starting wait for work.
> [  283.469957] rcun ffffffff82440c00 completed wait for work.
> [  283.470235] rcun ffffffff82440c00 initiating boost.
> [  283.470457] rcun ffffffff82440c00 completed boost.
> [  283.485312] rcun ffffffff82440c00 awaking rcuc20.
> [  283.485548] rcun ffffffff82440c00 awakened rcuc20.
> [  283.505188] rcun ffffffff82440c00 starting wait for work.
> [  283.513893] rcun ffffffff82440c00 completed wait for work.
> [  283.525161] rcun ffffffff82440c00 initiating boost.
> [  283.525381] rcun ffffffff82440c00 completed boost.
> [  283.545051] rcun ffffffff82440c00 awaking rcuc20.
> [  283.545289] rcun ffffffff82440c00 awakened rcuc20.
> [  283.545497] rcun ffffffff82440c00 starting wait for work.
> [  283.577780] rcun ffffffff82440c00 completed wait for work.
> [  283.578067] rcun ffffffff82440c00 initiating boost.
> [  283.585133] rcun ffffffff82440c00 completed boost.
> [  283.585366] rcun ffffffff82440c00 awaking rcuc20.
> [  283.604979] rcun ffffffff82440c00 awakened rcuc20.
> [  283.605219] rcun ffffffff82440c00 starting wait for work.
> [  283.673621] rcun ffffffff82440c00 completed wait for work.
> [  283.673904] rcun ffffffff82440c00 initiating boost.
> [  283.674126] rcun ffffffff82440c00 completed boost.
> [  283.684951] rcun ffffffff82440c00 awaking rcuc20.
> [  283.685186] rcun ffffffff82440c00 awakened rcuc20.
> [  283.704835] rcun ffffffff82440c00 starting wait for work.
> [  283.721536] rcun ffffffff82440c00 completed wait for work.
> [  283.724733] rcun ffffffff82440c00 initiating boost.
> [  283.724974] rcun ffffffff82440c00 completed boost.
> [  283.744676] rcun ffffffff82440c00 awaking rcuc20.
> [  283.744921] rcun ffffffff82440c00 awakened rcuc20.
> [  283.745142] rcun ffffffff82440c00 starting wait for work.
> [  283.849306] rcun ffffffff82440c00 completed wait for work.
> [  283.849580] rcun ffffffff82440c00 initiating boost.
> [  283.849806] rcun ffffffff82440c00 completed boost.
> [  283.864625] rcun ffffffff82440c00 awaking rcuc20.
> [  283.864859] rcun ffffffff82440c00 awakened rcuc20.
> [  283.884509] rcun ffffffff82440c00 starting wait for work.
> [  283.897233] rcun ffffffff82440c00 completed wait for work.
> [  283.904500] rcun ffffffff82440c00 initiating boost.
> [  283.904740] rcun ffffffff82440c00 completed boost.
> [  283.924388] rcun ffffffff82440c00 awaking rcuc20.
> [  283.924639] rcun ffffffff82440c00 awakened rcuc20.
> [  283.924857] rcun ffffffff82440c00 starting wait for work.
> [  283.961137] rcun ffffffff82440c00 completed wait for work.
> [  283.961412] rcun ffffffff82440c00 initiating boost.
> [  283.964375] rcun ffffffff82440c00 completed boost.
> [  283.964585] rcun ffffffff82440c00 awaking rcuc20.
> [  283.984347] rcun ffffffff82440c00 awakened rcuc20.
> [  283.984580] rcun ffffffff82440c00 starting wait for work.
> [  284.064957] rcun ffffffff82440c00 completed wait for work.
> [  284.065249] rcun ffffffff82440c00 initiating boost.
> [  284.065462] rcun ffffffff82440c00 completed boost.
> [  284.084281] rcun ffffffff82440c00 awaking rcuc20.
> [  284.084506] rcun ffffffff82440c00 awakened rcuc20.
> [  284.104135] rcun ffffffff82440c00 starting wait for work.
> [  284.124914] rcun ffffffff82440c00 completed wait for work.
> [  284.125251] rcun ffffffff82440c00 initiating boost.
> [  284.125488] rcun ffffffff82440c00 completed boost.
> [  284.144394] rcun ffffffff82440c00 awaking rcuc20.
> [  284.144636] rcun ffffffff82440c00 awakened rcuc20.
> [  284.163985] rcun ffffffff82440c00 starting wait for work.
> [  284.352449] rcun ffffffff82440c00 completed wait for work.
> [  284.352722] rcun ffffffff82440c00 initiating boost.
> [  284.352965] rcun ffffffff82440c00 completed boost.
> [  284.363729] rcun ffffffff82440c00 awaking rcuc21.
> [  284.363952] rcun ffffffff82440c00 awakened rcuc21.
> [  284.383609] rcun ffffffff82440c00 starting wait for work.
> [  284.400355] rcun ffffffff82440c00 completed wait for work.
> [  284.403541] rcun ffffffff82440c00 initiating boost.
> [  284.403752] rcun ffffffff82440c00 completed boost.
> [  284.423478] rcun ffffffff82440c00 awaking rcuc21.
> [  284.423730] rcun ffffffff82440c00 awakened rcuc21.
> [  284.423961] rcun ffffffff82440c00 starting wait for work.
> [  284.464264] rcun ffffffff82440c00 completed wait for work.
> [  284.464531] rcun ffffffff82440c00 initiating boost.
> [  284.464739] rcun ffffffff82440c00 completed boost.
> [  284.483510] rcun ffffffff82440c00 awaking rcuc21.
> [  284.483725] rcun ffffffff82440c00 awakened rcuc21.
> [  284.503396] rcun ffffffff82440c00 starting wait for work.
> [  284.524166] rcun ffffffff82440c00 completed wait for work.
> [  284.524430] rcun ffffffff82440c00 initiating boost.
> [  284.524660] rcun ffffffff82440c00 completed boost.
> [  284.543410] rcun ffffffff82440c00 awaking rcuc21.
> [  284.543634] rcun ffffffff82440c00 awakened rcuc21.
> [  284.563295] rcun ffffffff82440c00 starting wait for work.
>                                                                      done
> Loading required kernel modules                                      done
> Activating device mapper...
> FATAL: Could not load /lib/modules/2.6.39-tip-yh-05892-gb7b703b-dirty/modules.dep: No such file or directory
>                                                                      failed
> Starting MD Raid                                                     unused
> Waiting for udev to settle...
> Scanning for LVM volume groups...
> File descriptor 3 left open
>   Reading all physical volumes.  This may take a while...
> Activating LVM volume groups...
> File descriptor 3 left open
>                                                                      done
> Waiting for /firmware
> microcode . no more events
> Checking file systems...
> fsck 1.41.1 (01-Sep-2008)
> Checking all file systems.                                           done
>                                                                      done
> Mounting local file systems...
> /proc on /proc type proc (rw)
> sysfs on /sys type sysfs (rw)
> debugfs on /sys/kernel/debug type debugfs (rw)
> udev on /dev type tmpfs (rw)
> devpts on /dev/pts type devpts (rw,mode=0620,gid=5)
> /firmware on /lib/firmware type tmpfs (rw)
> microcode on /usr/lib/microcode type tmpfs (rw)                      done
> Activating remaining swap-devices in /etc/fstab...                   done
> Setting up linker cache (/etc/ld.so.cache) using ldconfig            done
> Creating /var/log/boot.msg                                           done
> Using boot-specified hostname 'lb-g5plus-1t-host'
> Setting up hostname 'lb-g5plus-1t-host'                              done
> Setting up loopback interface     lo        
>     lo        IP address: 127.0.0.1/8   
>               IP address: 127.0.0.2/8   
>                                                                      done
> System Boot Control: The system has been                             set up
> Skipped features:                                                boot.md
> System Boot Control: Running /etc/init.d/boot.local                  done
> INIT: Entering runlevel: 3
> Boot logging started on /dev/ttyS0(/dev/console) at Wed May 25 13:44:05 2011
> Master Resource Control: previous runlevel: N, switching to runlevel:3
> Starting D-Bus daemon                                                done
> Initializing random number generator                                 done
> [  287.794818] rcun ffffffff82440f00 completed wait for work.
> [  287.795218] rcun ffffffff82440f00 initiating boost.
> [  287.795440] rcun ffffffff82440f00 completed boost.
> [  287.807922] rcun ffffffff82440f00 awaking rcuc71.
> [  287.808186] rcun ffffffff82440f00 awakened rcuc71.
> [  287.808195] rcun ffffffff82440f00 starting wait for work.
> Starting syslog services                                             done
> [  288.693183] rcun ffffffff82440e00 completed wait for work.
> [  288.693586] rcun ffffffff82440e00 initiating boost.
> [  288.693810] rcun ffffffff82440e00 completed boost.
> [  288.706108] rcun ffffffff82440e00 awaking rcuc50.
> [  288.706352] rcun ffffffff82440e00 awakened rcuc50.
> [  288.725895] rcun ffffffff82440e00 starting wait for work.
> [  288.726166] rcun ffffffff82440e00 completed wait for work.
> [  288.745842] rcun ffffffff82440e00 initiating boost.
> [  288.746067] rcun ffffffff82440e00 completed boost.
> [  288.765741] rcun ffffffff82440e00 awaking rcuc50.
> [  288.765967] rcun ffffffff82440e00 awakened rcuc50.
> [  288.766203] rcun ffffffff82440e00 starting wait for work.
> Loading CPUFreq modules                                              done
> Starting HAL daemon                                                  done
> Setting up (localfs) network interfaces:
>     lo        
>     lo        IP address: 127.0.0.1/8   
>               IP address: 127.0.0.2/8                                done
> [  289.323903] rcun ffffffff82440c00 completed wait for work.
> [  289.324239] rcun ffffffff82440c00 initiating boost.
> [  289.324458] rcun ffffffff82440c00 completed boost.
> [  289.334891] rcun ffffffff82440c00 awaking rcuc20.
> [  289.335112] rcun ffffffff82440c00 awakened rcuc20.
> [  289.354785] rcun ffffffff82440c00 starting wait for work.
>     eth0      device: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
>               No configuration found for eth0                        unused
>     eth1      device: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
>               No configuration found for eth1                        unused
> [  289.859076] rcun ffffffff82440c00 completed wait for work.
> [  289.859428] rcun ffffffff82440c00 initiating boost.
> [  289.859641] rcun ffffffff82440c00 completed boost.
> [  289.873915] rcun ffffffff82440c00 awaking rcuc31.
> [  289.874127] rcun ffffffff82440c00 awakened rcuc31.
> [  289.893814] rcun ffffffff82440c00 starting wait for work.
>     eth10     device: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>               No configuration found for eth10                       unused
> [  290.106822] rcun ffffffff82440b00 completed wait for work.
> [  290.107203] rcun ffffffff82440b00 initiating boost.
> [  290.107436] rcun ffffffff82440b00 completed boost.
> [  290.123462] rcun ffffffff82440b00 awaking rcuc11.
> [  290.123677] rcun ffffffff82440b00 awakened rcuc11.
> [  290.143342] rcun ffffffff82440b00 starting wait for work.
>     eth11     device: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>               No configuration found for eth11                       unused
> [  290.350351] rcun ffffffff82441100 completed wait for work.
> [  290.350744] rcun ffffffff82441100 initiating boost.
> [  290.351016] rcun ffffffff82441100 completed boost.
> [  290.363076] rcun ffffffff82441100 awaking rcuc111.
> [  290.363345] rcun ffffffff82441100 awakened rcuc111.
> [  290.382943] rcun ffffffff82441100 starting wait for work.
>     eth12     device: Intel Corporation 82599EB 10 Gigabit Network Connection (rev 01)
>               No configuration found for eth12                       unused
> [  290.610137] rcun ffffffff82440b00 completed wait for work.
> [  290.610487] rcun ffffffff82440b00 initiating boost.
> [  290.610719] rcun ffffffff82440b00 completed boost.
> [  290.622562] rcun ffffffff82440b00 awaking rcuc11.
> [  290.622774] rcun ffffffff82440b00 awakened rcuc11.
> [  290.642453] rcun ffffffff82440b00 starting wait for work.
> [  290.642720] rcun ffffffff82440b00 completed wait for work.
> [  290.662423] rcun ffffffff82440b00 initiating boost.
> [  290.662643] rcun ffffffff82440b00 completed boost.
>     eth13     device: Intel Corporation 82599EB 10 Gigabit Network Connection (rev 01)
> [  290.682708] rcun ffffffff82440b00 awaking rcuc11.
> [  290.702367] rcun ffffffff82440b00 awakened rcuc11.
>               No configuration f[  290.702694] rcun ffffffff82440b00 starting wait for work.
> ound for eth13                                                       unused
> [  290.865245] rcun ffffffff82440e00 completed wait for work.
> [  290.865586] rcun ffffffff82440e00 initiating boost.
> [  290.865802] rcun ffffffff82440e00 completed boost.
> [  290.882235] rcun ffffffff82440e00 awaking rcuc51.
> [  290.882530] rcun ffffffff82440e00 awakened rcuc51.
> [  290.902004] rcun ffffffff82440e00 starting wait for work.
>     eth14     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth14                       unused
> [  291.128769] rcun ffffffff82440c00 completed wait for work.
> [  291.129110] rcun ffffffff82440c00 initiating boost.
> [  291.129333] rcun ffffffff82440c00 completed boost.
> [  291.141675] rcun ffffffff82440c00 awaking rcuc31.
> [  291.141904] rcun ffffffff82440c00 awakened rcuc31.
> [  291.161527] rcun ffffffff82440c00 starting wait for work.
>     eth15     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth15                       unused
> [  291.380340] rcun ffffffff82440c00 completed wait for work.
> [  291.380664] rcun ffffffff82440c00 initiating boost.
> [  291.380883] rcun ffffffff82440c00 completed boost.
> [  291.391214] rcun ffffffff82440c00 awaking rcuc21.
> [  291.391431] rcun ffffffff82440c00 awakened rcuc21.
> [  291.411105] rcun ffffffff82440c00 starting wait for work.
> [  291.432271] rcun ffffffff82440c00 completed wait for work.
> [  291.432551] rcun ffffffff82440c00 initiating boost.
> [  291.432785] rcun ffffffff82440c00 completed boost.
> [  291.451161] rcun ffffffff82440c00 awaking rcuc21.
> [  291.451167] rcun ffffffff82440c00 awakened rcuc21.
> [  291.451170] rcun ffffffff82440c00 starting wait for work.
>     eth16     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth16                       unused
> [  291.652073] rcun ffffffff82440b00 completed wait for work.
> [  291.652448] rcun ffffffff82440b00 initiating boost.
> [  291.652741] rcun ffffffff82440b00 completed boost.
> [  291.670699] rcun ffffffff82440b00 awaking rcuc1.
> [  291.670945] rcun ffffffff82440b00 awakened rcuc1.
> [  291.690597] rcun ffffffff82440b00 starting wait for work.
>     eth17     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth17                       unused
> [  291.931570] rcun ffffffff82441000 starting wait for work.
> [  291.931899] rcun ffffffff82441000 completed wait for work.
> [  291.932142] rcun ffffffff82441000 initiating boost.
> [  291.950219] rcun ffffffff82441000 completed boost.
> [  291.950445] rcun ffffffff82441000 awaking rcuc90.
> [  291.970127] rcun ffffffff82441000 awakened rcuc90.
> [  291.970344] rcun ffffffff82441000 starting wait for work.
> [  291.990092] rcun ffffffff82441000 completed wait for work.
> [  291.990101] rcun ffffffff82441000 initiating boost.
> [  291.990105] rcun ffffffff82441000 completed boost.
> [  291.990109] rcun ffffffff82441000 awaking rcuc90.
> [  291.990119] rcun ffffffff82441000 awakened rcuc90.
> [  291.990123] rcun ffffffff82441000 starting wait for work.
>     eth18     device: Intel Corporation 82599EB 10 Gigabit Network Connection (rev 01)
>               No configuration found for eth18                       unused
>     eth19     device: Intel Corporation 82599EB 10 Gigabit Network Connection (rev 01)
>               No configuration found for eth19                       unused
> [  292.470547] rcun ffffffff82440e00 completed wait for work.
> [  292.470936] rcun ffffffff82440e00 initiating boost.
> [  292.471191] rcun ffffffff82440e00 completed boost.
> [  292.489291] rcun ffffffff82440e00 awaking rcuc51.
> [  292.489550] rcun ffffffff82440e00 awakened rcuc51.
> [  292.509226] rcun ffffffff82440e00 starting wait for work.
> [  292.509478] rcun ffffffff82440e00 completed wait for work.
> [  292.529136] rcun ffffffff82440e00 initiating boost.
> [  292.529141] rcun ffffffff82440e00 completed boost.
> [  292.529144] rcun ffffffff82440e00 awaking rcuc51.
> [  292.529151] rcun ffffffff82440e00 awakened rcuc51.
> [  292.529155] rcun ffffffff82440e00 starting wait for work.
>     eth2      device: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
>               No configuration found for eth2                        unused
> [  292.753993] rcun ffffffff82440c00 completed wait for work.
> [  292.754348] rcun ffffffff82440c00 initiating boost.
> [  292.754596] rcun ffffffff82440c00 completed boost.
> [  292.768779] rcun ffffffff82440c00 awaking rcuc31.
> [  292.769018] rcun ffffffff82440c00 awakened rcuc31.
> [  292.788632] rcun ffffffff82440c00 starting wait for work.
>     eth20     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth20                       unused
> [  292.985585] rcun ffffffff82440c00 completed wait for work.
> [  292.985925] rcun ffffffff82440c00 initiating boost.
> [  292.986150] rcun ffffffff82440c00 completed boost.
> [  292.998422] rcun ffffffff82440c00 awaking rcuc31.
> [  292.998647] rcun ffffffff82440c00 awakened rcuc31.
> [  293.018318] rcun ffffffff82440c00 starting wait for work.
>     eth21     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth21                       unused
> [  293.289596] rcun ffffffff82440b00 completed wait for work.
> [  293.289987] rcun ffffffff82440b00 initiating boost.
> [  293.290245] rcun ffffffff82440b00 completed boost.
> [  293.307893] rcun ffffffff82440b00 awaking rcuc1.
> [  293.308159] rcun ffffffff82440b00 awakened rcuc1.
> [  293.327728] rcun ffffffff82440b00 starting wait for work.
> [  293.337111] rcun ffffffff82440b00 completed wait for work.
> [  293.347737] rcun ffffffff82440b00 initiating boost.
> [  293.347958] rcun ffffffff82440b00 completed boost.
>     eth22     de[  293.367776] rcun ffffffff82440b00 awaking rcuc1.
> vice: Intel Corporation 82599EB [  293.368186] rcun ffffffff82440b00 awakened rcuc1.
> 10 Gigabit Netwo[  293.368191] rcun ffffffff82440b00 starting wait for work.
> rk Connection (rev 01)
>               No configuration found for eth22                       unused
>     eth23     device: Intel Corporation 82599EB 10 Gigabit Network Connection (rev 01)
>               No configuration found for eth23                       unused
>     eth24     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth24                       unused
> [  294.075710] rcun ffffffff82440e00 completed wait for work.
> [  294.076063] rcun ffffffff82440e00 initiating boost.
> [  294.076287] rcun ffffffff82440e00 completed boost.
> [  294.086523] rcun ffffffff82440e00 awaking rcuc51.
> [  294.086800] rcun ffffffff82440e00 awakened rcuc51.
> [  294.106385] rcun ffffffff82440e00 starting wait for work.
> [  294.135592] rcun ffffffff82440e00 completed wait for work.
> [  294.135876] rcun ffffffff82440e00 initiating boost.
> [  294.136103] rcun ffffffff82440e00 completed boost.
> [  294.146373] rcun ffffffff82440e00 awaking rcuc51.
> [  294.146643] rcun ffffffff82440e00 awakened rcuc51.
> [  294.166295] rcun ffffffff82440e00 starting wait for work.
>     eth25     device: Intel Corporation 82599EB 10-Gigabit KX4 Network Connection (rev 01)
>               No configuration found for eth25                       unused
> [  294.383392] rcun ffffffff82440e00 completed wait for work.
> [  294.383728] rcun ffffffff82440e00 initiating boost.
> [  294.383945] rcun ffffffff82440e00 completed boost.
> [  294.395907] rcun ffffffff82440e00 awaking rcuc51.
> [  294.396134] rcun ffffffff82440e00 awakened rcuc51.
> [  294.415794] rcun ffffffff82440e00 starting wait for work.
>     eth26     device: QLogic Corp. 10GbE Converged Network Adapter (TCP/IP Networking) (rev 02)
>               No configuration found for eth26                       unused
> [  294.658799] rcun ffffffff82440c00 completed wait for work.
> [  294.659130] rcun ffffffff82440c00 initiating boost.
> [  294.659341] rcun ffffffff82440c00 completed boost.
> [  294.675419] rcun ffffffff82440c00 awaking rcuc31.
> [  294.675645] rcun ffffffff82440c00 awakened rcuc31.
> [  294.695468] rcun ffffffff82440c00 starting wait for work.
>     eth27     device: QLogic Corp. 10GbE Converged Network Adapter (TCP/IP Networking) (rev 02)
>               No configuration found for eth27                       unused
> [  294.918239] rcun ffffffff82440b00 completed wait for work.
> [  294.918602] rcun ffffffff82440b00 initiating boost.
> [  294.918834] rcun ffffffff82440b00 completed boost.
> [  294.934983] rcun ffffffff82440b00 awaking rcuc0.
> [  294.935245] rcun ffffffff82440b00 awakened rcuc0.
> [  294.954854] rcun ffffffff82440b00 starting wait for work.
>     eth3      device: Intel Corporation 82571EB Gigabit Ethernet Controller (rev 06)
>               No configuration found for eth3                        unused
> [  295.233919] rcun ffffffff82440d00 starting wait for work.
> [  295.234268] rcun ffffffff82440d00 completed wait for work.
> [  295.234550] rcun ffffffff82440d00 initiating boost.
> [  295.244455] rcun ffffffff82440d00 completed boost.
> [  295.244686] rcun ffffffff82440d00 awaking rcuc40.
>     eth4      de[  295.264423] rcun ffffffff82440d00 awakened rcuc40.
> vice: Intel Corporation 82576 Gi[  295.264682] rcun ffffffff82440d00 starting wait for work.
> gabit Network Connection (rev 01)
>               No configuration found for eth4                        unused
> [  295.477285] rcun ffffffff82440f00 completed wait for work.
> [  295.477635] rcun ffffffff82440f00 initiating boost.
> [  295.477861] rcun ffffffff82440f00 completed boost.
> [  295.494030] rcun ffffffff82440f00 awaking rcuc70.
> [  295.494278] rcun ffffffff82440f00 awakened rcuc70.
> [  295.513989] rcun ffffffff82440f00 starting wait for work.
>     eth5      device: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>               No configuration found for eth5                        unused
> [  295.720833] rcun ffffffff82440d00 completed wait for work.
> [  295.721156] rcun ffffffff82440d00 initiating boost.
> [  295.721376] rcun ffffffff82440d00 completed boost.
> [  295.733558] rcun ffffffff82440d00 awaking rcuc41.
> [  295.733799] rcun ffffffff82440d00 awakened rcuc41.
> [  295.753424] rcun ffffffff82440d00 starting wait for work.
>     eth6      device: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>               No configuration found for eth6                        unused
> [  296.000356] rcun ffffffff82440c00 completed wait for work.
> [  296.000716] rcun ffffffff82440c00 initiating boost.
> [  296.000942] rcun ffffffff82440c00 completed boost.
> [  296.013086] rcun ffffffff82440c00 awaking rcuc31.
> [  296.013305] rcun ffffffff82440c00 awakened rcuc31.
> [  296.032935] rcun ffffffff82440c00 starting wait for work.
>     eth7      device: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>               No configuration found for eth7                        unused
> [  296.220235] rcun ffffffff82440e00 completed wait for work.
> [  296.220570] rcun ffffffff82440e00 initiating boost.
> [  296.220796] rcun ffffffff82440e00 completed boost.
> [  296.232694] rcun ffffffff82440e00 awaking rcuc51.
> [  296.232934] rcun ffffffff82440e00 awakened rcuc51.
> [  296.252558] rcun ffffffff82440e00 starting wait for work.
> [  296.252841] rcun ffffffff82440e00 completed wait for work.
> [  296.272515] rcun ffffffff82440e00 initiating boost.
> [  296.272784] rcun ffffffff82440e00 completed boost.
> [  296.292387] rcun ffffffff82440e00 awaking rcuc51.
> [  296.292647] rcun ffffffff82440e00 awakened rcuc51.
> [  296.292920] rcun ffffffff82440e00 starting wait for work.
>     eth8      device: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>               No configuration found for eth8                        unused
> [  296.483877] rcun ffffffff82440b00 completed wait for work.
> [  296.484237] rcun ffffffff82440b00 initiating boost.
> [  296.484456] rcun ffffffff82440b00 completed boost.
> [  296.502204] rcun ffffffff82440b00 awaking rcuc1.
> [  296.502491] rcun ffffffff82440b00 awakened rcuc1.
> [  296.522201] rcun ffffffff82440b00 starting wait for work.
> [  296.522459] rcun ffffffff82440b00 completed wait for work.
> [  296.542024] rcun ffffffff82440b00 initiating boost.
> [  296.542317] rcun ffffffff82440b00 completed boost.
> [  296.561935] rcun ffffffff82440b00 awaking rcuc1.
> [  296.562213] rcun ffffffff82440b00 awakened rcuc1.
> [  296.562431] rcun ffffffff82440b00 starting wait for work.
>     eth9      device: Intel Corporation 82576 Gigabit Network Connection (rev 01)
>               No configuration found for eth9                        unused
>     ib0       device: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)
>               No configuration found for ib0                         unused
> [  297.014805] rcun ffffffff82440b00 completed wait for work.
> [  297.015156] rcun ffffffff82440b00 initiating boost.
> [  297.015406] rcun ffffffff82440b00 completed boost.
> [  297.031238] rcun ffffffff82440b00 awaking rcuc1.
> [  297.031490] rcun ffffffff82440b00 awakened rcuc1.
> [  297.051130] rcun ffffffff82440b00 starting wait for work.
>     ib1       device: Mellanox Technologies MT26428 [ConnectX VPI PCIe 2.0 5GT/s - IB QDR / 10GigE] (rev b0)
>               No configuration found for ib1                         unused
> Setting up service (localfs) network  .  .  .  .  .  .  .  .  .  .   done
> Starting RPC portmap daemon                                          done
> Setting up (remotefs) network interfaces:
> Setting up service (remotefs) network  .  .  .  .  .  .  .  .  .  .  done
> Master Resource Control: runlevel 3 has been                         reached
> [  298.843747] rcun ffffffff82440e00 completed wait for work.
> [  298.844125] rcun ffffffff82440e00 initiating boost.
> [  298.844380] rcun ffffffff82440e00 completed boost.
> [  298.858327] rcun ffffffff82440e00 awaking rcuc52.
> [  298.858648] rcun ffffffff82440e00 awakened rcuc52.
> [  298.878014] rcun ffffffff82440e00 starting wait for work.
> [  298.887761] rcun ffffffff82440c00 completed wait for work.
> [  298.898179] rcun ffffffff82440c00 initiating boost.
> [  298.898480] rcun ffffffff82440c00 completed boost.
> [  298.917825] rcun ffffffff82440c00 awaking rcuc30.
> [  298.918148] rcun ffffffff82440c00 awakened rcuc30.
> [  298.918399] rcun ffffffff82440c00 starting wait for work.
> [  299.051210] rcun ffffffff82441300 completed wait for work.
> [  299.051271] rcun ffffffff82440d00 completed wait for work.
> [  299.051279] rcun ffffffff82440d00 initiating boost.
> [  299.051283] rcun ffffffff82440d00 completed boost.
> [  299.051288] rcun ffffffff82440d00 awaking rcuc40.
> [  299.051300] rcun ffffffff82440c00 completed wait for work.
> [  299.051314] rcun ffffffff82440c00 initiating boost.
> [  299.051323] rcun ffffffff82440c00 completed boost.
> [  299.051328] rcun ffffffff82440c00 awaking rcuc31.
> [  299.051356] rcun ffffffff82440d00 awakened rcuc40.
> [  299.051360] rcun ffffffff82440d00 starting wait for work.
> [  299.051383] rcun ffffffff82440c00 awakened rcuc31.
> [  299.051388] rcun ffffffff82440c00 starting wait for work.
> [  299.148138] rcun ffffffff82441300 initiating boost.
> [  299.167706] rcun ffffffff82441300 completed boost.
> [  299.167993] rcun ffffffff82441300 awaking rcuc132.
> [  299.187516] rcun ffffffff82441300 awakened rcuc132.
> [  299.187841] rcun ffffffff82441300 starting wait for work.
> [  299.223164] rcun ffffffff82441300 completed wait for work.
> [  299.223485] rcun ffffffff82441300 initiating boost.
> [  299.227367] rcun ffffffff82441300 completed boost.
> [  299.227654] rcun ffffffff82441300 awaking rcuc132.
> [  299.227969] rcun ffffffff82441300 awakened rcuc132.
> [  299.247460] rcun ffffffff82441300 starting wait for work.
> [  299.278920] rcun ffffffff82440d00 completed wait for work.
> [  299.279251] rcun ffffffff82440d00 initiating boost.
> [  299.279497] rcun ffffffff82440d00 completed boost.
> [  299.297867] rcun ffffffff82440d00 awaking rcuc40.
> [  299.298180] rcun ffffffff82440d00 awakened rcuc40.
> [  299.317166] rcun ffffffff82440d00 starting wait for work.
> [  299.334809] rcun ffffffff82441300 completed wait for work.
> [  299.336979] rcun ffffffff82441300 initiating boost.
> [  299.337250] rcun ffffffff82441300 completed boost.
> [  299.338720] rcun ffffffff82441100 completed wait for work.
> [  299.338737] rcun ffffffff82441100 initiating boost.
> [  299.338745] rcun ffffffff82441100 completed boost.
> [  299.338752] rcun ffffffff82441100 awaking rcuc102.
> [  299.338803] rcun ffffffff82441100 awakened rcuc102.
> [  299.338809] rcun ffffffff82441100 starting wait for work.
> [  299.342935] rcun ffffffff82440f00 completed wait for work.
> [  299.342964] rcun ffffffff82440f00 initiating boost.
> [  299.342991] rcun ffffffff82440f00 completed boost.
> [  299.343009] rcun ffffffff82440f00 awaking rcuc70.
> [  299.343064] rcun ffffffff82440f00 awakened rcuc70.
> [  299.343077] rcun ffffffff82440f00 starting wait for work.
> [  299.350627] rcun ffffffff82441100 completed wait for work.
> [  299.350634] rcun ffffffff82441100 initiating boost.
> [  299.350638] rcun ffffffff82441100 completed boost.
> [  299.350641] rcun ffffffff82441100 awaking rcuc102.
> [  299.350652] rcun ffffffff82441100 awakened rcuc102.
> [  299.350655] rcun ffffffff82441100 starting wait for work.
> [  299.350689] rcun ffffffff82440f00 completed wait for work.
> [  299.350701] rcun ffffffff82440f00 initiating boost.
> [  299.350708] rcun ffffffff82440f00 completed boost.
> [  299.350716] rcun ffffffff82440f00 awaking rcuc70.
> [  299.350807] rcun ffffffff82440f00 awakened rcuc70.
> [  299.350815] rcun ffffffff82440f00 starting wait for work.
> [  299.557141] rcun ffffffff82441300 awaking rcuc132.
> [  299.557143] rcun ffffffff82441300 awakened rcuc132.
> [  299.557145] rcun ffffffff82441300 starting wait for work.
> 
> lb-g5plus-1t-host login: 
> lb-g5plus-1t-host login: [  379.823934] INFO: task rcun0:8 blocked for more than 120 seconds.
> [  379.824295] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  379.843811] rcun0           D 0000000000000000     0     8      2 0x00000000
> [  379.844152]  ffff882070d47e90 0000000000000046 ffff882070d46000 0000000000004000
> [  379.844178]  00000000001d1f40 ffff882070d47fd8 00000000001d1f40 ffff882070d47fd8
> [  379.844204]  0000000000004000 00000000001d1f40 ffff882070d18000 ffff882070d4a2b0
> [  379.844232] Call Trace:
> [  379.844255]  [<ffffffff810afa0a>] ? __lock_release+0x166/0x16f
> [  379.844273]  [<ffffffff81c21de9>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
> [  379.844287]  [<ffffffff810cf297>] ? rcu_cpu_kthread_timer+0x44/0x44
> [  379.844298]  [<ffffffff810adcde>] ? trace_hardirqs_on+0xd/0xf
> [  379.844309]  [<ffffffff810cf297>] ? rcu_cpu_kthread_timer+0x44/0x44
> [  379.844325]  [<ffffffff81099e3d>] kthread+0x8c/0xa8
> [  379.844342]  [<ffffffff81c29ad4>] kernel_thread_helper+0x4/0x10
> [  379.844353]  [<ffffffff81c22080>] ? retint_restore_args+0xe/0xe
> [  379.844364]  [<ffffffff81099db1>] ? __init_kthread_worker+0x5b/0x5b
> [  379.844375]  [<ffffffff81c29ad0>] ? gs_change+0xb/0xb
> [  379.844379] INFO: lockdep is turned off.

OK, so rcun0 covers CPUs 0-15.  Looking above, we find that this
means "rcun ffffffff82440b00".  And the last thing done by this
rcun kthread was "starting wait for work", which would be rcu_wait(),
which is as follows:

#define rcu_wait(cond)							\
do {									\
	for (;;) {							\
		set_current_state(TASK_INTERRUPTIBLE);			\
		if (cond)						\
			break;						\
		schedule();						\
	}								\
	__set_current_state(TASK_RUNNING);				\
} while (0)

But this has the kthread waiting with TASK_INTERRUPTIBLE, which should
prevent the "blocked for more than 120 seconds" diagnostic.

> [  379.844595] INFO: task rcun8:576 blocked for more than 120 seconds.
> [  379.844598] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  379.844602] rcun8           D 0000000000000000     0   576      2 0x00000000
> [  379.844608]  ffff881fff98de90 0000000000000046 ffff881fff98c000 0000000000004000
> [  379.844634]  00000000001d1f40 ffff881fff98dfd8 00000000001d1f40 ffff881fff98dfd8
> [  379.844658]  0000000000004000 00000000001d1f40 ffff882070d18000 ffff881fff9822b0
> [  379.844683] Call Trace:
> [  379.844694]  [<ffffffff810afa0a>] ? __lock_release+0x166/0x16f
> [  379.844705]  [<ffffffff81c21de9>] ? _raw_spin_unlock_irqrestore+0x3f/0x46
> [  379.844715]  [<ffffffff810cf297>] ? rcu_cpu_kthread_timer+0x44/0x44
> [  379.844726]  [<ffffffff810adcde>] ? trace_hardirqs_on+0xd/0xf
> [  379.844736]  [<ffffffff810cf297>] ? rcu_cpu_kthread_timer+0x44/0x44
> [  379.844747]  [<ffffffff81099e3d>] kthread+0x8c/0xa8
> [  379.844759]  [<ffffffff81c29ad4>] kernel_thread_helper+0x4/0x10
> [  379.844769]  [<ffffffff81c22080>] ? retint_restore_args+0xe/0xe
> [  379.844781]  [<ffffffff81099db1>] ? __init_kthread_worker+0x5b/0x5b
> [  379.844791]  [<ffffffff81c29ad0>] ? gs_change+0xb/0xb
> [  379.844794] INFO: lockdep is turned off.

Ditto here.  rcun8 handles CPUs 128-143, which includes CPU 132.  So we
have "rcun ffffffff82441300", which also was last seen "starting wait
for work".  And therefore also was waiting TASK_INTERRUPTIBLE.

If I cannot think of anything better, I will send you a patch to the
"blocked for more than 120 seconds" code that dumps out the state of
the rcun kthreads.

							Thanx, Paul
