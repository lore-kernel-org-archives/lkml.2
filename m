Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab1C3OIA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 10:08:00 -0400
Received: from service87.mimecast.com ([94.185.240.25]:51932 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754838Ab1C3OH7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 10:07:59 -0400
Subject: Re: kmemleak for MIPS
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Maxin John <maxin.john@gmail.com>, Daniel Baluta <daniel.baluta@gmail.com>,
        naveen yadav <yad.naveen@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <1301491622.3283.46.camel@edumazet-laptop>
References: <9bde694e1003020554p7c8ff3c2o4ae7cb5d501d1ab9@mail.gmail.com>
	 <AANLkTinnqtXf5DE+qxkTyZ9p9Mb8dXai6UxWP2HaHY3D@mail.gmail.com>
	 <1300960540.32158.13.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTim139fpJsMJFLiyUYvFgGMz-Ljgd_yDrks-tqhE@mail.gmail.com>
	 <1301395206.583.53.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTim-4v5Cbp6+wHoXjgKXoS0axk1cgQ5AHF_zot80@mail.gmail.com>
	 <1301399454.583.66.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTin0_gT0E3=oGyfMwk+1quqonYBExeN9a3=v=Lob@mail.gmail.com>
	 <AANLkTi=gMP6jQuQFovfsOX=7p-SSnwXoVLO_DVEpV63h@mail.gmail.com>
	 <1301476505.29074.47.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTi=YB+nBG7BYuuU+rB9TC-BbWcJ6mVfkxq0iUype@mail.gmail.com>
	 <AANLkTi=L0zqwQ869khH1efFUghGeJjoyTaBXs-O2icaM@mail.gmail.com>
	 <AANLkTi=vcn5jHpk0O8XS9XJ8s5k-mCnzUwu70mFTx4=g@mail.gmail.com>
	 <1301485085.29074.61.camel@e102109-lin.cambridge.arm.com>
	 <AANLkTikXfVNkyFE2MpW9ZtfX2G=QKvT7kvEuDE-YE5xO@mail.gmail.com>
	 <1301488032.3283.42.camel@edumazet-laptop>
	 <AANLkTikX0j xdkyYgPoqjvC5HzY8VydTbFh_gFDzM8zJ7@mail.gmail.com>
	 <AANLkTi=RXoEOVmTPiL=dfO97aOVKWOJWE7hoQduPPsCZ@mail.gmail.com>
	 <1301491622.3283.46.camel@edumazet-laptop>
Organization: ARM Limited
Date: Wed, 30 Mar 2011 15:07:48 +0100
Message-ID: <1301494068.29074.94.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 30 Mar 2011 14:07:50.0474 (UTC) FILETIME=[DAB912A0:01CBEEE3]
X-MC-Unique: 111033015075307901
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-30 at 14:27 +0100, Eric Dumazet wrote:
> Le mercredi 30 mars 2011 à 14:17 +0100, Maxin John a écrit :
> > I have compiled the kernel with below given modification in .config
> >
> > CONFIG_CMDLINE="uhash_entries=256"
> >
> > After booting with the new kernel, the "kmemleak" no longer complains
> > about the "udp_table_init".
> > However it do report another possible leak :)
> >
> > debian-mips:~# cat /sys/kernel/debug/kmemleak
> > unreferenced object 0x8f085000 (size 4096):
> >   comm "swapper", pid 1, jiffies 4294937670 (age 1043.280s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<801ac7a8>] __kmalloc+0x130/0x180
> >     [<80532500>] flow_cache_cpu_prepare+0x50/0xa8
> >     [<8052378c>] flow_cache_init_global+0x90/0x138
> >     [<80100584>] do_one_initcall+0x174/0x1e0
> >     [<8050c348>] kernel_init+0xe4/0x174
> >     [<80103d4c>] kernel_thread_helper+0x10/0x18
> > debian-mips:~#
> 
> Hmm, then MIPS kmemleak port might have a problem with percpu data ?
> 
> fcp->hash_table = kzalloc_node(sz, GFP_KERNEL, cpu_to_node(cpu));
> 
> fcp is a per cpu "struct flow_cache_percpu"

I can't figure out what it is. Kmemleak uses this block for scanning the
percpu data:

	for_each_possible_cpu(i)
		scan_block(__per_cpu_start + per_cpu_offset(i),
			   __per_cpu_end + per_cpu_offset(i), NULL, 1);

The __per_cpu_* symbols seem to be correctly defined in the MIPS
vmlinux.lds.S as it uses the PERCPU macro directly.

Other chunks allocated via pcpu_mem_alloc() should be tracked by
kmemleak and either reported as leaks or scanned (and not reporting
subsequent blocks referred from the percpu memory).

-- 
Catalin


