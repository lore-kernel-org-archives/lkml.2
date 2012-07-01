Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2GAQ4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 12:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17158 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab2GAQ4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 12:56:54 -0400
Message-ID: <4FF08154.3050407@redhat.com>
Date: Sun, 01 Jul 2012 12:56:52 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: john stultz <johnstul@us.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [RFC] Potential fix for leapsecond caused futex related
 load spikes
References: <4FF06CAB.9020800@redhat.com>
In-Reply-To: <4FF06CAB.9020800@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/01/2012 11:28 AM, Prarit Bhargava wrote:
> John,
> 
> I was hit by the futex issue as well.  I saw your patch and quickly did a test
> with top-of-tree + your patch using your reproducer.  I end up with warnings
> from the smp_call_function code followed by all sorts of deadlocks, etc.
> 
> I haven't had a chance to debug and will start doing so shortly ...
> 
> intel-canoepass-02 login: [  108.479555] Clock: inserting leap second 23:59:60 UTC
> [  108.485199] ------------[ cut here ]------------
> [  108.490368] WARNING: at kernel/smp.c:461 smp_call_function_many+0xbd/0x260()
> [  108.498236] Hardware name: S2600CP
> [  108.502060] Modules linked in: nfs nfs_acl auth_rpcgss fscache lockd sunrpc
> kvm_intel igb coretemp kvm ixgbe ptp pps_core ioatdma mdio tpm_tis crc32c_intel
> wmi joydev dca tpm lpc_ich ghash_clmulni_intel sb_edac mfd_core edac_core
> i2c_i801 microcode pcspkr tpm_bios hid_generic isci libsas scsi_transport_sas
> mgag200 i2c_algo_bit drm_kms_helper ttm drm i2c_core [last unloaded: scsi_wait_scan]
> [  108.540561] Pid: 1328, comm: leaptest Not tainted 3.5.0-rc4+ #4
> [  108.547169] Hypervisor: no hypervisor
> [  108.551273] Call Trace:
> [  108.554019]  <IRQ>  [<ffffffff8105814f>] warn_slowpath_common+0x7f/0xc0
> [  108.561398]  [<ffffffff810581aa>] warn_slowpath_null+0x1a/0x20
> [  108.567911]  [<ffffffff810b39bd>] smp_call_function_many+0xbd/0x260
> [  108.574931]  [<ffffffff8107e960>] ? hrtimer_wakeup+0x30/0x30
> [  108.581242]  [<ffffffff8107e960>] ? hrtimer_wakeup+0x30/0x30
> [  108.587560]  [<ffffffff810b3cb2>] smp_call_function+0x22/0x30
> [  108.593982]  [<ffffffff810b3d18>] on_each_cpu+0x28/0x70
> [  108.599825]  [<ffffffff8107ef7c>] clock_was_set+0x1c/0x30

John, the issue is that clock_was_set calls on_each_cpu() -- which cannot be
called from interrupt context as it calls smp_call_function_many().

I don't think you can call call_was_set() from update_wall_time() as
update_wall_time() is called in interrupt context.

Looking into it more ...

P.
