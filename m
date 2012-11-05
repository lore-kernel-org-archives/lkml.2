Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab2KENig (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 08:38:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:30434 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2KENif convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 08:38:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,715,1344236400"; 
   d="scan'208";a="237361146"
Date: Mon, 5 Nov 2012 21:38:26 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [floppy, blk_peek_request] BUG: scheduling while atomic:
 kworker/u:0/6/0x10000002
Message-ID: <20121105133826.GA14339@localhost>
References: <20121105070106.GA17015@localhost>
 <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <alpine.LNX.2.00.1211051422500.24253@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 02:24:15PM +0100, Jiri Kosina wrote:
> On Mon, 5 Nov 2012, Fengguang Wu wrote:
> 
> > Hi Herton,
> > 
> > I got the below oops in Linux 3.7-rc4 and it's bisected down to
> > 
> > commit b54e1f88897bcacc2cd359f48ea3b39eaf55f084
> > Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
> > Date:   Mon Aug 27 20:56:51 2012 -0300
> > 
> >     floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
> 
> Fengguang,
> 
> thanks for the report.
> 
> How reliable is the bisection result? (i.e. how reliably are you able to 
> trigger this oops?).
> 
> I am having a hard time seeing how that particular commit could be causing 
> this kind of oops.

It's almost 100% reproducible. And the bisect regards one commit as
good only after 360 boots w/o one single failure. So it should be a
believable result.

Thanks,
Fengguang
---

Below is the full bisect log.

wfg@bee ~/tip% /c/kernel-tests/reproduce linus:master:3d70f8c x86_64-randconfig-h224 3d70f8c617a436c7146ecb81df2265b4626dfe89
/c/kernel-tests/list-head linus:master:3d70f8c x86_64-randconfig-h224
less /cc/kernel-tests/kernels/x86_64-randconfig-h224/3d70f8c/dmesg-kvm-inn-50500-2012-11-05-03-35-21-3.7.0-rc4-1
[   24.050023] BUG: scheduling while atomic: kworker/u:0/6/0x10000002
[   14.108013] CPU 0
[   14.108013] Pid: 6, comm: kworker/u:0 Not tainted 3.7.0-rc4 #1 Bochs Bochs
[   14.108013] RIP: 0010:[<ffffffff8134eef5>]  [<ffffffff8134eef5>] blk_peek_request+0xd5/0x1c0
[   14.108013] RSP: 0000:ffff88000dc7dd88  EFLAGS: 00010092
[   14.108013] RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
[   14.108013] RDX: ffff88000f602688 RSI: ffffffff81fd95d8 RDI: 6b6b6b6b6b6b6b6b
[   14.108013] RBP: ffff88000dc7dd98 R08: ffffffff81fd95c8 R09: 0000000000000000
[   14.108013] R10: ffffffff81fd9480 R11: 0000000000000001 R12: 6b6b6b6b6b6b6b6b
[   14.108013] R13: ffff88000dc7dfd8 R14: ffff88000dc7dfd8 R15: 0000000000000000
[   14.108013] FS:  0000000000000000(0000) GS:ffffffff81e21000(0000) knlGS:0000000000000000
[   14.108013] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[   14.108013] CR2: 0000000000000000 CR3: 0000000001e11000 CR4: 00000000000006f0
[   14.108013] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   14.108013] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[   14.108013] Process kworker/u:0 (pid: 6, threadinfo ffff88000dc7c000, task ffff88000dc5ecc0)
[   14.108013] Stack:
[   14.108013]  0000000000000000 0000000000000000 ffff88000dc7ddb8 ffffffff8134efee
[   14.108013]  ffff88000dc7ddb8 0000000000000000 ffff88000dc7dde8 ffffffff814aef3c
[   14.108013]  ffffffff81e75d80 ffff88000dc0c640 ffff88000fbfb000 ffffffff814aed90
[   14.108013] Call Trace:
[   14.108013]  [<ffffffff8134efee>] blk_fetch_request+0xe/0x30
[   14.108013]  [<ffffffff814aef3c>] redo_fd_request+0x1ac/0x400
[   14.108013]  [<ffffffff814aed90>] ? start_motor+0x130/0x130
[   14.108013]  [<ffffffff8106b526>] process_one_work+0x136/0x450
[   14.108013]  [<ffffffff8106af65>] ? manage_workers+0x205/0x2e0
[   14.108013]  [<ffffffff8106bb6d>] worker_thread+0x14d/0x420
[   14.108013]  [<ffffffff8106ba20>] ? rescuer_thread+0x1a0/0x1a0
[   14.108013]  [<ffffffff8107075a>] kthread+0xba/0xc0
[   14.108013]  [<ffffffff810706a0>] ? __kthread_parkme+0x80/0x80
[   14.108013]  [<ffffffff818b553a>] ret_from_fork+0x7a/0xb0
[   14.108013]  [<ffffffff810706a0>] ? __kthread_parkme+0x80/0x80
[   14.108013] Code: 0f 84 c0 00 00 00 83 f8 01 0f 85 e2 00 00 00 81 4b 40 00 00 80 00 48 89 df e8 58 f8 ff ff be fb ff ff ff 48 89 df e8 fb fe ff ff <49> 8b 1c 24 49 39 dc 0f 85 2e ff ff ff 41 0f b6 84 24 28 04 00
[   14.108013] RIP  [<ffffffff8134eef5>] blk_peek_request+0xd5/0x1c0
[   14.108013]  RSP <ffff88000dc7dd88>
No patch removed
7:2 good:bad boots
repeat=360
cp /cc/kernel-tests/kernels/x86_64-randconfig-h224/3d70f8c/config-3.7.0-rc4 obj-bisect-x86_64/.config-bisect
Warning: you are leaving 3 commits behind, not connected to
any of your branches:

  1d603dc HID: multitouch: fix maxcontacts problem on GeneralTouch
  631c20b HID: multitouch: put the case in the right switch statement
  32fa273 HID: microsoft: fix invalid rdesc for 3k kbd

