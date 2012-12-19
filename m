Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751607Ab2LSW0W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 17:26:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47391 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab2LSW0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 17:26:15 -0500
Message-ID: <50D23EE8.7030904@zytor.com>
Date: Wed, 19 Dec 2012 14:25:44 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com> <CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com> <50CCCFD0.7030704@linux.intel.com> <CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com> <50CCEE49.3080801@zytor.com> <CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com> <50CCF6F6.4020107@zytor.com> <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com> <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie>
In-Reply-To: <20121219220504.GA32212@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 02:05 PM, Jacob Shin wrote:
> On Wed, Dec 19, 2012 at 01:48:33PM -0800, H. Peter Anvin wrote:
>> There are a few very serious problems we need to figure out related to generalizing very early boot.  If this range gets mapped, will the CPU treat it as WB?  If so, with what consequences for either the HT region or the hole below it?
>
> Hm .. I guess I need to read the whole email thread .. but if you can
> explain it in short, what are the problems?
>
> Yes the CPU treats it as WB because the region is under TOM2, so by
> default it is WB, and also when you create direct mapping page tables,
> the PATs mark them as WB.
>
> What we have seen is that even though the kernel never generate memory
> accesses in the hole (since E820 says that it is not RAM) when kernel
> read/writes memory near the hole, the CPU was prefetching into the
> hole because PATs say that it is WB. This resulted in MCE because
> there is no physical RAM there.
>

IOW, epic f*ckup.

The problem is that before we have awareness of the memory map, we need 
to map things in order to access them.  This is a big problem and right 
now there are ridiculous heuristics.  I have been working on mapping on 
demand, but there are concerns about the boundaries (i.e. what happens 
if the mapping spill over into a pit like this.)

This kind of stuff is really not acceptable.  A region which will cause 
malfunction if prefetched should not be WB in the MTRR system (I include 
TOM* in that.)  The real question is what we can do to mitigate the damage.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

