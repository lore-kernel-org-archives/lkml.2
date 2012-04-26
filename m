Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab2DZCAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 22:00:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:5956 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab2DZCAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 22:00:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="tgz'50?scan'50,208,49,50";a="136874136"
Message-ID: <1335405672.14538.135.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH] mm: percpu: Add PCPU_FC_FIXED to pcpu_fc for setting
 fixed pcpu_atom_size.
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: ShuoX Liu <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 26 Apr 2012 10:01:12 +0800
In-Reply-To: <20120425222429.GE8989@google.com>
References: <4F97BA98.6010001@intel.com> <20120425222429.GE8989@google.com>
Organization: MCG
Content-Type: multipart/mixed; boundary="=-Uxsjy9n9HSStt9bTs99D"
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Uxsjy9n9HSStt9bTs99D
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2012-04-25 at 15:24 -0700, Tejun Heo wrote:
> Hello, ShouX.
> 
> On Wed, Apr 25, 2012 at 04:49:28PM +0800, ShuoX Liu wrote:
> > From: ShuoX Liu <shuox.liu@intel.com>
> > 
> > We are enabling Android on Medfield. On i386, if the board has more
> > physical memory, it means the vmalloc space is small. If the vmalloc
> > space is big, it means physical memory is small. Dynamic percpu
> > allocation is based on VM space. On i386, by default, the chunk size
> > is 4MB. As vmalloc space is <= 128M, percpu allocation often fails.
> 
> Can you please provide more details - which kernel/user split was
> used, how much memory was there and so on?  Also, can you please
> attach boot log and the output of "cat /proc/vmallocinfo"?
We are enabling Android on Medfield which is an embedded i386 platform.
kernel/user split is 1/3G. Physical memory is 1GB and we turn on HIGHMEM.

The boot log is a little big. I copied the percpu part for your reference.