If you want to keep them by creating a new branch, this may be a good time
to do so with:

 git branch new_branch_name 1d603dca4991636223a278a8e2eb3be8b4c915f7

HEAD is now at 3d70f8c... Linux 3.7-rc4

2012-11-05-09:54:13 3d70f8c617a436c7146ecb81df2265b4626dfe89 compiling


/home/wfg/tip

2012-11-05-09:58:04 detecting boot state 3.7.0-rc4-bisect2 #33 ....1234.....5.6..78.9.10.11.1213......14.15..16. TEST FAILURE
Caught the bug, try to bisect it? [Y/n]No patch removed
git checkout cff7b8ba60e332377568c3d55c8036e9b1de32e6
Previous HEAD position was 3d70f8c... Linux 3.7-rc4
HEAD is now at cff7b8b... Merge branch 'fixes_for_linus' of git://git.linaro.org/people/mszyprowski/linux-dma-mapping

2012-11-05-09:59:14 cff7b8ba60e332377568c3d55c8036e9b1de32e6 compiling
/home/wfg/tip

2012-11-05-10:01:49 detecting boot state 3.7.0-rc2-bisect2-00153-gcff7b8b #34 .......1.2....3.45.67.8.910....11...1213..14..15.....16........17.....................OK 18..19.2021....OK 22.23.24..OK .OK 2526....OK .27....OK .2829OK 30..OK 31.OK ..3233OK .34.......OK .OK 3536...OK .OK .37OK .OK 383940.OK .41....OK .42..OK .43...........OK 44.......OK .OK 4546...OK .47....OK .48.OK 49.OK .50OK ..51..OK 52OK .OK .5354OK 55....OK .56....OK 57......OK 58.........OK .59..OK .60.OK 6162..OK .63.....OK 64OK 65.66..OK .67OK .OK 6869.OK 70OK .OK 7172OK 73.OK .74...OK 75..OK .76OK .77.............OK 78...............OK .OK 79..80...OK .81.OK .82...OK 83OK 84.OK .85OK .OK 86....OK 87.OK 88..OK 89.....OK .90OK .91.OK .92.93....OK ..94OK .95....OK .96....OK ..OK 9798OK .99.OK .OK ..100OK .101102..OK .103.....OK 104OK .105....OK 106.....OK 107.OK .108.OK 109.......OK 110.OK .OK .111OK 112..OK .113..OK 114.OK ..115....OK .116OK .117..OK 118................OK .119..OK .OK 120121..OK .122OK 123.OK .124..OK 125.OK .126.OK 127OK .OK .128129.OK .130OK 131...OK .132OK .OK 133OK ..134OK 135..OK .136........OK 137...................OK .138..OK ..OK 139OK 140141...OK .OK .142143...OK .OK 144OK 145OK 146147.OK 148.......OK .149....OK 150..OK 151..OK .152...OK .153.OK .OK .154.....OK .155.....OK .OK .156157...OK .158..OK 159OK .160OK .OK 161..OK ..OK 162.OK ..163.OK 164.OK .165.OK 166.......OK .167...OK 168..OK 169OK ...170....OK 171.......OK ..OK .172OK 173174175................OK 176...OK .177...OK 178OK 179OK .180.OK .181OK 182.OK .183.OK 184...OK ..185.OK .186...OK 187.188OK 189..OK .OK .190191.....OK .192..OK .193194..............OK 195......OK 196OK .197.OK .OK 198.....OK .199OK .OK .OK 200OK .OK 201202OK .203....OK 204....OK 205..OK 206....OK 207.....OK .208OK .209.OK .210.........OK .OK 211..........OK 212..OK .OK 213214OK .215..OK 216.OK 217218.OK 219OK .OK ..220221..OK .222..OK .223.OK .224....OK .225.OK .226.OK .227........OK .OK 228.OK 229OK 230OK 231232........OK 233........OK 234...OK .OK 235OK .OK 236.OK 237238......OK .239...OK 240OK .OK 241242.....OK 243....OK ..244.OK .245...OK ..246OK 247248..OK .OK 249OK ..250....OK 251...........OK 252.OK ..253OK .OK 254255.OK .256.OK 257..OK .258.OK .259OK 260.261.OK 262..OK .263....OK 264............OK 265.OK .OK 266OK .267268.....OK 269......OK .270......OK 271.....OK .272.OK 273OK 274OK 275OK .276.....OK 277OK 278OK .279..OK 280OK .OK 281OK 282283284...OK .285........OK 286.OK .287.OK .288....OK 289290.OK .291.OK .292293........OK .294.....OK 295..OK 296.OK 297OK .298OK .299.OK .300.OK 301...OK .302..OK 303.....OK 304OK .305..OK 306.......OK .307.OK .308OK .OK 309.310........OK .311.OK ..OK 312OK 313...OK .314315.OK .316.OK 317.OK .318....OK .319OK .OK 320321..OK .322323.OK 324OK ..325326OK .327OK 328....OK .329......OK 330OK .331....OK .332.OK ..333.......OK .334........OK .335..OK .336.OK 337..OK 338..OK .339...OK .OK 340OK 341..OK .342..OK 343......OK 344345..OK .OK 346347OK ..OK 348OK 349....OK 350........OK ..OK 351352..OK 353...OK ..OK 354355..OK .356OK .357..OK 358.OK .359.OK 360...OK .361..OK .OK 362363.OK .364365.OK 366......OK .367..OK ..OK 368....OK 369.....OK .370........OK 371372OK .373..............OK 374OK 375.OK .OK .OK 376OK 377378..OK .379..OK 380...OK .381..OK 382.OK .383OK ..384OK  SUCCESS
bisect: good commit cff7b8ba60e332377568c3d55c8036e9b1de32e6
git bisect start 3d70f8c617a436c7146ecb81df2265b4626dfe89 cff7b8ba60e332377568c3d55c8036e9b1de32e6 --
Checking out files: 100% (38951/38951), done.
Previous HEAD position was cff7b8b... Merge branch 'fixes_for_linus' of git://git.linaro.org/people/mszyprowski/linux-dma-mapping
HEAD is now at 3c0eee3... Linux 2.6.37
Bisecting: 329 revisions left to test after this (roughly 8 steps)
[f761237eee55222fdb509c79e784a67ab3d72cbd] Merge branch 'fixes' of git://git.infradead.org/users/vkoul/slave-dma
git bisect run /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-10:37:29 f761237eee55222fdb509c79e784a67ab3d72cbd compiling
/home/wfg/tip

