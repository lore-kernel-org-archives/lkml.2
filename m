Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab1CFCD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 21:03:58 -0500
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:40605 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752448Ab1CFCDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 21:03:55 -0500
Subject: Re: BUG at mm/mmap.c:2309 when cx18.ko and cx18-alsa.ko loaded
From: Andy Walls <awalls@md.metrocast.net>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, David Miller <davem@davemloft.net>,
        linux-media@vger.kernel.org,
        Devin Heitmueller <dheitmueller@kernellabs.com>,
        Hugh Dickins <hughd@google.com>
In-Reply-To: <1299362366.2570.27.camel@localhost>
References: <1299204400.2812.35.camel@localhost>
	 <1299362366.2570.27.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Mar 2011 21:03:37 -0500
Message-ID: <1299377017.2341.50.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-05_05:2011-03-04,2011-03-05,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 suspectscore=4
 phishscore=0 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1012030000 definitions=main-1103050172
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-03-05 at 16:59 -0500, Andy Walls wrote:
> On Thu, 2011-03-03 at 21:06 -0500, Andy Walls wrote:
> > Hi,
> > 
> > I got a BUG when loading the cx18.ko module (which in turn requests the
> > cx18-alsa.ko module) on a kernel built from this repository
> > 
> > 	http://git.linuxtv.org/media_tree.git staging/for_v2.6.39
> > 
> > which I beleive is based on 2.6.38-rc2.
> 
> [snip]
> 
> > So here is my transcription of a fuzzy digital photo of the screen:
> > 
> > kernel BUG at /home/andy/cx18dev/git/media_tree/mm/mmap.c:2309!
> > invalid opcode: 0000 [#1] SMP
> > last sysfs file: /sys/module/snd_pcm/initstate
> > Modules linked in: tda9887 tda8290 mxl5005s s5h1409 tuner_simple ...
> > ...
> > Pid: 2580, comm: udevd Not tainted 2.6.38-rc2-cx18-vb2-proto+
> > RIP: 0010:[<ffffffff810eb50b>]  [<ffffffff810eb50b>] exit_mmap+0x10f/0x11e
> > RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0020000000000000
> > RDX: 0000000000160011 RSI: ffffea____c42___ RDI: 0000000000000202
> > RBP: ffff____18c1f_58 R08: ffff____________ R09: 0000000000000004
> > R10: ffff_______bb_38 R11: 0000000000000000 R12: ffff____344a6680
> > R13: 00007fff22______ R14: ffff____________ R15: 0000000000000001
> > ...
> > CR2: 0000000000000000 ...
> > ....
> > Process udevd (pid: 25__, threadinfo ffff________, ...
> > Stack:
> >  000000000000015e ffff00003bc0e1d0 0000000000000246 ....
> > .....
> > Call Trace:
> > ... mmput+0x63/0xcf
> > ... exit_mm+0x132/0x13f
> > ... do_exit+0x238/0x749
> > ... ? __dequeue_signal+0xfa/0x12f
> > ... do_group_exit+0x7d/0xa5
> > ... get_signal_to_deliver+0x371/0x395
> > ... do_signal+0x72/0x692
> > ... ? do_page_fault+0x24a/0x391
> > ... ? printk+0x41/0x47
> > ... ? sigprocmask+0xa3/0xcd
> > ... do_notify_resume+0x2c/0x64
> > ... retint_signal+0x48/0x8c
> > 
> > Code: ff ff 48 8b 7d d8 4c 89 ea 31 f6 e8 3e fe ff ff 48 89 df e8 78 fe
> > ff ff 48 85 c0 48 89 c3 75 f0 49 83 bc 24 e0 00 00 00 00 74 04 <0f> 0b
> > eb fe 48 83 c4 18 5b 41 5c 41 5d c9 c3 55 48 89 e5 41 57
> > RIP  [<ffffffff810eb50b>] exit_mmap+0x10f/0x11e
> >  RSP <ffff880018c1fc28>
> > general protection fault: 0000 [#2] SMP
> > last sysfs file: /sys/devices/virtual/sound/card2/uevent
> > CPU 1
> > Modules linked in: cx18-alsa tda9887 tda8290 mxl5005s s5h1409
> > tuner_simple tuner_types cs5345 tuner cx18 dvb_core cx2341x v4l2_common
> > videodev v4l2_compat_ioctl32
> 
> 
> I'm dumping all my previous assumtpions about this BUG.  After a bit of
> reading, all I can say is that it's a page table deallocation problem at
> process exit.  After all the page table deallocations on exit,
> mm->nr_ptes is still > 0, and that's a bad thing.
> 
> It apparently happened in a child udevd exiting shortly after cx18.ko
> loaded.  The cx18 driver allocating large amounts kernel memory for DMA
> buffers upon load may be related to triggering the problem, but I doubt
> it is a root cause of the BUG.
> 
> 
> This monsterous thread from 5 years ago is somewhat enlightening:
> 
> 	http://lkml.indiana.edu/hypermail/linux/kernel/0503.2/1680.html
> 	http://lkml.indiana.edu/hypermail/linux/kernel/0503.2/1787.html
> 
> so it gives me a place to start looking for the problem.
> 
> Any advice on what data to collect is appreciated.

When attemtping to reproduce this BUG, I got another bug related to
memory management:

(Details handtyped from a photo):
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff010f22fa>] remove_vm_area+0x42/0x77
PGD 37cdd067 PUD 336c__67 PMD 0
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:14.4/0000:03:00.0/firmware/0000:03:00.0/loading
CPU 0
Modules linked in: tda9887 tda8290 mxl5005s s5h1409 tuner_simple tuner_types cx5345 tuner cx18(+) dvb_core cx2341x ...
Pid: 2470, comm: work_for_cpu Tainted: G        W 2.6.28-rc2-cx18-vb2-proto+
RIP: 0010:[<ffffffff010f22fa>]  [<ffffffff010f22fa>] remove_vm_area+0x42/0x77
...
RAX: 0000000000000000 RBX: ffff____35e7c540 RCX: 0000000000001000
RDX: 0000000000000000 ....
...
CR2: 0000000000000000 ....
Stack:
 ffff__0011485968 000000000000001 ffff____1147dc9_ ffffffff_1_f23__
....
Call Trace:
... __vunmap+0x3e/0xbd
... vfree+0x2e/0x30
... dvb_dmx_init+0x7e/0x253 [dvb_core]
... cx18_dvb_register+0xd2/0x75c [cx18]
... cx18_streams_resgister+0x6a/0x26a [cx18]
... cx18_streams_setup+0x3cc/0x486 [cx18]
... cx18_probe+0x11cc/0x12fb [cx18]
......

The code appears to be failing here:

/home/andy/cx18dev/git/media_tree/mm/vmalloc.c:1352
    161d:       eb 06                   jmp    1625 <remove_vm_area+0x45>
    161f:       48 89 c2                mov    %rax,%rdx
    1622:       48 8b 00                mov    (%rax),%rax    <--- Oops  p = &tmp->next)  (tmp = *p)
    1625:       48 39 d8                cmp    %rbx,%rax		(tmp = *p) != vm;	
    1628:       75 f5                   jne    161f <remove_vm_area+0x3f>
/home/andy/cx18dev/git/media_tree/mm/vmalloc.c:1354

Corresponding to this code in mm/vmalloc.c:

struct vm_struct *remove_vm_area(const void *addr)
{
        struct vmap_area *va;

        va = find_vmap_area((unsigned long)addr);
        if (va && va->flags & VM_VM_AREA) {
                struct vm_struct *vm = va->private;
                struct vm_struct *tmp, **p;
                /*
                 * remove from list and disallow access to this vm_struct
                 * before unmap. (address range confliction is maintained by
                 * vmap.)
                 */
                write_lock(&vmlist_lock);
                for (p = &vmlist; (tmp = *p) != vm; p = &tmp->next)  <--- Ooops
			;
[...]

That for() loop appears to assume the vm_struct will be on the vmlist
somewhere.  If it isn't, then I suppose the for() loop could end up
doing a NULL dereference.

This BUG happened in the final stages of the cx18 driver setting up a
CX23418 card instance.  I have 2 cards in this machine, so a number of
buffers had certainly been allocated using kmalloc().  The code in the
dvb_core that is failing got BUG'ed in this case was this:

int dvb_dmx_init(struct dvb_demux *dvbdemux)
{
        int i;
        struct dmx_demux *dmx = &dvbdemux->dmx;

        dvbdemux->cnt_storage = NULL;
        dvbdemux->users = 0;
        dvbdemux->filter = vmalloc(dvbdemux->filternum * sizeof(struct dvb_demux_filter));

        if (!dvbdemux->filter)
                return -ENOMEM;

        dvbdemux->feed = vmalloc(dvbdemux->feednum * sizeof(struct dvb_demux_feed));
        if (!dvbdemux->feed) {
                vfree(dvbdemux->filter);     <------- BUG/Oops happened in this call
                dvbdemux->filter = NULL;
                return -ENOMEM;
        }
...

Which is kind of interesting:
1. The first vmalloc() succeeded.
2. The second vmalloc() failed.
3. The vfree() of the pointer from the first vmalloc() caused an
Oops/BUG.

I'm not sure where to go from here.

Regards,
Andy









> Regards,
> Andy
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