04-26 09:57:32.987     0     0 W Kernel-Dmesg: <6>[    0.000000] SMP: Allowing 2 CPUs, 0 hotplug CPUs
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <7>[    0.000000] nr_irqs_gsi: 85
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <6>[    0.000000] Allocating PCI resources starting at 40000000 (gap: 40000000:bec00000)
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <6>[    0.000000] setup_percpu: NR_CPUS:2 nr_cpumask_bits:2 nr_cpu_ids:2 nr_node_ids:1
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <6>[    0.000000] PERCPU: Embedded 12 pages/cpu @f6400000 s25280 r0 d23872 u2097152
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <7>[    0.000000] pcpu-alloc: s25280 r0 d23872 u2097152 alloc=1*4194304
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <7>[    0.000000] pcpu-alloc: [0] 0 1
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <4>[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 252826
04-26 09:57:32.987     0     0 W Kernel-Dmesg: <5>[    0.000000] Kernel command line: init=/init pci=noearly console=tty
04-26 09:57:32.988     0     0 W Kernel-Dmesg: MFD3 console=logk0 earlyprintk=nologger loglevel=7 hsu_dma=7 kmemleak=off androidboot.bootmedia=sdcard androidboot.hardware=mfld_pr2 ip=50.0.0.2:50.0.0.1::255.255.255.0::usb0:on g_android.fastboot=1 droidboot.scratch=100 androidboot.wakesrc=05 androidboot.mode=fastboot
04-26 09:57:32.988     0     0 W Kernel-Dmesg: <6>[    0.000000] PID hash table entries: 4096 (order: 2, 16384 bytes)
04-26 09:57:32.988     0     0 W Kernel-Dmesg: <6>[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 b


We hit below issue.

03-13 08:22:36.273 11151 11133 I KERNEL : [74395.013328] PERCPU: allocation
failed, size=252 align=4, failed to allocate new chunk
03-13 08:22:36.274 11151 11133 I KERNEL : [74395.014062] Pid: 11151, comm: rild
Not tainted 3.0.8-137162-g5e405a0 #1
03-13 08:22:36.275 11151 11133 I KERNEL : [74395.014656] Call Trace:
03-13 08:22:36.283 11151 11133 I KERNEL : [74395.022691] [<c1306eaa>]
pcpu_alloc+0x12ca/0x1300
03-13 08:22:36.288 11151 11133 I KERNEL : [74395.027998] [<c125c1a9>] ?
sysctl_set_parent+0x29/0x40
03-13 08:22:36.293 11151 11133 I KERNEL : [74395.033335] [<c1306f0f>]
__alloc_percpu+0xf/0x20
03-13 08:22:36.298 11151 11133 I KERNEL : [74395.038144] [<c180dcad>]
snmp_mib_init+0x3d/0x70
03-13 08:22:36.302 11151 11133 I KERNEL : [74395.043221] [<c1846efa>]
ipv6_add_dev+0xfa/0x380


We run many stress testing and hit the percpu allocation failure at other
places.

We googled the error and found other guys in community also hit the bug.
You suggested them to use percpu_alloc=page. We tried it and it hurts power.

vmallocinfo is attached. From the vmallocinfo, we could find the VM space
is fragmented. We would write another patch to clean it up.

> 
> > If using PERCPU_FC_PAGE, system can't go to deep sleep states.
> 
> Why?
Medfield has 2 cpu threads. Only when all the 2 threads enter deep C states,
for example, C6, the core would enter C6. If booting kernel with percpu_alloc=page,
cpu core often aborts the C6 entering. We don't know why. C6 is aborted under
many conditions. One is when there is pending interrupt. I suspect with page size
alloc, it might trigger more cache miss. Just before calls mwait to enter
C6, we record some statistics data and that might trigger the cache miss
to abort the C6. It's just a _GUESS_.

We tried atom_size with 32k, 128k, 256k. There is no power regression.

> 
> > diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> > index 71f4727..824bc41 100644
> > --- a/arch/x86/kernel/setup_percpu.c
> > +++ b/arch/x86/kernel/setup_percpu.c
> > @@ -185,9 +185,13 @@ void __init setup_per_cpu_areas(void)
> >  #endif
> >  	rc = -EINVAL;
> >  	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
> > -		const size_t atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
> > +		size_t atom_size;
> >  		const size_t dyn_size = PERCPU_MODULE_RESERVE +
> >  			PERCPU_DYNAMIC_RESERVE - PERCPU_FIRST_CHUNK_RESERVE;
> > +		if (pcpu_chosen_fc == PCPU_FC_FIXED && pcpu_atom_size)
> > +			atom_size = pcpu_atom_size;
> > +		else
> > +			atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
> >  
> >  		rc = pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
> >  					    dyn_size, atom_size,
> 
> Umm... this is way too hacky.  atom_size can't be an arbitrary value
The interface is give admin more options. It doesn't mean admin could
choose any value.

> and the param is meaningful only to x86 yet defined globally. 
Right, from real usage requirement point of view. If we googled the failure
info dumped from kernel, we could see many other guys also hit it. That's why
we send the patch to LKML.

>  Also,
> while atom_size has effect on vmalloc area usage, way more important
> factor is distance between units.
Could you elaborate it?

>   What we probably need to do is
> tighten the rejection criteria of pcpu_embed_first_chunk()
Could you explain it more?

>  and fix
> whatever problem FC_PAGE is causing.
We can't fix FC_PAGE power regression. If we do so, we need contact many
hardware architects. Current kernel supports FC_PAGE and PMD_SIZE, why
not to allow admin to choose other values?

Thanks for the comments.

Yanmin


--=-Uxsjy9n9HSStt9bTs99D
Content-Type: application/x-compressed-tar; name="vmallocinfo.tgz"
Content-Disposition: attachment; filename="vmallocinfo.tgz"
Content-Transfer-Encoding: base64

H4sIACirmE8AA+2dQW/kOnLH5/w+he+LIBJJkdJhD4uXS4BsAiRAclgsGiJFzRhx2w275828fPpQ
zRL/LfesbVVxEQSYvjwC4/o9iiwWi1Ul6rfj+PDwFO4f56dPf69fk37WmOW/reua6/+mlmlaaz61
rTO2VZ1p1Kem1UrbT3fN361HV7+vL+fx+e7u0+/H//kyPn7+m3/33r//P/0132c3zzFNxD+kZn+Z
kuYu/fp2UHencH+4fzqOpz803539x+Z739ydvvz+8sd5bttp+cv7p+eY/v0XCBNHXXOO99PhdPx6
OD0/+ZhYbecSbDRmpU1Ne0tToJk3aWPc0uZZ39IMaPaa9vD47fD5dP9UcH6hqTCVJ1XhlmZB6+W0
HrTxmnb/eI4Ph+V5p+N4NXo6MZ3WYPpb5ghmYDDHubllBjDj+0yl+1fM2N8yoXvtRvfuT6GQ4gJq
5yvlux3EFsrXqr8Fapv2FekHQ9dC8dqN4p1e/OGYFG96vv8tPh/uH+/PC3NYVoZamOPn+PLH9u63
bFTvvr7E51/AIaT9EfIicDhNC89eeOZNHvSv3ejf+Xw8+KfDf+c129phQbXNL/hTkvJZqlWq7+8O
//nny//hv57H0yk+J8luptV+6YJau0Ac6IGiOWut7s3d4Z//7d+XcbzidIljabineW5utUph4pTe
9OpdmvsBTYPWXY/Mv8Zv9JT/cv/49fuf4/FPz3FM0LFJ0NvZ+wUMwg3Xj/pBnH6Fw6pUm1V5fLmH
lg7joqR+hj1zt895NQc/XIsnKP1igjrQpttVqLAKdSMfNd0CR+quGpPU6fg0fX2IpO1fT9N4jkld
vz5OL5eFtJiLFWleIaHxur993pfw9bAs9G/P9wn59PJ475dOqkTUrnlrY9BYFHpjfI/zQ9pnfBnG
0S+z0uu3ZkVjfvVmfl8ep8MFeLwyRmYxRmqY3iRinvV8vTry3nz5y4Mfl9Wh3dXqWGi3e6rBWuva
TLOD1al/8UpfpstEtHElNdPtOutgJLutkXyvX2O0tzTYx87upHW3NOhKt9GVyyrz4/kcn38vj2um
ZbnF0Lw1DR20xNIC0crZfo9Gu61GW8yFJdOibW/NR575dgVfEEQL13rywRX8ysRbqJ1r66xgB6Pg
tNzGOKiM26jMl5fkGi5DmLdntzg22tgyeOp28BwUxvUVugZlcRuT8nK6v3RtVb1p2WXbIcIb+UHf
YFJcqNC3q4n9wb7x5QW9a+dlYTj4/GPeArfdw87RN2/zVG/e5/VlVZj+onimHfo01Xen83bskgez
WE/dEW3qb30L0yvQNlbqt+dzOByfX86H08N4np+ej1du69LNtCO+sWtkGoE32nevwmH6tunpvHRU
jx6zPN7yLHh9DV4P3lRl/Zq+zLQZmgpdHDDTQ3fdxeUMMcXwMD7HQ3j6Ep/j4/lwjMen598XH9CQ
dq+Tc7NkzIDBHGoM5oDBHMbdvJsDRoYQL9TgBfA2a/qy330+jdOVb3nxOcxbPkeGZN64men3d6bu
dg2OmOdxGxWYp0M8rg7R4eXh6XKcukywcm9txxlEzJ3eR3erLyMW87jT++huDqIZQTS/0etkZL6c
DyFZ6fMyFV3zxmq7iGaKN9fewduUfkvxeDK/9qW3Tu0xA/YVEh0LTR3LEqAhMTsbre7a5Fyd4uO3
+PBweDp/vjrCLxv6qDEH9lbnYgui3NfIDMLJD5UmQkOi3N3IDMKNFXCwTnGuM8EzJnjeurovfo2m
PDyNS/TDNMuZbbHC5ZTf387vPADo5Y88w4DOm0MWy3m+2MCM69rNKev2cXV787jDzeNmCgHH6/Hb
MSVby5A5GanI5pmh7XZZhnY7jBlETLleZwbh5HrdqasnljvSHQIw3TYAw8SVPberEIHJDMKpCjgF
nKmAM8DRVOTT9Adx7hUOU6ErTIXGVJgKU4GYS0dH6TSYrvmR8dPuxhqEW2uAg3TnyFp1TpsPxyTb
bVCyw5HL5jTMXVp6S4zzBx3sp9cdvD11ZQoBK3QwQzKvJZ7tOm0/zOu2PEScrdqcPN6PON/uRRYh
YrtaPU5U3aqyp1kzXntBOyyyfsU0xebZjhaaS0r24YXWbldahmSejRV4tiw1u8aE9vvKWZQocvfM
OgfcmibJ6Y13JvSV2rriKds1NMJ4uKvVGch8WHvJDt2sTme7D6zOgNWZz853Si177R496151cu7B
nNiPehElyiyeRwc3zJmbkft8Pq8RQtVdEiQDjZr+kdHNhAyztDqtG5IN2uMVN9sO2hHMmTtqWTRT
1jXEUVeHVeTWICijN4h9OsfWBFeUfnB5C25t13aNUzdzdwnvXs1dc6PxhLjQvNnEFN/uU9uoTbdI
OoMo0KL7ZlC7TPSgtsyAzm0Pv/7+cUpr+5hTuf2aZL5+Mh/RoWiZo02iROFGLJLoVCizYlNmBYrj
UxwogU8JoIj9SmJccKER+5XEWHDJimy0OjzE8fHr6ZCV8qKAS0itbX1/95fx/HS8fzn9dd0hbqPm
hCMyV6tGFGSMrwoyOI87IkU9VkhRE4NwFXpXDkipyVVbEiUKV21HpIzHxrRsioESGL4SGAsK17SQ
aKZ0XE+KRIlSYco7TPnqW5tmSGeF9/bd4RUH09WJrQwxMs5WWCcWg2YrDJrFoFlxIIEYhLMVcNBW
Kw5gEYNw4gAWMQgnDmCNSPGnZgW9s9C79bQjOBqOSASPzZStmNatc/b9pIz/wZY2wZpN4oQAMQgn
PnESI+OiqzB2EftIHOTdiwNw4mg7MQg3VcBNBbf1Oz+Ie7VLzLBQcwULNcNCzRUs1AwLtR6Rcybg
g7hNFmBs4UO2lhbZ4HT7gcynv4mEEeJCUzkKkI4xruvU3Xz/fPy2pPOXQMX94+fDyznJLdmeSwHM
dKlPJSGSF5//R42H0xnXNsYsivH+yeqSESZhs1sYCaCx2y1s4UratXiScZ4fEatLTbl9tyWVnJr9
dbc4lbAjgjOj2z1EPYT7/cLzGi8ZfXaQlBmMSUvo14sX+U+//se38fTrl/H+8Q9rLaSxJRnebFeQ
h380W0FsgaQXkG+DEnaLEESz0tkiBuHEZocYGTdpee/Kbpya4t2YGIQbmacNEiUKN7hHopkSDZsS
DSgDnzKAEvmUWCgzN+RPokThBitJlCjcYCWJXiiq4Qa+vB7LuGgvPrclhgPOi5eYDmVN6ODkvQvo
XRA7qImBsZvkY4e9PzU77oRmUaKwzYgp73GlJtuMmJJB9abl5whImDhyS5sZhJNrldHAaf6Ia4y4
5o+4xogbtuHOoplCmc2r2oFwnPzXObnp4fxwyf4tqZC+TJ3ZbrqmHKg9lQ183GnyHRwA22RLqYam
b+3dt4dWufZwejgvTv0CUCFeNKi5+8vyj9+//3Wt2tikv7xtwVyrmjhKaUspU2qK4yLeQossX4ss
tMjytchCiyxfiyy0yJpeMNBdcVFtJw6iEINwtPsyAqjellcaUlN80CFGxm3faODhsOzc7mWHPKjv
dwv3EB52Cw8QHncLjxD2u4V9ec/A+0E+/n4sS8j7Vo7zLXDctAiJEoWbFiHRTNmWYu+iBExWMHzr
4EOxeH6S1xp5H9GvKM48EINw3AwdiRKFm6Ej0UyZuRk6EiWK3Bx7HKk8/0jlcaTy/COVx5HKyyOB
ScOLSQkt+8wZ4PyGlj1AobyEn5rsAcqimaJa/qLNwsSR61BQGCIl2NKzMHEqzL8qe0DQ8j0gaAya
rjBoGoOm5YeqAP81aPmhKpSahNRkW7xQahLSHsO2eMFg4Nk1CSRKFHGWlxiEE2d5iUE4+WkmMwgn
d44zI+PW6gLJJh9K+Dw15Zt8KOUFqcne5LMoUfgqbzHyTl4r7UOPZxtMBd5gwGMHhUOA9gf+dhZg
7yd2CDWLEoU/+xNmf5LHJjODcOLkuQ/wikMFrzjAKw5RnO0mBuFIGwR5ohChFmvyXIC7hIYzbtqb
NgyNWkcqNbnKRaJE4ZqWgMt/QiN/9yygtDJUKK0MKK1MTf6BkoSJwzVQJEqUSdKbCRyxS0qMjDMD
21MmYeKIzUtApWVqimtziEG4CoNmMGid2I8nBuHEfjwxCCf244lBOLEfTwzCibc1YhCugt510Luu
gt510Luugt510DtbQe8s9M5yjzEBxaqpyY0hkmimuIZNcTD5TmLyHUy+45t8B9103EKFgALU0O4N
YpNEFh5asbNOEOLJTVVmEI4byiJRonB9fxLNlJHr+5Nopnj56YggxGNrYlvOEqnJdveyaKZEbvCE
RInCtjpteVcsNcXBE2IQThw8SQwsu1luqFFllJrrPQXs88elJI9wavf5Q5WyxaAbbiqYRIkS+W6n
LhH1HAwVDrQu74qlpvhUSwzCiU+1xCCcuIabGISTLyFdEgqpKV9CulRTpKY4/kiMjFPyKBhBMm+9
nEPEM9A8U0HzDDTPVNA8A80zFTTPQPPkke+ge5ikgV9VRsLEYXsjGt6I5nsjGt6I5nsjGt6IHvk1
/CRMnAoTNmKIvBJYf4/H8xW0HL6W9hW03GPQfIVB81eDVsG+ethXX8G+ethXLw8FZkbGrSUlElyp
LUnNCtY1QO9CBb0L0LvJVthLJijeVEHxJije6huLuhehebGC5kVoXqygeRGax34vgESJwt9KZow8
u4glmLaEVsz6mQQGpVxWlZrcYvQkakGRq6YpV/OlJn+ASpVHasqjdKZUeQQjr/IIxpSzuzHiNyiC
QaDNWHmEMzMyzrH9lCxKFHZSyziMlGNHOUwp480VFVyfCXXuqclfMPADzVBBN8vbPcGsnhfr4eB5
mQqel4GhM1tDx3l3mhgXXNeI87XEIBw7wt3BgHZ8A9rpsny79WAnebRyTVZqyp1Ki3Cz7eWmLzMI
5/nnhCxMHLnNywzCydekxfHVDhUGDSF6WyFEb3EotoM8m5gZhJNnEzODcPJsYmYQTp5NzAzCVdA7
7AV2nOWOuB2hePJXEoiRcUFX6F6A5oUKmhegefJXR4lBOLazkUUzZWKnVOyEkZ/YKRWLY6Od2Ntc
Fs2UyD5t2FJelprszTKLEmXz1bR93o6NMAvyi2eCLXexpCY7p2dndGpmZ5dtuQww6TP7uJtFiSJf
qq68spya8qXqkCRyFZJETpXpc4o9fa5cs5ya7OlzSEM4zZ8+1JS5CjVlzqBTXYXxLhfcpaYgiO1K
jXdqyoOAzqJb8ivkghswaCN/JkcsxJEdd3KIz7uRHVZxOGs6+U0SxCCcoLbHIcrvKkT5HaL8rkKU
3yHK7ypE+R2i/M6vVafsL4oEh8C3W10yCW6CDZTXpBODcHJ3OzMyLvLfbUvC0BD2tcYkmikz269y
MxbRzParsihRuFcTkChR5HkAV25JDnSXMG+6cKlX2H2p1+UOGRIedguPEB53C3sI+93CEUU9M7+o
Z0ZRz9ywHaMZdSRzhTqSGXUkc4U6khl1JLMSaNmMaOC8flSIE9qaFR5P/jUhYhBOnkyb4Z7OFd7o
mPFGxyy/LJsYhJN7cDPeE5m13LGYy5emw7wWyUjCKbPBupK/H0oMwlVQPAPF69iBkBlvUswdOxAy
dxj5jr1hz6j+nvnV37PDCpLfAkOMBTc1e4vJSSIL99xdgkSJIl4mxCAcd7JIlChi15EYhBMfqKdm
wJANFYasVKhNzUhrjZ9DIgbhRjnODwXnxYeCqSlh39SM4t7hpuLUFG9BxCCceAua2uKdTK3AOyFh
4nCPCSRKFO4xgUSJwr3BjEQzRfNrREmYOPybRUiYOHIL0Wo8nhGncohBOHEOkRiEE4eHiUE4cXiY
GIQT5xCJQTi5/WrLm7BTu76RKHADCUK8CorXQfGc/AUzghCvguY5aJ78k3zEIBzfojlYNMe3aPDG
Wr43hvfVUpNbeUWiROEmQ0k0Uzz3DECiRKmgQR4a5CtokIcG+Qq2y2Pgvdx2qaZ4hqoRnxEnVd5/
Sk22cmVRolR4xnYATm6fVamunRS7upZEicJ2uBQcLsV3uBQcLsV3uBQcLqXZ5kmVmEpqckOKJEoU
7lGcRDPFcDN0JEoUboaORInCzdCRaKZ03OJdEiUKf5V3WOUdewtR5WMjk7LsLUSVixFSkxtGIlGi
sCMTysK+sC9GIFGi8O0L3B/Fd38U3B/Fd38UIll6dyRLQ9jsFkZh97T7AvMJFbJThQrZCSnPybGr
rUiUKGztcKXaKjXZ2uHK20GpGfkHdVfe45lKvlQy0DOGaObnayYkPacKSc8JSc/UFOdriHHBlRyq
AIdU6rQ7lTrh+0jT0MhXylA+Jpua8mPBUCreUlN+LBhKxVtqyo8FmUE4ucucGYSTu8yZQTh5sD0z
CCePaAwN9K6toHct9K5l+xJDuashNdm+xICzysA/qwzwyQd5njMxoKu6gq7Cvx74/vUA/3rg+9cD
/OuB718P8K+HTp4jGBweTf7KT2IE4OQ7kEduyg/y3uFj8JOXf5RzwlfhU5OWoSCZhOvlpyB/T40Y
hGMbiQDrHFq2kQjlJp3UZLuUoXyYKTXZLmUoJUCpyT5wZNFMUeyARijF46nJDmiEUjyemuyARijV
OVNgF49PAdtB4IdoAkI0gR+iCQjRBH6IJmALCWt+iXMECUgshQqJpYDEUlivCeUcQUKHx5PfD0oM
wsld14A4UJDfD0oMwsld19DBOMrvByUG4eSua0AyLsjvByUG4eRHpswgXAW9s9C79c4ASeYxOCie
q6B4Doq31iWJuocKpVChQimgQilUqFAKPTRv4G+OqHPifwqARInC30oGbCXs93FIlCjs00go7+Ok
Jvs0EsoVTVMI7Nh4FiUK+zwbAlzVwHdVA9ZEqLAmAtZEkK8JXPM/7b7mf4oIG8TVf+b4IJeYLHE6
/ltTU4Q5i06+j0acGmPP1sXYY5B6ti5GVJDGXvwGV2JgpPoKIwW7H9fPEDKe0eMZ5W+pEYNw8lN6
hGWK8svjiJFx8svjpljedkpNeQXpDLMw7zULlzxNFo7NfuESUY8t+y0fEiUKd5MmUaJwN2kSzRT5
m93EIBw3aEGiROEGLUiUKNygBYlmihKfCIhBOPGJIDEwfWskWStnP+wjuy2uvDGTmpsPOX8Qp1/h
MANanKojBuHERi6iajW222vhdm3s2bkgTtfL56DDoHUVBq3DoK0v2Ut654CTB6tjWyoBotpbCRBR
wBB3FzBEFDDE3QUMEQUMcXcBA0lkYXbZKYkShb2JdMXVSk32JtKVDz3HbuCe9GJXXKLUFF9hR4yM
C9zUURLVoHCPnyRKFO7xk0Qzhf1tPRIlyqo4vXUfXsH2FQ4aVOpnBLiIlcUupCFRorAdiK4U0qQm
24HoIpb7zF7utsQ5o7XsubflxpXU5BYakihRuIWG0ZUXC1JTHMyMrgeu36QcWK5LZmTcGkgTBB8j
rpVJTfnTjuVWktRkq2YWzZTAVs2xXL6dmuydKIsShf91PxImjjgEFccI3Mxed2PJeqcme91lUaKw
1x2+ZhvFX7P99PP38/fz9/P38/d//vtfQgGHmwDIAAA=


--=-Uxsjy9n9HSStt9bTs99D--

