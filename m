Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3AIAo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 19:44:27 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41504 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755277Ab3AIAo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 19:44:26 -0500
Date: Tue, 8 Jan 2013 19:43:41 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Shuah Khan <shuahkhan@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org, Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH v7u1 26/31] x86: Don't enable swiotlb if there is not
 enough ram for it
Message-ID: <20130109004340.GA12234@konrad-lan.dumpdata.com>
References: <CAE9FiQVKFz6K8xw2Eu5J8G6=QDdo2A7Y2-81GYP5yvP+T1YG5A@mail.gmail.com>
 <CAKocOOPqNPYU1dcDdHpKqMZtJnSOhT6tBGY7k4qGEy6uKSAr7Q@mail.gmail.com>
 <CAE9FiQVM-Rd82n-qhasDCA0+-n6TWH6m9Vm6N1nER__5p34z-Q@mail.gmail.com>
 <20130107152622.GD3219@phenom.dumpdata.com>
 <CAKocOOM9MYD8Z0-ha7NQP6B=J-eGS6uao5oAVfiO+i-a0TVy1A@mail.gmail.com>
 <8762382z2c.fsf@xmission.com>
 <CAE9FiQWeGKw0VEt5a74Sq3RQo6xBOreQ8Rf_O+B9HqSTHYJxBA@mail.gmail.com>
 <87y5g4z7rp.fsf@xmission.com>
 <CAE9FiQVVtfxZs7E9Q=VbNHNbYJg_9TGCTetkZMYT0tgt0JLNZw@mail.gmail.com>
 <CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQVCBehZ52p_UdfYbLoB3zJ=41NrQWeNyyCJ483D_9NEmg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 03:40:11PM -0800, Yinghai Lu wrote:
> On Mon, Jan 7, 2013 at 7:50 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> > On Mon, Jan 7, 2013 at 7:13 PM, Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> I meant we should detect failure to allocate bounce buffers in in
> >> swiotlb_init() instead of panicing.
> >>
> >> I meant swiotlb_map_single() should either panic or simply fail.
> >>
> >> If I have read lib/swiotlb.c correctly the only place we allocate a
> >> bounce buffer is in swiotlb_map_single.  If there are more places we can
> >> allocate bounce buffers those need to be handled as well.
> >
> > ok, will give it a try.
> 
> please check if you are ok with attached.
> 
> looks like it need more change of lines.

The swiotlb_full check I don't believe is neccessary. You won't ever get
to that unless swiotlb_map_page has at least provided a bounce buffer.
And if the swiotlb_map_page does not have a bounce buffer it will exit
with:

+       if (no_iotlb_memory)                                                    
+               return SWIOTLB_MAP_ERROR;                                       
+                 

which is dangerous. That is b/c there are drivers that don't use the
dma_mapping_error check (so check the bus address after calling
pci_map_*). This means they would try to do DMA on 0xffffffff (yikes!).

That is reason the failback (v_overflow_buffer) is still in
usage - b/c we have drivers that might just do this and this is the last
resort for them. And until those drivers are fixed - we _need_ this
fallback to work.