2012-11-05-10:39:59 detecting boot state 3.7.0-rc2-bisect2-00372-gf761237 #35 ...12.3..4....5...6...7.8..91011.....12....13.14..1516.............17...1819......OK 20........OK 21.22.....OK 2324...OK .25..OK 26..27...OK 28....OK .29...OK 30OK .OK 31...OK .OK 3233OK . 34OK .35....OK .36.OK .37......OK 3839OK .OK ..40OK .41....OK 42....OK .43..OK 44...OK 45...OK 46OK ..OK 47.48.OK 49....OK 50...OK .51OK .52........OK .OK 5354....OK 55OK .OK .56.......OK 57..OK .58.......OK 59...OK .60...OK 6162..OK .OK 6364OK .OK 65OK .66...OK 6768...OK 69...OK 70OK .OK 71.OK .OK 72.73....OK 74.OK .75........OK 7677........OK .78.....OK 79.......OK .80..OK .81OK 82.OK 83....OK .OK .OK 8485....OK 86....OK 87OK .8889..........OK .90...OK .91OK .92OK 93..OK .94...OK .95OK .96OK ..97.....OK 98.....OK .OK .OK 99OK 100.101OK 102..OK 103.OK 104...OK 105OK 106...OK 107.OK .108OK .109OK .110..........OK 111...OK .112.OK ..OK 113114.....OK .115.OK .116.....OK .117...OK .118..OK 119...OK 120..OK 121....OK .122OK 123124..OK 125OK 126....OK 127.OK 128129OK ..130.......OK 131132......OK .133.OK .OK ..134135..OK ..136OK .137.OK 138...OK .139.......OK 140...OK .141..OK 142....OK .OK 143OK .144..OK 145OK .146147OK 148.OK 149.....OK .150...OK 151OK 152..................OK .153OK 154155156......OK .157.....OK 158.159..OK 160...OK 161......OK .162.OK .163OK .164OK .165OK .OK 166.OK 167.OK .OK .168169...OK .170.OK .171...............OK .OK 172....OK ..OK 173.174OK ..175..OK ..176..OK .177...OK 178..OK 179.....OK 180...OK .OK 181...OK 182OK .OK 183184....OK .185OK 186.OK .187.OK .188.........OK .189..........OK .190OK ..191.OK .192OK .193.OK 194..OK .OK 195OK .196OK 197.....OK 198....OK 199...OK 200.OK 201202..OK .203OK .204OK 205.OK .OK 206OK 207208.....OK 209...........OK ..210.....OK .OK .211212....OK 213214OK .OK .OK 215216.OK 217.....OK 218....OK .219...OK 220.OK 221..OK ..OK 222OK .OK 223224OK 225226.OK 227.....OK 228.OK .OK .229OK 230231.................OK 232.......OK 233OK .OK .OK 234235...OK .OK 236237...OK 238...OK 239OK .OK 240......OK .241OK 242OK .OK 243.....OK .244245246.OK .247...............OK 248.....OK ..OK .OK 249.OK 250251..OK .OK 252253....OK 254255OK .256..OK 257...OK 258OK 259.....OK ..260OK .261.OK 262..OK 263.OK .264....OK .265.OK 266.OK .267......OK .OK 268............OK .OK 269.OK .OK 270..OK ..271.OK 272OK .273..OK 274OK .275.OK 276OK 277.......OK .278.OK 279.OK .OK 280....OK .281OK .282OK .OK .283OK 284.OK 285286.OK 287.............OK 288.OK .OK 289....OK .290....OK 291OK 292...OK 293OK .294295.OK 296.OK 297.OK .298.....OK 299.OK 300..OK 301....OK .OK .302303.OK .304..OK 305..OK .306...OK .307...OK .308.....OK 309.....OK 310.OK .311OK 312..OK .313OK 314OK .OK 315OK .OK 316OK 317318........OK .319.OK 320OK ..OK 321........OK .322..OK .323.OK .324....OK .OK ..325326...OK 327..........OK 328..OK .329...OK .330.OK .331..OK .OK .332...OK .333OK .334...OK ..335...OK 336.OK .337..OK 338.........OK .339OK .340.OK .341..OK 342.OK 343344.OK ..OK 345346.......OK 347OK .348.......OK .349...OK .OK 350...OK .OK 351OK 352..OK ..353OK .OK .354355OK 356.OK .357.OK .358.......OK .OK 359OK .360....OK .OK .361OK 362..........OK .363..OK 364.............OK 365OK .366OK .367OK 368...OK .369OK 370OK .371.OK  SUCCESS
Bisecting: 163 revisions left to test after this (roughly 7 steps)
[2df4f26167ab6adc7d2648f57f433ff461965fc8] Merge tag 'md-3.7-fixes' of git://neil.brown.name/md
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-11:14:45 2df4f26167ab6adc7d2648f57f433ff461965fc8 compiling
/home/wfg/tip

