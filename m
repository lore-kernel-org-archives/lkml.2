Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550Ab0KNRcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 12:32:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:17220 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756434Ab0KNRcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 12:32:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,196,1288594800"; 
   d="png'150?scan'150,208,150";a="677373582"
Date: Mon, 15 Nov 2010 01:32:08 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Nikanth Karthikesan <knikanth@suse.de>,
        David Rientjes <rientjes@google.com>,
        "Zheng, Shaohui" <shaohui.zheng@intel.com>,
        "linux-hotplug@vger.kernel.org" <linux-hotplug@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>,
        Venkatesh Pallipadi <venki@google.com>, Nikhil Rao <ncrao@google.com>,
        Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Subject: Re: [PATCH] x86, acpi: Handle all SRAT cpu entries even have cpu
 num limitation
Message-ID: <20101114173208.GA23017@localhost>
References: <20101111124015.GA9706@localhost>
 <1289480656.2084.80.camel@laptop>
 <20101113084018.GA23098@localhost>
 <1289644224.2084.521.camel@laptop>
 <20101113120030.GA31517@localhost>
 <1289653078.2084.675.camel@laptop>
 <20101113131042.GA5522@localhost>
 <4CDEE314.6090107@kernel.org>
 <20101113235746.GA9458@localhost>
 <4CDF3DA1.2090806@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Content-Disposition: inline
In-Reply-To: <4CDF3DA1.2090806@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I just found another problem. When passing "mem=256" to 2.6.37-rc1,
it dies hard early (not able to print any boot log). With this patch
applied, it's a bit better: it shows a kernel panic, but still dies
hard (not able to reboot with "panic=10").

Attached is the screenshot in kvm (it's not specific to kvm, it dies
hard on two more physical boxes). The screenshot shows that it panics
inside reserve_trampoline_memory().

Thanks,
Fengguang

