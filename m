Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab0EDPCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 11:02:49 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53329 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932439Ab0EDPCs (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 4 May 2010 11:02:48 -0400
Date: Tue, 4 May 2010 11:02:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com, x86@kernel.org,
       clalance@redhat.com, drjones@redhat.com
Subject: Re: [LKML] Re: [LKML] [PATCH] Fix NULL pointer for Xen guests
Message-ID: <20100504150214.GA5667@phenom.dumpdata.com>
References: <20100427152434.16193.49104.sendpatchset@prarit.bos.redhat.com> <20100427165816.GA24707@phenom.dumpdata.com> <4BD71A2D.6050309@redhat.com> <20100427183428.GA15385@phenom.dumpdata.com> <4BD73134.1030308@redhat.com> <20100503191634.GA19699@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503191634.GA19699@phenom.dumpdata.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090209.4BE0370B.0027:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 03:16:34PM -0400, Konrad Rzeszutek Wilk wrote:
> >> OK, so your control domain is RHEL5. Mine is the Jeremy's xen/next one
> >> (2.6.32). Let me try to compile RHEL5 under FC11 - any tricks necessary
> >> to do that?
> >>    
> >
> > I haven't tried it -- it might work :)
> >
> > Also, did you try booting with maxvcpus > vcpus as drjones suggested ?
> 
> Yes. No luck reproducing the crash/panic. I am just not seeing the failure you
> guys are seeing.
> 
> Let me build once more 2.6.33 vanilla + CONFIG_DEBUG_MARK_RODATA=n) and check
> this. And also install a vanilla RHEL5 dom0 as it looks impossible to
> compile a 2.6.18-era kernel under FC11.

Rebuilding everything from scratch did it. I am seeing a similar
failure where xenctx reports:

Call Trace:
  [<ffffffff8107f780>] stop_cpu+0xc6  <--
  [<ffffffff8105520e>] worker_thread+0x15d 
  [<ffffffff8107f6ba>] __stop_machine+0x106 
  [<ffffffff81058afb>] wake_up_bit+0x25 
  [<ffffffff81038720>] spin_unlock_irqrestore+0x9 
  [<ffffffff810550b1>] spin_lock_irq+0xb 
  [<ffffffff810586cb>] kthread+0x7a 
  [<ffffffff8100a964>] kernel_thread_helper+0x4 
  [<ffffffff81009d61>] int_ret_from_sys_call+0x7 
  [<ffffffff814033dd>] retint_restore_args+0x5 
  [<ffffffff8100a960>] gs_change+0x13 

With this guest file:

kernel = "/mnt/lab/vs11/vmlinuz"
ramdisk = "/mnt/lab/vs11/initramfs.cpio.gz"
memory = 2048
maxvcpus = 4
vcpus = 2
vif = [ 'mac=00:0F:4B:00:00:71, bridge=switch' ]
vfb = [ 'vnc=1, vnclisten=0.0.0.0,vncunused=1']
root = "debug loglevel=10 plymouth:splash=solar plymouth:debug norm console=hvc0 initcall_debug"

This is with the latest linux kernel:
d93ac51c7a129db7a1431d859a3ef45a0b1f3fc5 (Merge branch 'for-linus' of
git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client)

With your patch the PV guests keeps on going.

So:

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> The Xen I am using is xen-unstable - so 4.0.1. I know that the IRQ balance
> code in the Xen hypervisor was fixed in 4.0 (it used to run out of
> context - now it runs in the IRQ context). Maybe this bug you are seeing
> (and have the fix for) is just a red-heering?

Interestingly enough, I couldn't reproduce this on my Intel box, but on
a AMD box with a very wacked TSC (cpu MHz         : 2795681.405) I can
reproduce this.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