2012-11-05-11:17:06 detecting boot state 3.7.0-rc3-bisect2-00043-g2df4f26 #36 1...2.34.5......67...8.....910....11...1213.14.15..16.17..18 TEST FAILURE
Bisecting: 94 revisions left to test after this (roughly 6 steps)
[1a25b1c4ce189e3926f2981f3302352a930086db] Lock splice_read and splice_write functions
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-11:18:28 1a25b1c4ce189e3926f2981f3302352a930086db compiling
/home/wfg/tip

2012-11-05-11:19:56 detecting boot state 3.7.0-rc2-bisect2-00443-g1a25b1c #37 .1.2....3.456..78..9.......1011......12..............13....14..15....1617..OK 18...OK 19.OK 20.........OK 21.OK .22.OK 232425.........OK .OK 26..OK 27......OK .OK 2829OK ..30.....OK .OK .3132.OK 33.34OK .OK 3536......OK 3738..OK .39OK 40........OK 41..OK 42OK .OK 43...OK .44.....OK .OK 45OK 4647OK 48.....OK .49.............OK 50...OK .51OK 5253.......OK 54...OK .55OK .56...OK .57...OK .OK 58.OK 59OK 60.OK 61.....OK .62.OK .OK 63OK .OK 6465OK .OK 6667...............OK 68.......OK 69.OK 70...OK ..71..OK 72OK .73..OK 74OK 75..OK .76.....OK 77..OK 78.OK .79......OK .80OK ..OK 81OK 8283.OK .84.............OK 8586......OK ..OK 87OK .88.......OK .89OK 90OK 91.OK .OK 92.OK 93OK .94OK .95....OK 96..OK 97..OK 98.........OK .99OK 100101..OK 102...OK ..103...OK .104OK .105..................OK .OK .106107..OK .108.OK ..OK 109.OK 110.........OK 111OK .OK 112113.OK 114...OK .OK 115OK 116.117..OK 118119.OK 120..OK .OK .121...OK .OK 122.OK 123.OK .124OK .125................OK .OK .OK 126.127128.OK 129.OK 130.OK .131......OK 132..OK 133..OK 134...........OK .OK 135..OK 136OK .OK 137.138....OK .OK 139........OK 140...........OK 141OK .OK 142OK .143144..OK .145OK 146....OK .OK 147148..OK .149.OK 150OK 151152OK 153OK .154OK 155.......OK .OK 156..OK 157OK .158.OK .159.OK .160..OK 161162.........OK .163.....OK 164.......OK ..165OK .166OK .OK 167168.....OK .169.OK 170.OK .171..OK 172.OK .173.........OK 174175.OK .176..OK .177.OK .178.OK .OK 179180.....OK 181...OK ..182..OK 183.OK .184OK .185OK .186OK .187.....OK .188OK 189.OK .190....OK .OK 191192OK .OK 193.OK .OK 194......OK .195...OK .OK 196..OK 197....OK .198..OK .OK 199200....OK .201....OK .OK 202203................OK 204OK 205OK .206OK .207.OK .208.OK .OK 209210OK 211..OK 212...OK .213....OK .OK 214215.OK 216.OK 217OK .218219.....OK 220.......OK .OK 221OK .222.OK ..223.OK .224...OK .225........OK 226OK .227.....OK .228..OK 229OK .230OK 231..OK 232.OK .233.....OK 234..OK .OK 235.OK .236......OK 237.....OK .238.OK .239240241OK .242...........OK .243.....OK .244OK 245246..OK .247OK ..248...OK .249.OK .250OK .OK .251252....OK .253..OK 254..OK 255..OK 256OK ..257...OK 258....OK .259260.....OK ..261...OK .262.......OK 263264...OK 265.........OK 266..OK 267OK .268OK 269.OK .OK .270........OK .OK 271272OK .OK 273......OK 274OK .275...OK .OK .276OK 277.278.OK .279.OK .280.......OK .OK 281....OK .282283284.....OK .285.....OK .OK 286287OK 288..OK 289......OK .290..OK 291292OK .OK 293......OK 294OK 295............OK .296.......OK ..OK 297298OK 299.....OK .300....OK .301....OK .302.OK 303..OK .304..OK ..305OK .OK 306.OK 307308.OK .OK 309..OK 310....OK ..311OK 312.OK 313.OK .314.315......OK ..316..OK .317OK 318.OK ..OK 319320OK 321........OK .322.......OK .323.OK .324..OK 325....OK 326.......OK .OK 327OK .OK 328329.OK .330...OK .331OK 332.333....OK .334.......OK 335..OK .336OK 337338.....OK .339OK .OK .340..........OK 341342OK 343344.OK 345.OK .346.......OK ..OK 347348.OK 349350..OK .351OK .OK 352353OK 354..........OK .355OK .356....OK .357.........OK ..358.OK .359.OK ..360....OK .361.OK .362.OK .OK 363...OK .364......OK .OK 365366OK 367.368....OK 369370OK 371OK ..372....OK 373...OK .374OK .375OK 376..OK .377......OK ..378.OK .OK  SUCCESS
Bisecting: 48 revisions left to test after this (roughly 6 steps)
[065c8012b2ff79ed9b47e39b60d252b3802ecc0d] Merge tag 'fixes-for-3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-11:55:26 065c8012b2ff79ed9b47e39b60d252b3802ecc0d compiling
/home/wfg/tip

