Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab0CWLiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 07:38:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841Ab0CWLiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 07:38:07 -0400
Date: Tue, 23 Mar 2010 12:35:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Airlie <airlied@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Tejun Heo <tj@kernel.org>
Subject: Re: Can not boot with CONFIG_NO_BOOTMEM=y on i686
Message-ID: <20100323113551.GA3862@dhcp-lab-161.englab.brq.redhat.com>
References: <20100319131208.GA3911@dhcp-lab-161.englab.brq.redhat.com> <86802c441003201126j407eaf89j91cf91ae69454f30@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86802c441003201126j407eaf89j91cf91ae69454f30@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 11:26:06AM -0700, Yinghai Lu wrote:
> > After update to 2.6.34-rc1, I was experimented by strange oopses during
> > boot, what looked like memory corruption. Bisection shows that first bad
> > commit is 59be5a8e8ce765cf739ec7f07176219972de7481 ("x86: Make 32bit
> > support NO_BOOTMEM"). When I disable CONFIG_NO_BOOTMEM I'm able to start
> > system. Not sure what info is need to track down this issue, so please
> > let me know.
> 
> can you check patch
> 
> https://patchwork.kernel.org/patch/87081/

Patch helps somehow. Instead of many random oopses, now I have one and
the same oops, here is photo:
http://people.redhat.com/sgruszka/20100322_001.jpg

Oops is in pcpu_alloc+0x1aa, in code this is 

(gdb) l *(pcpu_alloc +0x1aa)
0xc04c2272 is in prefetch (/mnt/rhel5/usr/src/kernels/linux-2.6-debuginfo/arch/x86/include/asm/processor.h:886).
881	 * It's not worth to care about 3dnow prefetches for the K6
882	 * because they are microcoded there and very slow.
883	 */
884	static inline void prefetch(const void *x)
885	{
886		alternative_input(BASE_PREFETCH,
887				  "prefetchnta (%1)",
888				  X86_FEATURE_XMM,
889				  "r" (x));
890	}
(gdb) l *(pcpu_alloc +0x1a0)
0xc04c2268 is in pcpu_alloc (mm/percpu.c:1137).
1132					 */
1133					goto restart;
1134				}
1135	
1136				off = pcpu_alloc_area(chunk, size, align);
1137				if (off >= 0)
1138					goto area_found;
1139			}
1140		}
1141	
(gdb) l *(pcpu_alloc +0x1b0)
0xc04c2278 is in pcpu_alloc (mm/percpu.c:1116).
1111		}
1112	
1113	restart:
1114		/* search through normal chunks */
1115		for (slot = pcpu_size_to_slot(size); slot < pcpu_nr_slots; slot++) {
1116			list_for_each_entry(chunk, &pcpu_slot[slot], list) {
1117				if (size > chunk->contig_hint)
1118					continue;
1119	
1120				new_alloc = pcpu_need_to_extend(chunk);

So seems pcpu_slot[slot] is somehow corrupted. Looking further give
pcpu_slot is allocated by:

pcpu_slot = alloc_bootmem(pcpu_nr_slots * sizeof(pcpu_slot[0]));

So still we have some problem with CONFIG_NO_BOOTMEM on 32 bits.

Stanislaw 