On Sun, Nov 14, 2010 at 09:38:41AM +0800, Yinghai Lu wrote:
> 
> Recent Intel new system have different order in MADT, aka will list all thread0
> at first, then all thread1.
> But SRAT table still old order, it will list cpus in one socket all together.
> 
> If the user have compiled limited NR_CPUS or boot with nr_cpus=, could have missed
> to put some cpus apic id to node mapping into apicid_to_node[].
> 
> for example for 4 sockets system with 64 cpus with nr_cpus=32 will get crash...
> 
> [    9.106288] Total of 32 processors activated (136190.88 BogoMIPS).
> [    9.235021] divide error: 0000 [#1] SMP 
> [    9.235315] last sysfs file: 
> [    9.235481] CPU 1 
> [    9.235592] Modules linked in:
> [    9.245398] 
> [    9.245478] Pid: 2, comm: kthreadd Not tainted 2.6.37-rc1-tip-yh-01782-ge92ef79-dirty #274      /Sun Fire x4800
> [    9.265415] RIP: 0010:[<ffffffff81075a8f>]  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
> [    9.265835] RSP: 0000:ffff88103f8d1c40  EFLAGS: 00010046
> [    9.285550] RAX: 0000000000000000 RBX: ffff88103f887de0 RCX: 0000000000000000
> [    9.305356] RDX: 0000000000000000 RSI: 0000000000000200 RDI: 0000000000000200
> [    9.305711] RBP: ffff88103f8d1d10 R08: 0000000000000200 R09: ffff88103f887e38
> [    9.325709] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
> [    9.326038] R13: ffff88107e80dfb0 R14: 0000000000000001 R15: ffff88103f887e40
> [    9.345655] FS:  0000000000000000(0000) GS:ffff88107e800000(0000) knlGS:0000000000000000
> [    9.365503] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [    9.365776] CR2: 0000000000000000 CR3: 0000000002417000 CR4: 00000000000006e0
> [    9.385583] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> [    9.405368] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> [    9.405713] Process kthreadd (pid: 2, threadinfo ffff88103f8d0000, task ffff88305c8aa2d0)
> [    9.425563] Stack:
> [    9.425668]  ffff88103f8d1cb0 0000000000000046 0000000000000000 0000000200000000
> [    9.445509]  0000000000000000 0000000100000000 0000000000000046 ffffffff82bd1ce0
> [    9.465350]  000000015c8aa2d0 00000000001d2540 00000000001d2540 0000007d3f8d1d28
> [    9.465763] Call Trace:
> [    9.465875]  [<ffffffff810747c3>] wake_up_new_task+0x3c/0x10e
> [    9.485486]  [<ffffffff8107b2e3>] do_fork+0x28c/0x35f
> [    9.485753]  [<ffffffff810ab832>] ? __lock_acquire+0x1801/0x1813
> [    9.505474]  [<ffffffff8106f2bd>] ? finish_task_switch+0x80/0xf4
> [    9.525264]  [<ffffffff8106f286>] ? finish_task_switch+0x49/0xf4
> [    9.525575]  [<ffffffff8109da72>] ? local_clock+0x2b/0x3c
> [    9.545281]  [<ffffffff8103da76>] kernel_thread+0x70/0x72
> [    9.545544]  [<ffffffff81097c83>] ? kthread+0x0/0xa8
> [    9.545797]  [<ffffffff81037990>] ? kernel_thread_helper+0x0/0x10
> [    9.565519]  [<ffffffff81098099>] kthreadd+0xe8/0x12b
> [    9.585185]  [<ffffffff81037994>] kernel_thread_helper+0x4/0x10
> [    9.585485]  [<ffffffff81cd793c>] ? restore_args+0x0/0x30
> [    9.605192]  [<ffffffff81097fb1>] ? kthreadd+0x0/0x12b
> [    9.605479]  [<ffffffff81037990>] ? kernel_thread_helper+0x0/0x10
> [    9.625295] Code: a0 be 00 02 00 00 ff c2 48 63 d2 e8 f8 67 3b 00 3b 05 86 8e 52 01 48 89 c7 89 45 c8 7c c1 48 8b 45 b0 8b 4b 08 31 d2 48 c1 e0 0a <48> f7 f1 45 85 e4 75 08 48 3b 45 b8 72 08 eb 0d 48 89 45 a8 eb 
> [    9.645938] RIP  [<ffffffff81075a8f>] select_task_rq_fair+0x4f0/0x623
> [    9.665356]  RSP <ffff88103f8d1c40>
> [    9.665568] ---[ end trace 2296156d35fdfc87 ]---
> 
> So let just parse all cpu entries in SRAT.
> 
> Also add apicid checking with MAX_LOCAL_APIC, in case We could out of boundaries of
> apicid_to_node[].
> 
> it should fix following bug too.
> https://bugzilla.kernel.org/show_bug.cgi?id=22662
> 
> Reported-and-Tested-by: Wu Fengguang <fengguang.wu@intel.com>
> Reported-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/kernel/acpi/boot.c |    7 +++++++
>  arch/x86/mm/srat_64.c       |    8 ++++++++
>  drivers/acpi/numa.c         |   14 ++++++++++++--
>  3 files changed, 27 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/acpi/boot.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
> +++ linux-2.6/arch/x86/kernel/acpi/boot.c
> @@ -198,6 +198,13 @@ static void __cpuinit acpi_register_lapi
>  {
>  	unsigned int ver = 0;
>  
> +#ifdef CONFIG_X86_64
> +	if (id >= (MAX_APICS-1)) {
> +		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
> +		return;
> +	}
> +#endif
> +
>  	if (!enabled) {
>  		++disabled_cpus;
>  		return;
> Index: linux-2.6/arch/x86/mm/srat_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/srat_64.c
> +++ linux-2.6/arch/x86/mm/srat_64.c
> @@ -134,6 +134,10 @@ acpi_numa_x2apic_affinity_init(struct ac
>  	}
>  
>  	apic_id = pa->apic_id;
> +	if (apic_id >= MAX_LOCAL_APIC) {
> +		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%04x -> Node %u skipped that apicid too big\n", pxm, apic_id, node);
> +		return;
> +	}
>  	apicid_to_node[apic_id] = node;
>  	node_set(node, cpu_nodes_parsed);
>  	acpi_numa = 1;
> @@ -168,6 +172,10 @@ acpi_numa_processor_affinity_init(struct
>  		apic_id = (pa->apic_id << 8) | pa->local_sapic_eid;
>  	else
>  		apic_id = pa->apic_id;
> +	if (apic_id >= MAX_LOCAL_APIC) {
> +		printk(KERN_INFO "SRAT: PXM %u -> APIC 0x%02x -> Node %u skipped apicid that is too big\n", pxm, apic_id, node);
> +		return;
> +	}
>  	apicid_to_node[apic_id] = node;
>  	node_set(node, cpu_nodes_parsed);
>  	acpi_numa = 1;
> Index: linux-2.6/drivers/acpi/numa.c
> ===================================================================
> --- linux-2.6.orig/drivers/acpi/numa.c
> +++ linux-2.6/drivers/acpi/numa.c
> @@ -275,13 +275,23 @@ acpi_table_parse_srat(enum acpi_srat_typ
>  int __init acpi_numa_init(void)
>  {
>  	int ret = 0;
> +	int nr_cpu_entries = nr_cpu_ids;
> +
> +#ifdef CONFIG_X86_64
> +	/*
> +	 * Should not limit number with cpu num that will handle,
> +	 * SRAT cpu entries could have different order with that in MADT.
> +	 * So go over all cpu entries in SRAT to get apicid to node mapping.
> +	 */
> +	nr_cpu_entries = MAX_LOCAL_APIC;
> +#endif
>  
>  	/* SRAT: Static Resource Affinity Table */
>  	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
>  		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
> -				     acpi_parse_x2apic_affinity, nr_cpu_ids);
> +				     acpi_parse_x2apic_affinity, nr_cpu_entries);
>  		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
> -				     acpi_parse_processor_affinity, nr_cpu_ids);
> +				     acpi_parse_processor_affinity, nr_cpu_entries);
>  		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
>  					    acpi_parse_memory_affinity,
>  					    NR_NODE_MEMBLKS);

--X1bOJ3K7DJ5YkBrT
Content-Type: image/png
Content-Disposition: attachment; filename="panic-reserve_trampoline_memory.png"
Content-Transfer-Encoding: base64

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
7OdojmrTTHoGyr4hT47Hu++mdtUEq8iA8/7z3jPZJ7KHO87U2uHfOaXikR+ty5HcmDvLuydm
5udGTpsZOcv37WrfPeLjDTGkhxEcXZUnJ/XntqXUGzLw58+jNw090VPqqlLHi+sx53fcfv3X
sKNUJJPnojEXkznVbo9GB8quysN4boxmUc+2rh1j0jMIufXLXs8vfqNDnVuf2beHq7J3x/Dv
zFJzxxWP5GhuRM5ypGWei2H9qQE9LeFci7277Trfw8zrcrUY7rhW5lyh3kkHBxQ12vydX5yU
qlYqfvsVn0ISf8PFaAdQfzxzthVXv5vjPCb73n6yIxqRmjLXERnPgR3dAfHupPq31HMT8eIP
Rf3vJpiLf053m5+IImf5vMXY0SHV+v6rujZan6l5Xc6J4b2ulZiiMlBtam5LqWfnXrVh8FRw
l77/e72p4Unn4jiQ+22tR/4knWOLvWMrO0YBPKOzY+4NPnPna1XE6ufGM9qB0bPcM+5mXzbu
rpV3uS5XjiH1GcEBpblN4ZOLt3Mxum+tv2EHv845X6v2qqcuuwo8o1Y+r8XOz1JXPT7p4PjH
qovKvpljSr3zcu52mR73HZZ8rz2/S9eGh+1rszcS+fo14r57eJfzddXkhXud5d21sv+dOK3v
nJskOJeHdSI/mqVPjaHJYlf5aqVIK+3eIxKNyGsC+7el1L2yd9Uejg5DlQ+Vc6+/G7Tn85Gy
PUP6I5HZEY192+qJYaTm7mij5uZUX5Ubq9rP+BnfEf9Ve9gf+fPh2TuuPjnR29du5JTafd2P
50b8LI8eYzzy/VNIMtuo0Wjsa7HnvnNV/YpPqa4cw/rXSgAAAAAe4ksIAIDdqq03ccc9dJYB
AAAAAAAAAAAAAAAAAAAAAAA4Y5nYpsxoWD7zqlLvyai1ixQqtarUtUu37jiuyEK259+2b0HK
nFaichuVn1FXnbsdGbX26Crfce3bw6tqZX3X1q/MLVa7mj8vhpnL0sO1vs+TVdfGMQ6jbwjf
sS2l7p6xkb3970NPDHuip1R+qVa2n5edK9VTv+baqP48jzyI7qh9kRZ7bt9qtlH5GbV2Pytk
1Nqje+ceekC6NjKZ971z37nq+pVzRNViGGnnW6Xe/JxIfd9CcN4EHKv3aLOydltK1b8RvCo/
W+YuP0pdVarnO3N+tY7kW7wToWYd1BZFcuOqbb35TEGkfu1o8eJdG5Gtx7+h54eHajGEt/kj
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
+6TUvUr1f2fmrc9dBtzG60tP/D9Hc1S40e856tFxRv3f0zMCaK7UqpjszsbRbc2dr0gMI2c5
Xr921MpVeZjTbtRs0yLtRn7bO1rvrmpFW9kI5DCC4xeRAck521LqDRn48+fRR8qe6Cl1Vanj
jdEx53ePARmtX3NTxka7Y/5rWFVfVkX+Sb+wjZ6vnsfC80fNz46hOkPo628rEsO5s9z6bXm0
a6NaNN6gp/0cnVRSoe0d3bfd0Vh11XbfC6vo4ICiIo9bStUvlT8beZXRd1XMdaNE3kiy480d
kWjcpbWJv2HkLln6zvehxM9y/Fwwd756/n5tfdkxamNV25szRi8SjbmfPYBVTFH5xVWzu5Vy
S1RzGDxPyq4d3zz3itYdW8xx92HtO85XnTgcW9GaZ2p3LuXXSlZlbyQ3RrOoNQ0qP2N3bHFf
NOJTeyq3S3BHRnBAaW5GoUXXBj1MW4Ae/eMO7tW1sTsaQDU6OP6xdi7ijpl+Sr3zQcKtORVa
tnvZNxT/XmMB3tlutM5+zbb0jufL+wIy9UyqirTzrckjc9m4Njfio1eujcaOPQTOfbWqU6sS
vkckGnOvPhrdllL3yt5Ve7hqHQSlKuTe3CoPoy8xjeztqj3sGe47uq25N2WsOq5Izd3XRs29
Bm/0fO24Pu64oZ87y1fVlMj52lcre76h/zO7z/K+nI/X5cy7lP5tzU1ky2x741N0d0djX+uh
awMAAHg4oycAoMVLRgGAoiKLGeMsA/A2X0IAAFCfoewAAAAAAAAAAAAAAAAAAFtZJrap5oJe
SlU4X3fMqLklS5XaXSqyjOXxG/pzKWcp63jtiLQDuyNfuQX43KK3M0TOUf3oxVsqGcKqXHpS
RuUv7D26rZylrJ8dw+M3VLgjIu77PCF0bRzjsHZhtrltKXX3jI3s7fkCga1m+jx6SuWXamX7
3Bbn2pxq7WErGj31pX9PIpGPLM+Z2UZZQDSSe/YZ+f/mDMy56sWvRP17GL/feF4M5/Yk/46I
Od9CcJ64n/+6NonntqXUm5uPud/cMm9ZlIqXGs2EfaXuUivnFpiMn1O3MtzXm3/EgpbMq95c
HZzbw331vaczpVoM57buOeVe/ggB1BcfTqzUvUr1f+fc5I7dF+DMAZyrjqu/lv386+dojgoP
iqOjulr/2j/gfO10wrlt7cur0dyIDBcfjXwk2+fObzw3jt9wno27z/LotuLna/ce5re994r8
vmlZo+1DzXMR6Wq5Ywx1STybERxdVS4n9ee2pdQbMvDnz6M3uz3RU+qqUseL6zHnq/2+2l8r
I4Ng/2uoUMvOz+C1Z6f1W9b5b1znv/idH92qYdXVBlcft74jGpHIR1qJeIbPna/RjrZqw9qP
/1pz4H1+HcmPfGYL3HMNGq0R51uZex/E2vEIa8vWj+G+3OAqRnBAUaMNdM9NpFJ1SvXc7tcZ
HRDJ3h49nXc7orFqbNTdz1f/uYic5fh2828lM6Nx7a/Qa6Oxth6ZStN/Fu7yuBXZz3it3FGP
jjncv8+Z9wCZXRtPjSH16eDoqmyVt6XUs3NPA021nDz/TP4vbHNW3ahVHnGz74xfdZZrRnhH
NOrnUubjjWvfVXlYP3/6H3pz3mI294NHTiSv6tqoH8Nrc5gdTFGB0swShLV0bUBlNadXQI+5
KauZe1Vt1MZdYsi96OD4R3wO2Ocnd8w3U+qdDxJu9aiWdWtrZZ25rD17cscWqf5sYW9rerOe
QenO8rNzfvdx9ay4Ebnqtd4wcv5tkemcq67LrT3Z8XaqCjGM5M/ayLPPV+v0tE7qe0SiEZmN
378tpe6Vvav2cO5FgPKhZu71d4P2l2qVnSs1d4ytB5X+m5t90ei/Geq5/cpvASJb7I/5XPZe
dZZXxXDuBYdz0ciP/Oh2q7Vs+95EMLeH8ekPOTHckRuRUqPHddXd3VxNWTutb1Xk56568cnR
lWOYeUcEAAA8irE2AOTwklEA4FHWruODsywPAe7iSwgAANjBcG4AAAAAAAAAAAAAAAAA4EYs
E9uUGQ3LZ15V6j0ZFVl6UKl9peLLIkbWvY8c19rsXbV069znc1qJq5aJ9aaDyDmqH714SyVD
7nV+c9qN8608uxXNWboV2Of7vALr2jjGYe0iZ3PbUuruGRvZ2/PF9ubWCVcqv1Qr2+e2ONfm
VGsPW9Fo1Ze5GEZaichSl5ltlMU4I7lnn6kgv+2NdDQ/IxqR63L++QJavoXg03m/9dqmam5b
Sr35IjH3m9vcjYhSV5UazYR9perXyvxuTW0Rz/DmH7Hqy29767Rmxz3JjMZcvXAHC9X8EQKo
Lz6cWKl7ler/zrnf3HbfZt1rmO5o/fr5zOdojgrHNTqqq/Wv/WNe1k4nnNtWTl7NDdrv//xo
5CO1eO78xnPj+A3x6WY76suOmhJpbfZl6edn4leH+HHtHh+deS6AaxnB8YvIgOScbSn1hgz8
+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

--X1bOJ3K7DJ5YkBrT--