2012-11-05-11:56:45 detecting boot state 3.7.0-rc2-bisect2-00489-g065c801 #38 ...1....2.......3......4..5..6.7...8.......910.1112.13...14.15...16.17.OK .18.1920.OK .21.22...............OK 23...24...25OK 26..27..OK 28...........OK 29.OK .OK 30.OK .31..OK .32OK .33.......OK .OK 3435OK 36..OK .3738....OK .39....OK 40OK .41.....OK ..OK 42OK .43......OK .OK 4445..OK .46...OK .OK .4748OK .OK 49OK ..OK 50......OK .51OK 52....OK ..53.OK 54.OK 55..OK .56.OK ..57.....OK 58........OK .OK 59OK ..60.........OK 61..OK .62....OK .63OK .64OK 65.OK .66...OK .67.OK 68OK .69..OK .70....OK 71.OK 72OK .73OK .74.....OK .75.OK .OK ..76...OK 77OK .OK 78OK ..OK 7980.81.........OK 82OK .83......OK ..84.OK .85.OK .86......OK .87OK 88...OK .8990..OK 91.OK .92......OK .93.OK 94..OK .OK 9596OK .97...............OK 98OK .99..OK .100..........OK 101OK .OK 102OK .103....OK 104OK .105106..OK ..107..OK 108OK .OK 109110111.........OK 112OK .113OK 114.....OK .OK .115.......OK 116.OK ..117....OK .118.....OK .119OK .OK 120.OK 121...OK .122.OK 123OK 124125......OK .126OK 127....OK .OK 128129...OK 130.OK 131..........OK .132OK 133OK 134...OK .135.OK .136...OK .137OK .138.OK .OK 139140OK 141.OK .142OK ..143..OK .144OK 145.OK ..146...OK .147OK 148..OK ..149....OK .OK 150151OK .152...OK .153...OK 154155.......OK .156................OK .OK .OK 157158.OK 159......OK .160OK 161.......OK .OK 162OK 163164..OK .OK .OK 165166167.OK .168.OK 169OK .170...OK .OK 171OK .172173174.....OK .175.......OK .176.OK .177........OK 178179OK 180....OK ..181OK .OK 182183..OK .184OK ..185..OK .186OK .187.OK .188........OK 189.OK .190.OK .OK .191192OK .193.................OK .194.....OK .195..OK .OK .OK 196.OK .OK 197.198..OK .199OK .OK 200201.OK .202203.OK .204OK 205.OK 206.OK .207....OK 208.OK 209210OK 211...OK 212.OK 213...OK .214.....OK .215......OK .216......OK 217OK 218.OK 219......OK 220OK 221OK .OK 222.223...OK .224OK 225.......OK .226OK 227.OK 228.OK .229..OK .230.....OK .231..OK .232....OK .OK 233234235.....OK ..OK 236OK .OK 237.OK .238OK .239.OK .OK 240241....OK .242.OK 243.OK 244.OK .245..OK .246..OK 247OK .OK 248..OK 249..........OK .250OK .251..................OK 252253OK .254....OK .255OK 256OK 257....OK .258...OK 259OK 260...OK .261..OK 262.OK .263.OK .OK 264OK 265OK .OK 266267......OK .268.OK ..OK 269.270............OK .271..OK ..OK 272.OK 273274.OK .275...OK 276OK 277........OK 278279OK 280.281.........OK 282.OK 283284....OK ..285........OK .286...........OK .287.......OK 288289OK 290.OK .291.OK 292.OK .OK 293294.OK 295.OK .296..OK 297.OK 298.OK ..299300.OK .301.OK .302.OK 303...OK ..304..OK .OK 305306...OK 307...........OK .308....OK .309.OK 310.OK .311......OK .OK 312OK 313314....OK ..315OK 316.OK 317......OK .318..OK 319.OK .OK 320......OK .321..OK .322OK .323........OK .324.OK .325......OK .326.OK 327OK .OK 328.329.....OK .OK 330OK 331332..OK .OK 333OK ..334OK .335.OK 336...........OK 337338OK .339...OK .340.............OK 341........OK .342.....OK .343.OK 344.......OK 345OK 346....OK .347..OK 348349OK 350351.........OK .OK 352.OK 353354.....OK .355....OK ...356.....OK ..357.OK .OK .358OK 359.360......OK .361OK .362.OK .363...OK 364OK .365........OK 366OK 367.OK .368......OK 369.OK 370371.OK ..372...........OK ..373.....OK ..374....OK .375....OK .OK 376.OK 377....OK ..378OK .OK .OK 379380....OK 381....OK 382.OK 383.OK  SUCCESS
Bisecting: 29 revisions left to test after this (roughly 5 steps)
[a1ecac3b0656a68259927c234e505804d33a7b83] loop: Make explicit loop device destruction lazy
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-12:33:53 a1ecac3b0656a68259927c234e505804d33a7b83 compiling
/home/wfg/tip

2012-11-05-12:36:23 detecting boot state 3.7.0-rc2-bisect2-00027-ga1ecac3 #39 ..1............234....56789 TEST FAILURE
Bisecting: 9 revisions left to test after this (roughly 3 steps)
[238ab78469c6ab7845b43d5061cd3c92331b2452] floppy: do put_disk on current dr if blk_init_queue fails
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-12:37:06 238ab78469c6ab7845b43d5061cd3c92331b2452 compiling
/home/wfg/tip

