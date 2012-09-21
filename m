Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479Ab2IUJNt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 05:13:49 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:45322 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932213Ab2IUJNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 05:13:47 -0400
Date: Fri, 21 Sep 2012 10:13:33 +0100
From: Richard Davies <richard@arachsys.com>
To: Mel Gorman <mgorman@suse.de>
Cc: Shaohua Li <shli@kernel.org>, Rik van Riel <riel@redhat.com>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/6] Reduce compaction scanning and lock contention
Message-ID: <20120921091333.GA32081@alpha.arachsys.com>
References: <1348149875-29678-1-git-send-email-mgorman@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348149875-29678-1-git-send-email-mgorman@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

Thank you for this series. I have applied on clean 3.6-rc5 and tested, and
it works well for me - the lock contention is (still) gone and
isolate_freepages_block is much reduced.

Here is a typical test with these patches:

# grep -F '[k]' report | head -8
    65.20%         qemu-kvm  [kernel.kallsyms]     [k] clear_page_c
     2.18%         qemu-kvm  [kernel.kallsyms]     [k] isolate_freepages_block
     1.56%         qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock
     1.40%         qemu-kvm  [kernel.kallsyms]     [k] svm_vcpu_run
     1.38%          swapper  [kernel.kallsyms]     [k] default_idle
     1.35%         qemu-kvm  [kernel.kallsyms]     [k] get_page_from_freelist
     0.74%             ksmd  [kernel.kallsyms]     [k] memcmp
     0.72%         qemu-kvm  [kernel.kallsyms]     [k] free_pages_prepare


I did manage to get a couple which were slightly worse, but nothing like as
bad as before. Here are the results:

# grep -F '[k]' report | head -8
    45.60%       qemu-kvm  [kernel.kallsyms]     [k] clear_page_c
    11.26%       qemu-kvm  [kernel.kallsyms]     [k] isolate_freepages_block
     3.21%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock
     2.27%           ksmd  [kernel.kallsyms]     [k] memcmp
     2.02%        swapper  [kernel.kallsyms]     [k] default_idle
     1.58%       qemu-kvm  [kernel.kallsyms]     [k] svm_vcpu_run
     1.30%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
     1.09%       qemu-kvm  [kernel.kallsyms]     [k] get_page_from_freelist

# grep -F '[k]' report | head -8
    61.29%       qemu-kvm  [kernel.kallsyms]     [k] clear_page_c
     4.52%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
     2.64%       qemu-kvm  [kernel.kallsyms]     [k] copy_page_c
     1.61%        swapper  [kernel.kallsyms]     [k] default_idle
     1.57%       qemu-kvm  [kernel.kallsyms]     [k] _raw_spin_lock
     1.18%       qemu-kvm  [kernel.kallsyms]     [k] get_page_from_freelist
     1.18%       qemu-kvm  [kernel.kallsyms]     [k] isolate_freepages_block
     1.11%       qemu-kvm  [kernel.kallsyms]     [k] svm_vcpu_run

I will follow up with the detailed traces for these three tests.

Thank you!

Richard.
