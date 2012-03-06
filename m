Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab2CFBuU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 20:50:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35232 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758110Ab2CFBuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 20:50:18 -0500
Message-ID: <4F556D3D.8040400@zytor.com>
Date: Mon, 05 Mar 2012 17:49:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: zhenzhong.duan@oracle.com, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        joe.jin@oracle.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Initialize max_pfn_mapped as initial ident mapping size
 for x86_64
References: <1330669703-20176-1-git-send-email-zhenzhong.duan@oracle.com> <CAE9FiQV3CyB1YRPDxFu-jGr73+Qwpkn4O4QYYZvBJcyZA5Gouw@mail.gmail.com>
In-Reply-To: <CAE9FiQV3CyB1YRPDxFu-jGr73+Qwpkn4O4QYYZvBJcyZA5Gouw@mail.gmail.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2012 05:35 PM, Yinghai Lu wrote:
> 
> whole history:
> before following patch, on x86_64, for low memory (under 4g) pgtable
> will be allocated just under TOML
> and even those memory is not mapped directly. because now we are using
> early_ioremap to access those
> page table.
> 
> but looks it has problem with S4 resume. so good_end is set to initial
> mapped high address.
> (that is 512M). So page table will just below 512M
> but crash kernel is allocated below 768M. so will have no chance to
> get 512M porting for crashkernel.
> 
> Now your patch just set initial mapping limit to 1g. but according to
> arch/x86/kernel/head_64.S
> we only have initial mapping to 512M.
> 
> So you can not just simply set to 1G,  that will confuse early
> memblock allocator.
> 
> We may update find_early_table_space() to use 1G as good_end for
> x86_64 that will be less confusing.
> 

This is crazy.  All of it.  We shouldn't have a bunch of magic memory
limits on 64 bits, and trying to add and subtract to them really just
makes the pain worse.

WHY does it have a problem with S4 resume?  S4 is Linux code, so there
is a bug here that people keep trying to hack around instead of digging
into.

The early mapping range we can fix, and probably should.  Mapping the
first 4 GiB is not a lot of memory and makes a much more sensible
starting point.

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