2012-11-05-12:38:39 detecting boot state 3.7.0-rc2-bisect2-00017-g238ab78 #40 .1..2.345.....6.7.8....9.10.. TEST FAILURE
Bisecting: 4 revisions left to test after this (roughly 2 steps)
[8e42e0a23d30ba84d8e946042ee82aac4934048a] block: remove CONFIG_EXPERIMENTAL
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-12:39:22 8e42e0a23d30ba84d8e946042ee82aac4934048a compiling
/home/wfg/tip

2012-11-05-12:40:46 detecting boot state 3.7.0-rc2-bisect2-00012-g8e42e0a #41 12.3.4.5........678...9..............................10.11.12.......OK 13OK 14........OK 15OK .16.17..1819..OK 20..OK 21.......22...23...........24....OK .2526OK .27OK .28.OK ..29OK 30.OK 31..OK .32OK .OK 3334OK 35OK 36.OK .37......OK 38.OK 39..........OK 40..OK 4142.............................OK .43..OK .44OK .OK .OK 45OK 4647...OK 48..OK .OK 4950.OK .51.OK .52...OK 53.OK 54......OK .55..OK 56..OK 57OK .58OK .OK 5960.OK .OK .6162....OK .OK .OK 636465.......OK .66........OK 67OK 68...OK .69..OK 70OK 71..........OK 72.OK 73........OK 74.OK .OK 7576.OK ...7778.....OK ..79.......OK ..80.........OK 81OK 82.....OK .83OK 84OK 858687.OK .88.OK .OK .OK 89.OK 909192....OK .93.OK 94..OK 95....OK .96.............................OK .97OK 98.99OK .100.OK .OK ..OK 101OK 102103OK .104........OK 105.OK 106....OK .107108..OK .109..OK 110......OK .111.....OK .OK .112113.OK ..114OK .115OK .116.OK .117.OK .118..OK .119.OK 120.OK 121122......OK 123OK 124.........OK .125OK .126..........OK .127..OK 128OK .129OK ..130..OK .OK 131.132.OK .133...............OK .134..OK .135..OK .136OK 137.......OK 138OK .139.....OK .140.OK .141.OK 142.OK .OK ..143144OK .145.OK .OK 146OK 147.OK 148OK .149..OK .150.......OK .151...................OK 152..OK .153OK 154...OK .155OK .OK .156OK 157OK 158159....OK ..160OK ..OK 161162OK .163........OK .164OK .165OK ..OK 166167.......................OK .168...OK .169OK .170OK .OK .171172OK 173OK 174OK ..OK 175176.177OK .178OK 179OK .180.OK .181..OK ..182OK 183.OK 184...........OK .185..OK 186187........OK .OK ..188.OK ..189..OK .190OK .191..OK 192......OK 193OK .194.OK .195...OK .196..OK 197OK 198.........OK 199.OK 200......OK 201..OK 202..OK 203OK 204..OK .205.OK .OK 206.207OK .208.OK .209OK .210.OK .211.OK .OK .212OK .213...OK 214215.......OK 216........OK 217OK 218.......OK ..OK 219220OK 221222223...OK .224..OK .225..OK 226.227....OK .228........OK .229........OK 230.....OK .OK 231232......OK 233OK 234235....OK .OK .236237OK 238OK 239OK .240OK .241OK .242..OK 243OK .OK 244245OK .OK 246.OK .247.........OK 248....
..OK .249OK ..OK 250251OK .OK 252253OK .254.....OK 255...OK .256...OK 257OK 258OK .259.......OK 260.OK 261..........OK .262.OK .OK 263OK 264.........OK .265OK .266......OK ..OK 267268OK .269..OK 270271.OK .272OK ..273.OK 274.275OK .276....OK 277OK 278..OK .279.....OK .280OK 281..........OK .OK 282283.OK 284OK 285OK 286287OK .288...OK 289..OK .290.....OK ..291.....OK 292.......OK .293.OK .294........OK 295OK 296........OK .OK 297.OK 298.....OK .299....OK 300OK .OK .OK 301OK 302OK .303....OK .304OK ..OK 305.306.....OK .307.OK 308........OK 309......OK .OK .310OK .311OK 312OK 313314..OK .315..OK ..316..OK .317OK 318.OK 319...........OK .320OK .321OK .OK 322.......OK 323.......OK .324.OK 325........OK .OK 326327..........OK ..328329OK 330OK .331OK .332OK 333..OK .334.....OK 335OK 336337.OK .338.....OK 339..OK .OK 340.....OK .341OK .342OK .343OK .344345...OK .346OK 347OK .348..........OK .OK 349...OK 350.......OK .351...OK 352OK 353....OK .354...OK 355..OK .OK 356....OK ..OK 357358.OK .359.OK 360OK .361....OK 362363OK .364.....OK .365OK .366..OK .367........OK .368.OK 369OK .OK 370OK 371OK .OK 372373...OK .374375..OK 376..OK 377378..OK .379..OK 380......OK 381..OK ..382..OK 383......OK ..OK 384....OK 385...............OK  SUCCESS
Bisecting: 2 revisions left to test after this (roughly 1 step)
[975927b942c932bd839ed07e5d40b4037d816844] block: Add blk_rq_pos(rq) to sort rq when plushing
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-13:17:58 975927b942c932bd839ed07e5d40b4037d816844 compiling
/home/wfg/tip

