Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226Ab0IFPFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 11:05:24 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:5546 "EHLO
	TX2EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754693Ab0IFPCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 11:02:52 -0400
X-SpamScore: -3
X-BigFish: VS-3(zz4015Lzz1202hzz8275dhz32i87h2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0L8BZ2N-01-ANU-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
CC: "http://kvm.qumranet.com"@osrc.amd.com, linux-kernel@vger.kernel.org
Subject: [PATCH 0/27] Nested Paging Virtualization for KVM v3
Date: Mon, 6 Sep 2010 17:01:35 +0200
Message-ID: <1283785322-26898-1-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.0.4
MIME-Version: 1.0
Content-Type: text/plain
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi, Marcelo,

here is finally the third round of my NPT virtualization patches for KVM. It
took a while to get everything running (including KVM itself) on 32 bit again
to actually test it. But testing on 32 bit host and with a 32 bit hypervisor
was a very good idea. I found some serious bugs and shortcomings in my code
that are fixed now in v3.

The patchset was tested in a number of combinations:

	host(64|32e)
		->kvm(shadow|npt)
			->guest(64|32e|32)
				->test(boot|kbuild)

	host(64|32e)
		->kvm(npt)
			->guest(64|32e|32)
				->kvm(shadow|kvm)
					->guest(64|32e|32)
						->test(boot|kbuild)

Only the valid combinations where tested of course, so no 64 bit on 32 bit
combinations were tested. Except for that I tested all of the above
combinations and all worked without any regressions.

Other changes since v2 are:

	* Addressed the review comments from v2:
		- Rebased everything to latest upstream code
		- renamed nested_mmu to walk_mmu to make its
		  meaning more clear
		- the gva_to_gpa functions are not longer swapped
		  between the two mmu states which makes it more
		  consistent
		- Moved struct vcpu page fault data into seperate
		  sub-struct for better readability
		- Other minor stuff (coding style, typos)
		- Renamed the kvm_*_page_x86 functions to kvm_*_page_mmu so
		  that they can be made more generic later.
	* Made everything work on 32 bit
		- Introduced mmu->lm_root pointer to let the softmmu shadow 32
		  bit page tables with a long-mode page table. The lm_root
		  page-table root always just points to the mmu.pae_root, so
		  this builds entirely on the pae-shadow code.
		- Split mmu_alloc_roots into a shadow and direct_map version to
		  simplify the code and to not break the direct_map paths anymore
		  when changing something in that function.
	* Probably other changes I forgot about

This patchset applies on todays avi/master + the three patches I sent end of
last week. These patches are necessary for some of the tests above to run.

For the curious and impatient user I put everything in a branch on kernel.org.
If you want to test it you can pull the tree from

	git://git.kernel.org/pub/scm/linux/kernel/git/joro/linux-2.6-kvm.git npt-virt-v3

Please review and/or apply these patches if considered good enough. Otherwise I
appreciate your feedback.

Thanks,

	Joerg


