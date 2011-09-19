Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1ISRwT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 13:52:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:16951 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755708Ab1ISRwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 13:52:15 -0400
Date: Mon, 19 Sep 2011 19:51:59 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Lin Ming <mlin@ss.pku.edu.cn>
Cc: fa.linux.kernel@googlegroups.com, slawomir.czarko@gmail.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Sattler <tsattler@gmx.de>, Johannes Weiner <jweiner@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Subject: Re: iotop: khugepaged at 99.99% (2.6.38.3)
Message-ID: <20110919175159.GL7800@redhat.com>
References: <fa.FZDTDqnxL4JfQvyaCQTn405rzwM@ifi.uio.no>
 <ee48c89a-1e72-4b35-b9fc-99f4b8ade483@glegroupsg2000goo.googlegroups.com>
 <CAF1ivSY7rHuA_SGpnPkQ2hLwwOTEtDFTn=e_vx1=C_kW3aDjRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF1ivSY7rHuA_SGpnPkQ2hLwwOTEtDFTn=e_vx1=C_kW3aDjRA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 02:43:32PM +0800, Lin Ming wrote:
> # cat /proc/`pgrep khugepaged`/io
> rchar: 0
> wchar: 0
> syscr: 0
> syscw: 0
> read_bytes: 0
> write_bytes: 0
> cancelled_write_bytes: 0
> 
> Andrea,
> 
> From above output, all fields are zero.
> Does it mean that transparent huge page was not triggered/used at all?

Good idea to check it like that, yes that should confirm no
->writepage was called by khugepaged through
compaction->migrate->writepage.

It may have been used for migration, but the compaction code run by
khugepaged didn't trigger writes, or the write_bytes should have been
> 0.

With regard to Slawomir's problem, the kernel
kernel-PAE-2.6.40.4-5.fc15.i686 includes Mel's fix for the compaction
scan to stay in the right zone.

Slawomir could you run the command "cat /proc/`pgrep khugepaged`/io"
as root, so see if there's significant writeout going from khugepaged?
If there is you can try the patch in the below link.

https://lkml.org/lkml/2011/7/26/103

But the fact it happens on top of VMplayer with a PAE guest, may also
be a variable to take into account, migrate does quite some pagetable
work. If VMplayer uses EPT/NTP (do you have EPT/NTP available as VT
feature in the host /proc/cpuinfo?) it's hard to see how that could be
related.