2012-11-05-13:19:20 detecting boot state 3.7.0-rc2-bisect2-00014-g975927b #42 ...1.....2.....3....4..5..........67..8.......9.....10....11..12..13.OK 1415..1617.18...19.20.....21.OK 22...OK .23............24..OK .OK 25.26OK .OK 2728..OK .29.OK 30OK .OK 31.32.OK 33......OK .34OK .35.OK .36...OK .OK 37.38........OK .39...OK .40...........OK .41.OK .OK 42.43.OK 44..OK 4546..OK .OK 4748.OK 4950....OK .OK 51OK .52.....OK .53...OK 54....OK 55.....OK .56.OK 57OK .OK .OK .58OK .5960.....OK .61OK ..6263..........OK .OK .64..OK 6566..OK .67..OK 68.....OK .69........OK 70....OK 71.OK .72OK .OK 7374OK .75OK .76....OK .77...OK ..OK 78.79OK .80....OK ..OK 8182..........OK 83..OK 8485......OK 86..OK .OK .OK 87OK .OK 88OK 89.9091..OK .OK .92.OK .93OK 94OK .95.OK 96.OK ..97OK 98OK .99......OK .100......................OK 101102..OK 103104OK .OK 105106...OK 107......OK 108109.OK .110OK ..111..OK 112...OK .OK 113114OK .115OK 116....OK .117OK .118..................OK .OK 119.OK 120121OK .122OK ..OK 123..OK .124..OK .OK 125126127...OK .128OK 129......OK .130.OK ..131....OK .132...OK .133..OK .134..OK .135OK 136OK .OK 137......OK .138.........OK ..139OK ..OK 140141.......OK ..OK 142OK 143144....OK .145.....OK 146.......OK 147...OK 148.OK .OK .OK 149150151OK 152OK .OK 153OK 154..OK ..155..OK ..156..OK .157.....OK 158.OK .159...........OK 160161......OK .OK 162OK ..163...OK 164.OK .165.....OK 166....OK 167.OK .OK .OK 168169170.OK .171OK .172.OK .173.OK .174..........OK 175................OK 176OK .OK 177..OK ..178.OK 179OK 180OK ..181..OK 182...OK ..183184.OK .OK 185..OK .OK 186...OK 187....OK 188.OK 189.........OK ..OK 190.......OK 191........OK 192..OK .OK 193.OK .OK .194195.OK 196...OK .197OK 198..OK .199...OK .200...OK .201...OK .202....OK 203.OK 204....OK ..205..OK 206.OK ..207208..OK .OK 209210OK .211..OK .OK .212213.OK .OK 214OK ..215.......OK .216....OK 217..OK 218..OK .219OK .220.OK .221OK 222..OK .223...OK 224.OK 225.226...OK .227.OK ..228229..OK .230......OK 231.....OK .232...........OK 233......OK 234OK .235..OK ..236237.OK .238...OK 239..OK .OK .240OK .OK 241OK .OK 242OK 243244OK 245.....OK .246..............OK 247OK .248OK .OK 249.OK 250251............OK .252253...OK .254OK .255.OK .OK 256257OK .258...OK 259..OK .260...OK 261.OK 262....OK 263........OK .OK 264..OK .265266OK 267.........OK .OK 268OK 269OK .OK 270271OK 272OK 273274OK .275..........OK 276..OK .OK 277..OK .OK 278279..OK .280OK 281....OK .OK 282.OK .283.....OK 284285.OK .286287..OK ..288...........OK 289..OK 290................OK 291OK .292.OK 293.OK ..294OK 295....OK .296OK .297.....OK .298OK .299OK 300.301OK .OK ..OK 302303OK 304305.OK 306...........OK ..307.OK 308.OK 309OK .310..........OK ..311.OK .312..OK 313...OK .314.OK .OK 315....OK 316.OK 317.....OK 318..........OK 319320............OK .321OK 322323324OK .325................OK 326.OK 327328OK .329OK .OK 330OK 331OK 332333OK 334OK .335..OK 336.OK 337....OK .OK 338339...OK .340OK .341..OK 342343.....OK ..344OK 345OK .346.OK .OK 347......OK .348..........OK .349..........OK 350...OK .351.OK .352.OK 353354OK 355OK .356...OK 357..........OK 358359..OK .360..OK .OK 361OK 362OK 363364.OK 365366OK .OK .367368..........OK .369OK .370...OK .371OK ..372...OK .373OK ..374OK 375.376.OK .OK 377.OK 378....OK .OK 379380.........OK .381........OK 382.OK .383..OK .384.OK .385...OK .386..OK  SUCCESS
Bisecting: 0 revisions left to test after this (roughly 1 step)
[b54e1f88897bcacc2cd359f48ea3b39eaf55f084] floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-13:56:03 b54e1f88897bcacc2cd359f48ea3b39eaf55f084 compiling
/home/wfg/tip

2012-11-05-13:57:25 detecting boot state 3.7.0-rc2-bisect2-00016-gb54e1f8 #43 ...12.....34.....5........... TEST FAILURE
Bisecting: 0 revisions left to test after this (roughly 0 steps)
[2911758f14e36a7cd5c7367f951dcb8817552f71] xen/blkback: Fix compile warning
running /c/kernel-tests/bisect-test-boot-failure.sh obj-bisect-x86_64

2012-11-05-13:58:09 2911758f14e36a7cd5c7367f951dcb8817552f71 compiling
/home/wfg/tip

2012-11-05-13:59:33 detecting boot state 3.7.0-rc2-bisect2-00015-g2911758 #44 12.34..5.6.7.8...9....10.11......12.13.14.......15..1617.....18..19.......OK .20...21....22....23.......OK 2425...OK 26....OK 27.OK 28......OK .29...OK .30....OK .OK .31OK 32OK 3334.OK .35OK .OK 36OK .3738OK 39OK 40OK .4142........OK .43....OK .44OK .45........OK .46..OK .47...OK 48........OK 49OK .50..OK ..OK 51.OK 5253..........OK .OK 5455...OK .56.....OK .57.OK .58........OK .59.....OK .60..OK ..OK 6162.OK .OK 63.64..OK .OK 65..OK .66OK .OK ..67.OK 6869OK 70.OK 71..........OK .OK 72.73..OK ..74...OK 75.....OK .76.....OK 77OK 78..OK ..79..OK .OK 80..........OK ..81....OK .OK 82.......OK .83OK .84.........OK .85.OK .86.....OK .OK .OK 878889.OK .90OK .91..OK .92.OK .OK 93.94.OK 95OK .OK .OK ..969798OK .99....OK ..100...OK .101..OK ..102....OK .103....OK .104....OK .OK 105OK .106107.....OK .108..OK 109..........OK .110....OK .111...OK .112OK .113........OK .114...OK .115..OK .116...OK .117118..OK 119OK 120OK 121.122.........OK 123OK .124OK .125.OK .OK 126127.OK .128.OK .129OK .130..OK .131..OK .132..OK .OK 133.134..OK 135OK .136.......OK .OK 137138139.OK .OK .140..............OK 141...OK 142..............OK .143OK .144......OK ..145.OK .OK 146147OK .148...OK .149OK .150....OK ..OK 151OK .152.......OK .OK 153OK .OK 154.155.OK .OK .156OK .157..OK .158.OK .159.OK .160...OK .OK 161162163.........OK .OK .164165.OK .166OK .OK 167.168...OK .169..........OK 170..........OK 171OK .172.....OK .173...OK .174...OK .175OK .OK 176.177...OK .OK .178OK 179180.OK .181182............OK .OK 183OK 184OK 185OK .186...OK ..OK 187OK 188189190.....OK ..191OK 192..OK ..193.....OK ..OK 194OK 195196OK .197..OK 198.......OK .199.......OK .200....OK .201..........OK .OK 202203..OK .204OK .205OK ..206..OK 207.OK .208209.....OK .210........OK .211OK 212...OK ..OK 213OK 214....OK .OK 215216OK 217218......OK 219220OK .OK 221222OK .223.....OK .OK .224225OK 226...OK 227........OK .228..............OK 229.......OK ..230OK 231.OK 232...OK .233234OK ..OK 235OK 236237...OK .238.OK 239.OK .240..........OK .241...OK .242243.OK .244OK .245OK .246.OK .247OK 248OK .249.......OK .OK .250.251...OK .252...OK ..OK 253..OK 254OK .255.....OK .256....OK .257......OK .258.OK .259..OK .260..OK .261.OK .262...OK 263264OK .OK .265266...OK 267.OK .268.................OK 269....OK ..OK 270271OK 272273.OK .OK 274....OK 275276...OK .277OK .278.OK .OK 279280.281....OK .282OK .283.OK 284OK 285OK .286.....OK 287................OK .288....OK 289290.....OK .OK 291292OK 293OK ..294295...OK .OK 296....OK .297.......OK 298299.....OK .OK 300301OK .302.....OK .303OK 304.305OK .306.......OK .307OK .308...OK .309OK 310..OK .311OK .312OK 313.OK .OK .OK 314315.OK .316...OK 317.....OK 318.....OK ..OK 319320......OK 321OK 322323...OK .OK 324OK .OK 325.326..OK .327................OK 328......OK .OK 329330..OK .331...OK .OK 332OK .333OK 334.....OK .335.....OK .336OK .337..OK .338OK .339OK 340OK 341.OK ..342OK .OK 343....OK .344.OK .345...OK .346.........OK 347..OK ..348..OK 349.OK ..350OK 351.....OK ..OK 352353OK .354355.OK 356........OK 357358......OK 359OK 360.....OK 361.OK .362...OK .363OK .364......OK .365.....OK 366..OK .367...OK 368OK .369OK .370OK 371...OK .372.OK 373OK 374.....OK .375OK .376.OK .377OK .378OK 379OK 380......OK 381OK 382.....OK .383..OK .384.....OK .385OK .OK 386.387OK .388.....OK 389.......OK  SUCCESS
b54e1f88897bcacc2cd359f48ea3b39eaf55f084 is the first bad commit
commit b54e1f88897bcacc2cd359f48ea3b39eaf55f084
Author: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date:   Mon Aug 27 20:56:51 2012 -0300

    floppy: don't call alloc_ordered_workqueue inside the alloc_disk loop

    Since commit 070ad7e ("floppy: convert to delayed work and single-thread
    wq"), we end up calling alloc_ordered_workqueue multiple times inside
    the loop, which shouldn't be intended. Besides the leak, other side
    effect in the current code is if blk_init_queue fails, we would end up
    calling unregister_blkdev even if we didn't call yet register_blkdev.

    Just moved the allocation of floppy_wq before the loop, and adjusted the
    code accordingly.

    Cc: stable@vger.kernel.org # 3.5+
    Acked-by: Vivek Goyal <vgoyal@redhat.com>
    Reviewed-by: Ben Hutchings <ben@decadent.org.uk>
    Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
    Signed-off-by: Jiri Kosina <jkosina@suse.cz>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

:040000 040000 863343599fef91d30b434ac69f264fbe8280b206 748959e7b5f773ac836dac597f63dcbb7a7500e1 M      drivers
bisect run success


Previous HEAD position was 2911758... xen/blkback: Fix compile warning
HEAD is now at 124414e... Add linux-next specific files for 20121105

2012-11-05-14:36:52 124414ef06851214e47c23bab0e12235468418e0 compiling
/home/wfg/tip

2012-11-05-14:39:35 detecting boot state 3.7.0-rc4-bisect2-next-20121105 #45 ..1...2..........3.4.56......7..8.9..10..11.12.13....14.15......16.......171819 TEST FAILURE
